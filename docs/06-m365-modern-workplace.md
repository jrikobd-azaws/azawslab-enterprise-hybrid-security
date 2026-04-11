## On-prem Exchange source server status

### EXCH1 baseline
The Exchange source server host has been provisioned as:

- `exch1.corp.azawslab.co.uk`

Completed baseline steps:
- Built from a Hyper-V differencing disk
- Joined to `corp.azawslab.co.uk`
- Moved to `Tier-1 > Member Servers`
- Exchange Server Subscription Edition setup initiated

### Exchange setup preparation
During Exchange readiness checks, missing prerequisites were identified and installed individually using the links referenced directly by Exchange Setup.

Resolved prerequisites included:
- Unified Communications Managed API 4.0 Core Runtime 64-bit
- Visual C++ 2013 Redistributable
- IIS URL Rewrite Module

Dynamic Memory was disabled on EXCH1 before Exchange installation to better align the VM with Exchange workload requirements in the lab.
