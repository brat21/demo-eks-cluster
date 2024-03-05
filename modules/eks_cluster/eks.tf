data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.cluster.version}/amazon-linux-2/recommended/release_version"
}

data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

resource "aws_eks_cluster" "cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.eks_version

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    #subnet_ids        = flatten([aws_subnet.private.*.id])
    subnet_ids         = flatten([var.private_subnets])
    security_group_ids = [aws_security_group.cluster.id]

    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.eks_public_access_cidr
  }

  tags = merge(
    { type = "eks" },
    var.tags,
  )

  depends_on = [
    aws_iam_role.eks_cluster
  ]

}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.eks_cluster_name}-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
  tags = merge(
    { type = "eks-cluster-iam-role" },
    var.tags,
  )
}

resource "aws_eks_access_entry" "this" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = data.aws_iam_session_context.current.issuer_arn
  type          = "STANDARD"

  tags = merge(var.tags)
}

resource "aws_eks_access_policy_association" "this" {
  access_scope {
    namespaces = []
    type       = "cluster"
  }

  cluster_name = aws_eks_cluster.cluster.name

  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_session_context.current.issuer_arn

  depends_on = [
    aws_eks_access_entry.this,
  ]
}