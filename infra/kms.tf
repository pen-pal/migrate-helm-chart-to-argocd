module "ebs_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 4"

  description = "KMS key for EBS Volume"

  # Aliases
  aliases                 = ["${var.config.product}-${var.config.environment}-ebs"]
  aliases_use_name_prefix = true

  key_administrators = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  key_service_roles_for_autoscaling = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]


  tags = {
    Component = "ebs"
    Name      = "ebs-kms-key"
  }
}
