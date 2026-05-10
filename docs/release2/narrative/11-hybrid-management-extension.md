# 11-hybrid-management-extension

## 1. Objective

## 2. Business Problem

## 3. Technical Solution

## 4. Architecture Snapshot

## 5. Implementation Summary

## 6. Validation Summary

## 7. Evidence Path

## 8. Key Commands Used

## 9. Lessons Learned

## 10. Recruiter-Ready Outcome Statement

---

## P5 Update - FortiGate Symmetric HQ-to-Azure Workload Path

The HQ-to-Azure IIS validation exposed asymmetric routing. The workload subnet already sent return traffic for 192.168.1.0/24 to FortiGate port2, but GatewaySubnet initially sent HQ-initiated traffic directly to the workload subnet. FortiGate therefore saw return traffic only.

The validated fix was a targeted GatewaySubnet UDR for 10.10.0.0/24 with next hop FortiGate port1, creating a symmetric inspected path.

```text
DC1
  -> VPN Gateway / GatewaySubnet
  -> UDR 10.10.0.0/24 -> FortiGate port1
  -> FortiGate policy port1 -> port2
  -> vm-dev-client-01
  -> FortiGate port2
  -> FortiGate policy port2 -> port1
  -> VPN Gateway
  -> DC1
```

This route was validated manually first, then reconciled into `terraform/platform-networking/dev` and applied through the normal Terraform workflow. P5/O1/O3a is IaC-aligned for the current O1/P2b scope.


## O2 Azure Arc - MEM1 Hybrid Management Extension

### Objective

O2 extends Azure management visibility to the HQ lab by onboarding MEM1 as an Azure Arc-enabled server.

MEM1 was selected as the first Arc target because it is less sensitive than DC1 while still representing a realistic domain-joined Windows Server workload in the HQ environment.

### Architecture

```text
[MEM1]
  mem1.hq.azawslab.co.uk
  192.168.1.20
  DNS: 192.168.1.10
  Gateway: 192.168.1.254
        |
        | HQ/VyOS egress
        v
[Azure Arc]
  rg-dev-arc-norwayeast
  Microsoft.HybridCompute/machines/mem1
```

### Implementation Summary

The implementation used a scoped service principal named `sp-arc-onboarding` with the `Azure Connected Machine Onboarding` role assigned only at the Arc resource group scope.

The Arc onboarding secret was stored in Key Vault and was not printed or committed. MEM1 was connected from the server console using `azcmagent connect` with the secret entered through a SecureString prompt.

Required Azure Arc resource providers were registered at subscription scope before onboarding. The Arc machine was created with mandatory governance tags to satisfy the Release 2 Azure Policy baseline.

### Validation Summary

Validated result:
- Resource name: `mem1`
- Resource group: `rg-dev-arc-norwayeast`
- Location: `norwayeast`
- OS: `windows`
- Machine FQDN: `MEM1.hq.azawslab.co.uk`
- Agent version: `1.63.03384.2896`
- Status: `Connected`
- Provisioning state: `Succeeded`

Mandatory tags were present:
- `Environment=dev`
- `Project=Azawslab-Release2`
- `Owner=Hashib`
- `CostCenter=Lab`
- `Role=MEM`
- `Phase=O2`
- `Gateway=VyOS`

### Evidence Path

Evidence is stored under:

```text
docs/release2/evidence/O2/
```

Key evidence files:
- `o2-mem1-vyos-gateway-arc-preflight.txt`
- `o2-arc-onboarding-identity-bootstrap.txt`
- `o2-mem1-arc-connect-console.txt`
- `o2-mem1-arc-azure-validation.txt`

### Recruiter-Ready Outcome Statement

Implemented Azure Arc onboarding for a domain-joined HQ Windows Server using a scoped service principal, Key Vault-backed secret handling, mandatory Azure Policy tags, and validated Azure-side Connected Machine status. This extends Azure management visibility into the hybrid lab without exposing the server directly or weakening the least-privilege model.


