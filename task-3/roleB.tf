# Task 3 - roleB
# Allows only assuming roleC in Account B

data "aws_iam_policy_document" "roleB_policy" {

  statement {
    sid    = "AllowAssumeRoleC"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::111111111111:role/roleC"
    ]
  }
}


resource "aws_iam_role" "roleB" {
  name = "roleB"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::000000000000:root"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "roleB_policy" {
  name = "roleB-assume-roleC"

  role = aws_iam_role.roleB.id

  policy = data.aws_iam_policy_document.roleB_policy.json
}
