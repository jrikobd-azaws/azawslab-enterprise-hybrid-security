# Release 2 – Dependency‑Driven Execution Tracker

**Purpose:** Implement Release 2 core phases in an order that respects real dependencies.  
**Status:** Use checkboxes as you complete each step.

---

## Phase 0 – Foundation (Prerequisite – already documented)

- [x] **Domain strategy** (`hq.azawslab.co.uk`, `entra.azawslab.co.uk`, `br1.azawslab.co.uk`)
- [x] **Azure free trial subscription** active
- [x] **Management groups** (`mg-platform`, `mg-landingzones`, `mg-sandbox`)
- [x] **Service principal** (`sp-terraform-gh`) with OIDC & Contributor role
- [x] **Terraform backend** (Azure Storage, state locking)
- [x] **GitHub Codespaces** (or local environment) ready

---

## Phase 1 – Core Infrastructure (Deploy first)

- [ ] **P1 – Landing Zone Foundation** (Management groups, subscription placement already done in Phase 0)
- [ ] **P3 (Part 1) – Key Vault & initial policies**  
  *Deploy `kv-dev-platform-001` and assign basic policy (allowed locations).*  
  → See `docs/release2/Phases-with-steps.md` (P3 steps 1-4)
- [ ] **P5 – Hub‑Spoke Networking**  
  *Hub VNet, subnets (`GatewaySubnet`, `AzureFirewallSubnet`, `Mgmt`, `AzureBastionSubnet`), Spoke VNet (`Workload`), peering, route table (UDR placeholder), NSG.*  
  → See `Phases-with-steps.md` (P5 steps 1-7)
- [ ] **P5 – First test Windows VM**  
  *Deploy `vm-dev-client-01` in Spoke `Workload` subnet, private IP only, no public IP.*  
  → See `Phases-with-steps.md` (P5 step 8)

---

## Phase 2 – Compute & Configuration (Now configure VM)

- [ ] **P2a – Terraform modules** (if not already written) – `networking`, `security`, `compute`, `monitoring`  
  → See `Phases-with-steps.md` (P2a steps 1-7)
- [ ] **P2b – Ansible roles**  
  *Write `common`, `ad-join`, `webserver` roles, inventory with proxy (via Bastion/jumpbox).*  
  → See `Phases-with-steps.md` (P2b steps 1-6)
- [ ] **P2b – Run Ansible**  
  *Domain join to `hq.azawslab.co.uk` (requires VPN to on‑prem AD), security baseline, IIS install.*  
  → Evidence: VM in AD, IIS welcome page
- [ ] **P2c – CI/CD pipeline** (can be set up anytime after P2a)  
  *GitHub Actions workflow, OIDC, plan/apply on PR/merge.*  
  → See `Phases-with-steps.md` (P2c steps 1-5)

---

## Phase 3 – Security, Monitoring & Management (Enable after infrastructure)

- [ ] **P6 – Azure Firewall**  
  *Deploy firewall, policy rules, update UDR next hop, enable logs.*  
  → See `Phases-with-steps.md` (P6 steps 1-8)
- [ ] **P3 (Part 2) – RBAC & remaining policies**  
  *Assign `sp-terraform-gh` Contributor, test tag enforcement.*  
  → See `Phases-with-steps.md` (P3 steps 5-10)
- [ ] **P7 – Defender for Cloud**  
  *Enable Defender plan, remediate one recommendation, capture Secure Score improvement.*  
  → See `Phases-with-steps.md` (P7 steps 1-6)
- [ ] **P8 – Microsoft Sentinel**  
  *Enable Sentinel, add Azure Activity connector, create analytic rule, generate test incident.*  
  → See `Phases-with-steps.md` (P8 steps 1-6)

---

## Phase 4 – Finalise & Document

- [ ] **P9a – Monitoring & Alerting**  
  *Create action group, metric alert (CPU >80%), Log Analytics dashboard.*  
  → See `Phases-with-steps.md` (P9a steps 1-5)
- [ ] **P9b – Disaster Recovery**  
  *Azure Backup (daily, 30‑day retention), Azure Site Recovery, test failover, DR plan document.*  
  → See `Phases-with-steps.md` (P9b steps 1-8)
- [ ] **P9c – Onboarding Documentation**  
  *`docs/onboarding.md` and `CONTRIBUTING.md` with instructions for new engineer.*  
  → See `Phases-with-steps.md` (P9c steps 1-3)
- [ ] **P4 – Azure Lighthouse** (optional, can be done anytime after Phase 0)  
  *Deploy Lighthouse template to second tenant, verify cross‑tenant management.*  
  → See `Phases-with-steps.md` (P4 steps 1-9)

---

## Evidence Capture Summary

After each checkbox, save screenshots and terminal outputs to `docs/release2/evidence/<phase>/` as described in `Phases-with-steps.md`.

**Next action:** Start with **Phase 1 – P5 Hub‑Spoke Networking**. Open your environment (Codespaces/local), navigate to `terraform/environments/dev/`, and run the first `terraform apply` for the networking module.