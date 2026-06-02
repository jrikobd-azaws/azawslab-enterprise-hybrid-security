# Automation Control Plane

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-identity/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value">Workplace</span>
  </a>
  <a class="portfolio-chip" href="/engineering/terraform-state-boundaries/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Delivery</span>
  </a>
  <a class="portfolio-chip" href="/engineering/hybrid-multicloud-networking/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Network</span>
  </a>
  <a class="portfolio-chip" href="/engineering/private-aks-platform/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform</span>
  </a>
  <a class="portfolio-chip" href="/engineering/automation-control-plane/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value portfolio-chip-value-active">Operations</span>
  </a>
</div>

!!! summary "Scope"
    Engineering rationale, control-plane architecture, and evidence paths for the AWX-based automation layer in Release 2. All claims are verified against the A2 AWX evidence folder, job stdout logs, and the Release 2 Ansible source tree.

## Operations model

Release 2 moves automation away from one-off operator scripts and into a governed execution plane built on AWX. The model follows a simple chain:

- Source-controlled Ansible content is stored in the repository.
- AWX synchronises projects from that source.
- Inventories define target environments.
- Job templates turn playbooks into repeatable, tiered operations.
- Runtime credentials are handled by the automation platform, never committed into playbook code.
- Job output is captured as public-safe evidence.

This structure makes automation reviewable. A reviewer can inspect the source path, the AWX evidence, the stdout logs, and the Terraform platform-management evidence to confirm the end-to-end control plane.

## Control-plane architecture

```text
GitHub repository
  ansible/release2/
      |
      | project sync
      v
AWX control plane
  - Entra ID SSO
  - RBAC
  - inventories
  - projects
  - tiered job templates
  - runtime secret retrieval (Azure Key Vault, AWS SSM)
      |
      | governed job execution
      v
Private management path
  - Azure management host
  - private workloads
  - network targets
  - FortiGate automation path
  - Windows and Linux baseline targets
```

The design separates infrastructure provisioning from operational automation. Terraform creates the platform substrate; AWX executes repeatable operational tasks against managed targets.

## Design decisions

| Design choice | Engineering rationale | Evidence path |
|---|---|---|
| Use AWX as an automation control plane | Provides a governed execution layer for inventories, projects, tiered job templates, RBAC, and execution records. | [AWX evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) |
| Integrate AWX with identity | Entra ID SSO and RBAC make automation access part of the wider identity and governance model. | [A2 AWX evidence README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/evidence/A2-awx-control-plane/README.md) |
| Keep Ansible content source-controlled | Playbooks, roles, inventories, execution environments, and runbook material are reviewable as code. | [Release 2 Ansible folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) |
| Use runtime secret retrieval | Secrets are retrieved from Azure Key Vault and AWS SSM at job execution time, never stored in the repository. | [A2 AWX evidence README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/evidence/A2-awx-control-plane/README.md) |
| Keep private management paths | Automation traffic stays within the Azure-connected management path; no broad public SSH, RDP, WinRM, or FortiGate management exposure. | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) |

## Tiered automation model

AzAWSLab implements the AWX operating model through a five-tier job pattern. Each tier is backed by a specific AWX job number and stdout evidence.

| Tier | Runbook pattern | Evidence signal |
|---|---|---|
| Tier 1 | Read-only validation | AWX Job 35 validates FortiGate, VyOS, and Cisco state from the management host without changing device configuration. |
| Tier 2 | Sanitized backup | AWX Job 38 captures sanitized FortiGate, VyOS, and Cisco configuration evidence. |
| Tier 3 | Idempotency and no-change proof | AWX Job 40 validates that the automation path can prove no-change behaviour. |
| Tier 4 | Approved low-risk write/change | AWX Job 44 applies an approved low-risk VyOS marker change after explicit approval variables are provided. |
| Tier 5 | Rollback and emergency recovery | AWX Job 46 removes the same marker and validates rollback behaviour. |

This is a mature operations model: observe first, capture safe backup evidence, prove idempotency, apply only approved low-risk change, and demonstrate rollback.

The same control plane also supports runtime secret retrieval from Azure Key Vault and AWS SSM. Cisco access is specifically evidenced through AWS SSM retrieval of the Cisco RESTCONF password before Cisco read-only validation and backup activity.

## Source-controlled automation

The Release 2 Ansible tree provides the source layer for the automation model.

| Repository area | Purpose |
|---|---|
| `ansible/release2/playbooks/` | Operational playbooks for Release 2 automation paths. |
| `ansible/release2/roles/` | Reusable roles used by the automation workstreams. |
| `ansible/release2/inventory/dev/` | Development inventory structure for managed targets. |
| `ansible/release2/execution-environments/` | Execution environment material for AWX job runtime consistency. |
| `ansible/release2/docs/` | Runbook and implementation notes for automation workstreams. |
| `ansible/release2/network/` | Network automation material, including FortiGate-oriented paths. |
| `ansible/release2/awx-dispatch/` | AWX dispatch structure for platform-run automation. |

The important point is not just that Ansible exists. The important point is that automation has a reviewable source model before AWX executes it.

