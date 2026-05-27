# O4 Private AKS Closure

## Closure Status

O4 Private AKS is closed.

Resources are intentionally retained for O5. No teardown or scale-down decision is required at this point because O5 depends on the private AKS platform, Azure Firewall egress path, management execution path, AWX control-plane integration, and observability baseline.

## Enterprise Design Alignment

O4 follows the established Release 2 state-boundary model:

```text
platform-networking/dev
  owns:
    hub/spoke networking
    Azure Firewall
    shared route control
    FortiGate/VPN/BGP/hybrid connectivity

platform-aks/dev
  owns:
    private AKS
    ACR
    AKS identity
    Workload Identity/OIDC
    Key Vault CSI
    Azure Monitor managed Prometheus
    Azure Managed Grafana
    AKS subnet/UDR

platform-management/dev
  owns:
    management VM
    AWX automation control plane

AWX/A2
  owns:
    approval/control-plane workflow
    GitHub project sync
    tiered job templates

vm-dev-mgmt-01
  acts as:
    private execution target
    managed identity based AKS/kubectl execution path
```

This keeps Azure platform resources in Terraform state and in-cluster operational objects under AWX/Ansible execution from the private management path.

## O4 Execution Model

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
  - managed Prometheus/Grafana validation
```

AWX remains the control plane. It was not granted direct AKS write permission. The management VM managed identity is the approved private execution identity for O4 bootstrap and validation.

## Terraform Validation

Final Terraform no-drift was completed for both O4 state boundaries.

```text
platform-aks/dev:
  terraform plan -var='enable_o4_private_aks=true'
  result: No changes

platform-networking/dev:
  terraform plan with current-hybrid-o4 flags
  result: No changes
```

No local Terraform apply was run. GitHub Actions remains the apply path.

## AKS Platform Validation

Validated:

```text
Private AKS:
  aks-dev-norwayeast-01
  provisioningState: Succeeded
  powerState: Running
  Kubernetes version: 1.34.6

Private API:
  reachable from vm-dev-mgmt-01

Node:
  aks-system-46611056-vmss000000
  Ready

Execution identity:
  vm-dev-mgmt-01 managed identity
  member of azw-aks-platform-admins
  Azure Kubernetes Service Cluster User Role at AKS scope
```

## Identity and RBAC Validation

Validated Entra persona model:

```text
azw-aks-platform-admins:
  Admin for Lab
  AWX Admin
  vm-dev-mgmt-01 managed identity

azw-aks-app-operators:
  aks-operator@entra.azawslab.co.uk

azw-aks-readers:
  aks-reader@entra.azawslab.co.uk
```

Validated Kubernetes RBAC:

```text
azw-aks-app-operators:
  can create deployments
  can delete services

azw-aks-readers:
  can get pods
  cannot create deployments
```

The AKS cluster uses Microsoft Entra authentication with Kubernetes RBAC authorization. Azure Kubernetes Service RBAC Writer/Reader roles were not used for app groups.

## Application and ACR Validation

Validated:

```text
ACR:
  acrdevazawsne01.azurecr.io

Application image:
  acrdevazawsne01.azurecr.io/o4/aks-helloworld:v1

Namespace:
  prod-workload

Deployment:
  o4-nginx
  ready: 1/1

Internal service:
  o4-nginx-internal
  private IP: 10.10.2.6

Management host validation:
  curl http://10.10.2.6
  HTTP 200

HQ/DC validation:
  internal app reachable from approved private path
```

The first private endpoint validation uses an internal Kubernetes LoadBalancer service. Full internal NGINX ingress is not claimed in this closure and can be treated as a later enhancement if required.

## Azure Firewall Egress Validation

Validated:

```text
Azure Firewall:
  afw-dev-norwayeast-01
  private IP: 10.0.1.4
  provisioningState: Succeeded

AKS subnet:
  snet-aks-nodes-dev-norwayeast
  address prefix: 10.10.2.0/24

AKS egress route:
  0.0.0.0/0 -> VirtualAppliance -> 10.0.1.4

Firewall policy rule collection group:
  rcg-o4-private-aks-egress
  provisioningState: Succeeded
```

Pod egress validation succeeded from AKS:

```text
management.azure.com -> HTTP 400
mcr.microsoft.com -> HTTP 200
login.microsoftonline.com -> HTTP 302
```

## Observability Validation

Validated:

```text
Azure Monitor workspace:
  amw-dev-aks-norwayeast-01
  provisioningState: Succeeded

Azure Managed Grafana:
  amg-dev-aks-ne-01
  provisioningState: Succeeded

Managed Prometheus:
  ama-metrics pods Running
  kube-state-metrics component Running
  node metrics component Running

Grafana:
  O4 Private AKS Validation dashboard created
  AKS node/pod/workload metrics visible
```

O4 observability scope is AKS platform observability. Hybrid device observability for FortiGate, VyOS, Cisco, AWX, and management VM is future scope.

## AWX / Ansible Validation

Validated source-of-truth AWX model:

```text
Organization:
  AzawsLab Release 2

Inventory:
  A2 Network Security Devices

Execution host:
  vm_dev_mgmt_01

Project:
  AzawsLab Release 2 Network Automation
  GitHub sync: successful

Credential:
  A2 Dispatcher SSH - vm-dev-mgmt-01
```

O4 AWX tier jobs completed successfully:

```text
Tier 1:
  Private AKS read-only validation

Tier 2:
  Sanitized snapshot

Tier 3:
  Preflight / dry-run

Tier 4:
  Approved idempotent apply

Tier 5:
  Emergency marker rollback
```

Tier 5 deleted only the safe marker ConfigMap and confirmed the app remained running.

## Evidence

Primary evidence files are under:

```text
docs/release2/evidence/O4/
```

Expected key evidence includes:

```text
o4-final-terraform-no-drift-summary.txt
o4-aks-firewall-egress-validation.txt
o4-aks-firewall-egress-pod-validation.txt
o4-managed-prometheus-grafana-validation.txt
o4-managed-prometheus-kubernetes-validation.txt
o4-awx-control-plane-readiness-audit.txt
o4-awx-o4-tier-execution-evidence.txt
```

Screenshots under the same folder capture Azure portal, ACR, Azure Firewall, Grafana, AKS workload, and private app validation.

## Closure Decision

O4 is closed and retained for O5.

O5 can proceed using:

```text
private AKS platform
Azure Firewall egress
management VM private execution path
AWX tiered automation model
ACR-backed app deployment
managed Prometheus/Grafana baseline
validated internal app endpoint
```
