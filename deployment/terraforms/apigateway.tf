module "rest_api" {
  source        = "../modules/api_gateway"
  rest_api_name = "${var.stage}_${var.api_name}"
}


module "commission" {
  source      = "../modules/api_gateway"
  path_part   = "calculate_commission"
  parent_id   = lookup(module.rest_api.rest_api_root_id, "${var.stage}_${var.api_name}")
  rest_api_id = lookup(module.rest_api.rest_api_id, "${var.stage}_${var.api_name}")
}


module "tenant" {
  source      = "../modules/api_gateway"
  path_part   = "tenant"
  parent_id   = lookup(module.commission.rest_api_resource_id, module.commission.path_part)
  rest_api_id = lookup(module.rest_api.rest_api_id, "${var.stage}_${var.api_name}")
}

module "tenant_name" {
  source             = "../modules/api_gateway"
  path_part          = "{tenant}"
  parent_id          = lookup(module.tenant.rest_api_resource_id, module.tenant.path_part)
  rest_api_id        = lookup(module.rest_api.rest_api_id, "${var.stage}_${var.api_name}")
  http_method        = ["GET"]
  authorization_type = "CUSTOM"
  authorizer_id      = aws_api_gateway_authorizer.auth_by_apikey_authorizer.id
  function_names     = [module.lambda_get_output_commission.lambda_name]
  depends_on         = [module.lambda_get_output_commission, aws_api_gateway_authorizer.auth_by_apikey_authorizer]
}

module "deployment" {
  source      = "../modules/api_gateway"
  stage_name  = var.stage
  rest_api_id = lookup(module.rest_api.rest_api_id, "${var.stage}_${var.api_name}")
  depends_on  = [module.tenant_name]
}

locals {
  auth_by_apikey_authorizer_lambda_details       = jsondecode(var.auth_by_apikey_authorizer_lambda_details)
  auth_by_any_token_authorizer_lambda_invoke_arn = local.auth_by_apikey_authorizer_lambda_details.Item.invoke_arn.S
}

resource "aws_api_gateway_authorizer" "auth_by_apikey_authorizer" {
  name                             = "auth_by_apikey_authorizer"
  rest_api_id                      = lookup(module.rest_api.rest_api_id, "${var.stage}_${var.api_name}")
  type                             = "REQUEST"
  authorizer_uri                   = local.auth_by_any_token_authorizer_lambda_invoke_arn
  authorizer_credentials           = module.lambda_get_output_commission.iam_role_arn
  identity_source                  = "method.request.header.tenant"
  authorizer_result_ttl_in_seconds = 0
}