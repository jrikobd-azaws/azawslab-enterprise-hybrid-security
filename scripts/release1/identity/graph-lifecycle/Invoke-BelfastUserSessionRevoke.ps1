param(
    [string]$UserPrincipalName,
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

function Resolve-BelfastUser {
    param(
        [string]$InputUserPrincipalName
    )

    try {
        return Get-MgUser -UserId $InputUserPrincipalName -Property `
            Id,
            DisplayName,
            UserPrincipalName,
            AccountEnabled,
            UserType,
            CreatedDateTime
    }
    catch {
        throw ("User lookup failed for '{0}'. {1}" -f $InputUserPrincipalName, $_.Exception.Message)
    }
}

if (-not $UserPrincipalName) {
    $UserPrincipalName = Read-Host "Enter the target user UPN"
}

if (-not $UserPrincipalName) {
    throw "A target user UPN is required."
}

Test-BelfastGraphConnection

Write-Host ("Looking up user: {0}" -f $UserPrincipalName) -ForegroundColor Yellow
$user = Resolve-BelfastUser -InputUserPrincipalName $UserPrincipalName

Write-Host ""
Write-Host "Target user found:" -ForegroundColor Cyan
Write-Host ("Display name      : {0}" -f $user.DisplayName)
Write-Host ("User principal    : {0}" -f $user.UserPrincipalName)
Write-Host ("User ID           : {0}" -f $user.Id)
Write-Host ("Account enabled   : {0}" -f $user.AccountEnabled)
Write-Host ("User type         : {0}" -f $user.UserType)
Write-Host ("Created           : {0}" -f $user.CreatedDateTime)
Write-Host ""

if (-not $Apply) {
    Write-Host "Dry run only. No sign-in session revoke has been applied." -ForegroundColor Magenta
    Write-Host "Re-run with -Apply to revoke sessions." -ForegroundColor Magenta

    [pscustomobject]@{
        UserPrincipalName = $user.UserPrincipalName
        UserId            = $user.Id
        Applied           = $false
        Notes             = "Dry run only"
    }

    return
}

Write-Host "Revoking sign-in sessions..." -ForegroundColor Yellow

try {
    $result = Revoke-MgUserSignInSession -UserId $user.Id -ErrorAction Stop

    Write-Host "Session revoke submitted successfully." -ForegroundColor Green

    [pscustomobject]@{
        UserPrincipalName = $user.UserPrincipalName
        UserId            = $user.Id
        Applied           = $true
        Result            = $result.Value
        Notes             = "Refresh tokens and browser session cookies invalidated; app reauthentication timing may vary"
    }
}
catch {
    Write-Host "Session revoke failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red

    [pscustomobject]@{
        UserPrincipalName = $user.UserPrincipalName
        UserId            = $user.Id
        Applied           = $false
        Result            = $null
        Notes             = $_.Exception.Message
    }
}