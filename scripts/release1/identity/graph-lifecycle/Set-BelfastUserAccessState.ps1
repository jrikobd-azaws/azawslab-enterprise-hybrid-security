param(
    [Parameter(Mandatory = $false)]
    [string]$UserUpn,

    [Parameter(Mandatory = $false)]
    [switch]$Disable,

    [Parameter(Mandatory = $false)]
    [switch]$Enable,

    [Parameter(Mandatory = $false)]
    [switch]$Apply
)

$ErrorActionPreference = "Stop"

function Write-Section {
    param([string]$Text)
    Write-Host ""
    Write-Host $Text -ForegroundColor Cyan
    Write-Host ("=" * $Text.Length) -ForegroundColor Cyan
}

function Ensure-GraphConnection {
    $requiredScopes = @(
        "User.Read.All",
        "Directory.Read.All"
    )

    try {
        $context = Get-MgContext -ErrorAction SilentlyContinue
    }
    catch {
        $context = $null
    }

    if (-not $context) {
        Write-Host "No active Microsoft Graph session found. Connecting..." -ForegroundColor Yellow
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome | Out-Null
        $context = Get-MgContext
    }

    Write-Host ("Connected tenant  : {0}" -f $context.TenantId) -ForegroundColor Green
    Write-Host ("Connected account : {0}" -f $context.Account) -ForegroundColor Green
}

function Resolve-TargetUser {
    param([string]$Upn)

    $safeUpn = $Upn.Replace("'", "''")

    $user = Get-MgUser -Filter "userPrincipalName eq '$safeUpn'" -ConsistencyLevel eventual `
        -Property Id,DisplayName,UserPrincipalName,AccountEnabled,UserType,CreatedDateTime

    if (-not $user) {
        throw "No user found for UPN '$Upn'."
    }

    if ($user -is [array] -and $user.Count -gt 1) {
        throw "More than one user matched '$Upn'."
    }

    return $user
}

function Get-RequestedAction {
    param(
        [switch]$DisableSwitch,
        [switch]$EnableSwitch
    )

    if ($DisableSwitch -and $EnableSwitch) {
        throw "Use either -Disable or -Enable, not both."
    }

    if ($DisableSwitch) { return "Disable" }
    if ($EnableSwitch)  { return "Enable"  }

    while ($true) {
        $choice = Read-Host "Choose action [D]isable or [E]nable"

        if ([string]::IsNullOrWhiteSpace($choice)) {
            Write-Host "Please enter D or E." -ForegroundColor Yellow
            continue
        }

        switch ($choice.Trim().ToUpper()) {
            "D" { return "Disable" }
            "DISABLE" { return "Disable" }
            "E" { return "Enable" }
            "ENABLE" { return "Enable" }
            default {
                Write-Host "Invalid choice. Enter D for Disable or E for Enable." -ForegroundColor Yellow
            }
        }
    }
}

try {
    if (-not $UserUpn) {
        $UserUpn = Read-Host "Enter the target user UPN"
    }

    if ([string]::IsNullOrWhiteSpace($UserUpn)) {
        throw "A target user UPN is required."
    }

    Ensure-GraphConnection

    Write-Section "Looking up user"
    Write-Host ("Target UPN : {0}" -f $UserUpn) -ForegroundColor Yellow

    $targetUser = Resolve-TargetUser -Upn $UserUpn
    $requestedAction = Get-RequestedAction -DisableSwitch:$Disable -EnableSwitch:$Enable
    $targetEnabledState = if ($requestedAction -eq "Disable") { $false } else { $true }

    Write-Section "Target user found"
    Write-Host ("Display name     : {0}" -f $targetUser.DisplayName)
    Write-Host ("User principal   : {0}" -f $targetUser.UserPrincipalName)
    Write-Host ("User ID          : {0}" -f $targetUser.Id)
    Write-Host ("Account enabled  : {0}" -f $targetUser.AccountEnabled)
    Write-Host ("User type        : {0}" -f $targetUser.UserType)
    Write-Host ("Created          : {0}" -f $targetUser.CreatedDateTime)

    Write-Section "Requested action"
    Write-Host ("Action           : {0}" -f $requestedAction) -ForegroundColor Yellow
    Write-Host ("Apply mode       : {0}" -f $Apply.IsPresent)

    if (-not $Apply) {
        Write-Host ""
        Write-Host "Dry run only. No account state change has been applied." -ForegroundColor Magenta
        Write-Host "Re-run with -Apply to perform the action." -ForegroundColor Magenta

        [pscustomobject]@{
            UserPrincipalName = $targetUser.UserPrincipalName
            UserId            = $targetUser.Id
            CurrentState      = [bool]$targetUser.AccountEnabled
            RequestedAction   = $requestedAction
            TargetState       = $targetEnabledState
            Applied           = $false
            Notes             = "Dry run only"
        } | Format-List

        return
    }

    Write-Host ""
Write-Host "Applying account state change..." -ForegroundColor Yellow

Update-MgUser -UserId $targetUser.Id -AccountEnabled:$targetEnabledState -ErrorAction Stop

$verificationUser = Get-MgUser -UserId $targetUser.Id `
    -Property Id,DisplayName,UserPrincipalName,AccountEnabled,UserType,CreatedDateTime

if ([bool]$verificationUser.AccountEnabled -ne $targetEnabledState) {
    throw "Verification failed. The account state did not change to the expected value."
}

Write-Host "Account state update completed successfully." -ForegroundColor Green

[pscustomobject]@{
    UserPrincipalName = $verificationUser.UserPrincipalName
    UserId            = $verificationUser.Id
    PreviousState     = [bool]$targetUser.AccountEnabled
    RequestedAction   = $requestedAction
    CurrentState      = [bool]$verificationUser.AccountEnabled
    Applied           = $true
    Notes             = "AccountEnabled updated and verified via Microsoft Graph"
} | Format-List
}
catch {
    Write-Host ""
    Write-Host ("ERROR: {0}" -f $_.Exception.Message) -ForegroundColor Red
    exit 1
}