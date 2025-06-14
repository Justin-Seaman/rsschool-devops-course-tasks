# Create DynamoDB Table for Terraform Locking
resource "aws_dynamodb_table" "jsrslock_create" {
  name           = var.tf_lock_db
  hash_key       = "LockID"
  billing_mode   = "PROVISIONED"
  read_capacity  = 25
  write_capacity = 25

  attribute {
    name = "LockID"
    type = "S"
  }


  tags = {
    Name = "jsrslock"
  }
  lifecycle {
    prevent_destroy = true
  }
}