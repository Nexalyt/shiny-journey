resource "aws_eks_cluster" "this" {
  name     = "legal-dd-eks${var.environment}"
  role_arn = "arn:aws:iam::123456789012:role/EKSClusterRole" # Placeholder, replace with actual role
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  tags = merge(var.tags, { Name = "legal-dd-eks${var.environment}" })
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "legal-dd-eks-nodes${var.environment}"
  node_role_arn   = "arn:aws:iam::123456789012:role/EKSNodeRole" # Placeholder
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  tags = merge(var.tags, { Name = "legal-dd-eks-nodes${var.environment}" })
}
