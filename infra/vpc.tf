##################################################
# Create VPC in AWS
##################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6"

  name                                 = "${var.environment}-${var.project_name}-vpc"
  cidr                                 = var.vpc_cidr
  azs                                  = local.azs
  public_subnets                       = local.public_subnets
  private_subnets                      = local.private_subnets
  database_subnets                     = local.database_subnets
  create_database_subnet_group         = true
  create_database_subnet_route_table   = true
  enable_nat_gateway                   = true
  single_nat_gateway                   = false
  enable_ipv6                          = false
  one_nat_gateway_per_az               = true
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  public_subnet_tags = {
    "kubernetes.io/role/elb"                                                        = 1
    "kubernetes.io/cluster/${local.config.product}-${local.config.environment}-eks" = "shared"
    "Network"                                                                       = "Public"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"                                               = 1
    "kubernetes.io/cluster/${local.config.product}-${local.config.environment}-eks" = "shared"
    "Network"                                                                       = "Private"
  }
  database_subnet_tags = {
    "Network" = "Database"
  }
}
