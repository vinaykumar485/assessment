````markdown id="y5x9j1"
# Task 5 — Debugging the Broken IAM Policy

The original Terraform code contained exactly two issues.

---

## Issue 1 — Incorrect Principal ARN

The original trust policy used:

```text
arn:aws:iam::000000000000:user/roleB
````

This is incorrect because `roleB` is an IAM role, not an IAM user.

An IAM user ARN has this format:

```text
arn:aws:iam::ACCOUNT_ID:user/USERNAME
```

An IAM role ARN has this format:

```text
arn:aws:iam::ACCOUNT_ID:role/ROLENAME
```

Therefore, the correct principal is:

```text
arn:aws:iam::000000000000:role/roleB
```

### Why this matters

The trust policy must identify the actual IAM principal that is allowed to assume `roleC`.

The intended relationship is:

```text
Account A
roleB
  |
  | sts:AssumeRole
  ↓
Account B
roleC
```

Using `user/roleB` does not correctly identify the `roleB` IAM role.

---

## Issue 2 — S3 Permission Is Too Broad

The original policy contained:

```text
Action   = "s3:*"
Resource = "*"
```

This allows all S3 actions against all S3 resources that the policy applies to.

However, the requirement says that `roleC` should have full access to only one specific S3 bucket.

Therefore, the S3 resource must be restricted to the required bucket and its objects.

The corrected resources are:

```text
arn:aws:s3:::task3-cross-account-bucket
arn:aws:s3:::task3-cross-account-bucket/*
```

The first ARN represents the bucket itself.

The second ARN represents objects inside the bucket.

Therefore, `roleC` can access:

```text
task3-cross-account-bucket
```

and its objects, but the policy does not grant access to other S3 buckets.

---

## Final Fix

### Original

```text
user/roleB
```

Changed to:

```text
role/roleB
```

### Original

```text
Resource = "*"
```

Changed to:

```text
Resource = [
  "arn:aws:s3:::task3-cross-account-bucket",
  "arn:aws:s3:::task3-cross-account-bucket/*"
]
```

---

## Key IAM Lesson

A role's trust policy answers:

> Who can assume this role?

The permission policy answers:

> What can the role do after it is assumed?

For this task:

```text
roleC Trust Policy
        ↓
Only roleB can assume roleC

roleC Permission Policy
        ↓
Access only to task3-cross-account-bucket
```

This follows the principle of least privilege.

```

After creating this, **Task 5 is complete** from the coding/documentation side.
```
