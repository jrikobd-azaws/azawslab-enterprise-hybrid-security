# Release 2 - Azure Platform Engineering, Security, Automation, Private Platform and AI Operations

Release 2 transforms the hybrid workplace base into an Azure-centered enterprise platform engineering portfolio. It demonstrates governed infrastructure delivery, state-boundary discipline, secure networking, automation control planes, private platforms, AVD secure workspace and governed AI operations.

## What this release proves

| Capability | Reviewer signal |
|---|---|
| Landing zone and governance | Terraform roots, policy boundaries, RBAC and state ownership |
| Secretless delivery | GitHub Actions OIDC, plan/apply separation and controlled delivery |
| Ansible and AWX automation | Day 2 operations, network automation and AWX control-plane evidence |
| Hybrid BGP and multi-cloud transit | Azure, AWS branch integration, FortiGate, VyOS, Cisco and route propagation |
| Secure transmission and inspection | Firewall, private routing, UDRs, egress and inspection patterns |
| Private AKS platform | Private Kubernetes, ACR, identity, monitoring and private access controls |
| AVD secure workspace and FSLogix | Secure operations workspace and profile/container pattern |
| Governed AI operations | O6 enclave, policy-mediated AI operations and Kubernetes validation |

## Source and evidence

| Area | Repository path |
|---|---|
| Release 2 documentation | [docs/release2](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2) |
| Terraform implementation | [terraform](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform) |
| Ansible implementation | [ansible](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible) |
| Kubernetes manifests | [kubernetes](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/kubernetes) |
| Release 2 evidence | [docs/release2/evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) |

## Related pages

- [Landing Zone, Governance and Terraform State Boundaries](../engineering/terraform-state-boundaries.md)
- [Ansible and AWX Automation Control Plane](../engineering/automation-control-plane.md)
- [Hybrid BGP and Multi-Cloud Transit](../engineering/hybrid-bgp-multicloud-transit.md)
- [Secure Transmission and Traffic Inspection](../engineering/secure-transmission-inspection.md)
- [Private AKS Platform](../engineering/private-aks-platform.md)
- [AVD Secure Workspace](../engineering/avd-secure-workspace.md)
- [Governed AI Operations](../ai-operations/index.md)