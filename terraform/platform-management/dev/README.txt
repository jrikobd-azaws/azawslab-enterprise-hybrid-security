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
