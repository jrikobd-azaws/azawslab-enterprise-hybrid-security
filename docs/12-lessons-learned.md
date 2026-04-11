## AD and DNS implementation notes

### Built-in Users container conflict
A custom OU named `Users` could not be used because Active Directory already includes the default built-in `Users` container at the domain root.

To keep the structure clean and aligned with the lab design, standard users were placed under:

- `Tier-2 > User Accounts > Standard Users`

### Domain naming standardization
The active lab domain was standardized to:

- `corp.azawslab.co.uk`

This superseded earlier planning references and required alignment across the tracker, screenshots, and GitHub documentation.

### Pilot-first security group design
Pilot-targeted security groups were created early to support later phased hybrid identity, Exchange migration, and information protection testing.

Implemented examples:
- `SG-Pilot-Hybrid-Sync`
- `SG-Pilot-Exchange-Migration`
- `SG-DLP-Pilot`

### DNS suffix devolution issue on DC1
During DNS validation on DC1, internal DNS records were confirmed to be present and functional, including forward lookup, reverse lookup, PTR registration, and successful `dcdiag /test:dns /v` results.

However, non-absolute lookups for `dc1.corp.azawslab.co.uk` intermittently devolved into malformed queries by appending the parent public suffix. This caused unresolved queries to recurse via root hints to public DNS and return external results associated with the public parent domain.

Fix applied:
- Disabled **Append parent suffixes of the primary DNS suffix** in the NIC Advanced DNS settings on DC1

Validation outcome:
- Absolute FQDN lookups using a trailing dot resolved correctly
- Internal AD-integrated DNS was validated as functional
- DC1 was cleared for progression to DC2 build

## MEM1 and EXCH1 build notes

### Member server build pattern
MEM1 and EXCH1 were both deployed from Hyper-V differencing disks based on the Windows Server master image. This kept the server build process consistent with the planned lab deployment model.

### OU placement after domain join
After domain join, member server computer objects were moved into:

- `Tier-1 > Member Servers`

This kept the OU structure aligned with the tiered administration model already implemented in Active Directory.

### Exchange prerequisite remediation
Exchange Server Subscription Edition readiness checks on EXCH1 identified missing prerequisites.

Instead of using generic web searches, the remediation followed the exact Microsoft links presented by Exchange Setup. This reduced time spent troubleshooting and ensured the missing components were installed in a targeted way.

### Exchange memory setting adjustment
Dynamic Memory was disabled on EXCH1 before Exchange installation so the VM used fixed memory allocation during the Exchange build.
