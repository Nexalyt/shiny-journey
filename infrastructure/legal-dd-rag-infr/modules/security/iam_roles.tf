resource "aws_iam_role" "eks_cluster" {
  name = "legal-dd-eks-cluster-role${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  tags = var.tags
}

resource "aws_iam_role" "eks_node" {
  name = "legal-dd-eks-node-role${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  tags = var.tags
}

resource "aws_iam_role" "lambda_nlp" {
  name = "legal-dd-lambda-nlp-role${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags = var.tags
}

resource "aws_iam_role" "lambda_search" {
  name = "legal-dd-lambda-search-role${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags = var.tags
}

resource "aws_iam_role" "lambda_notify" {
  name = "legal-dd-lambda-notify-role${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags = var.tags
}

resource "aws_iam_role" "stepfunctions" {
  name = "legal-dd-stepfunctions-role${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.stepfunctions_assume_role.json
  tags = var.tags
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "stepfunctions_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}
