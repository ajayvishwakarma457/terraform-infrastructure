

# Create an AWS Security Group
resource "aws_security_group" "this" {

  # Name of the security group
  name        = var.name

   # VPC where the security group will be created
  vpc_id     = var.vpc_id

  # Description shown in AWS console
  description = "Managed by Terraform"

  # Dynamically create ingress (inbound) rules
  dynamic "ingress" {

    # Loop over all ingress rules passed as variable
    for_each = var.ingress_rules
    content {

      # Starting port for inbound traffic
      from_port   = ingress.value.from_port

      # Ending port for inbound traffic
      to_port     = ingress.value.to_port

      # Protocol (tcp / udp / icmp / -1 for all)
      protocol    = ingress.value.protocol

      # Allowed source CIDR blocks
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Dynamically create egress (outbound) rules
  dynamic "egress" {

    # Loop over all egress rules passed as variable
    for_each = var.egress_rules
    content {

      # Starting port for outbound traffic
      from_port   = egress.value.from_port

      # Ending port for outbound traffic
      to_port     = egress.value.to_port

      # Protocol (tcp / udp / icmp / -1 for all)
      protocol    = egress.value.protocol

      # Allowed destination CIDR blocks
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  # Merge common tags with Name tag
  tags = merge(var.tags,{Name = var.name})
}
