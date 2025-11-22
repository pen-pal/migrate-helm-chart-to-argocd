terraform {
  required_version = ">= 0.15.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4"
    }
  }
}
