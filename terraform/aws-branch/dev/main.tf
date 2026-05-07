module "aws_branch" {
  source = "../../modules/aws-branch"

  enable_o3b_aws_branch   = var.enable_o3b_aws_branch
  enable_o3b_aws_test_vms = var.enable_o3b_aws_test_vms
  enable_o3b_aws_cisco    = var.enable_o3b_aws_cisco

  aws_region            = var.aws_region
  ssh_source_cidr       = var.ssh_source_cidr
  key_pair_name         = var.key_pair_name
  test_vm_instance_type = var.test_vm_instance_type

  vpc_name              = "vpc-dev-aws-branch"
  vpc_cidr              = "172.16.0.0/16"
  mgmt_subnet_name      = "subnet-dev-aws-mgmt"
  mgmt_subnet_cidr      = "172.16.0.0/24"
  trusted_subnet_name   = "subnet-dev-aws-trusted"
  trusted_subnet_cidr   = "172.16.1.0/24"
  dmz_subnet_name       = "subnet-dev-aws-dmz"
  dmz_subnet_cidr       = "172.16.2.0/24"
  untrusted_subnet_name = "subnet-dev-aws-untrusted"
  untrusted_subnet_cidr = "172.16.254.0/24"

  cisco_name      = "cisco-dev-branch-01"
  trusted_vm_name = "ec2-dev-aws-trusted-01"
  dmz_vm_name     = "ec2-dev-aws-dmz-01"
  test_sg_name    = "azawslab-dev-aws-test-sg"

  common_tags = local.common_tags
}


