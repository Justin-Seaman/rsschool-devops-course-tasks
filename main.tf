terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "jsrsstate"
    key            = "state/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "jsrslock"
    encrypt        = true
  }
}
provider "aws" {
  region = var.aws_region
}