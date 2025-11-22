data "aws_eks_cluster" "cluster" {
  name       = "${var.config.product}-eks"
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = "${var.config.product}-eks"
  depends_on = [module.eks]
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# EKS Addon Version
data "aws_eks_addon_version" "vpc-cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

data "aws_eks_addon_version" "kube-proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

data "aws_eks_addon_version" "ebs-csi" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.cluster_version
  most_recent        = true
}
