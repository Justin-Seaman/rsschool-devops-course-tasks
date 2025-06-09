
# Terraform for AWS deployments

Deploying CI/CD changes via Terraform configuration files to test Infastructure as Code workflows.

## Terraform files

+ *main.tf* - main class responsible for configuraiton of state file to AWS S3 bucket backend.
+ *variables.tf* - environment specific variables file for aws-region, terraform state, and github OIDC connection.
+ *oidc.tf* - establishes OIDC trust relationship between AWS and GitHub. Only allowed for owner and repo set in variables.
+ *iam-gh_actions_role.tf* - grants FullAccess to core AWS Services to the role used for GitHub Actions OIDC.
+ *s3.tf* - Handles creation of s3 bucket for shared tf state

## GitHub Actions Files

On push to main branch, GitHub Actions will run based on yml action file in .github/workflows/terraform-deployment.yml to perform the following tasks

1. Perform a terraform format check on the contents of the repo
    - If this action fails with exit code 3, confirm the formatting of your terraform files before commiting. Run the following on your local git prior to push:
    > terraform fmt
2. Run terraform init and plan to compare the config to the state file and describe changes to be made upon apply
3. Run terraform apply to make the changes to the AWS resources.

## AWS information

- IAM sign-on URL: https://d-9a6769cb84.awsapps.com/start,
- MFA required
- Region = us-east-2