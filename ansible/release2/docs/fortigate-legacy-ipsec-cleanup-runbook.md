# FortiGate Legacy IPSec Cleanup Runbook

## Purpose

This runbook documents the future cleanup of the old direct FortiGate-to-VyOS IPSec configuration.

The active Release 2 hybrid design is:

```text
Azure VPN Gateway:
  IPSec termination plane

FortiGate:
  NVA inspection and service-chaining plane

VyOS:
  HQ/on-prem edge simulation
```

The previous direct FortiGate-to-VyOS IPSec attempt was abandoned because FortiGate BYOL trial mode exposed only DES-class IPSec proposals. The project did not weaken the security baseline to accommodate that lab limitation.

## Current Known Legacy Object

Observed legacy tunnel/interface:

```text
ipsec-vyos
```

Observed tunnel state after restart:

```text
selectors(total,up): 1/0
```

This indicates the old direct FortiGate-to-VyOS tunnel is not the active connectivity path. However, cleanup must still be controlled because the interface appears in FortiGate route output.

## Do Not Delete Yet

Do not delete `ipsec-vyos` until all references are captured and reviewed.

Deletion is a separate cleanup gate, not part of the O1 service-chain validation.

## Pre-Cleanup Snapshot

Run these commands before any deletion:

```text
get system status
get vpn ipsec tunnel summary
show vpn ipsec phase1-interface
show vpn ipsec phase2-interface
show system interface ipsec-vyos
show router static
get router info routing-table all
show firewall policy
show firewall address
show firewall addrgrp
```

Save output under:

```text
docs/release2/evidence/O1/o1-fortigate-legacy-ipsec-pre-cleanup.txt
```

## Reference Check

Confirm whether `ipsec-vyos` is referenced by:

```text
- static routes
- firewall policies
- address/interface zones
- VPN phase2 selectors
- automation docs
- old evidence only
```

If any active policy or route references `ipsec-vyos`, stop and review.

## Expected Active Design After Cleanup

```text
[Azure Workload]
  -> FortiGate NVA for selected service-chain paths
  -> Azure VPN Gateway
  -> VyOS/HQ
```

No active traffic should depend on direct FortiGate-to-VyOS IPSec.

## Candidate Cleanup Commands

Do not run these until the pre-cleanup snapshot is reviewed.

```text
config vpn ipsec phase2-interface
    delete "ipsec-vyos"
end

config vpn ipsec phase1-interface
    delete "ipsec-vyos"
end
```

If FortiGate reports dependency errors, stop and inspect references. Do not force broad deletions.

## Post-Cleanup Validation

After cleanup, validate:

```text
get vpn ipsec tunnel summary
show vpn ipsec phase1-interface
show vpn ipsec phase2-interface
show system interface ipsec-vyos
get router info routing-table all
execute ping 10.10.0.4
execute ping 192.168.1.254
```

Expected:

```text
- no active dependency on ipsec-vyos
- FortiGate can still reach 10.10.0.4
- FortiGate can still reach 192.168.1.254 through the Azure VPN Gateway path
- O1 service-chain validation remains intact
```

## Rollback

If cleanup breaks validation, restore from FortiGate config backup or recreate only the specific deleted legacy VPN objects if truly required.

Do not modify Azure VPN Gateway, GatewaySubnet routes, or Terraform-managed Azure resources as part of this cleanup.

## Lab Delta

The old `ipsec-vyos` config is retained temporarily as design-history residue until reviewed cleanup is performed. Its presence does not represent the active hybrid connectivity design.
