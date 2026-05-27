# O5 Location and Resiliency Governance Decision

## Decision

O5 uses Norway East as the primary deployment region and Norway West as the approved paired region for backup, disaster recovery, geo-redundant storage, and Azure service dependencies that require the regional pair.

```text
Primary region:
  norwayeast

Approved paired region:
  norwaywest
```

Norway West is not a general-purpose second workload region for O5 unless explicitly approved. It is included in governance to prevent backup, recovery, or geo-redundancy failures caused by overly narrow allowed-location policy.

## Why This Is Required

O5 includes AVD and FSLogix profile storage. FSLogix storage and future backup/DR workflows can require a resiliency model that extends beyond single-datacenter LRS.

The O5 source-of-truth therefore must not hard-code LRS as the final enterprise default. The correct posture is:

```text
Use ZRS for FSLogix storage where supported and policy-allowed.
Allow Norway West for paired-region backup/DR/geo-redundant services.
Use LRS only when intentionally selected for lab cost or compatibility reasons.
```

## Governance Requirement

The governance allowed-location policy must allow both:

```text
norwayeast
norwaywest
```

This avoids failures where Azure backup, geo-redundant storage, or paired-region recovery workflows require the paired region.

## Terraform State Boundary

```text
terraform/governance or equivalent governance root:
  owns allowed-location policy definition/assignment parameters

terraform/platform-avd/dev:
  owns O5 AVD and FSLogix resources in Norway East

terraform/platform-networking/dev:
  owns shared Azure Firewall and routing policy

terraform/platform-aks/dev:
  no O5 location policy ownership
```

## O5 Implementation Rule

O5 Terraform design must use:

```text
location = "norwayeast"
paired_location = "norwaywest"
```

Normal O5 resources deploy to Norway East.

Norway West is reserved for paired-region/backup/DR capability unless a future phase explicitly approves active resources there.

## Stop Conditions

Stop before O5 Terraform apply if:

```text
allowed-location governance excludes norwaywest
storage redundancy choice is blocked by policy
backup/DR service requires Norway West and governance denies it
Terraform plan attempts to deploy normal O5 compute in Norway West without explicit approval
```

## O5 Europe AVD Governance Update

Governance now permits four approved locations:

```text
norwayeast
norwaywest
northeurope
westeurope
```

Purpose:

```text
norwayeast:
  existing O1-O4 active platform region

norwaywest:
  Norway East paired backup / DR region

northeurope:
  O5 primary Azure Virtual Desktop secure admin/dev workspace region

westeurope:
  O5 alternate / DR / future resiliency region
```

Normal O5 AVD foundation resources deploy to North Europe. O5 does not deploy ordinary workload resources to Norway West or West Europe unless explicitly approved.
