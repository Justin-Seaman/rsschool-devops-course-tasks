resource "aws_dynamodb_table" "jsrslock_create" {
  name         = var.tf_lock_db
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }


  tags = {
    Name = "jsrslock"
  }
}