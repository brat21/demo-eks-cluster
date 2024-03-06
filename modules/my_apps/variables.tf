variable "namespace" {
  type    = string
  default = "my-app"
}

variable "eks_endpoint" {
  description = "Endpoint for EKS control plane"
  default     = ""
}

variable "eks_certificate" {
  description = "Certificate for EKS cluster"
  default     = ""
}

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  default     = ""
}

variable "eks_auth_token" {
  description = "Auth token for EKS cluster"
  default     = ""
}