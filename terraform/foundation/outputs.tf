output "aws_ecs_cluster_id" {
  value = aws_ecs_cluster.aws_ecs_cluster.id
}

output "aws_ecs_cluster_name" {
  value = aws_ecs_cluster.aws_ecs_cluster.name
}

output "aws_ecr_repository_url" {
  value = aws_ecr_repository.aws_ecr.repository_url
}

output "aws_cloudwatch_log_group_id" {
  value = aws_cloudwatch_log_group.log_group.id
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_exec_role.arn
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "load_balancer_security_group_id" {
  value = aws_security_group.load_balancer_security_group.id
}

output "application_load_balancer_id" {
  value = aws_alb.application_load_balancer.id
}

output "application_load_balancer_arn_suffix" {
  value = aws_alb.application_load_balancer.arn_suffix
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
