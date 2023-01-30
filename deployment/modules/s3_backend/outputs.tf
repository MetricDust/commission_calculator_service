output "s3_name" {
  value = aws_s3_bucket.terraform_state.*.bucket_domain_name
}

output "s3_bucket" {
  value = aws_s3_bucket.terraform_state.*.bucket
}