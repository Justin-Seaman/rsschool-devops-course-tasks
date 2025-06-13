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
  tags = {
    Name = "az1-priv1-all"
  }
  description       = "Allow all access from AZ1-PRIV1 network"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az1_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# INGRESS: Private Security Group Ingress Rule for AZ2_Priv1
resource "aws_vpc_security_group_ingress_rule" "priv_allow_in_az2_priv1" {
  tags = {
    Name = "az2-priv1-all"
  }
  description       = "Allow all access from AZ2-PRIV1 network"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az2_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# INGRESS: Private Security Group Ingress Rule for SSH FROM bastion host
resource "aws_vpc_security_group_ingress_rule" "priv_allow_ssh_bastion" {
  tags = {
    Name = "bastion-ssh"
  }
  description       = "Allow SSH from bastion host"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = "${var.nat_gw_private_ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
# EGRESS: Private Security Group Egress Rule for AZ1_PRIV1 Traffic
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_az1_priv1" {
  tags = {
    Name = "all-az1-priv1"
  }
  description       = "Allow all access to AZ1-PRIV1 network"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az1_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# EGRESS: Private Security Group Egress Rule for AZ2_PRIV1 Traffic
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_az2_priv1" {
  tags = {
    Name = "all-az2-priv1"
  }
  description       = "Allow all access to AZ2-PRIV1 network"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = var.az2_priv1_cidr
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# EGRESS: Private Security Group Egress Rule for All TRAFFIC to NAT Gateway
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_nat_gw" {
  tags = {
    Name = "all-nat-gw"
  }
  description       = "Allow all access to NAT-GW ip"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = "${var.nat_gw_private_ip}/32" # Allow traffic to the NAT Gateway
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
}
# EGRESS: Private Security Group Engress Rule for ALL TRAFFIC to WAN
resource "aws_vpc_security_group_egress_rule" "priv_allow_out_all" {
  tags = {
    Name = "all-wan"
  }
  description       = "Allow all access to WAN"
  security_group_id = aws_security_group.sec_grp-private.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "-1" # -1 means all protocols
  to_port           = -1
} 