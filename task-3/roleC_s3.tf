# Task 3 - roleC S3 permissions
# Full access to one specific S3 bucket only

data "aws_iam_policy_document" "roleC_s3" {

  statement {
    sid    = "FullAccessToSpecificBucket"
    effect = "Allow"

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::task3-cross-account-bucket",
      "arn:aws:s3:::task3-cross-account-bucket/*"
    ]
  }
}


resource "aws_iam_role_policy" "roleC_s3" {
  name = "roleC-s3-access"

  role = aws_iam_role.roleC.id

  policy = data.aws_iam_policy_document.roleC_s3.json
}
