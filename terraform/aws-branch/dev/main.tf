module "aws_branch" {
  source = "../../modules/aws-branch"

  enable_o3b_aws_branch   = var.enable_o3b_aws_branch
  enable_o3b_aws_test_vms = var.enable_o3b_aws_test_vms
  enable_o3b_aws_cisco    = var.enable_o3b_aws_cisco

  enable_o3b_ssm_parameters = var.enable_o3b_ssm_parameters
  o3b_ssm_parameter_prefix  = var.o3b_ssm_parameter_prefix

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

  azure_vpn_gateway_public_ip = var.azure_vpn_gateway_public_ip
  azure_vpn_gateway_asn       = var.azure_vpn_gateway_asn
  hq_vyos_bgp_asn             = var.hq_vyos_bgp_asn
  cisco_bgp_asn               = var.cisco_bgp_asn
  advertised_prefix_trusted   = var.advertised_prefix_trusted
  advertised_prefix_dmz       = var.advertised_prefix_dmz
  advertise_trusted_prefix    = var.advertise_trusted_prefix
  advertise_dmz_prefix        = var.advertise_dmz_prefix

  cisco_name                       = "cisco-dev-branch-01"
  cisco_instance_type              = var.cisco_instance_type
  cisco_ami_ssm_parameter_name     = var.cisco_ami_ssm_parameter_name
  cisco_mgmt_sg_name               = var.cisco_mgmt_sg_name
  cisco_untrusted_sg_name          = var.cisco_untrusted_sg_name
  cisco_trusted_sg_name            = var.cisco_trusted_sg_name
  aws_branch_azure_workload_prefix = var.aws_branch_azure_workload_prefix
  aws_branch_hq_prefix             = var.aws_branch_hq_prefix
  trusted_vm_name                  = "ec2-dev-aws-trusted-01"
  dmz_vm_name                      = "ec2-dev-aws-dmz-01"
  test_sg_name                     = "azawslab-dev-aws-test-sg"

  common_tags = local.common_tags
}




