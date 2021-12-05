output "api-endpoint" {
  value = "${aws_api_gateway_stage.replace-string-api-stage.invoke_url}/replace-string"
}

output "api-key" {
  value = "Get the replace-string-api-key API KEY from https://eu-west-1.console.aws.amazon.com/apigateway/home?region=eu-west-1#/api-keys"
}