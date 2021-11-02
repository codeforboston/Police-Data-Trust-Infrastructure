# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  aws_profile   = "cfb-pdt"
  aws_region    = "us-east-1"
  namespace     = "cfb"
  resource_name = "infra"

  # Pre-created AWS Resources:
  # S3 Bucket for storing Terragrunt/Terraform State files
  s3_terragrunt_region = "us-east-1"
  s3_terragrunt_bucket = "cfb-infra-terragrunt"
  # DynamoDB Table for storing lock files to avoid collision
  dynamodb_terraform_lock = "terraform-locks"
  # EC2 SSH Key
  key_name = "cfb-infra-us-east-1" #TODO: Make optional
}
