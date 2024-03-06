output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

output "eks_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster.eks_endpoint
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}
