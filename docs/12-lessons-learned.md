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
