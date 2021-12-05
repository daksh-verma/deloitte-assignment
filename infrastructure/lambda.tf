data "archive_file" "code-archive" {
  type        = "zip"
  source_dir  = "../api"
  output_path = "../code-archive.zip"
  excludes    = ["../infrastructure"]
}

resource "aws_s3_bucket_object" "code-s3-object" {
  bucket = aws_s3_bucket.infra-bucket.id

  key    = "code-archive.zip"
  source = data.archive_file.code-archive.output_path

  etag = filemd5(data.archive_file.code-archive.output_path)
}


resource "aws_lambda_function" "replace-string-lambda" {
  function_name = local.lambda.name
  role          = aws_iam_role.iam-role.arn
  handler       = "src/user-interface.replaceString"
  runtime       = "nodejs14.x"
  memory_size   = 3008
  timeout       = 600

  s3_bucket        = aws_s3_bucket.infra-bucket.id
  s3_key           = aws_s3_bucket_object.code-s3-object.key
  source_code_hash = data.archive_file.code-archive.output_base64sha256

  tags = merge(
    local.common_tags,
    { "Name" = local.lambda.name }
  )
}
