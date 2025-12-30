
What this EBS Module Does
    Creates an AWS EBS volume in a specified Availability Zone
    Allows configurable volume size and volume type
    Applies standard tags and a mandatory Name tag
    Attaches the EBS volume to a specified EC2 instance
    Uses a configurable device name for OS-level attachment
    Supports safe attachment (no forced detach by default)
    Creates a point-in-time snapshot of the EBS volume
    Tags the snapshot for project, environment, and ownership
    Enables data backup and recovery using snapshots
    Keeps EBS volume lifecycle fully managed by Terraform
    Supports reuse across environments (dev / stage / prod)
    Follows modular Terraform design and industry practices