locals {
  selected_config = {
    region                 = var.aws_region
    vpc_name               = var.vpc_name
    vpc_cidr               = var.vpc_cidr
    mgmt_subnet_name       = var.mgmt_subnet_name
    mgmt_subnet_cidr       = var.mgmt_subnet_cidr
    trusted_subnet_name    = var.trusted_subnet_name
    trusted_subnet_cidr    = var.trusted_subnet_cidr
    dmz_subnet_name        = var.dmz_subnet_name
    dmz_subnet_cidr        = var.dmz_subnet_cidr
    untrusted_subnet_name  = var.untrusted_subnet_name
    untrusted_subnet_cidr  = var.untrusted_subnet_cidr
    cisco_name             = var.cisco_name
    trusted_vm_name        = var.trusted_vm_name
    dmz_vm_name            = var.dmz_vm_name
    key_pair_name          = var.key_pair_name
  }
}
