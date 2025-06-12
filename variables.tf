#AWS Core Info:
variable "aws_account" {
  type        = string
  default     = "584296377309"
  description = "AWS Account Number (10 digit)"
}

variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region to deploy resources"
}

# Backend TF Create:
variable "tf_state_bucket" {
  type        = string
  default     = "jsrsstate"
  description = "Name of s3 bucket for terraform state"
}

variable "tf_lock_db" {
  type        = string
  default     = "jsrslock"
  description = "Name of DynamoDB for terraform lock"
}

# OIDC Trust for GitHub Actions Repo:
variable "gh_org" {
  type        = string
  default     = "Justin-Seaman"
  description = "GitHub org/user for OIDC trust"
}

variable "gh_repo" {
  type        = string
  default     = "rsschool-devops-course-tasks"
  description = "GitHub repo for OIDC trust"
}

# Networking:

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "az1_pub1_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for public subnet in AZ1"
}

variable "az1_priv1_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR block for private subnet in AZ1"
}

variable "az2_pub1_cidr" {
  type        = string
  default     = "10.0.3.0/24"
  description = "CIDR block for public subnet in AZ2"
}

variable "az2_priv1_cidr" {
  type        = string
  default     = "10.0.4.0/24"
  description = "CIDR block for private subnet in AZ1"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
  description = "List of availability zones to use for the VPC"
}
variable "nat_gw_private_ip" {
  type    = string
  default = "10.0.1.5"
}
variable "priavte-vm_private_ip" {
  type    = string
  default = "10.0.2.10"
}
variable "home_cidr" {
  type        = string
  default     = "173.63.75.129/32"
  description = "CIDR block for home network to allow SSH access"
}
variable "ssh_keypair_name" {
  type        = string
  default     = "ssh-ubuntu-kp"
  description = "Key pair name for SSH access to the instance"
}
variable "ssh_keypair_public_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHCPJh9tPWLz5k/kKTSEOatmM0wxyVqBOBgGKN8Qrd2o jseaman@EPUSPRIW0847"
  description = "Key pair pubkey for SSH access to the instance"
}