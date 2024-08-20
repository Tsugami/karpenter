locals {
  eks_cluster_name = "${var.name}-eks-cluster"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    # coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  tags = {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.eks_cluster_name
  }

  fargate_profiles = {
    karpenter = {
      selectors = [
        { namespace = "karpenter" }
      ]
    }
    coredns = {
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

  # EKS Managed Node Group(s)
  #   eks_managed_node_group_defaults = {
  #     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  #   }

  #   eks_managed_node_groups = {
  #     example = {
  #       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
  #       ami_type       = "AL2023_x86_64_STANDARD"
  #       instance_types = ["m5.xlarge"]

  #       min_size     = 2
  #       max_size     = 10
  #       desired_size = 2
  #     }
  #   }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  #   access_entries = {
  #     # One access entry with a policy associated
  #     example = {
  #       kubernetes_groups = []
  #       principal_arn     = "arn:aws:iam::123456789012:role/something"

  #       policy_associations = {
  #         example = {
  #           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #           access_scope = {
  #             namespaces = ["default"]
  #             type       = "namespace"
  #           }
  #         }
  #       }
  #     }
  #   }
}
