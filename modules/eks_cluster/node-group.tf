resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.eks_cluster_name}-node-group"
  version         = aws_eks_cluster.cluster.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnets

  ami_type  = "AL2_x86_64"
  disk_size = 50
  instance_types = [
    "t3.medium",
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  depends_on = [
    aws_iam_role.eks_node_group
  ]

  tags = merge(
    { Name = "${var.eks_cluster_name}-node-group" },
    var.tags,
  )
}

resource "aws_iam_role" "eks_node_group" {
  name = "${var.eks_cluster_name}-node-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = merge(
    { type = "node-group-iam-role" },
    var.tags,
  )
}

resource "aws_security_group" "node" {
  name        = "${var.eks_cluster_name}-node-sg"
  description = "${title(var.eks_cluster_name)} node Security Group"
  vpc_id      = var.vpc_id
  tags = merge({ "Name" = format("%s", "${var.eks_cluster_name}-node-sg") },
    var.tags,
  )

  dynamic "ingress" {
    for_each = var.eks_node_sg_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      self        = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.eks_node_sg_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      self        = egress.value.self
    }
  }
}