variable "rest_api_name" {
  default = null
  description = "Name of the Rest API"
}

variable "parent_id" {
  default = null
  description = "Parent Id of the api gateway resource if no resource apigateway as root resource "
}

variable "path_part" {
  default = null
  description = "path  of the resource to be created"
}

variable "rest_api_id" {
  default = null
  description = "id of the Rest api top attach to resource"
}

variable "http_method" {
  default = []
  description = "HTTP method for api resource"
}

variable "integration_type" {
  default = "AWS_PROXY"
  description = "AWS Method Integration type e.g.:`MOCK`, `AWS_PROXY`, etc "
}

//variable "lambda_invoke_arn" {
//  default = null
//  description = "used to invoke lambda from api gateway"
//}

variable "cache_key_parameters" {
  default = []
  description = "cache key parameters"
}

variable "cache_namespace" {
  default = null
  description = "Name of the cache"
}

variable "timeout" {
  default = null
  description = "Timeout seconds from api gateway"
}

variable "request_parameters" {
  default = {}
  description = "request parameters eg. pathParameters, queryStringParameters, headers"
}

variable "function_names" {
  default = []
  description = "AWS Lambda function name"
}

variable "stage_name" {
  default = null
  description = "AWS api gateway stage name"
}

variable "authorization_type" {
  default = "None"
}

variable "authorizer_id" {
  default = "None"
}