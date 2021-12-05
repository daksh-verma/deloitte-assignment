resource "aws_api_gateway_rest_api" "replace-string-api" {
  name           = local.api.name
  api_key_source = "HEADER"
}

resource "aws_api_gateway_resource" "replace-string-api-resource" {
  parent_id   = aws_api_gateway_rest_api.replace-string-api.root_resource_id
  path_part   = "replace-string"
  rest_api_id = aws_api_gateway_rest_api.replace-string-api.id
}

resource "aws_api_gateway_method" "replace-string-api-post" {
  authorization    = "NONE"
  http_method      = "POST"
  resource_id      = aws_api_gateway_resource.replace-string-api-resource.id
  rest_api_id      = aws_api_gateway_rest_api.replace-string-api.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "replace-string-api-post-integration" {
  resource_id             = aws_api_gateway_resource.replace-string-api-resource.id
  rest_api_id             = aws_api_gateway_rest_api.replace-string-api.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.replace-string-lambda.invoke_arn
  http_method             = aws_api_gateway_method.replace-string-api-post.http_method
  integration_http_method = aws_api_gateway_method.replace-string-api-post.http_method
}

resource "aws_api_gateway_deployment" "replace-string-api-deployment" {
  rest_api_id = aws_api_gateway_rest_api.replace-string-api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.replace-string-api-resource.id,
      aws_api_gateway_method.replace-string-api-post.id,
      aws_api_gateway_integration.replace-string-api-post-integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "replace-string-api-stage" {
  deployment_id = aws_api_gateway_deployment.replace-string-api-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.replace-string-api.id
  stage_name    = var.environment
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.replace-string-api.id
  resource_id = aws_api_gateway_resource.replace-string-api-resource.id
  http_method = aws_api_gateway_method.replace-string-api-post.http_method
  status_code = "200"
}

resource "aws_lambda_permission" "replace-string-api-lambda-permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.replace-string-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.replace-string-api.execution_arn}/*/${aws_api_gateway_method.replace-string-api-post.http_method}/replace-string"
}

resource "aws_api_gateway_api_key" "replace-string-api-key" {
  name = "replace-string-api-key"
}

resource "aws_api_gateway_usage_plan" "replace-string-usage-plan" {
  name = "replace-string-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.replace-string-api.id
    stage  = aws_api_gateway_stage.replace-string-api-stage.stage_name
  }

  quota_settings {
    limit  = 50
    offset = 0
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan_key" "replace-string-usage-plan-key" {
  key_id        = aws_api_gateway_api_key.replace-string-api-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.replace-string-usage-plan.id
}
