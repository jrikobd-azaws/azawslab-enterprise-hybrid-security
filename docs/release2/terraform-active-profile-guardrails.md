# Terraform Active Profile Guardrails - Release 2

## Purpose

Release 2 uses enable flags for costly or ephemeral resources such as Azure VPN Gateway, FortiGate, Cisco 8000V, Azure Firewall, and optional validation infrastructure.

Many enable flags intentionally default to `false` so optional resources are not created by accident.

This means a raw local `terraform plan` can be misleading after optional resources have been deployed through a GitHub Actions profile. If the active profile flags are not supplied, Terraform may propose destroying resources that are intentionally retained for the current validation window.

## Rule

Do not use raw local Terraform plans for active optional roots.

Use the profile-aware wrapper scripts:

```powershell
.\scripts\release2\plan-platform-networking-current-hybrid.ps1
.\scripts\release2\plan-aws-o3b-current.ps1
```

## Platform networking active hybrid profile

Terraform root:

```text
terraform/platform-networking/dev
```

Active current-hybrid flags:

```text
enable_p5_fortigate=true
enable_o3a_fortigate_vyos_ipsec=false
enable_o3a_azure_vpngw_vyos=true
enable_o1_fortigate_service_chain=true
enable_p5_gateway_ingress_fortigate=true
enable_o3b_aws_cisco_vpn=true
```

## AWS O3b active profile

Terraform root:

```text
terraform/aws-branch/dev
```

Active O3b flags:

```text
-var-file='o3b-dev.tfvars'
ssh_source_cidr=77.99.208.6/32
enable_o3b_ssm_parameters=true
enable_o3b_aws_cisco=true
```

`o3b-dev.tfvars` carries stable environment inputs such as the Azure management host additional management CIDR.

## Apply path

Local Terraform is allowed only for:

```text
init
validate
plan
preflight
```

Apply remains GitHub Actions controlled unless explicitly approved.

## Stop conditions

Stop immediately if any plan shows:

```text
destroy
replacement
VPN Gateway replacement
FortiGate VM/NIC replacement
Cisco EC2/ENI/EIP replacement
route table destroy
unexpected public access widening
```

## Evidence

Save final-process evidence under:

```text
docs/release2/evidence/<Phase>/
```

Do not commit `.tfplan`, `.tfstate`, private keys, raw secrets, PSKs, or unsanitized router running-config backups.