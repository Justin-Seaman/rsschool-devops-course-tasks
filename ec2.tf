resource "aws_instance" "nat-gw_ubuntu" {
  ami               = "ami-004364947f82c87a0"
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.jsrs-az1-pub1.id
  private_ip        = var.nat_gw_private_ip
  source_dest_check = false
  key_name          = var.ssh_keypair_name
  vpc_security_group_ids = [
    aws_security_group.sec_grp-public.id
  ]
  tags = {
    Name = "NAT_GW-Ubuntu"
  }
}
resource "aws_key_pair" "ubuntu-kp" {
  key_name   = var.ssh_keypair_name
  public_key = var.ssh_keypair_public_key
}
/*resource "aws_instance" "priv_ubuntu" {
  ami           = "ami-004364947f82c87a0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.jsrs-az1-priv1.id
  private_ip    = var.priavte-vm_private_ip
  vpc_security_group_ids = [
    aws_security_group.sec_grp-private.id
  ]
  tags = {
    Name = "PRIVATE-Ubuntu"
  }
}
*/