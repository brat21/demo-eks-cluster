variable "network" {
  type = object({
    cidr_block = string
    #    region          = string
    #    vpc_name        = string
    #    azs             = list(string)
    public_subnets  = list(string)
    private_subnets = list(string)
    #nat_gateways    = bool
  })
  default = {
    cidr_block = "10.1.0.0/16"
    #    region          = "us-east-1"
    #    vpc_name        = "custom-vpc"
    #    azs             = ["us-east-1a", "us-east-1b"]
    private_subnets = ["10.1.0.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    public_subnets  = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
    #    nat_gateways    = true
  }
}

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  default     = "demo-eks-cluster"
}

variable "eks_public_access_cidr" {
  description = "Cidr block for Public Access"
  default     = ["145.14.36.80/32", "80.235.87.151/32"]
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
  default     = "1.29"
}

variable "tags" {
  type = map(string)
  default = {
    Createdby = "Terraform"
    Team      = "DevOPS"
  }
  description = "AWS resource tags"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}