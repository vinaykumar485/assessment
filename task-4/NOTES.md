````markdown
# Task 4 — Least-Privilege Policy Writing

## CI User

The `ci` IAM user from Task 3 is given a custom least-privilege policy.

The policy allows the CI pipeline to perform only the actions required for:

- Pushing Docker images to a specific ECR repository
- Deploying a new ECS task definition
- Updating a specific ECS service
- Reading build artifacts from a specific S3 bucket

---

## 1. ECR Permissions

The `ci` user can push Docker images only to:

```text
ci-app
````

The policy allows:

* `ecr:GetAuthorizationToken`
* `ecr:BatchCheckLayerAvailability`
* `ecr:InitiateLayerUpload`
* `ecr:UploadLayerPart`
* `ecr:CompleteLayerUpload`
* `ecr:PutImage`

The repository-specific actions are restricted to the `ci-app` repository.

`ecr:GetAuthorizationToken` uses `Resource = "*"` because this action is not scoped to a specific ECR repository.

---

## 2. ECS Permissions

The CI pipeline can:

* Register a new ECS task definition
* Update the `ci-service` service in the `ci-cluster`
* Read ECS deployment information

The policy allows:

```text
ecs:RegisterTaskDefinition
ecs:UpdateService
ecs:DescribeServices
ecs:DescribeTaskDefinition
ecs:DescribeTasks
```

`ecs:UpdateService` is restricted to the specific ECS service.

`ecs:RegisterTaskDefinition` uses `Resource = "*"` because this API does not support the same resource-level restriction as the ECS service update operation.

---

## 3. S3 Permissions

The CI pipeline needs to read build artifacts from:

```text
ci-build-artifacts
```

The policy allows:

```text
s3:ListBucket
s3:GetBucketLocation
s3:GetObject
s3:GetObjectVersion
```

The bucket-level permissions are restricted to the specific bucket, and object-level permissions are restricted to objects inside that bucket.

---

## 4. What Was Deliberately Left Out?

### ECR

I did not allow:

```text
ecr:DeleteRepository
ecr:DeleteRepositoryPolicy
ecr:SetRepositoryPolicy
```

because the CI pipeline only needs to push images, not manage the ECR repository itself.

I also did not allow push access to all ECR repositories.

---

### ECS

I did not allow:

```text
ecs:*
```

because the CI pipeline does not need full ECS administration.

For example, it does not need permissions to:

* Create clusters
* Delete clusters
* Delete services
* Manage ECS capacity providers
* Modify unrelated ECS services

The service update permission is restricted to the required ECS service.

---

### S3

I deliberately did not allow:

```text
s3:PutObject
s3:DeleteObject
s3:DeleteBucket
```

because the CI pipeline only needs to read build artifacts.

This prevents the CI user from modifying or deleting artifacts.

---

### IAM

I did not give the `ci` user:

```text
iam:*
```

The CI pipeline should not be able to create, delete, or modify IAM users, groups, roles, or policies.

If the ECS task definition requires passing an IAM execution/task role, `iam:PassRole` would need to be added separately and scoped only to the required role ARN.

---

## Least-Privilege Principle

The main principle used in this policy is:

> Give the CI pipeline only the permissions it actually needs, and restrict access to specific resources wherever AWS supports resource-level permissions.

The policy intentionally avoids broad permissions such as:

```text
ecr:*
ecs:*
s3:*
iam:*
```

This reduces the impact if the CI credentials are accidentally exposed or compromised.

```
```
