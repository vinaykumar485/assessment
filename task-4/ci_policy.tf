```hcl
# Task 4 - Least Privilege Policy for ci user

data "aws_iam_policy_document" "ci_policy" {

  # --------------------------------
  # ECR - Push Docker Image
  # --------------------------------

  statement {
    sid    = "ECRAuthentication"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "ECRPushToSpecificRepository"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      "arn:aws:ecr:us-east-1:000000000000:repository/ci-app"
    ]
  }


  # --------------------------------
  # ECS - Deploy Application
  # --------------------------------

  statement {
    sid    = "RegisterTaskDefinition"
    effect = "Allow"

    actions = [
      "ecs:RegisterTaskDefinition"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "UpdateSpecificECSService"
    effect = "Allow"

    actions = [
      "ecs:UpdateService"
    ]

    resources = [
      "arn:aws:ecs:us-east-1:000000000000:service/ci-cluster/ci-service"
    ]
  }


  # --------------------------------
  # ECS - Read Deployment Information
  # --------------------------------

  statement {
    sid    = "ECSReadOnly"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks"
    ]

    resources = [
      "*"
    ]
  }


  # --------------------------------
  # S3 - Read Build Artifacts Only
  # --------------------------------

  statement {
    sid    = "S3ReadBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::ci-build-artifacts"
    ]
  }

  statement {
    sid    = "S3ReadObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::ci-build-artifacts/*"
    ]
  }
}


# --------------------------------
# Attach Policy to ci IAM User
# --------------------------------

resource "aws_iam_user_policy" "ci_policy" {
  name = "ci-least-privilege-policy"
  user = aws_iam_user.ci.name

  policy = data.aws_iam_policy_document.ci_policy.json
}
```
