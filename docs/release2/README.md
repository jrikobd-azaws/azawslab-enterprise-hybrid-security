## Transition from Release 1 to Release 2

Release 1 successfully established a hybrid workplace foundation using the `corp.azawslab.co.uk` AD domain and a Microsoft 365 tenant. During that phase, the domain was verified and configured.

For Release 2, the goal is to build a modern Azure platform with full infrastructure‑as‑code, Zero Trust networking, and advanced security monitoring. To create a clean, production‑intent environment free from legacy constraints, I established a new Microsoft Entra ID tenant with a dedicated namespace, `entra.azawslab.co.uk`. The on‑premises identity anchor is now `hq.azawslab.co.uk`, representing corporate headquarters, while a branch RODC uses `br1.azawslab.co.uk`.

This separation reflects real‑world scenarios where enterprises spin up greenfield cloud initiatives while maintaining existing on‑prem infrastructure. Microsoft Entra Connect synchronises identities between `hq.azawslab.co.uk` (and optionally the RODC) to `entra.azawslab.co.uk` using UPN suffix transformation – a standard pattern for rebranding or centralising cloud identity.

Release 1 remains in the repository as a completed, independent phase, demonstrating the foundational hybrid workplace skills. Release 2 advances the portfolio into Azure platform engineering and security, using a fresh identity namespace to align with best practices.

### Domain Namespaces

| Phase | Purpose | Domain / Namespace | Status |
|-------|---------|--------------------|--------|
| Release 1 baseline | Original hybrid workplace foundation | `corp.azawslab.co.uk` | Completed, preserved as baseline |
| Release 1 advanced validation | Cloud‑first continuation for advanced M365 / Intune / Purview / lifecycle work | `belfast.azawslab.co.uk` | Completed, continuation environment |
| Release 2 HQ AD | Greenfield corporate identity anchor | `hq.azawslab.co.uk` | New |
| Release 2 branch RODC | Branch office identity namespace | `br1.azawslab.co.uk` | New |
| Release 2 Entra tenant | Greenfield cloud identity namespace | `entra.azawslab.co.uk` | New |