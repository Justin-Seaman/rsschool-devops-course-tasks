ephemeral "aws_ssm_parameter" "db_secret" {
  arn             = "arn:aws:ssm:us-east-2:584296377309:parameter/jsrssecrets/rds/master_password"
  with_decryption = true
}
data "aws_ssm_parameter" "db_secret" {
  name = var.db_secret_path
}
data "aws_ssm_parameter" "db_user" {
  name = var.db_user_path
}
data "aws_ssm_parameter" "db_name" {
  name = var.db_name_path
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
  password_wo                 = ephemeral.aws_ssm_parameter.db_secret.value
  password_wo_version         = data.aws_ssm_parameter.db_secret.version
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
output "db_password_version" {
  value       = aws_db_instance.k3_sql_db.password_wo_version
  description = "The endpoint of the RDS instance"
}