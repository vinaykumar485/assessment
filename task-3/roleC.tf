# Task 3 - Account B
# roleC
#
# Only roleB from Account A can assume this role.

data "aws_iam_policy_document" "roleC_trust" {

  statement {
    sid    = "AllowOnlyRoleBFromAccountA"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::000000000000:role/roleB"
      ]
    }
  }
}


resource "aws_iam_role" "roleC" {
  name = "roleC"

  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}
