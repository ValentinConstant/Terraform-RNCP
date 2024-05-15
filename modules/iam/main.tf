resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_access_policy" {
  name        = "EC2AccessPolicy"
  description = "Policy for EC2 instances to access Secrets Manager and S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:github/*",
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:postgres/*",
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:jenkins/*",
          "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:k3s/*",
          "arn:aws:s3:::${var.postgres_bucket}/*",
          "arn:aws:s3:::${var.elasticsearch_bucket}/*",
          "arn:aws:s3:::${var.etcd_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_access_policy.arn
}
