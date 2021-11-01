resource "aws_cloudwatch_dashboard" "services" {
  dashboard_name = "${var.environment}-services"
  dashboard_body = jsonencode(local.dashboard)
}

locals {
  services = [aws_ecs_service.coffee_plz_svc.name]
  targets  = [aws_lb_target_group.coffee_plz_tg.arn_suffix]

  dashboard = {
    widgets = [
      {
        height = 3
        properties = {
          metrics = [
            for container in local.services : [
              "AWS/ECS",
              "CPUUtilization",
              "ServiceName",
              container,
              "ClusterName",
              data.terraform_remote_state.foundation.outputs.aws_ecs_cluster_name,
            ]
          ]
          period  = 300
          region  = var.region
          stacked = false
          stat    = "Average"
          title   = "ECS CPU utilization"
          view    = "timeSeries"
          yAxis = {
            left = {
              max = 100
              min = 0
            }
          }
        }
        type  = "metric"
        width = 12
        x     = 0
        y     = 0
      },
      {
        height = 3
        properties = {
          metrics = [
            for container in local.services : [
              "AWS/ECS",
              "MemoryUtilization",
              "ServiceName",
              container,
              "ClusterName",
              data.terraform_remote_state.foundation.outputs.aws_ecs_cluster_name,
            ]
          ]
          period  = 300
          region  = var.region
          stacked = false
          stat    = "Average"
          title   = "ECS memory utilization"
          view    = "timeSeries"
          yAxis = {
            left = {
              max = 100
              min = 0
            }
          }
        }
        type  = "metric"
        width = 12
        x     = 12
        y     = 0
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        x      = 0
        y      = 4
        properties = {
          title = "Request Count"
          metrics = [for n in local.targets :
            [
              "AWS/ApplicationELB", "RequestCount",
              "LoadBalancer", data.terraform_remote_state.foundation.outputs.application_load_balancer_arn_suffix,
              "TargetGroup", n,
            ]
          ]
          region = var.region
          period = 60
          stat   = "Sum"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type   = "metric"
        width  = 12
        height = 6
        x      = 12
        y      = 4
        properties = {
          title = "Response Time"
          metrics = [for n in local.targets :
            [
              "AWS/ApplicationELB", "TargetResponseTime",
              "LoadBalancer", data.terraform_remote_state.foundation.outputs.application_load_balancer_arn_suffix,
              "TargetGroup", n,
            ]
          ]
          region = var.region
          period = 60
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
    ]
  }
}
