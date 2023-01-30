output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "lambda_role" {
  value = aws_lambda_function.lambda.role
}

output "iam_role_id" {
  value = aws_iam_role.lambda_role.id
}

output "lambda_name" {
  value = aws_lambda_function.lambda.function_name
}


output "iam_role_arn" {
  value = aws_iam_role.lambda_role.arn
}