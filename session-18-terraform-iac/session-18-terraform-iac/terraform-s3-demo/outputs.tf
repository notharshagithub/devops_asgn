output "bucket_name" {
  description = "Name of the created S3 bucket."
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "Amazon Resource Name (ARN) of the S3 bucket."
  value       = aws_s3_bucket.demo.arn
}

output "aws_region" {
  description = "Region configured for the AWS provider."
  value       = var.aws_region
}
