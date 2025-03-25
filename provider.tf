terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "fastfood-db-terraform-state"
    key    = "infra/state.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  region = var.aws_region
}