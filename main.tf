terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
    backend "s3" {
    bucket = "jsrsstate"
    key = "state/terraform.tfstate"
    region = "us-east-2"
  }
}
# Configure the AWS provider
provider "aws" {
  region = "us-east-2"
}

# Configure GitHub Actions User
resource "aws_iam_user" "gh_actions_user" {
  name = "ghactions"
  path = "/"

  tags = {
    tag-key = "tf-created"
  }
}
#NEEDED??
    #resource "aws_iam_access_key" "lb" {
    #  user = aws_iam_user.lb.name
    #}

    #data "aws_iam_policy_document" "lb_ro" {
    #  statement {
    #    effect    = "Allow"
    #    actions   = ["ec2:Describe*"]
    #    resources = ["*"]
    #  }
    #}

    #resource "aws_iam_user_policy" "lb_ro" {
    #  name   = "test"
    #  user   = aws_iam_user.lb.name
    #  policy = data.aws_iam_policy_document.lb_ro.json
    #}

resource "aws_iam_role" "gh_actions_role" {
  name                = "GithubActionsRole"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::584296377309:user/ghactions"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "r53_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "iam_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_role_policy_attachment" "sqs_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "ebrdg_full_access" {
  role       = aws_iam_role.gh_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}