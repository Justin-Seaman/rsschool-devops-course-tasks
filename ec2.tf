resource "aws_instance" "ubuntu" {
  ami           = "ami-004364947f82c87a0"
  instance_type = "t2.micro"
}