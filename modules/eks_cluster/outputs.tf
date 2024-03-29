output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "eks_role_name" {
  value = aws_iam_role.eks_cluster.name
}

output "eks_node_group_name" {
  value = aws_eks_node_group.my_node_group.node_group_name
}

output "eks_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.cluster.endpoint
}

output "eks_certificate" {
  description = "Certificate for EKS cluster"
  value       = aws_eks_cluster.cluster.certificate_authority.0.data
}

output "eks_auth_token" {
  description = "EKS Auth token for EKS cluster"
  value       = data.aws_eks_cluster_auth.cluster.token
}