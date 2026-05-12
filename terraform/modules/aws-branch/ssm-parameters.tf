locals {
  o3b_ssm_parameter_prefix_normalized = trimsuffix(var.o3b_ssm_parameter_prefix, "/")

  o3b_ssm_non_secret_parameters = var.enable_o3b_ssm_parameters ? {
    aws-region                           = var.aws_region
    management-source-cidr               = var.ssh_source_cidr
    vpc-cidr                             = var.vpc_cidr
    trusted-subnet-cidr                  = var.trusted_subnet_cidr
    dmz-subnet-cidr                      = var.dmz_subnet_cidr
    untrusted-subnet-cidr                = var.untrusted_subnet_cidr
    azure-vpn-gateway-public-ip          = var.azure_vpn_gateway_public_ip
    azure-vpn-gateway-asn                = tostring(var.azure_vpn_gateway_asn)
    hq-vyos-bgp-asn                      = tostring(var.hq_vyos_bgp_asn)
    cisco-bgp-asn                        = tostring(var.cisco_bgp_asn)
    advertised-prefix-trusted            = var.advertised_prefix_trusted
    advertised-prefix-dmz                = var.advertised_prefix_dmz
    advertise-trusted-prefix             = tostring(var.advertise_trusted_prefix)
    advertise-dmz-prefix                 = tostring(var.advertise_dmz_prefix)
    o3c-azure-workload-prefix            = var.aws_branch_azure_workload_prefix
    o3c-hq-prefix                        = var.aws_branch_hq_prefix
    o3c-trusted-private-ssh-source-cidrs = join(",", var.trusted_private_ssh_source_cidrs)
    o3c-validation-scope                 = "trusted-private-positive-control-dmz-negative-control"
  } : {}

  o3b_secure_parameter_names = [
    "${local.o3b_ssm_parameter_prefix_normalized}/cisco-admin-password",
    "${local.o3b_ssm_parameter_prefix_normalized}/vpn-psk",
    "${local.o3b_ssm_parameter_prefix_normalized}/bootstrap-secret"
  ]
}

resource "aws_ssm_parameter" "o3b_non_secret" {
  for_each = local.o3b_ssm_non_secret_parameters

  name        = "${local.o3b_ssm_parameter_prefix_normalized}/${each.key}"
  description = "Azawslab Release 2 O3b non-secret metadata: ${each.key}"
  type        = "String"
  value       = each.value
  overwrite   = true

  tags = merge(var.common_tags, {
    Name               = "ssm-o3b-${each.key}"
    Phase              = "O3b"
    DataClassification = "NonSecret"
    ManagedBy          = "Terraform"
  })
}
