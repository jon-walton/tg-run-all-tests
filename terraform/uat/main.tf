terraform {
#  required_version = "1.1.2"
  backend "local" {}
#  required_providers {
#    aws = {
#      source = "hashicorp/aws"
#      version = "3.72.0"
#    }
#
#    sops = {
#      source = "carlpett/sops"
#      version = "0.6.3"
#    }
#  }
}

#provider "aws" {
#  region = "ap-southeast-1"
#  allowed_account_ids = [123]
#  default_tags {
#    Environment = "uat"
#  }
#}
#
#provider "sops" {}
