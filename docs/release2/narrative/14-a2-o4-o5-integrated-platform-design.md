# A2/O4/O5 Integrated Platform Design

## Objective

This document aligns the next Release 2 implementation path across A2, O4, and O5.

The goal is to avoid rework by designing the automation control plane, private AKS platform, and secure admin/dev workspace together before Terraform or Ansible implementation starts.

## Domain Model

```text
HQ / on-prem:
  hq.azawslab.co.uk

Azure / Entra:
  entra.azawslab.co.uk

AWS branch:
  br.azawslab.co.uk
```

## Integrated Architecture

```text
[Engineer]
    |
    v
[O5 AVD single-user admin/dev workspace]
    |
    +-- PowerShell 7
    +-- Azure CLI
    +-- AWS CLI
    +-- Terraform
    +-- Git
    +-- VS Code
    +-- kubectl
    +-- Helm
    +-- Docker CLI or approved container tooling
    |
    v
[A2 AWX vm-dev-awx-01]
    |
    +-- Entra/Azure AD login
    +-- AWX RBAC
    +-- GitHub project sync
    +-- Azure Key Vault runtime secrets
    +-- AWS SSM runtime secrets
    |
    +-- Tier 1 read-only validation
    +-- Tier 2 sanitized backup
    +-- Tier 3 preflight/dry-run
    +-- Tier 4 approved write/change
    +-- Tier 5 rollback/emergency
    |
    v
[O4 Private AKS Platform]
    |
    +-- ACR
    +-- Workload Identity
    +-- Key Vault CSI Driver
    +-- internal ingress
    +-- NGINX or .NET sample app
    +-- Azure Firewall egress
    +-- FortiGate hybrid/private inspection only where proven
```

## A2 AWX Scope

A2 deploys and validates the AWX automation control plane.

A2 is not read-only. A2 must include read, backup, preflight, approved write, and rollback/emergency tiers in the same implementation package.

The first write validation should be low risk and reversible.

Recommended first write:

```text
VyOS:
  idempotent low-risk marker or description change
```

Recommended first rollback:

```text
VyOS:
  revert or remove the same marker or description change
```

FortiGate write requires a separate write-capable API token.

Cisco broad write remains guarded until RESTCONF/NETCONF or network_cli transport is proven enterprise-stable.

## O4 Private AKS Scope

O4 deploys a private AKS modern application platform.

Included:

- Private AKS cluster.
- ACR.
- Workload Identity.
- OIDC issuer.
- Key Vault CSI Driver.
- Internal ingress.
- NGINX or .NET sample container.
- Azure Firewall egress path.
- FortiGate only where private/hybrid inspection is proven.

## O5 AVD Scope

O5 deploys a single-user secure admin/dev workspace.

Included:

- Personal/single-user AVD model.
- FSLogix profile container.
- Azure Files private endpoint.
- Admin/dev platform tooling.
- AWX access validation.
- AKS tooling validation.

## Implementation Rule

A2/O4/O5 implementation should start only after this integrated design is merged.

Terraform changes must explain root/module/variable/wiring with a text diagram before code.

Ansible/AWX changes must explain inventory/group_vars/playbook/role/runtime-secret/job-template flow before code.
---

## O4 Private AKS State Boundary and O5 Alignment

O4 is implemented as a dedicated private AKS platform root, not inside platform networking and not inside the generic workload root.

```text
platform-networking/dev
  owns:
    Azure Firewall
    FortiGate
    VPN Gateway
    BGP/transit
    hub/spoke route control

platform-management/dev
  owns:
    management VM
    AWX control plane

platform-aks/dev
  owns:
    private AKS
    ACR
    AKS identity
    Workload Identity
    Key Vault CSI
    Azure Monitor managed Prometheus
    Azure Managed Grafana

O5 later
  owns:
    AVD + FSLogix secure admin/developer workspace
```

This separation keeps AKS platform lifecycle independent from hybrid transit lifecycle and AWX management-plane lifecycle.

O4 creates/verifies AKS-specific groups:

```text
azw-aks-platform-admins
azw-aks-app-operators
azw-aks-readers
```

O5 later creates/verifies AVD-specific groups:

```text
azw-avd-admins
azw-avd-users
azw-avd-platform-engineers
```

The two sets are intentionally separate but aligned. O5 users or platform engineers will use the AVD workspace to operate and validate the O4 private AKS platform through approved tooling.

## O4 Closure Final State

O4 Private AKS is closed and intentionally retained for O5.

The final O4 design keeps the Release 2 state boundaries clean:

```text
platform-networking/dev
  owns:
    hub/spoke networking
    Azure Firewall
    shared route control
    FortiGate
    VPN Gateway
    BGP and hybrid routing

platform-aks/dev
  owns:
    private AKS
    ACR
    AKS managed identity
    Workload Identity and OIDC
    Key Vault CSI driver
    Azure Monitor managed Prometheus
    Azure Managed Grafana
    AKS subnet and UDR

platform-management/dev
  owns:
    management VM
    AWX automation control plane
```

The O4 operating model is:

```text
Engineer / AWX user
  |
  v
A2 AWX control plane
  - Entra login
  - AWX RBAC
  - GitHub project sync
  - tiered O4 job templates
  |
  v
vm-dev-mgmt-01 execution target
  - az login --identity
  - kubectl
  - kubelogin
  - private AKS API access
  |
  v
O4 Private AKS
  - prod-workload namespace
  - Kubernetes RBAC
  - ACR-backed sample app
  - internal LoadBalancer endpoint
  - managed Prometheus and Grafana validation
```

AWX remains the control plane. It was not granted direct AKS write permission. The management VM managed identity is the approved private execution identity for O4 bootstrap and validation.

The AKS authorization model is:

```text
Microsoft Entra authentication
+
Kubernetes RBAC authorization
```

Azure RBAC is used for Azure control-plane resources such as ACR, Grafana, Monitor, subnet permissions, and `az aks get-credentials`. Kubernetes RBAC is used inside AKS for namespace, app-operator, and reader access.

O4 validates the following enterprise controls:

```text
Private AKS API:
  reachable from vm-dev-mgmt-01

Identity:
  vm-dev-mgmt-01 managed identity used for private execution
  azw-aks-platform-admins used for bootstrap administration
  azw-aks-app-operators bound through Kubernetes RBAC
  azw-aks-readers bound through Kubernetes RBAC

Application:
  prod-workload namespace
  ACR-backed image
  internal LoadBalancer service
  private endpoint reachable from management and HQ paths

Egress:
  AKS subnet 10.10.2.0/24 uses UDR default route to Azure Firewall
  Azure Firewall private IP 10.0.1.4 handles AKS egress
  AKS pod egress to Azure cloud endpoints validated

Observability:
  Azure Monitor managed Prometheus running
  Azure Managed Grafana accessible
  O4 Private AKS validation dashboard created

Automation:
  AWX project sync successful
  O4 Tier 1 through Tier 5 job templates registered and executed
  vm-dev-mgmt-01 remained the execution target
  Tier 5 rollback removed only the safe marker ConfigMap
```

O4 uses an internal Kubernetes LoadBalancer as the first private endpoint validation. Full internal NGINX ingress is not claimed as part of this closure and may be implemented later if required by a future application pattern.

Final Terraform no-drift was validated for both O4 state boundaries:

```text
platform-aks/dev:
  terraform plan -var='enable_o4_private_aks=true'
  result: No changes

platform-networking/dev:
  terraform plan with current-hybrid-o4 flags
  result: No changes
```

No local Terraform apply was run. GitHub Actions remains the apply path.

O4 evidence is stored under:

```text
docs/release2/evidence/O4/
```

