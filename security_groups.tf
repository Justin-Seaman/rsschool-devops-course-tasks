# Public Security Group
resource "aws_security_group" "sec_grp-public" {
  name        = "sec_grp-public"
  description = "Controls access to public resources"
  vpc_id      = aws_vpc.jsrs-vpc.id
  tags = {
    Name = "sec_grp-public"
  }

  #Allow SSH in from anywhere
  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS out to anywhere
  egress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Priavte Security Group
resource "aws_security_group" "sec_grp-private" {
  name        = "sec_grp-private"
  description = "Controls access to private resources"
  vpc_id      = aws_vpc.jsrs-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sec_grp-private"
  }
}