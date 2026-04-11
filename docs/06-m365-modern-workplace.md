# 06-m365-modern-workplace.md

## On-prem Exchange source platform status

### EXCH1 baseline
The on-prem Exchange source server has been provisioned as:

- `exch1.corp.azawslab.co.uk`

Completed baseline steps:
- Built from a Hyper-V differencing disk
- Joined to `corp.azawslab.co.uk`
- Moved to `Tier-1 > Member Servers`
- Exchange Server Subscription Edition installed successfully
- Exchange Admin Center access validated

### Exchange setup notes
- Exchange organization name: `AZAWSLAB Exchange`
- Mailbox role selected during setup
- Dynamic Memory was disabled on EXCH1 before Exchange installation
- Missing prerequisites identified by Exchange readiness checks were installed individually:
  - Unified Communications Managed API 4.0 Core Runtime 64-bit
  - Visual C++ 2013 Redistributable
  - IIS URL Rewrite Module

### Current state
The on-prem Exchange source platform is now present and operational at a baseline level. The next stage is post-install validation, mailbox preparation, and migration-path planning before hybrid sync work begins.
