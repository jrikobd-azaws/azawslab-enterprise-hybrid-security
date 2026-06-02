# Platform Journey

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/releases/">
    <span class="portfolio-chip-label">Journey</span>
    <span class="portfolio-chip-value portfolio-chip-value-ready">Public Ready</span>
  </a>
  <a class="portfolio-chip" href="/releases/release1/">
    <span class="portfolio-chip-label">R1</span>
    <span class="portfolio-chip-value">Workplace + M365</span>
  </a>
  <a class="portfolio-chip" href="/releases/release2/">
    <span class="portfolio-chip-label">R2</span>
    <span class="portfolio-chip-value">Platform + Multi-Cloud</span>
  </a>
  <a class="portfolio-chip" href="/releases/release3/">
    <span class="portfolio-chip-label">R3</span>
    <span class="portfolio-chip-value portfolio-chip-value-muted">Roadmap</span>
  </a>
</div>

!!! summary "What this page is"
    A guided entry into the AzAWSLab release lifecycle: from a realistic Microsoft hybrid enterprise environment to Azure platform engineering, secure multi-cloud networking, automation, resilience, and the AI Operations Enclave with policy-mediated tool use and human approval boundaries.

Release 1 and Release 2 are implemented and routed to public-safe evidence through screenshots, CLI output, workflow records, source files, manifests, diagrams, and design documents. Release 3 is marked as roadmap until implementation evidence is added.

## Transformation map

```mermaid
flowchart LR
    R1["Release 1<br>Hybrid workplace<br>Identity, endpoint security<br>Microsoft 365 operations"]
    R2["Release 2<br>Azure platform engineering<br>Networking, automation<br>Private AKS and AVD"]
    R3["Release 3<br>Multi-cloud roadmap<br>Kubernetes, GitOps<br>DevSecOps"]

    R1 --> R2 --> R3
```

## Deliveries at a glance

| Release | Focus | Status |
|---|---|---|
| [Release 1](/releases/release1/) | Hybrid workplace, identity, endpoint security, and Microsoft 365 operations | Implemented and evidenced |
| [Release 2](/releases/release2/) | Platform engineering, secure networking, automation, private platform services, operations, and AI governance | Implemented and evidenced |
| [Release 3](/releases/release3/) | Multi-cloud Kubernetes, GitOps, DevSecOps, observability, and resilience roadmap | Roadmap |

## How to use this journey

| Reviewer need | Recommended path |
|---|---|
| Fast project understanding | Start here for the release map, then open the [Proof Gallery](/proof-gallery/) for the evidence route. |
| Recruiter or hiring-manager scan | Review the delivery table, then use [Release 2](/releases/release2/) for platform engineering, secure networking, automation, private platform services, operations, and AI governance signals. |
| Hybrid workplace and Microsoft 365 proof | Review [Release 1](/releases/release1/) for hybrid workplace, identity, endpoint security, Microsoft 365 operations, monitoring, and recovery evidence. |
| Platform architecture depth | Review [Release 2](/releases/release2/) for Terraform roots, OIDC, FortiGate inspection, AWS branch routing, AWX automation, private AKS, AVD, backup, operations, and AI governance. |
| Security architecture review | Follow Release 1 identity and endpoint controls into Release 2 private access, inspection, Sentinel, Defender, backup, and the AI Operations Enclave, evidenced through O6. |
| Future roadmap context | Use [Release 3](/releases/release3/) to separate the multi-cloud Kubernetes, GitOps, and DevSecOps roadmap from implemented proof. |

## Evidence model

The release pages are not marketing summaries. They route reviewers to implementation sources and evidence layers:

- GitHub Markdown documentation for architecture decisions and implementation notes.
- Screenshot folders for portal-level configuration and operational outcomes.
- CLI and workflow output for runtime validation and delivery records.
- Terraform, Kubernetes, Ansible, and GitHub Actions source for implementation traceability.
- Proof pages for reviewers who need a guided route through the evidence.

## Source entry points

- [GitHub repository](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security)
- [Release 1 screenshots](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/screenshots/release1)
- [Release 2 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence)
- [Terraform source](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/terraform)
- [Ansible source](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/ansible)
- [Kubernetes source](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/kubernetes)
- [Proof Gallery](/proof-gallery/)
- [Evidence Guide](/evidence-guide/)
