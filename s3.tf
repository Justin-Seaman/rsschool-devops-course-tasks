resource "aws_s3_bucket" "jsrsstate_create" {
  bucket = var.tf_state_bucket
}
resource "aws_s3_bucket_ownership_controls" "jsrsstate_ownership" {
  bucket = aws_s3_bucket.jsrsstate_create.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "jsrsstate_encrypt" {
  bucket  = aws_s3_bucket.jsrsstate_create.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_versioning" "jsrsstate_versioning" {
  bucket = aws_s3_bucket.jsrsstate_create.id
  versioning_configuration {
    status = "Enabled"
  }
}