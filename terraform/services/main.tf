terraform {
  backend "s3" {
    bucket = "coffee-plz-tfstate"
    region = "ca-central-1"
    key    = "coffee-plz/services.tfstate"
  }
  required_providers {
    aws = { version = "3.58.0" }
  }
}

provider "aws" {
  region = "ca-central-1"
}

data "aws_availability_zones" "current" {}

data "terraform_remote_state" "foundation" {
  backend = "s3"
  config = {
    bucket = "coffee-plz-tfstate"
    key    = "coffee-plz/foundation.tfstate"
    region = "ca-central-1"
  }
}
