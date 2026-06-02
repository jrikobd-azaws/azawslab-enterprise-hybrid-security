# AI Operations Enclave

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

!!! success "Status: Implemented & Evidenced"
    The AI operations enclave is implemented and evidenced through O6 policy records, agent access evidence, network policy validation, namespace lifecycle checks, cleanup validation, and companion local lab documentation.

The AI Operations Enclave demonstrates a controlled pattern for using AI-assisted support in platform operations. It is not an autonomous infrastructure operator. It is an AI operations enclave with policy-mediated tool use and human approval boundaries.

## Operating model

O6 treats AI-assisted operations as a governed workflow:

1. An agent proposes a tool call or operational action.
2. A policy boundary evaluates the request.
3. Allowed read-only or pre-approved actions are logged.
4. Denied or restricted actions are logged and do not proceed automatically.
5. Any action outside the permitted support context remains inside a human review boundary.
6. Evidence is retained through policy decision logs, agent enforcement records, network isolation checks, namespace lifecycle records, and cleanup validation.

## Design principles

- **Deny-by-default policy boundary** - the policy model starts from denial and allows only defined support actions.
- **Policy-mediated tool use** - tool calls are evaluated against allowed tools, scope, and risk context.
- **Human review boundary** - actions beyond read-only or pre-approved support remain subject to human review.
- **Structured decision logging** - policy decisions and enforcement outcomes are captured as reviewable evidence.
- **Agent-specific access scope** - agents are represented with constrained access context rather than broad operator authority.
- **Network and namespace isolation** - the evidence set validates isolation boundaries and namespace lifecycle.
- **Cleanup validation** - O6 includes post-cleanup proof so the enclave does not leave unmanaged residue.

## Architecture

```text
AI Agent / Operations Assistant
        |
        | proposed tool call
        v
MCP Policy Boundary
  - deny-by-default rules
  - allowed tool registry
  - project / namespace scope
  - risk classification
        |
        | allowed read-only action -> logged allow decision
        | denied action -> logged deny decision
        | restricted action -> human review boundary
        v
Scoped Tool Context
  - Kubernetes support context
  - Azure query context
  - local lab validation context
        |
        v
Structured Evidence
  - policy decision logs
  - agent enforcement records
  - network policy evidence
  - namespace lifecycle evidence
  - cleanup checks
```

## MCP policy boundary

The policy boundary evaluates proposed tool use before execution. The important design point is not that AI can run infrastructure commands; it is that AI support is constrained by policy, scope, and evidence.

The O6 evidence route demonstrates:

- policy decisions captured as reviewable records;
- agent-specific enforcement context;
- denied or restricted actions recorded as evidence;
- namespace lifecycle validation;
- network policy and egress validation;
- post-cleanup checks.

**Evidence:** [`docs/release2/evidence/O6/`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6)

## Human review boundary

O6 does not present AI as a replacement for operator judgement. The boundary is deliberately conservative:

- read-only or pre-approved support actions can be evaluated and logged;
- restricted or unknown actions do not become automatic infrastructure change;
- human review remains required for actions that move beyond the permitted support model;
- the companion local lab includes a human-in-the-loop pause before GitOps output and keeps generated infrastructure changes reviewable.

This keeps AI assistance useful while preserving operator accountability.

## Platform integration

The AI operations enclave is integrated into the broader AzAWSLab story:

| Platform area | Integration point |
|---|---|
| Terraform state boundaries | AI-assisted work does not bypass the platform ownership and state model. |
| GitHub Actions OIDC | Future AI-assisted change proposals remain compatible with reviewable pipeline delivery. |
| AWX automation | Operational automation remains governed through job templates, runbooks, and execution evidence. |
| Private AKS | O6 uses Kubernetes support context while respecting namespace and network boundaries. |
| Evidence model | Policy decisions, enforcement records, lifecycle proof, and cleanup checks are captured as public-safe evidence. |
| Companion local AI lab | The local lab provides a reproducible development pattern before any cloud-side promotion. |

## Companion local AI lab

The [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra) repository implements a local reference pattern aligned with O6. It lets the AI governance model be tested locally with deterministic validation, local or hybrid model routing, project isolation, tool access controls, and human review gates.

See the [Companion Local AI Lab](/companion-project/) page for the local implementation and usage workflow.

## Evidence map

| Claim | Repository location | What to verify |
|---|---|---|
| Policy-mediated tool use is enforced | [`O6 evidence`](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6) | MCP policy records and decision logs. |
| Agent access is scoped | Same folder | Agent enforcement records and access context. |
| Network isolation is validated | Same folder | Network policy and egress validation evidence. |
| Namespace lifecycle is controlled | Same folder | Namespace lifecycle and cleanup records. |
| Cleanup is evidenced | Same folder | Post-cleanup validation checks. |
| Local reference implementation exists | [`local-ai-lab-infra`](https://github.com/jrikobd-azaws/local-ai-lab-infra) | Local lab workflow, validation pipeline, and documentation. |

## Review entry points

- [O6 Evidence Folder](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6)
- [Companion Local AI Lab](/companion-project/)
- [local-ai-lab-infra repository](https://github.com/jrikobd-azaws/local-ai-lab-infra)
- [Proof Gallery](/proof-gallery/)
- [Skills Matrix](/skills-matrix/)
