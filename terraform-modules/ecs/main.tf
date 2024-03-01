#----- ECS --------
resource "aws_ecs_cluster" "cluster" {
  name = local.envname

  tags = var.tags
}

resource "aws_ecs_capacity_provider" "this" {
  name = local.envname

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.asg.arn
  }

  tags = var.tags

  // depends_on = [aws_iam_service_linked_role.ecs]
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE", aws_ecs_capacity_provider.this.name]
    
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 100
  }
}
