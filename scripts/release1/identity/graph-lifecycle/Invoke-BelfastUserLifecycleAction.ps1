param()

function Read-MenuChoice {
    param(
        [string]$Prompt,
        [string[]]$ValidChoices
    )

    do {
        $choice = Read-Host $Prompt
    } while ($choice -notin $ValidChoices)

    return $choice
}

function Read-RequiredValue {
    param(
        [string]$Prompt
    )

    do {
        $value = Read-Host $Prompt
    } while ([string]::IsNullOrWhiteSpace($value))

    return $value
}

function Ensure-GraphConnection {
    try {
        $context = Get-MgContext -ErrorAction SilentlyContinue
        if (-not $context) {
            Write-Host ""
            Write-Host "No active Microsoft Graph session found. Connecting..." -ForegroundColor Yellow
            Connect-MgGraph -Scopes "User.Read.All","User.ReadWrite.All","Group.Read.All"
        }
    }
    catch {
        Write-Host ""
        Write-Host "Failed to establish Microsoft Graph connection: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

function Get-DepartmentSelection {
    Write-Host ""
    Write-Host "Choose department:" -ForegroundColor Yellow
    Write-Host "1. Finance"
    Write-Host "2. Operations"

    $choice = Read-MenuChoice -Prompt "Enter 1 or 2" -ValidChoices @("1","2")

    switch ($choice) {
        "1" { return "Finance" }
        "2" { return "Operations" }
    }
}

function Get-RoleSelection {
    param(
        [string]$Department
    )

    Write-Host ""
    Write-Host "Choose role for department [$Department]:" -ForegroundColor Yellow

    switch ($Department) {
        "Finance" {
            Write-Host "1. Finance Analyst"
            Write-Host "2. Finance Assistant"
            $choice = Read-MenuChoice -Prompt "Enter 1 or 2" -ValidChoices @("1","2")
            switch ($choice) {
                "1" { return "Finance Analyst" }
                "2" { return "Finance Assistant" }
            }
        }
        "Operations" {
            Write-Host "1. Operations Analyst"
            Write-Host "2. Operations Assistant"
            $choice = Read-MenuChoice -Prompt "Enter 1 or 2" -ValidChoices @("1","2")
            switch ($choice) {
                "1" { return "Operations Analyst" }
                "2" { return "Operations Assistant" }
            }
        }
        default {
            throw "Unsupported department [$Department]."
        }
    }
}

function Get-OfficeLocationSelection {
    Write-Host ""
    Write-Host "Choose office location:" -ForegroundColor Yellow
    Write-Host "1. Belfast"
    Write-Host "2. London"
    Write-Host "3. Manual entry"

    $choice = Read-MenuChoice -Prompt "Enter 1, 2 or 3" -ValidChoices @("1","2","3")

    switch ($choice) {
        "1" { return "Belfast" }
        "2" { return "London" }
        "3" { return (Read-RequiredValue -Prompt "Enter office location") }
    }
}

function Get-ExecutionMode {
    Write-Host ""
    Write-Host "Choose execution mode:" -ForegroundColor Yellow
    Write-Host "1. Dry run"
    Write-Host "2. Apply"

    $choice = Read-MenuChoice -Prompt "Enter 1 or 2" -ValidChoices @("1","2")

    switch ($choice) {
        "1" { return "DryRun" }
        "2" { return "Apply" }
    }
}

function Get-TargetUser {
    param(
        [string]$UserUpn
    )

    Write-Host ""
    Write-Host "Looking up user..." -ForegroundColor Cyan

    return Get-MgUser `
        -UserId $UserUpn `
        -Property Id,DisplayName,UserPrincipalName,Department,JobTitle,OfficeLocation,AccountEnabled `
        -ErrorAction Stop
}

function Show-UserState {
    param(
        [string]$Title,
        [object]$User
    )

    Write-Host ""
    Write-Host $Title -ForegroundColor Cyan
    Write-Host "Display name     : $($User.DisplayName)"
    Write-Host "User principal   : $($User.UserPrincipalName)"
    Write-Host "Department       : $($User.Department)"
    Write-Host "Job title        : $($User.JobTitle)"
    Write-Host "Office location  : $($User.OfficeLocation)"
    Write-Host "Account enabled  : $($User.AccountEnabled)"
    Write-Host "User ID          : $($User.Id)"
}

function Show-RequestedState {
    param(
        [string]$ActionName,
        [string]$Department,
        [string]$JobTitle,
        [string]$OfficeLocation,
        [string]$Mode
    )

    Write-Host ""
    Write-Host "Requested action" -ForegroundColor Cyan
    Write-Host "Action type      : $ActionName"
    Write-Host "Department       : $Department"
    Write-Host "Job title        : $JobTitle"
    Write-Host "Office location  : $OfficeLocation"
    Write-Host "Mode             : $Mode"
}

function Invoke-UserUpdate {
    param(
        [string]$UserUpn,
        [string]$Department,
        [string]$JobTitle,
        [string]$OfficeLocation,
        [string]$Mode,
        [string]$ActionName
    )

    $user = Get-TargetUser -UserUpn $UserUpn
    Show-UserState -Title "Current values" -User $user
    Show-RequestedState `
        -ActionName $ActionName `
        -Department $Department `
        -JobTitle $JobTitle `
        -OfficeLocation $OfficeLocation `
        -Mode $Mode

    if ($Mode -eq "DryRun") {
        Write-Host ""
        Write-Host "Dry run only. No changes have been applied." -ForegroundColor Magenta
        return
    }

    Write-Host ""
    Write-Host "Applying update..." -ForegroundColor Yellow

    Update-MgUser `
        -UserId $UserUpn `
        -Department $Department `
        -JobTitle $JobTitle `
        -OfficeLocation $OfficeLocation `
        -ErrorAction Stop

    $updatedUser = Get-TargetUser -UserUpn $UserUpn

    Write-Host ""
    Write-Host "Update completed successfully." -ForegroundColor Green
    Show-UserState -Title "Updated values" -User $updatedUser
}

function Invoke-ProfileUpdateAction {
    Write-Host ""
    Write-Host "=== Profile update ===" -ForegroundColor Green

    $userUpn = Read-RequiredValue -Prompt "Enter target user UPN"

    $department = Get-DepartmentSelection
    $jobTitle = Get-RoleSelection -Department $department
    $officeLocation = Get-OfficeLocationSelection
    $mode = Get-ExecutionMode

    Invoke-UserUpdate `
        -UserUpn $userUpn `
        -Department $department `
        -JobTitle $jobTitle `
        -OfficeLocation $officeLocation `
        -Mode $mode `
        -ActionName "Profile update"
}

function Invoke-DepartmentMoveAction {
    Write-Host ""
    Write-Host "=== Department move ===" -ForegroundColor Green

    $userUpn = Read-RequiredValue -Prompt "Enter target user UPN"

    $currentUser = Get-TargetUser -UserUpn $userUpn
    Show-UserState -Title "Current values before move" -User $currentUser

    Write-Host ""
    Write-Host "Current department: $($currentUser.Department)" -ForegroundColor Yellow
    Write-Host "Select target department for mover scenario." -ForegroundColor Yellow

    $targetDepartment = Get-DepartmentSelection

    if ($currentUser.Department -eq $targetDepartment) {
        Write-Host ""
        Write-Host "Warning: target department matches the current department." -ForegroundColor Yellow
    }

    $targetJobTitle = Get-RoleSelection -Department $targetDepartment
    $officeLocation = Get-OfficeLocationSelection
    $mode = Get-ExecutionMode

    Show-RequestedState `
        -ActionName "Department move" `
        -Department $targetDepartment `
        -JobTitle $targetJobTitle `
        -OfficeLocation $officeLocation `
        -Mode $mode

    if ($mode -eq "DryRun") {
        Write-Host ""
        Write-Host "Dry run only. No department move has been applied." -ForegroundColor Magenta
        return
    }

    Write-Host ""
    Write-Host "Applying department move..." -ForegroundColor Yellow

    Update-MgUser `
        -UserId $userUpn `
        -Department $targetDepartment `
        -JobTitle $targetJobTitle `
        -OfficeLocation $officeLocation `
        -ErrorAction Stop

    $updatedUser = Get-TargetUser -UserUpn $userUpn

    Write-Host ""
    Write-Host "Department move completed successfully." -ForegroundColor Green
    Show-UserState -Title "Updated values after move" -User $updatedUser
}

function Show-MainMenu {
    Write-Host ""
    Write-Host "==============================================" -ForegroundColor DarkCyan
    Write-Host " Belfast User Lifecycle Action Console" -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "1. Profile update"
    Write-Host "2. Department move"
    Write-Host "3. Exit"
    Write-Host ""
}

try {
    Ensure-GraphConnection

    do {
        Show-MainMenu
        $mainChoice = Read-MenuChoice -Prompt "Choose an option (1-3)" -ValidChoices @("1","2","3")

        switch ($mainChoice) {
            "1" { Invoke-ProfileUpdateAction }
            "2" { Invoke-DepartmentMoveAction }
            "3" {
                Write-Host ""
                Write-Host "Exiting script." -ForegroundColor Yellow
            }
        }

    } while ($mainChoice -ne "3")
}
catch {
    Write-Host ""
    Write-Host "Script failed: $($_.Exception.Message)" -ForegroundColor Red
    throw
}