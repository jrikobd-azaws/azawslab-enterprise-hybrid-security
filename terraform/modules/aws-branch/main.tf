data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  branch_enabled   = var.enable_o3b_aws_branch
  test_vms_enabled = var.enable_o3b_aws_branch && var.enable_o3b_aws_test_vms
  cisco_enabled    = var.enable_o3b_aws_branch && var.enable_o3b_aws_cisco

  selected_config = {
    region                = var.aws_region
    vpc_name              = var.vpc_name
    vpc_cidr              = var.vpc_cidr
    mgmt_subnet_name      = var.mgmt_subnet_name
    mgmt_subnet_cidr      = var.mgmt_subnet_cidr
    trusted_subnet_name   = var.trusted_subnet_name
    trusted_subnet_cidr   = var.trusted_subnet_cidr
    dmz_subnet_name       = var.dmz_subnet_name
    dmz_subnet_cidr       = var.dmz_subnet_cidr
    untrusted_subnet_name = var.untrusted_subnet_name
    untrusted_subnet_cidr = var.untrusted_subnet_cidr
    cisco_name            = var.cisco_name
    trusted_vm_name       = var.trusted_vm_name
    dmz_vm_name           = var.dmz_vm_name
    key_pair_name         = var.key_pair_name
  }
}

resource "aws_vpc" "this" {
  count = local.branch_enabled ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "this" {
  count = local.branch_enabled ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(var.common_tags, {
    Name = "igw-dev-aws-branch"
  })
}

resource "aws_subnet" "mgmt" {
  count = local.branch_enabled ? 1 : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.mgmt_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = var.mgmt_subnet_name
  })
}

resource "aws_subnet" "trusted" {
  count = local.branch_enabled ? 1 : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.trusted_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = var.trusted_subnet_name
  })
}

resource "aws_subnet" "dmz" {
  count = local.branch_enabled ? 1 : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.dmz_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = var.dmz_subnet_name
  })
}

resource "aws_subnet" "untrusted" {
  count = local.branch_enabled ? 1 : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.untrusted_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = var.untrusted_subnet_name
  })
}

resource "aws_route_table" "mgmt" {
  count = local.branch_enabled ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.common_tags, {
    Name = "rt-dev-aws-mgmt"
  })
}

resource "aws_route_table" "trusted" {
  count = local.branch_enabled ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.common_tags, {
    Name = "rt-dev-aws-trusted"
  })
}

resource "aws_route_table" "dmz" {
  count = local.branch_enabled ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.common_tags, {
    Name = "rt-dev-aws-dmz"
  })
}

resource "aws_route_table" "untrusted" {
  count = local.branch_enabled ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.common_tags, {
    Name = "rt-dev-aws-untrusted"
  })
}

resource "aws_route_table_association" "mgmt" {
  count = local.branch_enabled ? 1 : 0

  subnet_id      = aws_subnet.mgmt[0].id
  route_table_id = aws_route_table.mgmt[0].id
}

resource "aws_route_table_association" "trusted" {
  count = local.branch_enabled ? 1 : 0

  subnet_id      = aws_subnet.trusted[0].id
  route_table_id = aws_route_table.trusted[0].id
}

resource "aws_route_table_association" "dmz" {
  count = local.branch_enabled ? 1 : 0

  subnet_id      = aws_subnet.dmz[0].id
  route_table_id = aws_route_table.dmz[0].id
}

resource "aws_route_table_association" "untrusted" {
  count = local.branch_enabled ? 1 : 0

  subnet_id      = aws_subnet.untrusted[0].id
  route_table_id = aws_route_table.untrusted[0].id
}

resource "aws_security_group" "test" {
  count = local.branch_enabled ? 1 : 0

  name        = var.test_sg_name
  description = "O3b AWS branch test VM security group"
  vpc_id      = aws_vpc.this[0].id

  ingress {
    description = "Temporary SSH from approved source"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_source_cidr]
  }

  ingress {
    description = "ICMP inside branch VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Outbound internet for patching and validation"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = var.test_sg_name
  })
}

resource "aws_instance" "trusted" {
  count = local.test_vms_enabled ? 1 : 0

  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.test_vm_instance_type
  subnet_id                   = aws_subnet.trusted[0].id
  vpc_security_group_ids      = [aws_security_group.test[0].id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = merge(var.common_tags, {
    Name    = var.trusted_vm_name
    Segment = "Trusted"
  })
}

resource "aws_instance" "dmz" {
  count = local.test_vms_enabled ? 1 : 0

  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.test_vm_instance_type
  subnet_id                   = aws_subnet.dmz[0].id
  vpc_security_group_ids      = [aws_security_group.test[0].id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = merge(var.common_tags, {
    Name    = var.dmz_vm_name
    Segment = "DMZ"
  })
}
