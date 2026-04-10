## OU and naming decisions

### Built-in Users container conflict
A custom OU named `Users` could not be used because Active Directory already includes the default built-in `Users` container at the domain root.

To keep the structure clean and aligned with the lab design, standard users were placed under:

- `Tier-2 > User Accounts > Standard Users`

### Domain naming correction
The active lab domain was standardised to:

- `corp.azawslab.co.uk`

This superseded earlier planning references and required documentation alignment across the tracker and repository.

### Pilot-first group design
Pilot-targeted groups were created early to support later phased hybrid sync, Exchange migration, and information protection testing.

Implemented examples:
- `SG-Pilot-Hybrid-Sync`
- `SG-Pilot-Exchange-Migration`
- `SG-DLP-Pilot`
