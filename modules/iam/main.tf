data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-RNCP-Infra"
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
  name        = "EC2AccessPolicy-RNCP-Infra"
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
          "arn:aws:s3:::elasticsearch-backup-bucket-936b40a0",
          "arn:aws:s3:::postgres-backup-bucket-936b40a0",
          "arn:aws:s3:::etcd-backup-bucket-936b40a0"
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
          "arn:aws:s3:::elasticsearch-backup-bucket-936b40a0/*",
          "arn:aws:s3:::postgres-backup-bucket-936b40a0/*",
          "arn:aws:s3:::etcd-backup-bucket-936b40a0/*"
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
  name = "ec2-instance-profile-RNCP-Infra"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_access_policy.arn
}