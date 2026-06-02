# Monitoring, Backup & Resilience

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
    Engineering rationale and evidence for the Release 2 operational resilience capabilities: security posture management, SIEM deployment, synthetic alert validation, and a hardened backup protection model that evolved through three design stages.

## Operations visibility model

Release 2 uses a layered operations model rather than treating monitoring and backup as separate afterthoughts.

| Layer | Implemented capability | Evidence |
|---|---|---|
| Security posture | Defender for Servers Plan 1, secure score, and recommendations | `docs/release2/evidence/P7/` |
| SIEM deployment | Microsoft Sentinel with Log Analytics integration, provider/schema checks, policy exemption handling, and post-apply validation | `docs/release2/evidence/P8/` |
| Alert validation | Azure Monitor alert rules tested with synthetic CPU stress and action group notification evidence | `docs/release2/evidence/P9a/` |
| Recovery protection | Recovery Services Vault with immutability, Multi-User Authorization / Resource Guard, and soft-delete validation | `docs/release2/evidence/P9b/` |
| Backup architecture evolution | Three-stage redesign covering platform-shared vault config, governance policy exemption handling, backup-now trigger, and final recovery point validation | `docs/release2/evidence/P9b-redesign/` |

## Microsoft Sentinel and Defender visibility

Defender for Cloud provides the posture-management layer: Defender for Servers Plan 1 is activated, secure score is captured, and security recommendations are generated.

Microsoft Sentinel provides the SIEM deployment layer: the workspace is provisioned with Log Analytics integration, provider and schema checks are captured, policy exemption records are documented, and post-apply validation evidence confirms the deployment path.

The public evidence proves deployment and validation. Incident or analytic-rule claims are linked only where explicit incident records or rule exports are present.

## Azure Monitor alert validation

Operational alerting is tested, not just configured.

Azure Monitor alert rules are created for critical conditions. Synthetic CPU stress is triggered on a monitored VM, and the resulting alert is captured through action group notifications. This proves the alert pipeline works end-to-end: metric threshold is breached, alert fires, and notification is sent.

**Evidence:** P9a folder - alert rule configuration, synthetic stress output, and notification evidence.

## Recovery Services Vault protection model

The backup design is built around deletion protection and governed recovery readiness.

The evidenced controls include:

- Recovery Services Vault configuration.
- Immutability.
- Multi-User Authorization through Resource Guard.
- Soft-delete validation.
- Backup-now trigger output.
- Final recovery point validation.

These controls ensure that backups cannot be accidentally or maliciously deleted, that an extra approval gate exists for destructive operations, and that backups are genuinely recoverable.

**Evidence:** P9b folder - vault properties, MUA configuration, soft-delete status, backup-now job logs, and recovery point screenshots.

## P9b redesign: staged resilience engineering

The backup architecture did not follow a single, linear path. It went through three deliberate design stages.

| Stage | Focus | Outcome |
|---|---|---|
| Stage 1 | Platform-shared vault configuration | Established vault, backup policy, and initial protected items. |
| Stage 2 | Governance and policy exemption handling | Documented how Azure Policy exemptions interact with backup and MUA requirements. |
| Stage 3 | Backup-now trigger and final recovery point validation | Proved that on-demand backup works and that recovery points are usable. |

This multi-stage evolution shows that the resilience design responded to real constraints: governance policy, shared platform architecture, and operational validation. It is not a one-click deployment.

**Evidence:** P9b-redesign folder - design notes, stage-by-stage outputs, and final validation evidence.

## Enterprise hardening pattern

The current implementation uses immutability, MUA/Resource Guard, and soft-delete. In a stricter enterprise environment, the same protection model can be extended further:

- Customer-managed keys for backup encryption.
- Private endpoints for the Recovery Services Vault.
- Role-based access control with just-in-time elevation for backup deletion.
- Separate vaults for production and non-production workloads.
- Automated restore testing with post-restore validation scripts.

These patterns are documented here to show that the platform's resilience design understands what a fully hardened enterprise backup regime requires, even if not every control is activated in a demonstration environment.

## Engineering significance

- Demonstrates that operational visibility is layered: posture management, SIEM, and synthetic alert validation each have distinct evidence.
- Shows that the backup design includes deletion protection through immutability, MUA, and soft-delete, and has been validated through on-demand backup and recovery point inspection.
- Proves that resilience engineering is iterative: the P9b redesign evidence reveals real design evolution, not a static setup.
- Establishes that the platform can be monitored, alerted on, backed up, and recovered with controls that match enterprise expectations.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Defender for Servers Plan 1 active, secure score captured | [`docs/release2/evidence/P7/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P7) | Secure score screenshots, recommendations list |
| Sentinel workspace deployed and validated | [`docs/release2/evidence/P8/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P8) | Provider/schema checks, policy exemption records, post-apply validation |
| Azure Monitor alerts fire on synthetic CPU stress | [`docs/release2/evidence/P9a/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P9a) | Alert rule config, stress test output, notification evidence |
| Recovery Services Vault has immutability, MUA, soft-delete | [`docs/release2/evidence/P9b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P9b) | Vault properties, MUA configuration, soft-delete status |
| Backup-now trigger produces a valid recovery point | [`docs/release2/evidence/P9b/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P9b) and [`docs/release2/evidence/P9b-redesign/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P9b-redesign) | Backup-now job logs, recovery point screenshots |
| Backup architecture evolved through three design stages | [`docs/release2/evidence/P9b-redesign/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P9b-redesign) | Stage-by-stage design notes, final validation outputs |

## Review takeaway

Monitoring, Backup & Resilience proves that Release 2 has an operational visibility and recovery plane, not just deployed infrastructure.

A reviewer can inspect the Defender, Sentinel, alerting, Recovery Services Vault, MUA, soft-delete, and P9b redesign evidence to confirm that monitoring and resilience were implemented, validated, and documented as part of the platform operating model.