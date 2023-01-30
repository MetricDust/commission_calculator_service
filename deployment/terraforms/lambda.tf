
data "archive_file" "archive" {
  output_path = "../../build/artifacts/lambda.zip"
  type        = "zip"
  source_dir  = "../../build/package"
}

module "lambda_get_output_commission" {
  source          = "../modules/lambda"
  file_path       = data.archive_file.archive.output_path
  handler         = "app.commission_handler"
  lambda_name     = "${var.stage}_lambda_get_output_commission"
  runtime         = "python3.8"
  policy_document = [data.aws_iam_policy_document.policy_document.json]
  depends_on      = [data.aws_iam_policy_document.policy_document,data.archive_file.archive]
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = ""
    actions = [
      "logs:*",
      "dynamodb:*",
      "execute-api:*",
      "lambda:InvokeFunction",
      "s3:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

}


