# -------------------------------
# IAM Base Configuration
# -------------------------------

# 1️⃣ Strong Account Password Policy
resource "aws_iam_account_password_policy" "secure_policy" {
  minimum_password_length    = 12
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers              = true
  require_symbols              = true
  allow_users_to_change_password = true
  max_password_age            = 90
  password_reuse_prevention   = 5
  hard_expiry                 = false
}

# 2️⃣ IAM Group (Optional)
resource "aws_iam_group" "devops_group" {
  name = "${var.project_name}-devops-group"
}

# 3️⃣ IAM Policy (attach to group)
resource "aws_iam_policy" "devops_policy" {
  name        = "${var.project_name}-devops-policy"
  description = "Basic IAM policy for DevOps engineers"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "s3:*",
          "cloudwatch:*",
          "logs:*",
          "ssm:*",
          "iam:Get*",
          "iam:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

# 4️⃣ Attach Policy to Group
resource "aws_iam_group_policy_attachment" "devops_attach" {
  group      = aws_iam_group.devops_group.name
  policy_arn = aws_iam_policy.devops_policy.arn
}

# 5️⃣ Example IAM User (optional)
resource "aws_iam_user" "ajay_user" {
  name = "${var.project_name}-admin"
  tags = var.common_tags
}

# Add user to DevOps group
resource "aws_iam_user_group_membership" "ajay_membership" {
  user = aws_iam_user.ajay_user.name
  groups = [
    aws_iam_group.devops_group.name
  ]
}

# 6️⃣ Optional IAM Role for EC2 (used later)
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

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

# Attach SSM Managed Policy
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role      = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "rds_iam_auth" {
  name = "rds-iam-auth-prod"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "rds-db:connect"
        Resource = "arn:aws:rds-db:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.db_resource_id}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_pull" {
  name = "ecr-pull-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_push" {
  name = "ecr-push-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "github_actions_ecr" {
  name = "github-actions-ecr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:ORG/REPO:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_ecr_push" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "apprunner_ecr_access" {
  name = "apprunner-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        # Service = "build.apprunner.amazonaws.com"
        Service = [
            "build.apprunner.amazonaws.com",
            "tasks.apprunner.amazonaws.com"
        ]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

