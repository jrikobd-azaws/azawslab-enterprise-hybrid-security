# 1. Provide a temporary password (SYSTEM will use this to create the account)
$Password = ConvertTo-SecureString "BelfastPilot2026!" -AsPlainText -Force

# 2. Create the custom account beladm01
if (-not (Get-LocalUser -Name "beladm01" -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name "beladm01" -Password $Password -Description "Belfast Pilot Local Admin"
}

# 3. Add to Administrators and Enable
Add-LocalGroupMember -Group "Administrators" -Member "beladm01"
Enable-LocalUser -Name "beladm01"