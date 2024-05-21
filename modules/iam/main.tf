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
      # {
      #   Effect: "Allow",
      #   Action: [
      #     "secretsmanager:CreateSecret",
      #     "secretsmanager:PutSecretValue",
      #     "secretsmanager:GetSecretValue",
      #     "secretsmanager:DescribeSecret",
      #     "secretsmanager:UpdateSecret"
      #   ],
      #   Resource: "*"
      # }
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
        ],
        Resource = [
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/k3s/master/ip",
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/k3s/master/token",
        ],
      },
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

resource "aws_iam_role" "bastion_role" {
  name = "bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "bastion_policy" {
  name = "bastion-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_role_attachment" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_policy.arn
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion_role.name
}