variable "aws_region" {
  default = "us-east-1"
}

variable "name" {
  default = "karpenter-demo"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
