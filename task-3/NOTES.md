# Task 3 — Multi-Account IAM & Cross-Account Access

## Account A

Account A contains:

* `group1`

  * `engine`
  * `ci`
* `group2`

  * `admin1`
  * `admin2`
* `roleA` — administrative access to AWS services except IAM
* `roleB` — allowed to assume `roleC` in Account B

## Account B

Account B contains:

* `roleC` — full access to one specific S3 bucket
* `roleC` can be assumed only by `roleB` from Account A

---

## 1. Would you actually give engine and ci IAM users with access keys in a real production setup?

For this assessment, I created `engine` and `ci` as IAM users with programmatic access because the task specifically asks for IAM users.

In a real production environment, I would normally avoid using long-lived IAM user access keys for CI/CD systems.

Instead, I would prefer IAM roles with temporary credentials. For a CI/CD pipeline, I would use OIDC federation where possible. The CI system can authenticate to AWS and assume an IAM role without storing a permanent AWS access key and secret key.

This is safer because long-lived access keys can be accidentally exposed in source code, CI/CD configuration, logs, or other places.

For human users, I would also prefer a centralized identity solution such as IAM Identity Center instead of creating many individual IAM users.

So, for this assessment I followed the requirement, but in production I would prefer short-lived credentials and role-based access.

---

## 2. In roleC's trust policy, why does it matter whether you trust the whole Account A root vs. roleB's specific ARN?

The trust policy determines who is allowed to assume a role.

If `roleC` trusts the whole Account A principal:

```text
arn:aws:iam::000000000000:root
```

the trust relationship is broader than necessary. It establishes trust with the Account A principal, and permissions in Account A can determine which identities are able to use that trust relationship.

However, this task specifically requires that only `roleB` should be able to assume `roleC`.

Therefore, I use the specific role ARN:

```text
arn:aws:iam::000000000000:role/roleB
```

This is more restrictive and follows the principle of least privilege.

The intended flow is:

```text
Account A
    |
    | roleB
    |
    | sts:AssumeRole
    v
Account B
    |
    | roleC
    |
    v
Specific S3 bucket
```

Other identities in Account A, such as `engine`, `ci`, `admin1`, `admin2`, or `roleA`, are not directly trusted by `roleC`.

---

## Trust Policy vs Permission Policy

A trust policy answers:

> Who can assume this role?

A permission policy answers:

> What can this role do after it has been assumed?

For `roleC`:

* Trust policy → only `roleB` from Account A can assume it.
* Permission policy → `roleC` can access only the specified S3 bucket.

Both are required for the cross-account access to work securely.

---

## Task 3 Summary

The intended access flow is:

```text
Account A                         Account B

engine  ──X
ci      ──X
admin1  ──X
admin2  ──X
roleA   ──X

roleB ─────────────────────────► roleC
                                   |
                                   v
                         task3-cross-account-bucket
```

`roleB` has only the permission to assume `roleC`.

`roleC` trusts only `roleB` and has access to the specific S3 bucket.
