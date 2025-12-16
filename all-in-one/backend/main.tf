# backend.tf

# ----------------------------
# 1️⃣ Create S3 bucket for Terraform state
# ----------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "tanvora-terraform-state-001"
  force_destroy = true

  tags = {
    Name = "tanvora-terraform-state-001"
    Environment = "infra"
  }
}

# ----------------------------
# 2️⃣ Enable Versioning for state recovery
# ----------------------------
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ----------------------------
# 3️⃣ Enable Encryption for security
# ----------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ----------------------------
# 4️⃣ Create DynamoDB Table for state locking
# ----------------------------
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "tanvora-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "tanvora-terraform-lock"
    Environment = "infra"
  }
}