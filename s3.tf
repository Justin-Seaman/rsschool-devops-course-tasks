resource "aws_s3_bucket" "jsrsstate_create" {
  bucket = var.tf_state_bucket
}
resource "aws_s3_bucket_ownership_controls" "jsrsstate_ownership" {
  bucket = aws_s3_bucket.jsrsstate_create.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}