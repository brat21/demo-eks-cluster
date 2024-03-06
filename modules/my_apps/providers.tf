provider "kubernetes" {
  host                   = var.eks_cluster_name #data.aws_eks_cluster.cluster.endpoint
  token                  = var.eks_auth_token   #data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(var.eks_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_name
    token                  = var.eks_auth_token
    cluster_ca_certificate = base64decode(var.eks_certificate)
  }
}