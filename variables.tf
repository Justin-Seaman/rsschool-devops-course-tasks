variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region to deploy resources"
}

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