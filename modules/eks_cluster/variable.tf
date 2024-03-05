variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  default     = "demo-eks-cluster"
}

variable "eks_public_access_cidr" {
  description = "Cidr block for Public Access"
  default     = ["0.0.0.0/0"]
}

variable "eks_sg_ingress" {
  description = "Ingress Security Group rules for EKS Cluster"
  type = list(
    object({
      description = string
      cidr_blocks = list(string)
      from_port   = number
      to_port     = number
      protocol    = string
      self        = bool
    })
  )
  default = []
}

variable "eks_sg_egress" {
  description = "Egress Security Group rules for EKS Cluster"
  type = list(
    object({
      description = string
      cidr_blocks = list(string)
      from_port   = number
      to_port     = number
      protocol    = string
      self        = bool
    })
  )
  default = []
}


variable "eks_node_sg_ingress" {
  description = "Ingress Security Group rules for EKS Nodes"
  type = list(
    object({
      description = string
      cidr_blocks = list(string)
      from_port   = number
      to_port     = number
      protocol    = string
      self        = bool
    })
  )
  default = [
    { from_port = 53, to_port = 53, protocol = "tcp", cidr_blocks = [], self = true, description = "Node to node CoreDNS" },
    { from_port = 53, to_port = 53, protocol = "udp", cidr_blocks = [], self = true, description = "Node to node CoreDNS UDP" },
    { from_port = 1025, to_port = 65535, protocol = "tcp", cidr_blocks = [], self = true, description = "Node to node ingress on ephemeral ports" },
  ]
}

variable "eks_node_sg_egress" {
  description = "Egress Security Group rules for EKS Nodesr"
  type = list(
    object({
      description = string
      cidr_blocks = list(string)
      from_port   = number
      to_port     = number
      protocol    = string
      self        = bool
    })
  )
  default = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], self = false, description = "Allow all egress" },
  ]
}

variable "eks_version" {
  description = "Version of EKS Cluster"
  default     = ""
}

variable "tags" {
  type = map(string)
  default = {
    Createdby = "Terraform"
    Team      = "DevOPS"
  }
  description = "AWS resource tags"
}

variable "aws_region" {
  description = "AWS Region"
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID"
  default     = ""
}

variable "private_subnets" {
  description = "List of Private Subnet IDs"
  default     = []
}

variable "public_subnets" {
  description = "List of Public Subnet IDs"
  default     = []
}