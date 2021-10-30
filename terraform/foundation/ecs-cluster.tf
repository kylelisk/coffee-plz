# ecs-cluster.tf - All the ecs related mumbo jumbo

resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "${var.environment}-cluster"
  tags = {
    Name        = "${var.environment}-ecs"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.environment}-logs"

  tags = {
    Application = var.environment
    Environment = var.environment
  }
}
