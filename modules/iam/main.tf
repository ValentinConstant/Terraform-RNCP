data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_role" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_instance_profile" "eks_instance_profile" {
  name = "eks-instance"
  role = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy" "eks_kms_policy" {
  name = "eks-kms-policy"
  role = aws_iam_role.eks_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:ListKeys",
          "kms:ListAliases",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "arn:aws:kms:eu-west-3:564088821524:key/e666320d-0445-40fc-a77f-aba025243c42"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eks_acm_policy" {
  name = "eks-acm-policy"
  role = aws_iam_role.eks_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "acm:GetCertificate"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "eks-s3-access"
  description = "Policy to allow EKS nodes to access S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = concat(
          [for bucket in var.s3_buckets : "arn:aws:s3:::${bucket}"],
          [for bucket in var.s3_buckets : "arn:aws:s3:::${bucket}/*"]
        )
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
