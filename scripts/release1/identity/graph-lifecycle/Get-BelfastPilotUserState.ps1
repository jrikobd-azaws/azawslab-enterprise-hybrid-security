param(
    [string[]]$UserPrincipalNames
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

function Get-SafeAdditionalProperty {
    param(
        $Object,
        [string]$Key
    )

    if ($null -ne $Object -and
        $null -ne $Object.AdditionalProperties -and
        $Object.AdditionalProperties.ContainsKey($Key)) {
        return $Object.AdditionalProperties[$Key]
    }

    return $null
}

if (-not $UserPrincipalNames -or $UserPrincipalNames.Count -eq 0) {
    $inputValue = Read-Host "Enter one or more user UPNs separated by commas"
    $UserPrincipalNames = $inputValue.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

if (-not $UserPrincipalNames -or $UserPrincipalNames.Count -eq 0) {
    throw "No user UPNs were provided."
}

Test-BelfastGraphConnection

$results = foreach ($upn in $UserPrincipalNames) {
    Write-Host ("Querying user: {0}" -f $upn) -ForegroundColor Yellow

    try {
        $user = Get-MgUser -UserId $upn -Property `
            Id,
            DisplayName,
            UserPrincipalName,
            AccountEnabled,
            CreatedDateTime,
            UserType,
            Department,
            JobTitle,
            OfficeLocation

        $memberOf = Get-MgUserMemberOf -UserId $user.Id -All |
            ForEach-Object {
                [pscustomobject]@{
                    ObjectType   = Get-SafeAdditionalProperty -Object $_ -Key "@odata.type"
                    DisplayName  = Get-SafeAdditionalProperty -Object $_ -Key "displayName"
                    Description  = Get-SafeAdditionalProperty -Object $_ -Key "description"
                    MailNickname = Get-SafeAdditionalProperty -Object $_ -Key "mailNickname"
                }
            } |
            Sort-Object DisplayName

        [pscustomobject]@{
            QueryValue        = $upn
            Found             = $true
            DisplayName       = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            AccountEnabled    = $user.AccountEnabled
            UserType          = $user.UserType
            Department        = $user.Department
            JobTitle          = $user.JobTitle
            OfficeLocation    = $user.OfficeLocation
            CreatedDateTime   = $user.CreatedDateTime
            GroupCount        = @($memberOf).Count
            Groups            = $memberOf
            Notes             = $null
        }
    }
    catch {
        [pscustomobject]@{
            QueryValue        = $upn
            Found             = $false
            DisplayName       = $null
            UserPrincipalName = $null
            AccountEnabled    = $null
            UserType          = $null
            Department        = $null
            JobTitle          = $null
            OfficeLocation    = $null
            CreatedDateTime   = $null
            GroupCount        = 0
            Groups            = @()
            Notes             = $_.Exception.Message
        }
    }
}

foreach ($result in $results) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ("User query: {0}" -f $result.QueryValue) -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ("Found             : {0}" -f $result.Found)

    if (-not $result.Found) {
        Write-Host ("Notes             : {0}" -f $result.Notes) -ForegroundColor Red
        continue
    }

    Write-Host ("Display name      : {0}" -f $result.DisplayName)
    Write-Host ("User principal    : {0}" -f $result.UserPrincipalName)
    Write-Host ("Account enabled   : {0}" -f $result.AccountEnabled)
    Write-Host ("User type         : {0}" -f $result.UserType)
    Write-Host ("Department        : {0}" -f $result.Department)
    Write-Host ("Job title         : {0}" -f $result.JobTitle)
    Write-Host ("Office location   : {0}" -f $result.OfficeLocation)
    Write-Host ("Created           : {0}" -f $result.CreatedDateTime)
    Write-Host ("Group count       : {0}" -f $result.GroupCount)

    if ($result.GroupCount -gt 0) {
        Write-Host ""
        Write-Host "Group membership:" -ForegroundColor Magenta
        $result.Groups | Format-Table ObjectType, DisplayName, Description, MailNickname -AutoSize
    }
    else {
        Write-Host "Group membership  : none found"
    }
}

$results