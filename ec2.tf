resource "aws_instance" "nat-gw_ubuntu" {
  ami               = "ami-004364947f82c87a0"
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.jsrs-az1-pub1.id
  private_ip        = var.nat_gw_private_ip
  source_dest_check = false
  vpc_security_group_ids = [
    aws_security_group.sec_grp-public.id
  ]
  tags = {
    Name = "NAT_GW-Ubuntu"
  }
}