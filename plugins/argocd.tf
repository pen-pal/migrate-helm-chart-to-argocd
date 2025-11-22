resource "helm_release" "argocd" {
  count = var.create-argocd ? 1 : 0

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.14"
  namespace        = local.argocd.namespace
  create_namespace = true

  values = [
    "${file("${path.module}/values/values.argocd.yaml")}"
  ]

  set = [
    {
      name  = "server.path"
      value = "/"
    },
    {
      name  = "server.tls"
      value = "true"
    },
    {
      name  = "server.extraArgs[0]"
      value = "--insecure"
      type  = "string"
    },
    {
      name  = "configs.cm.create"
      value = "true"
    }
  ]
}
