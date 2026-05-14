# O4 Private AKS Implementation Design

## Purpose

O4 delivers the private AKS modern application platform for Release 2.

O4 is not a connectivity/transit phase and is not an AWX/management-plane phase. It creates the private Kubernetes application platform that O5 later consumes from the secure AVD admin/developer workspace.

## State Boundary Decision

O4 is implemented in a dedicated Terraform root:

```text
terraform/platform-aks/dev
```

This is intentional.

```text
terraform/platform-networking/dev
  owns:
    hub/spoke networking
    Azure Firewall
    FortiGate
    VPN Gateway
    BGP/transit routing
    shared route control

terraform/platform-management/dev
  owns:
    vm-dev-mgmt-01
    vm-dev-awx-01
    AWX operations plane

terraform/platform-aks/dev
  owns:
    private AKS
    ACR
    AKS node subnet and AKS-specific route table
    AKS user-assigned identity
    Workload Identity
    OIDC issuer
    Key Vault CSI Driver
    Azure Monitor managed Prometheus
    Azure Managed Grafana
    O4 platform outputs for AWX/O5 validation

future O5 root
  owns:
    AVD
    FSLogix
    admin/developer workspace tooling
```

A single monolithic `platform-networking/dev` root for AKS would mix application-platform lifecycle with VPN, FortiGate, Azure Firewall, and BGP lifecycle. That increases blast radius and makes safe operation harder.

A single `workloads/dev` root would also be weaker because O4 is not just an application VM. It is a platform service with identity, ACR, private API, cluster operations, observability, and future O5 dependency.

## Apply Order

O4 uses two state boundaries.

```text
Apply 1:
  terraform/platform-networking/dev

Purpose:
  Azure Firewall and O4 egress policy

Status:
  complete before AKS root implementation

Apply 2:
  terraform/platform-aks/dev

Purpose:
  complete private AKS platform stack
```

The Azure Firewall stage is complete when:

```text
Azure Firewall:
  afw-dev-norwayeast-01
  private IP present
  provisioningState Succeeded

Firewall Policy:
  afwp-dev-norwayeast
  dnsSettings.enableProxy true

Rule collection:
  rcg-o4-private-aks-egress
  provisioningState Succeeded
```

## O4 Entra Groups

O4 uses Microsoft Entra groups for AKS and namespace access separation.

The groups are created or verified by Azure CLI, not Terraform, to avoid introducing AzureAD/Graph provider complexity into the O4 infrastructure root.

```text
azw-aks-platform-admins
  objectId: f2607c9e-74e3-4575-be31-696b23535bcc
  use:
    AKS platform admin group
    Terraform variable aks_admin_group_object_ids

azw-aks-app-operators
  objectId: 5e4974b4-4d25-4e18-9f73-7f65557af0d1
  use:
    prod-workload namespace operator RBAC

azw-aks-readers
  objectId: 6a628503-dd45-4086-825e-7623ce525989
  use:
    read-only validation and namespace/cluster review
```

Terraform input:

```hcl
aks_admin_group_object_ids = [
  "f2607c9e-74e3-4575-be31-696b23535bcc"
]
```

## O5 Alignment

O4 AKS groups do not replace O5 AVD groups.

```text
O4 AKS groups:
  azw-aks-platform-admins
  azw-aks-app-operators
  azw-aks-readers

O5 AVD groups later:
  azw-avd-admins
  azw-avd-users
  azw-avd-platform-engineers
```

The intended relationship is:

```text
Platform engineer
  |
  +-- member of azw-aks-platform-admins for O4 AKS administration
  |
  +-- later member of azw-avd-platform-engineers for O5 AVD-based operations
        |
        v
      O5 AVD workspace
        |
        +-- kubectl
        +-- Helm
        +-- Azure CLI
        +-- Terraform
        +-- Git / VS Code
        +-- AWX access
        |
        v
      O4 private AKS
```

## O4 Resource Target

