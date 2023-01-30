variable "profile" {}
variable "region" {}
variable "stage" {
  default = "beta"
}
variable "stack" {
  default = "commission_service"
}

variable "api_name" {
  default = "commission_service"
}


variable "s3_backup_folder" {}
variable "s3_backup_bucket" {}
variable "s3_backup_region" {}

variable "bucketName" {
  default="commission-service"
}

variable "auth_by_apikey_authorizer_lambda_details" {}
