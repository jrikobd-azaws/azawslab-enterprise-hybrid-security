data "aws_ssm_parameter" "cisco_8000v_ami" {
  count = local.cisco_enabled ? 1 : 0

  name = var.cisco_ami_ssm_parameter_name
}

resource "aws_security_group" "cisco_mgmt" {
  count = local.cisco_enabled ? 1 : 0

  name        = var.cisco_mgmt_sg_name
  description = "O3b Cisco Catalyst 8000V management security group"
  vpc_id      = aws_vpc.this[0].id

  ingress {
    description = "SSH management from approved validation source"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = concat([var.ssh_source_cidr], var.additional_ssh_source_cidrs)
  }

  egress {
    description = "Allow outbound management updates and validation traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = var.cisco_mgmt_sg_name
    Role = "CiscoMgmt"
  })
}

resource "aws_security_group" "cisco_untrusted" {
  count = local.cisco_enabled ? 1 : 0

  name        = var.cisco_untrusted_sg_name
  description = "O3b Cisco Catalyst 8000V untrusted VPN security group"
  vpc_id      = aws_vpc.this[0].id

  ingress {
    description = "IKE from Azure VPN Gateway"
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["${var.azure_vpn_gateway_public_ip}/32"]
  }

  ingress {
    description = "IPSec NAT-T from Azure VPN Gateway"
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["${var.azure_vpn_gateway_public_ip}/32"]
  }

  ingress {
    description = "Validation ICMP from approved source"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = concat([var.ssh_source_cidr], var.additional_ssh_source_cidrs)
  }

  egress {
    description = "Allow outbound VPN and internet traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = var.cisco_untrusted_sg_name
    Role = "CiscoUntrusted"
  })
}

resource "aws_security_group" "cisco_trusted" {
  count = local.cisco_enabled ? 1 : 0

  name        = var.cisco_trusted_sg_name
  description = "O3b Cisco Catalyst 8000V trusted/private security group"
  vpc_id      = aws_vpc.this[0].id

  ingress {
    description = "Allow VPC private traffic to Cisco trusted interface"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow trusted/private routed traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr, var.aws_branch_azure_workload_prefix, var.aws_branch_hq_prefix]
  }

  tags = merge(var.common_tags, {
    Name = var.cisco_trusted_sg_name
    Role = "CiscoTrusted"
  })
}

resource "aws_network_interface" "cisco_mgmt" {
  count = local.cisco_enabled ? 1 : 0

  subnet_id         = aws_subnet.mgmt[0].id
  security_groups   = [aws_security_group.cisco_mgmt[0].id]
  source_dest_check = false

  tags = merge(var.common_tags, {
    Name = "eni-${var.cisco_name}-mgmt"
    Role = "CiscoMgmt"
  })
}

resource "aws_network_interface" "cisco_untrusted" {
  count = local.cisco_enabled ? 1 : 0

  subnet_id         = aws_subnet.untrusted[0].id
  security_groups   = [aws_security_group.cisco_untrusted[0].id]
  source_dest_check = false

  tags = merge(var.common_tags, {
    Name = "eni-${var.cisco_name}-untrusted"
    Role = "CiscoUntrusted"
  })
}

resource "aws_network_interface" "cisco_trusted" {
  count = local.cisco_enabled ? 1 : 0

  subnet_id         = aws_subnet.trusted[0].id
  security_groups   = [aws_security_group.cisco_trusted[0].id]
  source_dest_check = false

  tags = merge(var.common_tags, {
    Name = "eni-${var.cisco_name}-trusted"
    Role = "CiscoTrusted"
  })
}

resource "aws_eip" "cisco_mgmt" {
  count = local.cisco_enabled ? 1 : 0

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "eip-${var.cisco_name}-mgmt"
    Role = "CiscoMgmt"
  })
}

resource "aws_eip" "cisco_untrusted" {
  count = local.cisco_enabled ? 1 : 0

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "eip-${var.cisco_name}-untrusted"
    Role = "CiscoUntrusted"
  })
}

resource "aws_eip_association" "cisco_mgmt" {
  count = local.cisco_enabled ? 1 : 0

  allocation_id        = aws_eip.cisco_mgmt[0].id
  network_interface_id = aws_network_interface.cisco_mgmt[0].id
}

resource "aws_eip_association" "cisco_untrusted" {
  count = local.cisco_enabled ? 1 : 0

  allocation_id        = aws_eip.cisco_untrusted[0].id
  network_interface_id = aws_network_interface.cisco_untrusted[0].id
}

resource "aws_instance" "cisco" {
  count = local.cisco_enabled ? 1 : 0

  ami           = data.aws_ssm_parameter.cisco_8000v_ami[0].value
  instance_type = var.cisco_instance_type
  key_name      = var.key_pair_name

  network_interface {
    network_interface_id = aws_network_interface.cisco_mgmt[0].id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.cisco_untrusted[0].id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.cisco_trusted[0].id
    device_index         = 2
  }

  tags = merge(var.common_tags, {
    Name    = var.cisco_name
    Role    = "Cisco8000V"
    Segment = "BranchEdge"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}


