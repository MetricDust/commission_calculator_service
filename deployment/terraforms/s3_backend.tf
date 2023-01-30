
data "aws_region" "current" {}

  terraform {
  backend "s3" {
    encrypt = true
  }
}

data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = var.s3_backup_bucket
    key =var.s3_backup_folder
    region = data.aws_region.current.name
  }
}

