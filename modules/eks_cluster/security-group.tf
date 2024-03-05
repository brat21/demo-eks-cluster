resource "aws_security_group" "cluster" {
  name        = "${var.eks_cluster_name}-sg"
  description = "${title(var.eks_cluster_name)} Security Group"
  vpc_id      = var.vpc_id
  tags = merge({ "Name" = format("%s", "${var.eks_cluster_name}-sg") },
    var.tags,
  )

  dynamic "ingress" {
    for_each = var.eks_sg_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      self        = ingress.value.self #
    }
  }

  dynamic "egress" {
    for_each = var.eks_sg_egress
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      self        = egress.value.self #
    }
  }
}