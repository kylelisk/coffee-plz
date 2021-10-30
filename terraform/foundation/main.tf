terraform {
  backend "s3" {
    bucket = "coffee-plz-tfstate"
    region = "ca-central-1"
    key    = "coffee-plz/foundation.tfstate"
  }
  required_providers {
    aws = { version = "3.58.0" }
  }
}

provider "aws" {
  region = "ca-central-1"
}

data "aws_availability_zones" "current" {}
