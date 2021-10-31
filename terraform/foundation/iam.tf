# iam.tf - All the fun IAM stuffs

resource "aws_iam_role" "fargate_role" {
  name                = "${var.environment}-fargate-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name   = "core_ecs_policy_attachment"
    policy = data.aws_iam_policy_document.coffee_policy_doc.json
  }
}

data "aws_iam_policy_document" "coffee_policy_doc" {
  statement {
    actions = [
      "states:DescribeStateMachine",
      "states:StartExecution",
      "states:ListExecutions",
      "states:DescribeExecution",
      "states:StopExecution",

      "lambda:ListFunctions",
      "lambda:GetFunction",
      "lambda:ListAliases",
      "lambda:InvokeFunction",

      "events:PutTargets", # Required for step functions with Fargate.
      "events:PutRule",
      "events:DescribeRule",

      "ecs:DescribeContainerInstances",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:RunTask",
      "ecs:ListServices",
      "ecs:UpdateService",
      "ec2:DescribeInstances",

      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ListQueues",
      "sqs:PurgeQueue",
      "sns:Publish",
      "sns:ConfirmSubscription",

      "iam:PassRole",

      "firehose:PutRecord",

      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",

      "translate:TranslateText",
    ]
    resources = ["*"]
  }
}
