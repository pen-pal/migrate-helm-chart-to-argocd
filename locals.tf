locals {
  common_tags = {
    product     = var.project
    environment = var.environment
    terraform   = "true"
  }
  project_name = var.project_name

  config = {
    product     = var.project
    environment = var.environment
  }

  # Private subnets (large, for EKS workloads)
  # Total IPs per /19 = 2^(32−19) = 8,192
  # AWS reserved = 5
  # Usable IPs = 8,192 − 5 = 8,187 usable IPs per private subnet
  # 3 AZs → each AZ gets one /19 → 8,187 usable per AZ for EKS nodes + pods
  # 10.10.0.0/19
  # 10.10.32.0/19
  # 10.10.64.0/19
  private_subnets = [
    cidrsubnet(var.vpc_cidr, 3, 0),
    cidrsubnet(var.vpc_cidr, 3, 1),
    cidrsubnet(var.vpc_cidr, 3, 2)
  ]

  # Public subnets (small, for ALB/NAT)
  # 256 IPs
  # Total IPs per /24 = 2^(32−24) = 256
  # AWS reserved = 5
  # Usable IPs = 256 − 5 = 251 usable IPs per public subnet
  public_subnets = [
    cidrsubnet(var.vpc_cidr, 8, 206), # 10.10.200.0/24 (AZ a)
    cidrsubnet(var.vpc_cidr, 8, 208), # 10.10.201.0/24 (AZ b)
    cidrsubnet(var.vpc_cidr, 8, 210)  # 10.10.202.0/24 (AZ c)
  ]

  # Database subnets
  # Total IPs = 128
  # AWS reserves 5 IPs per subnet (network, broadcast, plus some for AWS networking)
  # Usable IPs = 128 − 5 = 123 usable IPs per DB subnet
  database_subnets = [
    cidrsubnet(var.vpc_cidr, 9, 400), # 10.10.220.0/25 (AZ a)
    cidrsubnet(var.vpc_cidr, 9, 401), # 10.10.220.128/25 (AZ b)
    cidrsubnet(var.vpc_cidr, 9, 402)  # 10.10.221.0/25 (AZ c)
  ]

  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
}
