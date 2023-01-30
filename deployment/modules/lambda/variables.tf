variable "lambda_name" {
  description = "Name of the Lambda"
}

variable "handler" {
  description = "Lambda Handler `filename.function_name`"
}

variable "runtime" {
  default = "python3.8"
  type = string
  description = "Lambda Runtime e.g.: java11, python3.8, nodejs12.x, etc"
}

variable "memory_size" {
  default = 256
  type = number
  description = "Lambda execution memory size e.g.: 128, 512, 1028"
}

variable "environment_variables" {
  default = {}
  description = "Environment Variables for lambda"
}

variable "timeout" {
  default = 60
  type = number
  description = "Lambda execution timeout"
}

variable "concurrency" {
  default = null
  description = "Lambda concurrent executions"
}

variable "tags" {
  default = null
}

variable "file_path" {
  description = "Source code file path"
}

variable "policy_document" {
  default = []
  description = "Used to grant permissions to lambda execution to other resources"
}

variable "allow_cloud_watch_logs" {
  default = true
}

variable "trigger" {
  default = null
}

variable "source_arn" {
  default = null
}