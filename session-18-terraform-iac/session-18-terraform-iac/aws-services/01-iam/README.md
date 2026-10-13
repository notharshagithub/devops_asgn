# 01 — IAM: Identity and Access Management (Governance)

## What is IAM?

AWS Identity and Access Management (IAM) controls authentication and authorization for AWS resources. It determines **who or what can make a request** and **which actions are allowed or denied**. IAM is an account-wide control plane; some IAM resources can also be scoped by path or policy.

## Core concepts

### Users
An IAM user is an identity that can represent a person or application and can have long-term credentials. For human access in modern AWS environments, prefer federation through IAM Identity Center and temporary credentials rather than creating long-lived IAM user access keys.

### Groups
A group is a collection of IAM users. Permissions can be attached to a group so that its users receive a common permission set. Groups cannot be used as principals in resource policies in the same way roles or users can.

### Roles
An IAM role is an identity with permissions that can be assumed by a trusted principal. Roles issue temporary security credentials and are commonly used by EC2, Lambda, federated users, and cross-account access.

### Policies
Policies are JSON documents that define permissions. An identity-based policy attaches to a user, group, or role. A resource-based policy attaches to a resource, such as an S3 bucket. Permissions boundaries, service control policies, session policies, and explicit denies can further restrict effective permissions.

### Permissions and authorization
A policy generally specifies `Effect` (`Allow` or `Deny`), `Action`, `Resource`, and optional `Condition`. An explicit deny overrides an allow. A request must be authenticated and authorized by the combined applicable policy evaluation rules.

## Least privilege

Least privilege means granting only the actions, resources, and conditions needed for a task. Start narrow, test the workload, inspect access activity, then reduce permissions further. Avoid broad `Action: "*"` and `Resource: "*"` where they are not required.

## IAM best practices

- Protect the AWS account root user; do not use it for routine work and do not create root access keys.
- Require MFA for human access, especially privileged users.
- Prefer federation and temporary credentials; avoid long-lived access keys where possible.
- Use roles for workloads rather than storing user keys on servers.
- Grant least-privilege permissions and review policies regularly.
- Prefer customer-managed policies when a precise reusable policy is needed; review AWS-managed policies before attaching them.
- Use IAM Access Analyzer and CloudTrail to help review access and activity.
- Remove unused users, roles, permissions, and credentials.
- Separate development, test, and production roles; protect privileged operations with approval.

## Common use cases

- Giving an EC2 instance permission to read selected S3 objects through an instance profile role.
- Allowing a CI/CD workflow to assume a restricted deployment role.
- Granting a developer read-only access to logs without permission to change production resources.
- Enabling secure cross-account access for a trusted role.

## References

- [IAM policies and permissions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)
- [IAM security best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)
