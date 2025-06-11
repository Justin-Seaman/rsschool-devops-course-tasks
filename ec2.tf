resource "aws_instance" "ubuntu" {
  ami           = "ami-004364947f82c87a0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.jsrs-az1-pub1.id
  tags = {
    Name = "NAT_GW-Ubuntu"
  }
}