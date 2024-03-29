# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https:   //github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  aws_profile             = local.account_vars.locals.aws_profile
  aws_region              = local.account_vars.locals.aws_region
  aws_version             = local.account_vars.locals.aws_version
  s3_terragrunt_region    = local.account_vars.locals.s3_terragrunt_region
  s3_terragrunt_bucket    = local.account_vars.locals.s3_terragrunt_bucket
  dynamodb_terraform_lock = local.account_vars.locals.dynamodb_terraform_lock
}

# Generate an AWS provider block
generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "${local.aws_version}"
    }
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = local.s3_terragrunt_bucket
    key            = "terragrunt-states/infra/${path_relative_to_include()}/terraform.tfstate"
    region         = local.s3_terragrunt_region
    dynamodb_table = local.dynamodb_terraform_lock
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.environment_vars.locals,
)
