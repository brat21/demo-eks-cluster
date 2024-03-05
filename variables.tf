variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  default = "my-tf-bucket-5"
}

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  default     = "demo-eks-cluster-5"
}

#variable "domain_name" {
#  type    = string
#  default = ""
#}