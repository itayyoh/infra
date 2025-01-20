# modules/eks/main.tf

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name = "${var.environment}-eks"
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    security_group_ids = [var.cluster_security_group_id]
    subnet_ids = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-eks"
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.eks_cluster
  ]
}

# CloudWatch Log Group for EKS
resource "aws_cloudwatch_log_group" "eks_cluster" {
  name = "/aws/eks/${var.environment}-eks/cluster"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-eks-logs"
    }
  )
}

# EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

  instance_types = ["t3a.medium"]

  # Ensure that we can properly delete the node group when destroying
  lifecycle {
    create_before_destroy = false
  }

  labels = {
    role = "general"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-node-group"
    },
    {
      "k8s.io/cluster-autoscaler/enabled" = "true"
      "k8s.io/cluster-autoscaler/${var.environment}-eks" = "owned"
    }
  )

  depends_on = [
    aws_eks_cluster.main
  ]
}