```text
Resource group:
  rg-dev-aks-norwayeast

AKS:
  aks-dev-norwayeast-01
  Kubernetes version 1.34.6
  private API
  public API disabled
  system node pool: 1 x Standard_D2s_v4
  network plugin: Azure CNI Overlay
  outbound type: userDefinedRouting

Subnet:
  snet-aks-nodes-dev-norwayeast
  10.10.2.0/24

Route table:
  rt-aks-egress-dev-norwayeast
  0.0.0.0/0 -> Azure Firewall private IP 10.0.1.4

ACR:
  acrdevazawsne01
  admin disabled
  anonymous pull disabled where provider-supported
  AKS kubelet identity has AcrPull

Identity and secrets:
  AKS user-assigned identity
  OIDC issuer enabled
  Workload Identity enabled
  Key Vault CSI Driver enabled

Observability:
  Azure Monitor workspace
  managed Prometheus integration
  Azure Managed Grafana
```

## Private Ingress / App Exposure Decision

O4 must not create a public Kubernetes LoadBalancer for first validation.

For fast O4 validation, the first private app exposure model is:

```text
internal LoadBalancer service
```

This supports direct reachability validation from:

```text
vm-dev-mgmt-01 or AWX
HQ/VyOS
AWS trusted network
```

The AWS DMZ path remains blocked or not advertised by design.

Internal NGINX ingress can be added later if needed, but the first O4 closure should avoid unnecessary ingress-controller complexity unless the source documents require it.

## Cost and Teardown Decision

O4 creates cost-bearing resources.

```text
Azure Firewall:
  already enabled for O4/O5 validation
  keep active during O4 and O5 implementation

AKS:
  1 node only
  Standard_D2s_v4
  keep active only while O4/O5 validation is in progress

Managed Grafana / Azure Monitor workspace:
  deploy for O4 observability validation
  keep through O5 if O5 needs AKS monitoring validation
  otherwise document teardown or disable plan after closure

ACR:
  retain while AKS sample app validation is active
```

Do not scale out AKS during O4 unless explicitly required.

Do not add public app exposure to simplify validation.

Do not claim FortiGate inspection for O4 app paths unless effective routes and FortiGate policy counters/logs prove traversal.

## O4 Consolidated Validation

After AKS deployment, validation is performed once as a consolidated pass, not as repeated small documentation loops.

```text
A. AKS platform
  cluster exists
  private API reachable
  node Ready
  system pods healthy

B. Identity/RBAC
  O4 Entra groups exist
  admin group wired to AKS
  prod-workload namespace RBAC applied

C. ACR
  ACR exists
  admin disabled
  anonymous pull disabled where supported
  kubelet identity has AcrPull
  sample image pulls successfully

D. Workload Identity / Key Vault CSI
  OIDC issuer enabled
  Workload Identity enabled
  Key Vault CSI Driver enabled
  CSI pods/drivers present

E. Internal app
  prod-workload namespace exists
  app pods Running
  service is private/internal
  no public LoadBalancer

F. Firewall and egress
  AKS subnet route table associated
  default route points to Azure Firewall private IP
  pod outbound test succeeds through allowed path

G. Private app reachability
  management/AWX -> app succeeds
  HQ/VyOS -> app succeeds
  AWS trusted -> app succeeds
  AWS DMZ -> blocked/fails by design

H. Observability
  Azure Monitor workspace exists
  managed Prometheus enabled/associated
  Managed Grafana exists

I. AWX
  O4 Tier 1 read-only validation succeeds
  O4 Tier 2 sanitized snapshot succeeds
  O4 app validation succeeds
```

## O4 Evidence Plan

Final evidence only.

```text
docs/release2/evidence/O4/
  o4-private-aks-closure-summary.md
  o4-private-aks-terraform-plan-summary.txt
  o4-private-aks-github-actions-apply-summary.txt
  o4-private-aks-platform-validation.txt
  o4-private-aks-rbac-validation.txt
  o4-private-aks-acr-pull-validation.txt
  o4-private-aks-app-reachability-validation.txt
  o4-private-aks-firewall-egress-validation.txt
  o4-private-aks-prometheus-grafana-validation.txt
  o4-private-aks-awx-validation.txt
  o4-private-aks-cost-teardown-decision.txt
```

Do not commit:

```text
.tmp/
tfplan
tfstate
kubeconfig
tokens
passwords
raw secrets
failed logs
trial/error evidence
```