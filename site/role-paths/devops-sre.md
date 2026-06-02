# DevOps / SRE Pathway

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value">Deep Dive</span>
  </a>
  <a class="portfolio-chip" href="/proof-gallery/">
    <span class="portfolio-chip-label">Proof</span>
    <span class="portfolio-chip-value">Gallery</span>
  </a>
  <a class="portfolio-chip" href="/skills-matrix/">
    <span class="portfolio-chip-label">Skills</span>
    <span class="portfolio-chip-value">Matrix</span>
  </a>
</div>

!!! summary "Purpose of this page"
    A technical evaluation guide for DevOps engineers, site reliability engineers, and platform operations reviewers. It focuses on CI/CD pipeline safety, infrastructure as code delivery, automation governance, observability, backup resilience, and operational runbooks.

## Operations review framework

DevOps and SRE reviewers care about how the platform is delivered, operated, monitored, and recovered. This pathway organises the operational capabilities into four areas and links each area to engineering notes and public proof routes.

---

## 1. CI/CD and Infrastructure Delivery

**What to validate:** Secret-less pipelines, controlled Terraform delivery, state boundaries, and code-to-evidence traceability.

| Capability | Engineering note | Evidence route |
|---|---|---|
| GitHub Actions OIDC and workflow-controlled delivery | [GitHub Actions OIDC](/engineering/github-actions-oidc/) | Workflow and identity-federation evidence |
| Multi-root Terraform with isolated state boundaries | [Terraform State Boundaries](/engineering/terraform-state-boundaries/) | Terraform source, state-boundary documentation, and evidence index |
| Source, workflow, documentation, and platform claim traceability | [Code Traceability](/engineering/code-traceability/) | Traceability evidence and proof routes |

### Operational validation checklist

- Validate that the pipeline reduces reliance on long-lived deployment credentials.
- Inspect Terraform state boundaries and how root separation reduces blast radius.
- Confirm that source, workflow, and evidence routes can be reviewed together.
- Review how delivery governance supports repeatable platform operations.

---

## 2. Automation Control Plane

**What to validate:** AWX governed automation, job execution discipline, runtime handling, and source-controlled Ansible.

| Capability | Engineering note | Evidence route |
|---|---|---|
| AWX as the central automation execution layer | [Automation Control Plane](/engineering/automation-control-plane/) | AWX control-plane evidence |
| Source-controlled Ansible playbooks, inventories, and runbooks | [Automation Control Plane](/engineering/automation-control-plane/) | Ansible source and execution evidence |
| Governed job execution and operational runbook evidence | [Automation Control Plane](/engineering/automation-control-plane/) | Job-template and execution-log evidence |

### Operational validation checklist

- Validate that automation execution is governed rather than operator-local.
- Inspect how runbooks, inventories, and job templates are source-controlled or evidenced.
- Review how operational changes are executed with repeatability.
- Confirm that automation evidence supports day-2 operations.

---

## 3. Observability and Alerting

**What to validate:** Security monitoring, alert validation, Defender for Cloud, Sentinel, Azure Monitor, and Release 1 operational visibility.

| Capability | Engineering note | Evidence route |
|---|---|---|
| Azure Monitor, Sentinel, Defender for Cloud, and alert validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Release 2 monitoring, alerting, Defender, and Sentinel evidence |
| Release 1 operational visibility model | [Monitoring and Operational Visibility](/engineering/release1-monitoring-operational-visibility/) | Release 1 sign-in, audit, policy, and alert evidence |
| Operational resilience visibility | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Monitoring and resilience evidence routes |

### Operational validation checklist

- Validate that alerting is tested, not only configured.
- Inspect how Release 1 operational visibility matures into Release 2 monitoring.
- Review monitoring evidence alongside the Proof Gallery and Skills Matrix.
- Confirm that operational visibility supports incident review and platform support.

---

## 4. Backup Resilience and Recovery

**What to validate:** Recovery Services Vault controls, backup validation, soft-delete handling, recovery evidence, and BCDR planning.

| Capability | Engineering note | Evidence route |
|---|---|---|
| Recovery Services Vault and backup policy evidence | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Backup and vault evidence |
| Soft-delete handling and recovery validation | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | Backup, recovery, and resilience evidence |
| BCDR planning and operational recovery model | [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/) | BCDR documentation and resilience evidence |

### Operational validation checklist

- Validate that backup is treated as a recovery capability, not only a scheduled job.
- Inspect soft-delete handling and recovery validation evidence.
- Review BCDR documentation and how it supports operational continuity.
- Confirm that backup and resilience controls are part of the platform operating model.

---

## Suggested review path

1. Open the [Proof Gallery](/proof-gallery/) and review Delivery Engineering and Operations Engineering.
2. Review the [Skills Matrix](/skills-matrix/) for the DevOps and SRE competency map.
3. Drill into [Automation Control Plane](/engineering/automation-control-plane/) for AWX and Ansible evidence.
4. Validate pipeline security in [GitHub Actions OIDC](/engineering/github-actions-oidc/) and traceability in [Code Traceability](/engineering/code-traceability/).
5. Examine backup resilience in [Monitoring, Backup and Resilience](/engineering/monitoring-backup-resilience/).
