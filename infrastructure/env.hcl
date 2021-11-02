locals {
  environment = "prod"

  // ALB
  default_alb_url = "www.codeforboston.org"

  // Amazon Certificate Manager
  // Hardcoding pre-created certificate to avoid reaching limit https://github.com/aws/aws-cdk/issues/5889
  domain_names = ["nationalpolicedata.org"]

  // Route 53 Records - That will point to the ALB
  // host_names = ["fight.foodoasis.net"]
  host_names = []

  // ECS
  ecs_ec2_instance_count = 0
  ecs_ec2_instance_type  = "t3.small"

  // Bastion
  bastion_hostname         = "bastion.nationalpolicedata.org"
  cron_key_update_schedule = "5,0,*,* * * * *"
  github_file = {
    github_repo_owner = "codeforboston",
    github_repo_name  = "police-data-trust",
    github_branch     = "main",
    github_filepath   = "aws_terraform_infra/bastion_github_users",
  }

  // Global tags
  tags = { terraform_managed = "true", last_changed = formatdate("EEE YYYY-MMM-DD hh:mm:ss", timestamp()) }
}
