# Companion Local AI Lab

<div class="portfolio-chipline">
  <a class="portfolio-chip" href="/engineering/">
    <span class="portfolio-chip-label">Engineering</span>
    <span class="portfolio-chip-value portfolio-chip-value-ready">Deep Dive</span>
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

!!! summary "Purpose"
    The companion [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra) repository provides a local-first AI infrastructure workflow aligned with the O6 policy-mediated operations model. It gives reviewers a runnable way to inspect AI-assisted infrastructure generation, validation, evidence capture, and human review boundaries before those patterns are promoted into cloud operations.

## Repository at a glance

| Area | Description |
|---|---|
| Repository | [`jrikobd-azaws/local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra) |
| Scope | Local AI-assisted infrastructure workflow, validation pipeline, tool access controls, evidence bundles, and review gates. |
| Runtime model | Local-first workflow with Ollama/local model support and optional cloud provider routing where configured. |
| Relationship to O6 | A local reference implementation aligned with the AzAWSLab O6 governance pattern: policy-mediated tool use, controlled execution, validation evidence, and human review boundaries. |
| Safety posture | The lab is designed to generate, review, and validate infrastructure artifacts without auto-applying infrastructure changes. |

## Operating model

The companion lab is designed around controlled AI assistance rather than autonomous execution.

```text
User request
   |
   v
Multi-agent workflow
   |
   v
Local generation and planning
   |
   v
Sandbox validation
   - Terraform validation
   - TFLint
   - Checkov
   - Trivy
   - Infracost
   - Ansible syntax checks
   - ansible-lint
   - yamllint
   |
   v
Evidence bundle
   - deterministic reports
   - JSON audit data
   - run index
   - checkpoints
   |
   v
Human review / HITL pause
   |
   v
Optional GitOps-ready output
```

## How to use the project

The project includes a runnable usage guide at:

[docs/how_to_use_project.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/how_to_use_project.md)

The guide walks through:

1. syncing or cloning the repository;
2. creating and activating the Python virtual environment;
3. loading environment configuration;
4. starting the local services;
5. verifying Ollama and required models;
6. building or using the sandbox validation image;
7. running smoke validation;
8. reviewing deterministic SecOps and FinOps reports;
9. inspecting JSON audit bundles and run indexes;
10. stopping at the human-in-the-loop boundary before GitOps output.

The key operational point is that the project is designed for local validation and review. It should not auto-apply infrastructure.

## Safety and validation model

| Safety control | What it proves |
|---|---|
| No-auto-apply posture | The workflow is designed not to run `terraform apply` or `terraform destroy` automatically. |
| HITL pause | Generated infrastructure output remains subject to human review before GitOps or promotion. |
| Sandbox validation | IaC, security, cost, and syntax checks run before generated output is considered reviewable. |
| Deterministic reports | SecOps and FinOps outputs can be inspected consistently between runs. |
| JSON audit bundles | Runs produce structured evidence that can be reviewed after execution. |
| SQLite run index | Execution metadata is retained for traceability. |
| LangGraph checkpointing | Workflow state can be persisted and inspected. |
| Tool access controls | Tool use is validated and constrained instead of being handed broad execution authority. |

## Core components

| Component | Implementation role |
|---|---|
| Orchestrator | Coordinates the local multi-agent workflow and validation path. |
| Agent roles | Separate concerns such as planning, generation, security review, cost review, and GitOps formatting. |
| Local LLM runtime | Supports local model execution through Ollama where configured. |
| Provider routing | Allows configured provider selection for different review or generation tasks. |
| Sandbox validator | Runs infrastructure, security, cost, and syntax checks before output is treated as reviewable. |
| Evidence bundle | Captures reports, JSON audit data, run metadata, and validation outputs. |
| Human review gate | Keeps generated infrastructure changes under engineer control. |

## Documentation and evidence routes

Use the actual repository documentation as the review path:

| Document or folder | What to inspect |
|---|---|
| [README.md](https://github.com/jrikobd-azaws/local-ai-lab-infra) | Project overview, current status, design goals, safety controls, and run model. |
| [docs/how_to_use_project.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/how_to_use_project.md) | Step-by-step usage workflow and validation commands. |
| [docs/architecture.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/architecture.md) | Local lab architecture and component relationships. |
| [docs/project_status.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/project_status.md) | Current implementation status and capability notes. |
| [docs/provider_selection.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/provider_selection.md) | Provider routing and model selection context. |
| [docs/open-webui.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/open-webui.md) | Local UI integration notes where relevant. |
| [docs/awx-artifacts.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/awx-artifacts.md) | AWX-related generated artifacts and review context. |
| [docs/troubleshooting.md](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/troubleshooting.md) | Operational troubleshooting and run support. |
| [docs/evidence/](https://github.com/jrikobd-azaws/local-ai-lab-infra/tree/main/docs/evidence) | Evidence generated by the companion workflow. |

## Relationship to AzAWSLab O6

The companion lab is not a separate unrelated project. It supports the O6 story by giving the AI operations pattern a local development and validation environment.

| O6 concept | Companion lab support |
|---|---|
| Policy-mediated tool use | Tool access controls and validation keep AI actions bounded. |
| Human approval boundaries | HITL pause keeps generated changes under engineer review. |
| Evidence capture | JSON audit bundles, reports, run indexes, and validation output provide reviewable proof. |
| Platform safety | No-auto-apply posture prevents generated infrastructure from mutating live environments automatically. |
| Reproducibility | Local setup and usage guide allow the workflow to be rerun and inspected. |

## Why this matters

- AI governance is shown as a working implementation pattern, not only a concept.
- The project demonstrates local-first AI infrastructure generation with validation, traceability, and review gates.
- The design is suitable for technical reviewers who want to inspect how AI-assisted operations can remain bounded.
- The companion project strengthens O6 by showing how the same operational discipline can be tested safely before cloud-side adoption.

## Review entry points

- [local-ai-lab-infra on GitHub](https://github.com/jrikobd-azaws/local-ai-lab-infra)
- [How to Use guide](https://github.com/jrikobd-azaws/local-ai-lab-infra/blob/main/docs/how_to_use_project.md)
- [Companion evidence folder](https://github.com/jrikobd-azaws/local-ai-lab-infra/tree/main/docs/evidence)
- [O6 AI Operations Enclave](/ai-operations/)
- [O6 Evidence Folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6)
