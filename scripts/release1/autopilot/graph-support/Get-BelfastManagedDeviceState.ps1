param(
    [string[]]$DeviceNames
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

function Get-PrimaryUserDisplay {
    param(
        [string]$ManagedDeviceId
    )

    try {
        $users = Get-MgDeviceManagementManagedDeviceUser -ManagedDeviceId $ManagedDeviceId

        if ($users) {
            return ($users | ForEach-Object {
                if ($_.AdditionalProperties.ContainsKey("userPrincipalName")) {
                    $_.AdditionalProperties["userPrincipalName"]
                }
                elseif ($_.AdditionalProperties.ContainsKey("displayName")) {
                    $_.AdditionalProperties["displayName"]
                }
                else {
                    $_.Id
                }
            }) -join "; "
        }
    }
    catch {
        return "Unable to query primary user"
    }

    return $null
}

if (-not $DeviceNames -or $DeviceNames.Count -eq 0) {
    $inputValue = Read-Host "Enter one or more device names separated by commas"
    $DeviceNames = $inputValue.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

if (-not $DeviceNames -or $DeviceNames.Count -eq 0) {
    throw "No device names were provided."
}

Test-BelfastGraphConnection

$results = foreach ($deviceName in $DeviceNames) {
    Write-Host ("Querying managed device: {0}" -f $deviceName) -ForegroundColor Yellow

    try {
        $filter = "deviceName eq '$deviceName'"
        $devices = Get-MgDeviceManagementManagedDevice -Filter $filter

        if (-not $devices) {
            [pscustomobject]@{
                QueryValue              = $deviceName
                Found                   = $false
                DeviceName              = $deviceName
                AzureADDeviceId         = $null
                ManagedDeviceId         = $null
                OperatingSystem         = $null
                OSVersion               = $null
                ComplianceState         = $null
                ManagementState         = $null
                ManagementAgent         = $null
                OwnerType               = $null
                EnrolledDateTime        = $null
                LastSyncDateTime        = $null
                UserDisplayName         = $null
                UserPrincipalName       = $null
                PrimaryUser             = $null
                SerialNumber            = $null
                Model                   = $null
                Manufacturer            = $null
                DeviceEnrollmentType    = $null
                AutopilotEnrolled       = $null
                Notes                   = "Device not found"
            }
            continue
        }

        foreach ($device in $devices) {
            [pscustomobject]@{
                QueryValue              = $deviceName
                Found                   = $true
                DeviceName              = $device.DeviceName
                AzureADDeviceId         = $device.AzureADDeviceId
                ManagedDeviceId         = $device.Id
                OperatingSystem         = $device.OperatingSystem
                OSVersion               = $device.OSVersion
                ComplianceState         = $device.ComplianceState
                ManagementState         = $device.ManagementState
                ManagementAgent         = $device.ManagementAgent
                OwnerType               = $device.ManagedDeviceOwnerType
                EnrolledDateTime        = $device.EnrolledDateTime
                LastSyncDateTime        = $device.LastSyncDateTime
                UserDisplayName         = $device.UserDisplayName
                UserPrincipalName       = $device.UserPrincipalName
                PrimaryUser             = Get-PrimaryUserDisplay -ManagedDeviceId $device.Id
                SerialNumber            = $device.SerialNumber
                Model                   = $device.Model
                Manufacturer            = $device.Manufacturer
                DeviceEnrollmentType    = $device.DeviceEnrollmentType
                AutopilotEnrolled       = $device.AutopilotEnrolled
                Notes                   = $null
            }
        }
    }
    catch {
        [pscustomobject]@{
            QueryValue              = $deviceName
            Found                   = $false
            DeviceName              = $deviceName
            AzureADDeviceId         = $null
            ManagedDeviceId         = $null
            OperatingSystem         = $null
            OSVersion               = $null
            ComplianceState         = $null
            ManagementState         = $null
            ManagementAgent         = $null
            OwnerType               = $null
            EnrolledDateTime        = $null
            LastSyncDateTime        = $null
            UserDisplayName         = $null
            UserPrincipalName       = $null
            PrimaryUser             = $null
            SerialNumber            = $null
            Model                   = $null
            Manufacturer            = $null
            DeviceEnrollmentType    = $null
            AutopilotEnrolled       = $null
            Notes                   = $_.Exception.Message
        }
    }
}

foreach ($result in $results) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ("Managed device query: {0}" -f $result.QueryValue) -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ("Found                : {0}" -f $result.Found)

    if (-not $result.Found) {
        Write-Host ("Notes                : {0}" -f $result.Notes) -ForegroundColor Red
        continue
    }

    Write-Host ("Device name          : {0}" -f $result.DeviceName)
    Write-Host ("Managed device ID    : {0}" -f $result.ManagedDeviceId)
    Write-Host ("Azure AD device ID   : {0}" -f $result.AzureADDeviceId)
    Write-Host ("Operating system     : {0}" -f $result.OperatingSystem)
    Write-Host ("OS version           : {0}" -f $result.OSVersion)
    Write-Host ("Compliance state     : {0}" -f $result.ComplianceState)
    Write-Host ("Management state     : {0}" -f $result.ManagementState)
    Write-Host ("Management agent     : {0}" -f $result.ManagementAgent)
    Write-Host ("Owner type           : {0}" -f $result.OwnerType)
    Write-Host ("Enrolled             : {0}" -f $result.EnrolledDateTime)
    Write-Host ("Last sync/check-in   : {0}" -f $result.LastSyncDateTime)
    Write-Host ("User display name    : {0}" -f $result.UserDisplayName)
    Write-Host ("User principal name  : {0}" -f $result.UserPrincipalName)
    Write-Host ("Primary user         : {0}" -f $result.PrimaryUser)
    Write-Host ("Serial number        : {0}" -f $result.SerialNumber)
    Write-Host ("Model                : {0}" -f $result.Model)
    Write-Host ("Manufacturer         : {0}" -f $result.Manufacturer)
    Write-Host ("Enrollment type      : {0}" -f $result.DeviceEnrollmentType)
    Write-Host ("Autopilot enrolled   : {0}" -f $result.AutopilotEnrolled)
}

$results