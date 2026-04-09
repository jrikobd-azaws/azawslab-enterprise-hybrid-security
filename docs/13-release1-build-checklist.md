# Release 1.0 - Secure Hybrid Identity, Pilot AD Migration, Messaging Migration, Endpoint Security, and M365 Governance
      
## Phase 1 - On-Prem Foundation
- [x] Configure Hyper-V virtual switch design
- [x] NAT configured on host
- [x] Tracking workbook prepared
- [x] Windows Server 2022 parent image created and generalized
- [ ] Build DC1
- [ ] Build DC2
- [ ] Create domain
- [ ] Configure OU structure
- [ ] Create pilot users and groups
- [ ] Build one member server
- [ ] Build Exchange Server 2019
- [ ] Validate internal AD and DNS health
- [ ] Document server names, IPs, and roles

## Phase 2 - Hybrid Identity and Pilot Active Directory Migration
- [ ] Confirm Microsoft 365 / Entra tenant readiness
- [ ] Configure admin role separation
- [ ] Choose sync method for lab design
- [ ] Install and configure Entra ID Connect
- [ ] Define pilot sync scope
- [ ] Sync pilot users and groups
- [ ] Validate synchronized identities in Entra
- [ ] Test pilot user sign-in
- [ ] Document hybrid identity architecture
- [ ] Document future migration path toward broader cloud-managed identity

## Phase 3 - Exchange 2019 to Microsoft 365 Migration
- [ ] Confirm Exchange 2019 source readiness
- [ ] Prepare Exchange Online target state
- [ ] Define pilot migration scope
- [ ] Migrate pilot mailbox/users
- [ ] Validate mailbox access
- [ ] Validate mail flow
- [ ] Document migration steps
- [ ] Record lessons learned and limitations

## Phase 4 - Microsoft 365 Baseline
- [ ] Configure licensing baseline
- [ ] Validate Exchange Online access
- [ ] Configure Teams baseline
- [ ] Configure SharePoint baseline
- [ ] Review user/admin role assignments
- [ ] Document target service baseline

## Phase 5 - Endpoint Administration and MDM

### Windows corporate managed scenario
- [ ] Build Windows 11 test device
- [ ] Enroll Windows device in Intune
- [ ] Validate compliant state
- [ ] Apply configuration profile

### Windows remote / trust scenarios
- [ ] Define joined device scenario
- [ ] Define registered / lighter-trust scenario
- [ ] Document difference between both models

### Linux supporting module
- [ ] Build Ubuntu VM
- [ ] Validate Linux management/support path
- [ ] Apply Ansible baseline
- [ ] Document Intune role vs Ansible role

### Mobile / BYOD
- [ ] Configure Android MAM / App Protection baseline
- [ ] Document iOS policy staging if used

## Phase 6 - Defender and Endpoint Security
- [ ] Configure endpoint protection baseline
- [ ] Review antivirus / anti-malware settings
- [ ] Configure Attack Surface Reduction rules
- [ ] Configure ransomware resilience controls
- [ ] Review endpoint security posture
- [ ] Capture Defender / security evidence

## Phase 7 - Zero Trust Access Control
- [ ] Configure MFA
- [ ] Configure Conditional Access
- [ ] Require compliant device for selected access
- [ ] Test unmanaged-device block
- [ ] Test compliant-device allow flow
- [ ] Document Zero Trust access logic

## Phase 8 - Information Protection and Compliance Baseline
- [ ] Create sensitivity labels
- [ ] Configure DLP baseline
- [ ] Configure SIT-based detection
- [ ] Configure document fingerprinting
- [ ] Update GDPR / NIST / CIS mapping
- [ ] Document what is implemented vs planned

## Phase 9 - Monitoring and Alerting
- [ ] Review Entra sign-in logs
- [ ] Review audit logs
- [ ] Review Intune / device compliance visibility
- [ ] Create one baseline alert
- [ ] Document monitoring and alert strategy
- [ ] Note Release 2 Sentinel expansion plan

## Phase 10 - Evidence and GitHub Updates
- [ ] Capture screenshots for each completed area
- [ ] Name screenshots clearly
- [ ] Upload screenshots to GitHub
- [ ] Update relevant markdown docs
- [ ] Update lessons learned
- [ ] Mark completed items in checklist
- [ ] Prepare Release 1 publish summary

---

# Evidence Checklist

## On-Prem and Hybrid Identity
- [ ] AD OU / users / groups screenshot
- [ ] Entra ID Connect setup screenshot
- [ ] Synced users in Entra screenshot
- [ ] Pilot sign-in screenshot
- [ ] Admin role separation screenshot

## Exchange / M365
- [ ] Exchange 2019 source screenshot
- [ ] Exchange Online target screenshot
- [ ] Pilot mailbox migration evidence
- [ ] Teams baseline screenshot
- [ ] SharePoint baseline screenshot

## Intune / Endpoint
- [ ] Windows enrollment screenshot
- [ ] Compliance policy screenshot
- [ ] Security baseline screenshot
- [ ] WUfB screenshot
- [ ] Joined vs registered scenario evidence
- [ ] Linux support / Ansible evidence
- [ ] Android MAM screenshot

## Security
- [ ] Defender / endpoint security screenshot
- [ ] ASR configuration screenshot
- [ ] MFA screenshot
- [ ] Conditional Access screenshot
- [ ] Blocked unmanaged-device screenshot

## Information Protection
- [ ] Sensitivity labels screenshot
- [ ] DLP screenshot
- [ ] SIT screenshot
- [ ] Fingerprinting screenshot
- [ ] Blocked action / test screenshot

## Monitoring
- [ ] Sign-in logs screenshot
- [ ] Audit logs screenshot
- [ ] Alert rule screenshot

---

# Definition of Release 1 Complete

Release 1 is complete when:
- [ ] The on-prem foundation is built
- [ ] Hybrid identity works
- [ ] Pilot AD synchronization is validated
- [ ] Pilot Exchange migration is validated
- [ ] M365 baseline is working
- [ ] At least one Windows endpoint is enrolled and compliant
- [ ] Zero Trust controls are tested
- [ ] Information protection baseline is configured
- [ ] Monitoring and one alert are documented
- [ ] Screenshots are uploaded
- [ ] GitHub docs are updated
