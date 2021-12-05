resource "aws_iam_policy" "iam-policy" {
  name   = local.iam.policy_name
  policy = file("${path.module}/iam-role/policy.json")

  tags = merge(
    local.common_tags,
    { "Name" = local.iam.policy_name }
  )
}

resource "aws_iam_role" "iam-role" {
  name                = local.iam.role_name
  assume_role_policy  = file("${path.module}/iam-role/trust-policy.json")
  managed_policy_arns = [aws_iam_policy.iam-policy.arn]

  tags = merge(
    local.common_tags,
    { "Name" = local.iam.role_name }
  )
}