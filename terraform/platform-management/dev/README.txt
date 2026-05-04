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
