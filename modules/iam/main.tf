data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-unique"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_access_policy" {
  name        = "EC2AccessPolicy-unique"
  description = "Policy for EC2 instances to access S3 and Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource: [
          "arn:aws:s3:::${var.elasticsearch_bucket}",
          "arn:aws:s3:::${var.postgres_bucket}",
          "arn:aws:s3:::${var.etcd_bucket}"
        ]
      },
      {
        Effect: "Allow",
        Action: [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource: [
          "arn:aws:s3:::${var.elasticsearch_bucket}/*",
          "arn:aws:s3:::${var.postgres_bucket}/*",
          "arn:aws:s3:::${var.etcd_bucket}/*"
        ]
      },
      {
        Effect: "Allow",
        Action: [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile-unique"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_access_policy.arn
}