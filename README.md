# Repository

### infrastructure structure
```
infra
├── data.tf
├── eks-variables.tf
├── eks.tf
├── irsa.tf
├── kms.tf
├── LICENSE
├── locals.tf
├── main.tf
├── plugin-variables.tf
├── plugins
│   ├── argocd.tf
│   ├── datasource.tf
│   ├── locals.tf
│   ├── providers.tf
│   ├── reloader.tf
│   ├── values
│   │   ├── values.argocd.yaml
│   ├── variables.tf
│   └── versions.tf
├── plugins.tf
├── README.md
├── terraform-bootstrap.cfn
├── terraform.auto.tfvars
├── variables.tf
├── version.tf
└── vpc.tf
```

### argocd apps structure
```
argocd
├── apps
│   ├── target-env
│   │   ├── Chart.yaml
│   │   ├── templates
│   │   │   └── pgadmin
│   │   │       ├── _helpers.tpl
│   │   │       └── pgadmin.yaml
│   │   └── values.yaml
│   └── values
│       └── pgadmin
│           ├── Chart.yaml
│           └── pgadmin.yaml
├── controller.yaml
```
