data "aws_ssm_parameter" "db_secret" {
  name            = var.db_secret_path
  with_decryption = true
}
data "aws_ssm_parameter" "db_user" {
  name            = var.db_user_path
  with_decryption = true
}
data "aws_ssm_parameter" "db_name" {
  name            = var.db_name_path
  with_decryption = true
}
resource "aws_db_instance" "k3_sql_db" {
  allocated_storage           = 10
  db_name                     = data.aws_ssm_parameter.db_name.value
  engine                      = "postgres"
  engine_version              = "15.12"
  allow_major_version_upgrade = false
  apply_immediately           = false
  instance_class              = "db.t3.micro"
  username                    = data.aws_ssm_parameter.db_user.value
  password                    = data.aws_ssm_parameter.db_secret.value
  skip_final_snapshot         = true
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.sec_grp-private.id]
  publicly_accessible         = false
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-private-subnet-group"
  subnet_ids = [aws_subnet.jsrs-az1-priv1.id, aws_subnet.jsrs-az2-priv1.id] # Use subnets in your VPC

  tags = {
    Name = "RDS Subnet Group allowing access to private subnets"
  }
}