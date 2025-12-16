📘 backend.tf — Terraform Remote Backend Setup

  . This file provisions all the AWS resources needed for a remote Terraform backend.
  . It ensures Terraform state is stored safely in S3, protected with encryption, versioned for recovery, and locked using DynamoDB to    avoid concurrent modifications.

🪣 1️⃣ S3 Bucket — Store Terraform State

  resource "aws_s3_bucket" "terraform_state" {
    bucket        = "tanvora-terraform-state-001"
    force_destroy = true

    tags = {
      Name = "tanvora-terraform-state-001"
      Environment = "infra"
    }
  }


  . Creates a dedicated S3 bucket to store the Terraform state file (terraform.tfstate).
  . The force_destroy = true option allows deleting the bucket even if it contains files (useful for resets).
  . Tags make it easy to identify in AWS console.
  . 🧠 Purpose: This is where Terraform keeps all information about the infrastructure it has created (resource IDs, configs, etc.).



🌀 2️⃣ S3 Versioning — Recover Old States

  resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
      status = "Enabled"
    }
  }


  . Enables versioning on the S3 bucket.
  . Every time Terraform updates the state file, S3 keeps the previous version too.
  . Helps restore older states if corruption or accidental deletion happens.
  . 🧠 Purpose: Protects against accidental state loss or corruption. 


🔒 3️⃣ Server-Side Encryption — Secure the State

  resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  . Applies AES-256 encryption by default to all objects in the bucket.
  . Ensures sensitive Terraform data (like IAM ARNs, subnet IDs, etc.) is encrypted at rest in AWS.
  . 🧠 Purpose: Adds a layer of security so your state file is protected even if the bucket were accessed directly.  


🧭 4️⃣ DynamoDB Table — Manage State Locking

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


  . Creates a DynamoDB table with a single primary key LockID.
  . Terraform uses this table to lock the state whenever someone runs terraform apply or terraform plan.
  . Prevents multiple users or pipelines from modifying infrastructure at the same time.
  . PAY_PER_REQUEST mode ensures you pay only when the table is used.
  . 🧠 Purpose: Avoids race conditions or corrupted state files in collaborative environments.



✅ Summary

  | Resource                                                        | Function                        |
  | --------------------------------------------------------------- | ------------------------------- |
  | `aws_s3_bucket.terraform_state`                                 | Stores Terraform state remotely |
  | `aws_s3_bucket_versioning.versioning`                           | Enables rollback of old states  |
  | `aws_s3_bucket_server_side_encryption_configuration.encryption` | Encrypts state data (AES-256)   |
  | `aws_dynamodb_table.terraform_lock`                             | Locks state during operations   |



⚙️ Next Step — Configure Backend in Provider

  Once these resources exist, link them in your main Terraform configuration:

    terraform {
      backend "s3" {
        bucket         = "tanvora-terraform-state-001"
        key            = "infra/terraform.tfstate"
        region         = "ap-south-1"
        dynamodb_table = "tanvora-terraform-lock"
        encrypt        = true
      }
    }

    Then reinitialize:

    terraform init -reconfigure


    . This setup gives you an enterprise-grade Terraform backend with:
    . Remote state storage 🪣
    . Automatic locking 🔒
    . Encryption at rest 🔐
    . Version recovery 🧾

