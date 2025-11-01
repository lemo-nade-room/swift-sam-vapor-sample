terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_ecr_repository" "sam_lambda_app" {
  name                 = "sam-lambda-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

data "aws_ecr_lifecycle_policy_document" "latest_only" {
  rule {
    priority    = 1
    description = "Latest以外は自動削除"

    action { type = "expire" }

    selection {
      tag_status   = "untagged"
      count_type   = "imageCountMoreThan"
      count_number = 1
    }
  }
}

resource "aws_ecr_lifecycle_policy" "example" {
  repository = aws_ecr_repository.sam_lambda_app.name
  policy     = data.aws_ecr_lifecycle_policy_document.latest_only.json
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.sam_lambda_app.repository_url
}