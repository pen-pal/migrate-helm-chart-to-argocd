module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21"

  vpc_id                                 = module.vpc.vpc_id
  subnet_ids                             = module.vpc.private_subnets #module.vpc.private_subnets
  ip_family                              = "ipv4"
  name                                   = "${local.config.product}-${local.config.environment}-eks"
  kubernetes_version                     = var.cluster_version
  endpoint_private_access                = var.cluster_endpoint_private_access
  endpoint_public_access                 = var.cluster_endpoint_public_access
  security_group_description             = var.cluster_security_group_description
  security_group_name                    = "${local.config.product}-${local.config.environment}-eks"
  self_managed_node_groups               = var.self_managed_node_groups
  enable_irsa                            = var.enable_irsa
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  prefix_separator                       = ""
  iam_role_name                          = "${local.config.product}-${local.config.environment}-eks"
  iam_role_additional_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  authentication_mode = "API_AND_CONFIG_MAP"

  create_kms_key = true


  addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = data.aws_eks_addon_version.coredns.version
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = data.aws_eks_addon_version.kube-proxy.version
      configuration_values = jsonencode({
        mode = "ipvs"
        ipvs = {
          scheduler = "rr"
        }
      })
    }
    vpc-cni = {
      before_compute           = true
      resolve_conflicts        = "OVERWRITE"
      addon_version            = data.aws_eks_addon_version.vpc-cni.version
      service_account_role_arn = module.vpc_cni_irsa.arn
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION          = "true"
          WARM_PREFIX_TARGET                = "1"
          ENABLE_POD_ENI                    = "true"
          AWS_VPC_K8S_CNI_EXTERNALSNAT      = "true"
          POD_SECURITY_GROUP_ENFORCING_MODE = "standard"
        }
      })
    }
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      addon_version            = data.aws_eks_addon_version.ebs-csi.version
      service_account_role_arn = module.ebs_csi_irsa.arn
      configuration_values = jsonencode({
        fips = true
      })
    }
  }

  # Extend cluster security group rules
  security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_kubelet = {
      description                   = "To node 1025-65535"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_15017 = {
      description                   = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
      protocol                      = "TCP"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_15012 = {
      description                   = "Cluster API to nodes ports/protocols"
      protocol                      = "TCP"
      from_port                     = 15012
      to_port                       = 15012
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    ondemand = {
      name                  = "default-${var.environment}"
      create_security_group = false
      use_name_prefix       = true

      enable_efa_support = false

      iam_role_attach_cni_policy = true
      iam_role_use_name_prefix   = false
      iam_role_additional_policies = {
        AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
        AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      min_size     = var.ondemand_min_size
      max_size     = var.ondemand_max_size
      desired_size = var.ondemand_desired_size

      subnet_ids = module.vpc.private_subnets

      create_launch_template     = true
      use_custom_launch_template = true

      ami_type                   = var.ondemand_ami_type
      enable_bootstrap_user_data = true

      bootstrap_extra_args = <<-EOT
        [settings.host-containers.admin]
        enabled = false
        [settings.kernel]
        lockdown = "integrity"
        [settings.kubernetes.node-labels]
        "environment" = "${var.environment}"
        [settings.kubernetes.node-taints]
        dedicated = "experimental:PreferNoSchedule"
        special = "true:PreferNoSchedule"
      EOT
      ### bottlerocket configuration

      force_update_version = true
      disk_size            = 50
      instance_types       = length(var.ondemand_instance_types) > 0 ? var.ondemand_instance_types : var.instance_types
      capacity_type        = var.capacity_type

      update_config = {
        max_unavailable_percentage = 50
      }

      disable_api_termination = false
      ebs_optimized           = true
      enable_monitoring       = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            kms_key_id            = module.ebs_kms.key_arn
            delete_on_termination = true
          }
        }
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      node_repair_config = {
        enabled = true
      }

      tags = {
        "k8s.io/cluster-autoscaler/${"${local.config.product}-${local.config.environment}-eks"}" = "owned"
        "k8s.io/cluster-autoscaler/enabled"                                                      = "TRUE"
      }
    }
  }
}
