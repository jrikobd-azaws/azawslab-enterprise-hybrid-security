## Windows Server 2022 Base Image Prepared

A standardized Windows Server 2022 Desktop Experience parent image was created for the Phase 1 on-prem foundation.

### Purpose
This parent image will be used with differencing disks for:
- DC1
- DC2
- MEM1

This approach reduces storage use on the lab host and keeps core server builds consistent.

### Actions completed
- Installed Windows Server 2022 Desktop Experience
- Renamed server to `WS2022-MASTER`
- Applied Windows updates
- Cleaned temporary files and recycle bin
- Cleared event logs to keep the image generic
- Ran Sysprep with `/generalize /oobe /shutdown`
- Preserved the VHDX as a read-only parent image
