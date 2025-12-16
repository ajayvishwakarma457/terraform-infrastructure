👤 IAM Module — Tanvora Infrastructure

📘 Overview

This Terraform module provisions a secure and production-ready IAM (Identity and Access Management) setup on AWS.
It enforces a strong password policy, creates IAM groups, users, policies, and roles used by EC2 instances — following AWS security best practices.


⚙️ Resources Created
| Category                    | Resource                                        | Purpose                                                                                    |
| --------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------ |
| **Security Policy**         | `aws_iam_account_password_policy.secure_policy` | Enforces a strong account-wide password policy                                             |
| **IAM Group**               | `aws_iam_group.devops_group`                    | Group for DevOps users                                                                     |
| **IAM Policy**              | `aws_iam_policy.devops_policy`                  | Grants DevOps-level access to key AWS services (EC2, S3, CloudWatch, SSM, IAM read access) |
| **Group Policy Attachment** | `aws_iam_group_policy_attachment.devops_attach` | Attaches the DevOps policy to the DevOps group                                             |
| **IAM User**                | `aws_iam_user.ajay_user`                        | Example IAM user (admin or DevOps engineer)                                                |
| **User Group Membership**   | `aws_iam_user_group_membership.ajay_membership` | Adds the user to the DevOps group                                                          |
| **IAM Role (for EC2)**      | `aws_iam_role.ec2_role`                         | EC2 instance role for service access                                                       |
| **Role Policy Attachment**  | `aws_iam_role_policy_attachment.ssm_attach`     | Grants EC2 role access to AWS Systems Manager (SSM)                                        |



🧩 Inputs (variables.tf)
| Variable       | Type          | Description                        | Example                   |
| -------------- | ------------- | ---------------------------------- | ------------------------- |
| `project_name` | `string`      | Project prefix for resource naming | `"tanvora"`               |
| `common_tags`  | `map(string)` | Common tags for all IAM resources  | `{ Environment = "dev" }` |


📤 Outputs (outputs.tf)
| Output              | Description                                |
| ------------------- | ------------------------------------------ |
| `ec2_role_name`     | Name of IAM role created for EC2 instances |
| `devops_group_name` | Name of IAM group for DevOps users         |
| `ajay_user_name`    | IAM username for the created admin user    |


🚀 Usage Example

In your root main.tf:

    module "iam" {
        source       = "./modules/iam"
        project_name = var.project_name
        common_tags  = var.common_tags
    }

🔒 Key Features

    Strong password policy:
        . Minimum length: 12
        . Requires uppercase, lowercase, numbers, and symbols
        . Password rotation every 90 days
        . Prevents reusing last 5 passwords

    Role-based access:
        DevOps group with permissions to manage compute, storage, logging, and monitoring resources.

    SSM-ready EC2 role:
        EC2 instances using this role can be accessed and managed via AWS Systems Manager (no SSH keys needed).

    Reusable structure:
        The module can be extended for more groups, users, or policies as your organization grows.


✅ Verification Checklist

| Check           | Expected Result                       |
| --------------- | ------------------------------------- |
| Password policy | Appears under IAM → Account Settings  |
| DevOps group    | Visible under IAM → Groups            |
| DevOps policy   | Attached to group                     |
| Admin user      | Exists and assigned to DevOps group   |
| EC2 role        | Created and visible under IAM → Roles |
| SSM policy      | Attached to EC2 role                  |


🧠 Summary
This IAM module creates a secure, modular foundation for AWS access management by:
    . Enforcing password complexity and rotation
    . Defining DevOps group and policies
    . Creating a managed EC2 IAM role
    . Applying consistent tags and naming
It’s designed for easy integration with other Terraform modules like VPC, EC2, and S3 in the Tanvora infrastructure.


🧱 List of Resources Created

| #   | Resource Type                     | Terraform Name    | Purpose                                                         |
| --- | --------------------------------- | ----------------- | --------------------------------------------------------------- |
| 1️⃣ | `aws_iam_account_password_policy` | `secure_policy`   | Enforces strong password policy for the entire AWS account      |
| 2️⃣ | `aws_iam_group`                   | `devops_group`    | Creates a “DevOps” group for engineers or admins                |
| 3️⃣ | `aws_iam_policy`                  | `devops_policy`   | Defines DevOps permissions (EC2, S3, CloudWatch, SSM, IAM read) |
| 4️⃣ | `aws_iam_group_policy_attachment` | `devops_attach`   | Attaches the custom DevOps policy to the DevOps group           |
| 5️⃣ | `aws_iam_user`                    | `ajay_user`       | Creates an example IAM user (admin or engineer)                 |
| 6️⃣ | `aws_iam_user_group_membership`   | `ajay_membership` | Adds the IAM user to the DevOps group                           |
| 7️⃣ | `aws_iam_role`                    | `ec2_role`        | IAM role for EC2 instances (to allow access to AWS services)    |
| 8️⃣ | `aws_iam_role_policy_attachment`  | `ssm_attach`      | Attaches the AWS-managed **SSM policy** to the EC2 role         |


💡 In short:

This module configures IAM best practices for your project:
. 🔐 Strong account password policy
. 👥 DevOps group and permissions
. 👨‍💻 Example admin user (you)
. 💼 EC2 instance role (with SSM access)
