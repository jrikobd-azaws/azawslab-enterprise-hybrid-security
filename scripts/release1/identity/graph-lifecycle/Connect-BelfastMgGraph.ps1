Connect-MgGraph -Scopes `
"User.Read.All",`
"Group.Read.All",`
"Device.Read.All",`
"DeviceManagementManagedDevices.Read.All",`
"DeviceManagementServiceConfig.Read.All",`
"DeviceManagementManagedDevices.PrivilegedOperations.All"

Import-Module Microsoft.Graph.Beta.DeviceManagement