## AWX evidence model

The A2 evidence folder proves the AWX control plane through multiple evidence types.

| Evidence type | What it proves |
|---|---|
| AWX API final-state export | Captures the final state of the AWX control-plane configuration. |
| Entra SSO evidence | Shows AWX identity integration and sign-in path. |
| Job stdout logs | Shows jobs were executed and output was preserved. |
| Project and inventory evidence | Shows AWX has synchronized automation content and target structure. |
| Terraform planning evidence | Shows AWX platform infrastructure is tied back to the platform-management root. |
| Closure evidence | Summarizes the final control-plane state and reviewer interpretation. |

## Runtime secret boundary

The automation model deliberately avoids committing operational secrets.

- Credentials are not stored in Git.
- Runtime secret injection is used where sensitive values are required.
- Azure Key Vault and AWS SSM serve as secret sources for relevant paths.
- Job logs preserve execution state without exposing plaintext secrets.
- Redaction notes keep public evidence safe while retaining reviewer value.

This is a mature boundary: source code remains reviewable, credentials remain outside the repository, and evidence remains safe to publish.

## Operational workstreams

The automation control plane supports several Release 2 operational workstreams.

| Workstream | Implementation signal | Evidence path |
|---|---|---|
| AWX control-plane operation | Entra ID SSO, RBAC, project sync, tiered job templates, runtime secret retrieval, and job logs. | [A2 AWX evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) |
| Windows common baseline | Ansible validates private WinRM reachability, baseline marker creation, and idempotent execution. | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) |
| Linux AD join pattern | Linux host join path uses the management VM, runtime secrets, delegated service account, and validation output. | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) |
| FortiGate automation path | Service-chain codification, read-only API validation, two-policy reconciliation, and guarded cleanup patterns are documented. | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) |
| Platform-management placement | AWX and management infrastructure are tied to the platform-management lifecycle rather than treated as an external manual server. | [A2 AWX evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) |

## Terraform and AWX boundary

Terraform and AWX have different responsibilities.

| Layer | Responsibility |
|---|---|
| Terraform | Creates infrastructure, state boundaries, networks, management resources, and platform services. |
| AWX | Executes operational automation, validates configuration, runs controlled playbooks, and preserves job evidence. |

This separation matters because the platform should not use Terraform as a general-purpose operations runner. Terraform owns desired infrastructure state. AWX owns repeatable operational execution.

```text
Terraform
    -> provision platform substrate
    -> management host and infrastructure roots
    -> network and service foundations

AWX
    -> sync Ansible project
    -> select inventory and tiered job template
    -> retrieve runtime secrets
    -> execute job
    -> preserve stdout evidence
```

## Engineering significance

Automation Control Plane demonstrates five operations-engineering decisions:

1. Automation is centralized through AWX rather than scattered across operator laptops.
2. Ansible content is source-controlled and reviewable.
3. Runtime secrets are handled outside committed code, with AWS SSM and Azure Key Vault providing the retrieval boundary.
4. A tiered operating model (T1-T5) proves the platform can safely observe, back up, verify idempotency, change, and roll back.
5. Job output is preserved as evidence, making the entire operations cycle auditable.

This page proves that Release 2 is not only provisioned; it is operable under a governed, evidence-backed control plane.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| AWX control plane is operational | [A2 AWX evidence README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/evidence/A2-awx-control-plane/README.md) | Entra ID SSO, RBAC, project sync, tiered job templates, runtime secret retrieval, and job evidence |
| AWX evidence includes job stdout and final-state exports | [A2 AWX evidence folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane) | Job stdout files, final-state JSON, closure evidence, and platform-management planning files |
| Release 2 Ansible content is source-controlled | [Release 2 Ansible folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) | Playbooks, roles, inventory, execution environments, runbook docs, and AWX dispatch structure |
| Runtime secret handling avoids committed secrets | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) | Key Vault and AWS SSM usage; warnings not to commit passwords, vault files, tokens, or private keys |
| Private management path is part of the automation model | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) | Management host path, private workload access, and warning against broad public management exposure |
| FortiGate automation is documented | [Release 2 Ansible README](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible/release2) | FortiGate read-only API check, service-chain playbook, two-policy refresh, and guarded cleanup model |
| Tiered T1-T5 job model is complete | Job stdout logs (Jobs 35, 38, 40, 44, 46) and closure evidence | Read-only validation, sanitized backup, idempotency proof, approved write, rollback |
| AWS SSM used for Cisco RESTCONF password retrieval | [Job 35 stdout](https://raw.githubusercontent.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/main/docs/release2/evidence/A2-awx-control-plane/a2-awx-job-35-stdout.txt) | AWS SSM path `/azawslab/release2/o3b/cisco-restconf-password` loaded before Cisco read-only validation |

## Review takeaway

Automation Control Plane proves that Release 2 has a governed operations layer.

A reviewer can inspect AWX evidence, the five-tier job model, Ansible source, runtime secret boundaries, and job output to confirm that automation is identity-integrated, source-controlled, and evidence-backed.