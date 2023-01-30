locals {
  triggers = tomap({
    "sns"= "sns.amazonaws.com",
    "api-gateway" = "apigateway.amazonaws.com"
  })
  cloudwatch_command = <<COMMAND
  export res=$(aws logs put-retention-policy --log-group-name
  /aws/lambda/${aws_lambda_function.lambda.function_name} --retention-in-days 7);
  echo '{"res": "'$res'"}'
  COMMAND
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  handler = var.handler
  role = aws_iam_role.lambda_role.arn
  runtime = var.runtime
  memory_size = var.memory_size
  timeout = var.timeout
  reserved_concurrent_executions = var.concurrency
  filename = var.file_path
  source_code_hash = base64sha256(var.file_path)
  tags = var.tags

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? var.environment_variables : {}
    content {
      variables = environment.value
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = data.aws_iam_policy_document.role_doc.json
  name = "${var.lambda_name}_lambda_role"
}

data "aws_iam_policy_document" "role_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com","apigateway.amazonaws.com"]
      type = "Service"
    }
    effect = "Allow"
    sid = ""
  }
}

resource "aws_iam_role_policy" "policy" {
  count = length(var.policy_document) > 0 ? length(var.policy_document) : 0
  policy = var.policy_document[count.index]
  role = aws_iam_role.lambda_role.id
  depends_on = [aws_iam_role.lambda_role]
}

resource "aws_iam_role_policy" "lambda_role_logs_policy" {
  count = var.allow_cloud_watch_logs ? 1 : 0
  role = aws_iam_role.lambda_role.id
  depends_on = [aws_iam_role.lambda_role]
  policy = data.aws_iam_policy_document.cloud_watch_document.json
}

data "aws_iam_policy_document" "cloud_watch_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_lambda_permission" "trigger" {
  count = var.trigger == null ? 0 : 1
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = lookup(local.triggers, var.trigger)
  source_arn = var.source_arn
}
data "external" "resource" {
  program = ["bash", "-c", local.cloudwatch_command]
}
