module "eks_plugins" {
  source = "./plugins"

  config     = var.config
  account-id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  cluster_id                         = data.aws_eks_cluster.cluster.id
  cluster_certificate_authority_data = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_endpoint                   = data.aws_eks_cluster.cluster.endpoint
  oidc_issuer                        = try(replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", ""), null)
  oidc_issuer_arn                    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"

  create-argocd = var.create_argocd
  argocd_domain = var.argocd_domain
}
