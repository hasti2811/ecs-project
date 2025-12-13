terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }

  backend "s3" {
    bucket         = "hasti-ecs-project-s3"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "ecs-project-dynamo-db"
  }
}

provider "aws" {
  region = "eu-west-2"
}