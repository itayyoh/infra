output "cluster_role_arn" {
  description = "ARN of EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  description = "ARN of EKS node group IAM role"
  value       = aws_iam_role.eks_node_group.arn
}

output "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}

output "node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = aws_security_group.eks_nodes.id
}