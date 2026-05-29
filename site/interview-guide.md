# Interview Guide

This page helps reviewers map the project to interview discussion areas.

## Architecture questions

- Why was the project split into releases?
- Why separate Terraform roots and state boundaries?
- Why use GitHub Actions OIDC instead of static credentials?
- How does the hybrid and multi-cloud design reduce risk?
- What is the boundary between AI assistance and infrastructure mutation?

## Evidence questions

- Where is Release 1 proof?
- Where is Release 2 proof?
- How are screenshots and logs redacted?
- Which evidence folders prove private AKS, AVD, AWX, and O6?

## Implementation questions

- Which Terraform root owns which capability?
- Which workflows validate and apply infrastructure?
- How is private platform access handled?
- How is operational evidence captured?
- How does the companion AI project connect to O6?

## Source links

- [Role guide](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/ROLE_GUIDE.md)
- [Skills matrix](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/SKILLS_MATRIX.md)
- [Proof gallery](https://github.com/jrikobd-azaws/azawslab-enterprise-hybrid-security/blob/main/PROOF_GALLERY.md)