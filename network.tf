module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "5.13.0"
  name               = "${var.name}-vpc"
  cidr               = "10.0.0.0/16"
  enable_nat_gateway = true
  azs                = var.azs
  private_subnets    = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets     = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]


  private_subnet_tags = {
    "karpenter.sh/discovery" = local.eks_cluster_name
  }
}
