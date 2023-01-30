locals {
  verify_data = data.external.verify_bucket.*.result == [] ? false : tobool(lookup(data.external.verify_bucket.*.result[0], "bucket"))
}

data "aws_region" "current" {
}

data "external" "verify_bucket" {
  count = var.verify == true ? 1 : 0
  program = ["bash", "-c", "if [[ ! $(aws s3api head-bucket --bucket ${var.bucket_name} 2>&1) ]] ; then echo '{\"bucket\": \"true\"}'; else echo '{\"bucket\": \"false\"}'; fi" ]
}

resource "aws_s3_bucket" "terraform_state" {
  count = local.verify_data == true ? 0 : 1
  bucket = var.bucket_name
}

