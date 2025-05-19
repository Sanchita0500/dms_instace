resource "aws_iam_role" "dms_access_for_dynamodb" {
  name = "dms-access-dynamodb-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "dms.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "dms_dynamodb_policy" {
  name = "dms-dynamodb-policy-${var.env}"
  role = aws_iam_role.dms_access_for_dynamodb.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamo_table_name}"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
