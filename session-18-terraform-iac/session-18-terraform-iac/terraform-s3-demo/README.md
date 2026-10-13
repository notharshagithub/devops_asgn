# Terraform S3 Demo

## Objective

Use Terraform to provision an Amazon S3 bucket and manage its configuration as code.

## Resources created

- S3 bucket with an AWS-generated unique suffix (avoids relying on a globally unique hard-coded bucket name).
- S3 Block Public Access settings enabled.
- Default server-side encryption using SSE-S3 (`AES256`).
- Bucket versioning enabled.

No objects are uploaded by this project. The bucket is not configured for public website hosting.

## 1. Prerequisites and AWS authentication

Install Terraform and the AWS CLI, then configure credentials using an approved method. For an interactive learning account, a named AWS CLI profile is also possible.

```bash
terraform -version
aws --version
aws sts get-caller-identity
```

If using a profile, select it for the shell before running Terraform, e.g. `export AWS_PROFILE=my-learning-profile`. Do not place access keys in `terraform.tfvars` or commit credentials.

## 2. Initialize Terraform

Run every Terraform command from this directory (`terraform-s3-demo/`).

```bash
terraform init
```

Downloads the required AWS provider and initializes the working directory. Review and commit `.terraform.lock.hcl` if Terraform creates it; it records selected provider versions and checksums.

## 3. Format the files

```bash
terraform fmt
terraform fmt -check
```

`fmt` applies canonical formatting. `fmt -check` verifies formatting without changing files.

## 4. Validate configuration

```bash
terraform validate
```

Checks Terraform syntax and internal configuration consistency. It does not replace a plan or prove that AWS permissions are sufficient.

## 5. Review a plan

```bash
terraform plan -out=tfplan
```

Review the plan before continuing. It should show creation of the S3 bucket and its public-access, encryption, and versioning configuration resources.

## 6. Apply

```bash
terraform apply tfplan
```

Terraform creates the resources in the configured region. Confirm the account and region are correct before applying. The default prefix is `session18-terraform-s3-demo-`; Terraform adds a generated suffix for uniqueness.

If you prefer the interactive workflow, use `terraform apply` and review the proposed changes before confirming.

## 7. Inspect the result

```bash
terraform show
terraform output
terraform output bucket_name
terraform output bucket_arn
```

`terraform show` displays the tracked infrastructure state. `terraform output` displays the declared outputs, including bucket name, ARN, and region.

Optional AWS CLI checks:

```bash
aws s3api get-public-access-block --bucket "$(terraform output -raw bucket_name)"
aws s3api get-bucket-encryption --bucket "$(terraform output -raw bucket_name)"
aws s3api get-bucket-versioning --bucket "$(terraform output -raw bucket_name)"
```

## 8. Destroy the resources

When finished:

```bash
terraform destroy
```

Review the destroy plan and confirm. The demo does not upload objects, so the bucket should be empty. If you add objects manually, remove the objects and any noncurrent versions before destroying the bucket; S3 buckets cannot be deleted while they contain object versions.

## What each file does

| File | Purpose |
|---|---|
| `provider.tf` | Terraform/provider requirements and AWS provider configuration |
| `main.tf` | S3 bucket, block-public-access, encryption, and versioning resources |
| `variables.tf` | Region and bucket-prefix inputs |
| `terraform.tfvars` | Non-secret input values for this demo |
| `outputs.tf` | Bucket name, ARN, and region outputs |
| `.gitignore` | Excludes Terraform state, working files, and plan files |

## Important security notes

- Terraform state can contain sensitive infrastructure data. Keep state files and backups out of Git.
- Do not commit AWS credentials or secrets. Use CLI profiles, IAM Identity Center, environment credentials, or a supported role-based identity.
- Keep Block Public Access enabled unless you have a reviewed, explicit reason to change it.
- Review every `terraform plan`, especially before destructive changes.
- This creates real AWS resources and may incur charges. Destroy the resources when you finish.

## References

- [Terraform AWS S3 bucket resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
- [S3 default encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)
- [Terraform CLI commands](https://developer.hashicorp.com/terraform/cli/commands)
