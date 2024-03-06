module "network" {
  source     = "./modules/network/"
  aws_region = var.aws_region
}

module "eks_cluster" {
  source                 = "./modules/eks_cluster/"
  aws_region             = var.aws_region
  eks_cluster_name       = var.eks_cluster_name
  eks_public_access_cidr = ["145.14.36.80/32", "80.235.87.151/32"]
  eks_version            = 1.29
  vpc_id                 = module.network.vpc_id
  private_subnets        = module.network.private_subnets
}

module "my_apps" {
  source           = "./modules/my_apps/"
  eks_endpoint     = module.eks_cluster.eks_endpoint
  eks_certificate  = module.eks_cluster.eks_certificate
  eks_cluster_name = module.eks_cluster.eks_cluster_name
  eks_auth_token   = module.eks_cluster.eks_auth_token
} 