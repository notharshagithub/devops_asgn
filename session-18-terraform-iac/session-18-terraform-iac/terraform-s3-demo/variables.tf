variable "aws_region" {
  description = "AWS region in which to create the S3 bucket."
  type        = string
  default     = "ap-south-1"
}

variable "bucket_prefix" {
  description = "Lowercase prefix for the S3 bucket name. AWS bucket names must be globally unique."
  type        = string
  default     = "session18-terraform-s3-demo"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,45}$", var.bucket_prefix))
    error_message = "bucket_prefix must be 3-46 characters using lowercase letters, numbers, or hyphens; it must begin with a lowercase letter or number."
  }
}
