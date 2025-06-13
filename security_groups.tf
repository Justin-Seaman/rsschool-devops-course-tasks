# INIT: Public Security Group
resource "aws_security_group" "sec_grp-public" {
  name        = "sec_grp-public"
  description = "Controls access to public resources"
  vpc_id      = aws_vpc.jsrs-vpc.id
  tags = {
    Name = "sec_grp-public"
  }
}
# INGRESS: Public Security Group Ingress Rule for All internet Traffic
resource "aws_vpc_security_group_ingress_rule" "pub_allow_in_inside" {
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = var.vpc_cidr # Allow traffic from within the VPC
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# INGRESS: Public Security Group Engress Rule for SSH
resource "aws_vpc_security_group_ingress_rule" "pub_allow_in_ssh" {
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = var.home_cidr
  from_port         = 22
  ip_protocol       = "tcp" # -1 means all protocols
  to_port           = 22
}
# EGRESS: Public Security Group Engress Rule for All inside VPC Traffic
resource "aws_vpc_security_group_egress_rule" "pub_allow_out_inside" {
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = var.vpc_cidr # Allow traffic to within the VPC
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# EGRESS: Public Security Group Engress Rule for HTTP
resource "aws_vpc_security_group_egress_rule" "pub_allow_out_http" {
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
# EGRESS: Public Security Group Engress Rule for HTTPS
resource "aws_vpc_security_group_egress_rule" "pub_allow_out_https" {
  security_group_id = aws_security_group.sec_grp-public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# INIT: Priavte Security Group
resource "aws_security_group" "sec_grp-private" {
  name        = "sec_grp-private"
  description = "Controls access to private resources"
  vpc_id      = aws_vpc.jsrs-vpc.id
  tags = {
    Name = "sec_grp-private"
  }
}
# INGRESS: Private Security Group Ingress Rule for AZ1_Priv1
resource "aws_vpc_security_group_ingress_rule" "priv_allow_in_az1_priv1" {
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az1_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# INGRESS: Private Security Group Ingress Rule for AZ2_Priv1
resource "aws_vpc_security_group_ingress_rule" "priv_allow_in_az2_priv1" {
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az2_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# INGRESS: Private Security Group Ingress Rule for ssh bastion host
resource "aws_vpc_security_group_ingress_rule" "priv_allow_in_az2_priv1" {
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.nat_gw_private_ip
  from_port         = 22
  ip_protocol       = "tcp" 
  to_port           = 22
}
# EGRESS: Private Security Group Engress Rule for az1_priv1 Traffic
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_az1_priv1" {
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az1_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
} # EGRESS: Private Security Group Engress Rule for az2_priv1 Traffic
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_az2_priv1" {
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az2_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# EGRESS: Private Security Group Engress Rule for All traffic to NAT Gateway
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_nat_gw" {
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = "${var.nat_gw_private_ip}/32" # Allow traffic to the NAT Gateway
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}