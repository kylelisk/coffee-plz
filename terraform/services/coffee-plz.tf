resource "aws_lb_target_group" "coffee_plz_tg" {
  name        = "${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.foundation.outputs.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.environment}-lb-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "coffee_plz_listener" {
  load_balancer_arn = data.terraform_remote_state.foundation.outputs.application_load_balancer_id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.coffee_plz_tg.id
  }
}

resource "aws_ecs_task_definition" "coffee_plz_definition" {
  family = "${var.environment}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.environment}-container",
      "image": "${data.terraform_remote_state.foundation.outputs.aws_ecr_repository_url}:latest",
      "entryPoint": [],
      "environment": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${data.terraform_remote_state.foundation.outputs.aws_cloudwatch_log_group_id}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "${var.environment}"
        }
      },
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = data.terraform_remote_state.foundation.outputs.ecs_task_execution_role_arn
  task_role_arn            = data.terraform_remote_state.foundation.outputs.ecs_task_execution_role_arn

  tags = {
    Name        = "${var.environment}-ecs-td"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "coffee_plz_svc" {
  name                 = "${var.environment}-ecs-service"
  cluster              = data.terraform_remote_state.foundation.outputs.aws_ecs_cluster_id
  task_definition      = aws_ecs_task_definition.coffee_plz_definition.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = data.terraform_remote_state.foundation.outputs.private_subnet_ids.*
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      data.terraform_remote_state.foundation.outputs.load_balancer_security_group_id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.coffee_plz_tg.arn
    container_name   = "${var.environment}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.coffee_plz_listener]
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.coffee_plz_definition.family
}

resource "aws_security_group" "service_security_group" {
  vpc_id = data.terraform_remote_state.foundation.outputs.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [data.terraform_remote_state.foundation.outputs.load_balancer_security_group_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-service-sg"
    Environment = var.environment
  }
}
