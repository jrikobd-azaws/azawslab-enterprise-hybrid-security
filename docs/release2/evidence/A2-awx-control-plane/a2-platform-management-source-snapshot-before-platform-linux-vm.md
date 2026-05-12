# A2 Platform Management Source Snapshot Before Platform Linux VM Module

Purpose: capture current Terraform/workflow source before adding reusable platform-linux-vm module and vm-dev-awx-01.

## terraform/platform-management/dev/main.tf

```text
data "azurerm_subnet" "management" {
  name                 = "snet-mgmt"
  virtual_network_name = "vnet-dev-norwayeast-spoke-workload"
  resource_group_name  = "rg-dev-workload-norwayeast"
}

locals {
  common_tags = {
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

  tags = local.common_tags
}

resource "azurerm_public_ip" "management" {
  name                = "pip-vm-dev-mgmt-01-norwayeast-01"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

resource "azurerm_network_interface" "management" {
  name                = "nic-vm-dev-mgmt-01-01"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management.id
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "management" {
  name                            = "vm-dev-mgmt-01"
  resource_group_name             = azurerm_resource_group.management.name
  location                        = azurerm_resource_group.management.location
  size                            = "Standard_B2als_v2"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.management.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.management_ssh_public_key
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

  tags = local.common_tags
}

```

## terraform/platform-management/dev/variables.tf

```text
variable "management_ssh_public_key" {
  type        = string
  description = "SSH public key for the temporary Linux management host"
}

```

## terraform/platform-management/dev/outputs.tf

```text
output "management_resource_group_name" {
  value = azurerm_resource_group.management.name
}

output "management_vm_name" {
  value = azurerm_linux_virtual_machine.management.name
}

output "management_private_ip" {
  value = azurerm_network_interface.management.private_ip_address
}

output "management_public_ip_id" {
  value = azurerm_public_ip.management.id
}

```

## terraform/platform-management/dev/providers.tf

```text
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-dev-terraformstate-norwayeast"
    storage_account_name = "stdevtfstatene01"
    container_name       = "tfstate"
    key                  = "platform-management-dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

```

## terraform/platform-management/dev/README.txt

```text
# Platform-management root

This Terraform root owns temporary operations-plane management resources for Release 2.

Owned here:
- temporary Linux Ansible management VM
- management NIC
- management public IP
- management resource group

State:
- platform-management-dev.tfstate

This root discovers the existing workload management subnet through Azure data sources.

Management host lifecycle:
- The temporary Ansible management host is owned by this platform-management root.
- The management host currently uses a deallocate-by-default lifecycle rather than a destroy/recreate lifecycle.
- Keep vm-dev-mgmt-01 deallocated unless actively needed for Ansible or operational validation.
- Do not convert the existing management VM resources to count-based destroy/recreate without a dedicated migration plan and moved block/state-address validation.
- This avoids accidental VM replacement caused by SSH key drift, OS disk lifecycle changes, or prior state-split history.

```

## terraform/modules/compute/main.tf

```text
locals {
  effective_computer_name = var.computer_name != null ? var.computer_name : substr(replace(var.vm_name, "-", ""), 0, 15)
}

resource "azurerm_network_interface" "vm" {
  name                = "nic-${var.vm_name}-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                 = var.vm_name
  resource_group_name  = var.resource_group_name
  location             = var.location
  size                 = "Standard_B2als_v2"
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  computer_name        = local.effective_computer_name
  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}

```

## terraform/modules/compute/variables.tf

```text
variable "vm_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}
variable "tags" {
  type = map(string)
}
variable "computer_name" {
  type    = string
  default = null
}

```

## terraform/modules/compute/outputs.tf

```text
File not present in current repo snapshot.
```

## .github/workflows/release2-terraform-apply.yml

```text
name: Release 2 Terraform Apply

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  terraform-apply:
    name: Terraform apply (${{ matrix.root_name }})
    runs-on: ubuntu-latest
    environment: release-2
    strategy:
      fail-fast: false
      matrix:
        include:
          - root_name: governance
            working_directory: terraform/governance
          - root_name: platform-shared-dev
            working_directory: terraform/platform-shared/dev
          - root_name: workload-dev
            working_directory: terraform/workloads/dev
          - root_name: platform-networking-dev
            working_directory: terraform/platform-networking/dev
          - root_name: platform-management-dev
            working_directory: terraform/platform-management/dev

    defaults:
      run:
        shell: bash
        working-directory: ${{ matrix.working_directory }}

    env:
      TF_VAR_management_ssh_public_key: ${{ secrets.MGMT_SSH_PUBLIC_KEY }}

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.15.0

      - name: Azure login with OIDC
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Terraform fmt check
        run: terraform fmt -check -recursive

      - name: Terraform init
        run: terraform init

      - name: Terraform validate
        run: terraform validate

      - name: Terraform plan
        run: terraform plan -no-color -input=false -out=tfplan

      - name: Terraform apply
        run: terraform apply -input=false -auto-approve tfplan





```

## .github/workflows/release2-terraform-ci.yml

```text
name: Release 2 Terraform CI

on:
  pull_request:
    branches:
      - main
      - Release2_plan
    paths:
      - 'terraform/**'
      - '.github/workflows/release2-terraform-ci.yml'
  workflow_dispatch:

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  terraform-checks:
    name: Terraform checks (${{ matrix.root_name }})
    runs-on: ubuntu-latest
    environment: release-2
    strategy:
      fail-fast: false
      matrix:
        include:
          - root_name: governance
            working_directory: terraform/governance
          - root_name: platform-shared-dev
            working_directory: terraform/platform-shared/dev
          - root_name: workload-dev
            working_directory: terraform/workloads/dev
          - root_name: platform-networking-dev
            working_directory: terraform/platform-networking/dev
          - root_name: platform-management-dev
            working_directory: terraform/platform-management/dev
          - root_name: aws-branch-dev
            working_directory: terraform/aws-branch/dev

    defaults:
      run:
        shell: bash
        working-directory: ${{ matrix.working_directory }}

    env:
      TF_VAR_management_ssh_public_key: ${{ secrets.MGMT_SSH_PUBLIC_KEY }}

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.15.0

      - name: Azure login with OIDC
        if: matrix.root_name != 'aws-branch-dev'
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Configure AWS credentials with OIDC
        if: matrix.root_name == 'aws-branch-dev'
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.AWS_ROLE_ARN }}
          aws-region: ${{ vars.AWS_REGION }}

      - name: Verify AWS identity
        if: matrix.root_name == 'aws-branch-dev'
        run: aws sts get-caller-identity

      - name: Terraform fmt check
        run: terraform fmt -check -recursive

      - name: Terraform init
        run: terraform init

      - name: Terraform validate
        run: terraform validate

      - name: Terraform plan
        run: terraform plan -no-color -input=false











```
