#module "remote_state" {
#  source      = "./modules/s3backend/"
#  bucket_name = var.bucket_name
#  aws_region  = var.aws_region
#}

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

module "my_app" {
  source = "./modules/my_app/"
  # my_app_namespace = "my-app"
}


#odule "eks_apps" {
# source      = "./modules/eks_apps/"
# bucket_name = var.bucket_name
# region      = var.aws_region
#
