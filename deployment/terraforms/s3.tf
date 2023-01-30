resource "aws_s3_bucket" "commission-service" {
  bucket = "${var.stage}-${var.bucketName}"
  tags = {
    Name = var.bucketName
  }
}