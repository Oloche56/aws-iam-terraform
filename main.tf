# AWS IAM Terraform Configuration
# Secure IAM setup following best practices

# Configure AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create IAM group for developers
resource "aws_iam_group" "developers" {
  name = "Developers"
  path = "/"
}

# Create IAM user
resource "aws_iam_user" "example_user" {
  name = "demo.user"
  path = "/"
}

# Add user to group
resource "aws_iam_user_group_membership" "example" {
  user = aws_iam_user.example_user.name

  groups = [
    aws_iam_group.developers.name,
  ]
}

# Create IAM policy for S3 read-only access
resource "aws_iam_policy" "s3_read_only" {
  name        = "S3ReadOnlyAccess"
  description = "Provides read-only access to S3 buckets"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "s3_read_only" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}

# Output important information
output "iam_user_arn" {
  value = aws_iam_user.example_user.arn
}

output "iam_group_name" {
  value = aws_iam_group.developers.name
}
