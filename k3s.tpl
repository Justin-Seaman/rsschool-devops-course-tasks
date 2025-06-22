#!/bin/bash
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# Install AWS CLI v2
apt-get update -y
apt-get install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

K3_TOKEN=$(aws ssm get-parameter --name "${k3s_token_path}" --with-decryption --region ${aws_region} --query "Parameter.Value" --output text)

if [ "${control_plane}" = "true" ]; then
  echo "Running control plane command..."
  DB_PASSWORD=$(aws ssm get-parameter --name "${db_secret_path}" --with-decryption --region ${aws_region} --query "Parameter.Value" --output text)
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --token=$${K3_TOKEN} --node-name=${node_name} --datastore-endpoint='postgres://${db_user}:$${DB_PASSWORD}@${db_server}:5432/${db_name}'" sh -
else
  echo "Running agent node command..."
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --node-name=${node_name}" K3S_URL="https://${control_plane_ip}:6443" K3S_TOKEN="$${K3_TOKEN}" sh -
fi