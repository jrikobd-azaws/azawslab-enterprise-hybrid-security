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
A2 AWX reusable platform Linux VM module:
- vm-dev-awx-01 is owned by this platform-management root.
- vm-dev-awx-01 uses terraform/modules/platform-linux-vm.
- vm-dev-mgmt-01 remains inline for this A2.1 change to avoid risk to the live Ansible control node.
- terraform/modules/compute is not changed because it is currently used by the Windows workload VM path.
- AWX is disabled by default through enable_a2_awx=false.
- AWX must not receive a public IP unless explicitly approved.
- AWX uses the existing snet-mgmt subnet through data.azurerm_subnet.management.
- AWX receives a system-assigned managed identity.
- The AWX managed identity receives least-privilege Key Vault secret Get/List access.
- AWX bootstrap, RBAC, GitHub project sync, job templates, workflow approvals, and rollback/emergency workflows are handled by the later Ansible/AWX layer.
- vm-dev-mgmt-01 can be refactored into terraform/modules/platform-linux-vm later using Terraform moved blocks in a separate no-replacement branch.
