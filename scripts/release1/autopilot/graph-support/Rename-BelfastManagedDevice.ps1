param(
    [string]$CurrentDeviceName,
    [string]$NewDeviceName,
    [switch]$Apply
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

if (-not $CurrentDeviceName) {
    $CurrentDeviceName = Read-Host "Enter the current managed device name"
}

if (-not $NewDeviceName) {
    $NewDeviceName = Read-Host "Enter the new managed device name"
}

if (-not $CurrentDeviceName) {
    throw "Current device name is required."
}

if (-not $NewDeviceName) {
    throw "New device name is required."
}

Test-BelfastGraphConnection

Write-Host ("Looking up managed device: {0}" -f $CurrentDeviceName) -ForegroundColor Yellow

$filter = "deviceName eq '$CurrentDeviceName'"
$device = Get-MgDeviceManagementManagedDevice -Filter $filter | Select-Object -First 1

if (-not $device) {
    throw ("Managed device not found: {0}" -f $CurrentDeviceName)
}

Write-Host ""
Write-Host "Managed device found:" -ForegroundColor Cyan
Write-Host ("Device name        : {0}" -f $device.DeviceName)
Write-Host ("Managed device ID  : {0}" -f $device.Id)
Write-Host ("Azure AD device ID : {0}" -f $device.AzureADDeviceId)
Write-Host ("OS                 : {0}" -f $device.OperatingSystem)
Write-Host ("OS version         : {0}" -f $device.OSVersion)
Write-Host ("Primary user UPN   : {0}" -f $device.UserPrincipalName)
Write-Host ""
Write-Host ("Requested new name : {0}" -f $NewDeviceName) -ForegroundColor Yellow
Write-Host ""

if (-not $Apply) {
    Write-Host "Dry run only. No rename has been applied." -ForegroundColor Magenta
    Write-Host "Re-run with -Apply to perform the rename." -ForegroundColor Magenta

    [pscustomobject]@{
        CurrentDeviceName = $device.DeviceName
        ManagedDeviceId   = $device.Id
        NewDeviceName     = $NewDeviceName
        Applied           = $false
        Notes             = "Dry run only"
    }

    return
}

Write-Host "Applying rename operation..." -ForegroundColor Yellow

try {
    Set-MgBetaDeviceManagementManagedDeviceName `
        -ManagedDeviceId $device.Id `
        -DeviceName $NewDeviceName `
        -ErrorAction Stop

    Write-Host "Rename request submitted successfully." -ForegroundColor Green

    [pscustomobject]@{
        CurrentDeviceName = $device.DeviceName
        ManagedDeviceId   = $device.Id
        NewDeviceName     = $NewDeviceName
        Applied           = $true
        Notes             = "Rename submitted via Graph beta cmdlet"
    }
}
catch {
    Write-Host "Rename failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    [pscustomobject]@{
        CurrentDeviceName = $device.DeviceName
        ManagedDeviceId   = $device.Id
        NewDeviceName     = $NewDeviceName
        Applied           = $false
        Notes             = $_.Exception.Message
    }
}