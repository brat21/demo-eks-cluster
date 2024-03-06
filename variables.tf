variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  default = "my-tf-bucket"
}

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  default     = "demo-eks-cluster"
}