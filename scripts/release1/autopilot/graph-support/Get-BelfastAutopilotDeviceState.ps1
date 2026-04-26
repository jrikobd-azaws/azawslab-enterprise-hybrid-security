param(
    [string]$DeviceNamePrefix,
    [string]$GroupTag
)

$ErrorActionPreference = "Stop"

function Test-BelfastGraphConnection {
    try {
        $ctx = Get-MgContext
        if (-not $ctx) {
            throw "No Microsoft Graph connection found. Run Connect-MgGraph first."
        }

        Write-Host ("Connected tenant : {0}" -f $ctx.TenantId) -ForegroundColor Green
        Write-Host ("Connected account: {0}" -f $ctx.Account) -ForegroundColor Green
        Write-Host ""
    }
    catch {
        throw "Microsoft Graph is not connected. Run Connect-MgGraph first."
    }
}

if (-not $DeviceNamePrefix -and -not $GroupTag) {
    $DeviceNamePrefix = Read-Host "Enter device name prefix to filter Autopilot devices (or press Enter to skip)"
    $GroupTag = Read-Host "Enter group tag to filter Autopilot devices (or press Enter to skip)"
}

Test-BelfastGraphConnection

Write-Host "Querying Windows Autopilot devices..." -ForegroundColor Yellow

$devices = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -All

if ($DeviceNamePrefix) {
    $devices = $devices | Where-Object { $_.DisplayName -like "$DeviceNamePrefix*" }
}

if ($GroupTag) {
    $devices = $devices | Where-Object { $_.GroupTag -eq $GroupTag }
}

$results = foreach ($device in $devices) {
    [pscustomobject]@{
        DisplayName                     = $device.DisplayName
        SerialNumber                    = $device.SerialNumber
        GroupTag                        = $device.GroupTag
        PurchaseOrderIdentifier         = $device.PurchaseOrderIdentifier
        Manufacturer                    = $device.Manufacturer
        Model                           = $device.Model
        ManagedDeviceId                 = $device.ManagedDeviceId
        AzureADDeviceId                 = $device.AzureActiveDirectoryDeviceId
        EnrollmentState                 = $device.EnrollmentState
        LastContactedDateTime           = $device.LastContactedDateTime
        AddressableUserName             = $device.AddressableUserName
        UserPrincipalName               = $device.UserPrincipalName
        ResourceName                    = $device.ResourceName
        DeploymentProfileAssignmentStatus = $device.DeploymentProfileAssignmentStatus
        DeploymentProfileAssignedDateTime = $device.DeploymentProfileAssignedDateTime
        RemediationState                = $device.RemediationState
    }
}

if (-not $results -or $results.Count -eq 0) {
    Write-Host "No Autopilot devices matched the supplied filter." -ForegroundColor Red
}
else {
    Write-Host ""
    Write-Host "Matched Autopilot devices:" -ForegroundColor Cyan
    $results | Format-Table DisplayName, SerialNumber, GroupTag, EnrollmentState, DeploymentProfileAssignmentStatus, LastContactedDateTime -AutoSize
}

$results