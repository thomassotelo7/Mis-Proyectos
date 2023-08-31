module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
  
  cluster_name    = "Tetris-cluster"
  cluster_version = "1.27"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
        resolve_conflict = "OVERWRITE"
        }
    vpc-cni = {
        resolve_conflict = "OVERWRITE"
    }
    
    kube-proxy = {
        most_recent = true
    }
    csi = {
        resolve_conflict = "OVERWRITE"
    }
  }

create_aws_auth_configmap = true
manage_aws_auth_configmap = true
  
  aws_auth_users = [
    {
      userarn  = data.aws_iam_user.me.arn
      username = "daveops"
      groups   = ["system:masters"]
    }
  ]

eks_managed_node_group = {
    node-group = {
        desired_capacity = 1
        max_capacity = 2
        min_capacity = 1
        instances_types = ["t3.medium"]

        tags = {
            Environment = "tetris-env"
        }
    }

    tags = {
        Terraform =  "true"
        Environment = "tetris-env"
    }
}

/*
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
*/

}