module "networking" {
  source = "../../modules/networking"

  resource_group_name      = "rg-dev-workload-norwayeast"
  location                 = "norwayeast"
  vnet_name                = "vnet-dev-norwayeast-spoke-workload"
  vnet_address_space       = ["10.10.0.0/16"]
  workload_subnet_name     = "snet-workload"
  workload_subnet_prefixes = ["10.10.0.0/24"]

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

# Temporary placeholder:
# keep this root skeleton creation-only for now.
# We will wire admin_password safely during state migration.

# module "compute" {
#   source = "../../modules/compute"
#
#   vm_name             = "vm-dev-client-01"
#   resource_group_name = "rg-dev-workload-norwayeast"
#   location            = "norwayeast"
#   subnet_id           = module.networking.workload_subnet_id
#   admin_username      = "azureuser"
#   admin_password      = "TEMP_PLACEHOLDER_DO_NOT_APPLY"
#
#   tags = {
#     Environment      = "Development"
#     Project          = "Azawslab-Release2"
#     Owner            = "HASHIBUR RAHMAN"
#     CostCenter       = "Lab-123"
#     DeploymentMethod = "Terraform"
#   }
# }

