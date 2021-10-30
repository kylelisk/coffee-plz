# ecr.tf - The container registry

resource "aws_ecr_repository" "aws_ecr" {
  name = "${var.environment}-ecr"
  tags = {
    Name        = "${var.environment}-ecr"
    Environment = var.environment
  }
}
