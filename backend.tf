terraform {
  backend "s3" {
    bucket = "terraform-state-us-east-1-demo-argocd-gitops"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
