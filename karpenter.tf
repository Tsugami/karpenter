
module "karpenter" {
  source                    = "aws-ia/eks-blueprints-addons/aws"
  version                   = "1.16.3"
  cluster_name              = module.eks.cluster_name
  cluster_endpoint          = module.eks.cluster_endpoint
  cluster_version           = module.eks.cluster_version
  oidc_provider_arn         = module.eks.oidc_provider_arn
  enable_karpenter          = true
  create_delay_dependencies = [for prof in module.eks.fargate_profiles : prof.fargate_profile_arn]

  karpenter_node = {
    # Use static name so that it matches what is defined in `karpenter.yaml` example manifest
    iam_role_use_name_prefix = false
  }
}

# resource "kubernetes_manifest" "karpenter_ec2_nodeclass" {
#   manifest = {
#     apiVersion = "karpenter.k8s.aws/v1beta1"
#     kind       = "EC2NodeClass"
#     metadata = {
#       name = "default"
#     }
#     spec = {
#       amiFamily = "AL2" # Amazon Linux 2
#       subnetSelectorTerms = [
#         {
#           tags = {
#             "karpenter.sh/discovery" = "${local.eks_cluster_name}"
#           }
#         }
#       ]

#       securityGroupSelectorTerms = [
#         {
#           tags = {
#             "karpenter.sh/discovery" = "${local.eks_cluster_name}"
#           }
#         }
#       ]

#       role = module.karpenter.karpenter.node_iam_role_name
#       # amiSelectorTerms = [
#       #   {
#       #     name = "*"
#       #   }
#       # ]
#     }
#   }
#   depends_on = [ module.karpenter ]
# }



# resource "kubernetes_manifest" "karpenter_default_nodepool" {
#   manifest = {
#     apiVersion = "karpenter.sh/v1beta1"
#     kind       = "NodePool"
#     metadata = {
#       name = "default"
#     }
#     spec = {
#       template = {
#         spec = {
#           requirements = [
#             {
#               key      = "kubernetes.io/arch"
#               operator = "In"
#               values   = ["amd64"]
#             },
#             {
#               key      = "kubernetes.io/os"
#               operator = "In"
#               values   = ["linux"]
#             },
#             {
#               key      = "karpenter.sh/capacity-type"
#               operator = "In"
#               values   = ["spot"]
#             },
#             {
#               key      = "karpenter.k8s.aws/instance-category"
#               operator = "In"
#               values   = ["c", "m", "r", "t"]
#             },
#             {
#               key      = "karpenter.k8s.aws/instance-generation"
#               operator = "Gt"
#               values   = ["2"]
#             }
#           ]
#           nodeClassRef = {
#             apiVersion = "karpenter.k8s.aws/v1beta1"
#             kind       = "EC2NodeClass"
#             name       = "default"
#           }
#         }
#       }
#       limits = {
#         cpu = 1000
#       }
#       weight = 100
#       disruption = {
#         consolidationPolicy = "WhenUnderutilized"
#         # expireAfter         = "720h"
#       }
#     }
#   }

#   depends_on = [kubernetes_manifest.karpenter_ec2_nodeclass, module.karpenter]
# }




# resource "kubernetes_manifest" "karpenter_default_nodepool_fallback" {
#   manifest = {
#     apiVersion = "karpenter.sh/v1beta1"
#     kind       = "NodePool"
#     metadata = {
#       name = "default-fallback"
#     }
#     spec = {
#       template = {
#         spec = {
#           requirements = [
#             {
#               key      = "kubernetes.io/arch"
#               operator = "In"
#               values   = ["amd64"]
#             },
#             {
#               key      = "kubernetes.io/os"
#               operator = "In"
#               values   = ["linux"]
#             },
#             {
#               key      = "karpenter.sh/capacity-type"
#               operator = "In"
#               values   = ["on-demand"]
#             },
#             {
#               key      = "karpenter.k8s.aws/instance-category"
#               operator = "In"
#               values   = ["c", "m", "r", "t"]
#             },
#             {
#               key      = "karpenter.k8s.aws/instance-generation"
#               operator = "Gt"
#               values   = ["2"]
#             }
#           ]
#           nodeClassRef = {
#             apiVersion = "karpenter.k8s.aws/v1beta1"
#             kind       = "EC2NodeClass"
#             name       = "default"
#           }
#         }
#       }
#       limits = {
#         cpu = 1000
#       }
#       weight = 100

#       disruption = {
#         consolidationPolicy = "WhenUnderutilized"
#         # expireAfter         = "720h"
#       }
#     }
#   }

#   depends_on = [kubernetes_manifest.karpenter_ec2_nodeclass, module.karpenter]
# }


