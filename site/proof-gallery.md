# Curated Evidence Gallery

This page gives reviewers a fast route into the strongest evidence. Sensitive identifiers, secrets, raw state, and operationally risky details are excluded from public presentation.

## Primary evidence maps

| Evidence area | What it proves | Link |
|---|---|---|
| Portfolio proof gallery | Curated proof across releases | [PROOF_GALLERY.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/PROOF_GALLERY.md) |
| Evidence handling model | Redaction and proof standards | [EVIDENCE_GUIDE.md](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/EVIDENCE_GUIDE.md) |
| Release 2 evidence root | Azure platform, networking, automation, private platform, O6 evidence | [docs/release2/evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence) |
| Skills and evidence index | Skills-to-proof mapping | [Release 2 skills and evidence index](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/06-skills-and-evidence-index.md) |

## Featured proof paths

??? success "GitHub Actions OIDC and Terraform delivery"
    **Capability proven:** workflow-controlled Terraform delivery without relying on long-lived deployment credentials as the normal delivery path.

    **Reviewer signal:** platform engineering maturity, reduced credential exposure, and auditable CI/CD boundaries.

    **Direct evidence:** [P0 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/P0)

??? success "Terraform state boundaries"
    **Capability proven:** separated Terraform roots and state ownership across networking, management, shared services, AKS, AVD, governance, and AWS branch resources.

    **Reviewer signal:** blast-radius control and ownership clarity.

    **Direct evidence:** [Terraform state and pipeline map](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/docs/release2/11-terraform-state-and-pipeline-map.md)

??? success "AWX automation control plane"
    **Capability proven:** operational automation control plane and validated automation evidence.

    **Reviewer signal:** operational maturity beyond ad hoc scripts.

    **Direct evidence:** [A2 AWX evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/A2-awx-control-plane)

??? success "Private AKS"
    **Capability proven:** private platform delivery and controlled AKS access/egress patterns.

    **Reviewer signal:** reduced public exposure and private platform design.

    **Direct evidence:** [O4 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O4)

??? success "AVD and FSLogix secure workspace"
    **Capability proven:** secure administrative workspace and profile/container support pattern.

    **Reviewer signal:** private access and operations workspace design.

    **Direct evidence:** [O5 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O5)

??? info "O6 governed AI operations"
    **Capability proven:** policy-mediated AI operations pattern with Kubernetes support manifests and evidence logs.

    **Reviewer signal:** AI operations are constrained by policy and human approval rather than unrestricted autonomous mutation.

    **Direct evidence:** [O6 evidence](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/tree/main/docs/release2/evidence/O6)