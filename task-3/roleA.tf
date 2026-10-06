# Task 3 - roleA
# Administrative access to all AWS services except IAM

data "aws_iam_policy_document" "roleA_policy" {

  statement {
    sid    = "AllowAllAWSServices"
    effect = "Allow"

    actions = [
      "*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "DenyIAMAccess"
    effect = "Deny"

    actions = [
      "iam:*"
    ]

    resources = [
      "*"
    ]
  }
}


resource "aws_iam_role" "roleA" {
  name = "roleA"

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


resource "aws_iam_role_policy" "roleA_policy" {
  name = "roleA-admin-except-iam"

  role = aws_iam_role.roleA.id

  policy = data.aws_iam_policy_document.roleA_policy.json
}
