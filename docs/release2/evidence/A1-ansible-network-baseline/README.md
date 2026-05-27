# A1 - Ansible Network Automation Baseline

## What This Evidence Proves
Ansible playbooks perform read-only validation of FortiGate, VyOS, and Cisco device states. Configuration backups are captured without making changes to live devices.

## Evidence Inventory
- Playbook run logs (read-only commands)
- Device state extracts (routing tables, firewall policies, interface statuses)
- Sanitized configuration backups

## How to Interpret
Check that playbook output shows only "show" commands and that no configuration mode changes occurred. Compare the extracted state against expected architecture.

## Redaction Notes
Device management IPs and sensitive policy details are masked; command outputs are preserved.

## Related Capability Document
- [03. Automation, SecOps & Resilience](../../03-automation-secops-resilience.md)

## Related Standards
- [Evidence Verification Guide](../../../../EVIDENCE_GUIDE.md)

## Reviewer Takeaway
**Network state is continuously validated and version-controlled without risking production drift.**