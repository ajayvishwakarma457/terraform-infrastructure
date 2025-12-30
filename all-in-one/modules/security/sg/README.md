
Security Group Module – What This Module Does
    Creates a single AWS Security Group inside a specified VPC
    Manages the security group lifecycle fully using Terraform
    Supports dynamic creation of multiple ingress (inbound) rules
    Supports dynamic creation of multiple egress (outbound) rules
    Allows rule definitions to be passed as variables (no hardcoded ports or CIDRs)
    Enables reusable and environment-agnostic security group configuration
    Associates the security group with a given VPC using vpc_id
    Applies standard and custom AWS tags to the security group
    Automatically adds a Name tag matching the security group name
    Suitable for use with:
        EC2 instances
        Application Load Balancers (ALB)
        RDS databases
        ECS services
        App Runner services
    Follows least-privilege and infrastructure-as-code best practices
    Designed for production-ready, scalable AWS deployments