# Manual Steps for K3s Cluster backed on SQL RDS

### Confirm network access

+ Terraform apply will output the internal-dns FQDN of the SQL server:
  + rds_address = `terraform-20250614180245579800000001.cbewwym4udkr.us-east-2.rds.amazonaws.com`
+ You can install pgsql with the following commands:

    ```bash
    apt install postgresql-client-common
    apt install postgres-client
    ```

+ You can remote into the PSQL server with the following commands:

    ```bash
    psql -h terraform-20250614180245579800000001.cbewwym4udkr.us-east-2.rds.amazonaws.com /
    -U postgres -d k3sdb
    ```

+ This method can be used for querying db after install also

### Install Basics

#### PRIMARY:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --token=my-manual-token-123 --node-name=cp-node --datastore-endpoint='postgres://postgres:changeme123@terraform-20250614180245579800000001.cbewwym4udkr.us-east-2.rds.amazonaws.com:5432/k3sdb'" sh -

```


#### WORKER(S):

Repalce K3S_TOKEN with token found on primary with the following command `/var/lib/rancher/k3s/server/node-token`.

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --node-name=w1-node" K3S_URL="https://10.0.2.10:6443" K3S_TOKEN="my-manual-token-123" sh -
```

![k3s-cluster](./.visual_assets/k3s-cluster.png)

## ISSUE:

+ We are storing passwords in plaintext and within the Configs and Terraform State!! We should consider security best practices when planing to mitigate with:
  + [AWS Systems Manage (SSM) - Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
  + [Terraform Ephemeral Resources](https://developer.hashicorp.com/terraform/language/resources/ephemeral)
  + [Terraform Example of Secure Variables](https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables)

  + Temp fix: Using tfvars.tf to pull environment variables from local system. Add secrets to local Windows device with the following Script for testing, and GitHub Actions Secrets for Pipeline.
    + Windows:

      ```powershell
      $env:TF_VAR_SQL_USER = "user123"
      $env:TF_VAR_SQL_PASSWORD = "password123"
      $env:TF_VAR_SQL_DATABASE = "db123"
      $env:TF_VAR_Cluster_TOKEN = "cluster123"
      ```

    + GitHub Actions:

      ```yaml
      env:
        TF_VAR_SQL_User: ${{ secrets.SQL_USER }}
        TF_VAR_SQL_Password: ${{ secrets.SQL_PASSWORD }}
        TF_VAR_SQL_Database: ${{ secrets.SQL_DATABASE }}
        TF_VAR_Cluster_Token: ${{ secrets.CLUSTER_TOKEN }}
      ```

  + ISSUE: Secrets are not handled properly and visible in user-data of ec2 instances. Need to use aws methods to get these secrets so they never show in plaintext.

+ We may want to be able to scale more workers with different paramters. We may want to use a template file to standardize our startup scripts by role: https://developer.hashicorp.com/terraform/language/functions/templatefile
+ bastion_address output var may be null if plan completes before dns name assigned. How can we wait until created?
+ After install, k3 control plane is extremly slow...will try adding swap file

```bash
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab
```

+ Killing a process in the middle of terraform plan could cause a locking issue. To address this, perform the following steps:
  1. Find the status of the lock table 
  ```ps1
  aws dynamodb get-item `   
   --table-name "jsrslock" `
   --key '{\"LockID\": {\"S\": \"jsrsstate/state/terraform.tfstate\"}}' `
   --region us-east-2
  
  aws dynamodb delete-item ` #Flags above (e.g. --tabl-name "jsrslock")
  ```

## SECURE INSTALL STEPS:

1. With the use of ephemeral/data aws_ssm_parameter, password_wo, password_wo_version, we can write and update the Master Password of the SQL server without storing the password in plaintext within the TF state or in our repo. SSM is the primary store of this information, and when it is changed in this location it is updated by the DB Resource block. Manual rollover of K3S nodes would still be required, but would just be easier to teardown and rebuild with new installs with new db-connection strings.
2. Similarly, we leverage EC2 Instance Roles and SSM to call AWS CLI on the instance with read permissions to the parameters required for DB Password and K3S Token string. Howwever, Token String will change after initial database creation:
e.g. from 
`O30hVB9UoXxVf6C9Mq4hj5lecA7xH3dUalY` ->  `K10a38a68832314623e53cc5a09c45f017c0a8338df12fb7cb7095dc0dc94a01e58::server:O30hVB9UoXxVf6C9Mq4hj5lecA7xH3dUalY`
where K10a38... is the "the token ID, a kind of public identifier used for internal reference"

To simplify future rebuilds, just re-write the token secret to include the output of 
`sudo cat /var/lib/rancher/k3s/server/node-token` on the control-plane node.

This should be available once the cluster is fully initialized. Check your cluster with the following commands

`sudo systemctl status k3s` -> General success of failure to run the K3s service

`sudo k3s kubectl get nodes -o wide` -> Full view of cluster node status
![k3-cluster-up](.visual_assets\k3s-cluster_up.png)

With the updated token in place in SSM, you can now teardown and rebuild the ec2 instances without risk of losing data, because RDS will maintain the cluster storage in the external SQL DB. With proper SQL backup and recovery procedures, the K3s cluster can be recoverable on-demand while not over-spending on EC2 uptime! 💰