# Task 3 - Account A
# IAM Users and Groups

# -----------------------------
# IAM Users
# -----------------------------

resource "aws_iam_user" "engine" {
  name = "engine"
}

resource "aws_iam_user" "ci" {
  name = "ci"
}

resource "aws_iam_user" "admin1" {
  name = "admin1"
}

resource "aws_iam_user" "admin2" {
  name = "admin2"
}


# -----------------------------
# IAM Groups
# -----------------------------

resource "aws_iam_group" "group1" {
  name = "group1"
}

resource "aws_iam_group" "group2" {
  name = "group2"
}


# -----------------------------
# Group 1 Members
# CLI / Programmatic Access
# -----------------------------

resource "aws_iam_group_membership" "group1_membership" {
  name  = "group1-membership"
  group = aws_iam_group.group1.name

  users = [
    aws_iam_user.engine.name,
    aws_iam_user.ci.name
  ]
}


# -----------------------------
# Group 2 Members
# Console + CLI Access
# -----------------------------

resource "aws_iam_group_membership" "group2_membership" {
  name  = "group2-membership"
  group = aws_iam_group.group2.name

  users = [
    aws_iam_user.admin1.name,
    aws_iam_user.admin2.name
  ]
}
