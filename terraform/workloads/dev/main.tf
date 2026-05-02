data "terraform_remote_state" "platform_shared_dev" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-dev-terraformstate-uksouth"
    storage_account_name = "stdevtfstateazaws01"
    container_name       = "tfstate"
    key                  = "platform-shared-dev.tfstate"
  }
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name        = "rg-dev-workload-norwayeast"
  location                   = "norwayeast"
  vnet_name                  = "vnet-dev-norwayeast-spoke-workload"
  vnet_address_space         = ["10.10.0.0/16"]
  workload_subnet_name       = "snet-workload"
  workload_subnet_prefixes   = ["10.10.0.0/24"]
  management_subnet_name     = "snet-mgmt"
  management_subnet_prefixes = ["10.10.1.0/24"]

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

module "compute" {
  source = "../../modules/compute"

  vm_name             = "vm-dev-client-01"
  resource_group_name = "rg-dev-workload-norwayeast"
  location            = "norwayeast"
  subnet_id           = module.networking.workload_subnet_id
  admin_username      = "azureuser"
  admin_password      = data.terraform_remote_state.platform_shared_dev.outputs.generated_local_admin_password

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_resource_group" "management" {
  name     = "rg-dev-management-norwayeast"
  location = "norwayeast"

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_public_ip" "management" {
  name                = "pip-vm-dev-mgmt-01-norwayeast-01"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_network_interface" "management" {
  name                = "nic-vm-dev-mgmt-01-01"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.networking.management_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management.id
  }

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}

resource "azurerm_linux_virtual_machine" "management" {
  name                = "vm-dev-mgmt-01"
  resource_group_name = azurerm_resource_group.management.name
  location            = azurerm_resource_group.management.location
  size                = "Standard_B2als_v2"
  admin_username      = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.management.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment      = "Development"
    Project          = "Azawslab-Release2"
    Owner            = "HASHIBUR RAHMAN"
    CostCenter       = "Lab-123"
    DeploymentMethod = "Terraform"
  }
}
