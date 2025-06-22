# INIT: Public Security Group
resource "aws_security_group" "sec_grp-public" {
  name        = "sec_grp-public"
  description = "Controls access to public resources"
  vpc_id      = aws_vpc.jsrs-vpc.id
  tags = {
    Name = "sec_grp-public"
  }
}
# INGRESS: Public Security Group Ingress Rule for All inside Traffic
resource "aws_vpc_security_group_ingress_rule" "pub_allow_in_inside" {
  tags = {
    Name = "vpc-all"
  }
  description       = "Allow all access from VPC network"
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = var.vpc_cidr # Allow traffic from within the VPC
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# INGRESS: Public Security Group Egress Rule for SSH
resource "aws_vpc_security_group_ingress_rule" "pub_allow_in_ssh" {
  tags = {
    Name = "home-ssh"
  }
  description       = "Allow SSH access from home network"
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = var.home_cidr
  from_port         = 22
  ip_protocol       = "tcp" # -1 means all protocols
  to_port           = 22
}
# EGRESS: Public Security Group Egress Rule for All inside VPC Traffic
resource "aws_vpc_security_group_egress_rule" "pub_allow_out_inside" {
  tags = {
    Name = "all-vpc"
  }
  description       = "Allow all access to VPC network"
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = var.vpc_cidr # Allow traffic to within the VPC
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# EGRESS: Public Security Group Egress Rule for ALL TRAFFIC
resource "aws_vpc_security_group_egress_rule" "pub_allow_out_all" {
  tags = {
    Name = "all-wan"
  }
  description       = "Allow all access to WAN"
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}