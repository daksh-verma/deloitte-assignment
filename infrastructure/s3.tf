resource "aws_s3_bucket" "infra-bucket" {
  bucket = local.s3.infra_bucket_name
  acl    = "private"

  tags = merge(
    local.common_tags,
    { "Name" = local.s3.infra_bucket_name }
  )
}
