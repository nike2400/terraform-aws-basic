# ---------------------------------
# Terraform configuration
# ---------------------------------

terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  # tfstate stored in s3
  # you must execute "terraform init" when you change the storage for tfstate file 
  backend "s3" {
    bucket  = "aws-basic-tfstate-20230729"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# ---------------------------------
# Provider
# ---------------------------------

provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

# ---------------------------------
# Variables
# ---------------------------------

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
}
