
AWS Secrets Manager – Terraform Module
    This module creates and manages secrets in AWS Secrets Manager.


What this module does
    Creates an AWS Secrets Manager secret
    Stores secret values securely as JSON
    Encrypts secrets automatically using AWS KMS (default or custom)
    Manages secret versions separately from the secret metadata
    Allows updating secret values without recreating the secret
    Supports tagging for cost tracking and ownership



Resources created
    aws_secretsmanager_secret
        Defines the secret container (name, description, tags)
    aws_secretsmanager_secret_version
        Stores the actual secret value (secret_string) as a JSON payload



How it works
    The secret metadata is created first
    The secret value is encoded as JSON and stored as a version
    Any change in secret_value creates a new secret version
    Applications fetch the secret at runtime, not from Terraform state



Use cases
    Database credentials
    API keys and tokens
    Application configuration secrets
    ECS, App Runner, Lambda, EC2 secret consumption


Key points
    No secrets hardcoded in application code
    No secrets exposed in plaintext in AWS console
    Versioned secrets for safe updates
    Industry-standard approach for secret management in AWS




=============================================================Diagram=============================================================

    +------------------+
    |   Application    |
    | (ECS / EC2 /     |
    |  Lambda / App)   |
    +--------+---------+
            |
            | 1. Request secret (AWS SDK)
            v
    +--------+---------+
    |   IAM Role       |
    | (Permission     |
    |  Check)         |
    +--------+---------+
            |
            | 2. Allowed?
            v
    +--------+---------+
    | AWS Secrets     |
    | Manager         |
    | (Encrypted)     |
    +--------+---------+
            |
            | 3. Decrypt (KMS)
            v
    +--------+---------+
    |   AWS KMS        |
    | (Key used for   |
    |  encryption)    |
    +--------+---------+
            |
            | 4. Plain secret
            v
    +------------------+
    |   Application    |
    | (Used at        |
    |  Runtime)       |
    +------------------+


    Rotation (optional)

    +------------------+
    | Secrets Manager  |
    +--------+---------+
            |
            | Triggers rotation
            v
    +--------+---------+
    |   Lambda         |
    | (Rotation Fn)   |
    +--------+---------+
            |
            | Update credential
            v
    +--------+---------+
    | Database / API  |
    +------------------+

