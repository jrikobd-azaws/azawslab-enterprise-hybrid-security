Write-Host "Network profiles:"
Get-NetConnectionProfile | Select-Object Name, InterfaceAlias, NetworkCategory

Write-Host "`nCurrent WinRM firewall rules:"
Get-NetFirewallRule | Where-Object {
    $_.DisplayName -like "*WinRM*" -or $_.Name -like "*WINRM*"
} | Select-Object DisplayName, Enabled, Profile, Direction, Action

Write-Host "`nEnable all WinRM firewall rules:"
Get-NetFirewallRule | Where-Object {
    $_.DisplayName -like "*WinRM*" -or $_.Name -like "*WINRM*"
} | Enable-NetFirewallRule

Write-Host "`nSet WinRM Public rule to any remote address:"
Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" -ErrorAction SilentlyContinue | Set-NetFirewallRule -Profile Any -Enabled True
Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" -ErrorAction SilentlyContinue | Select-Object DisplayName, Enabled, Profile, Direction, Action

Write-Host "`nListener check:"
winrm enumerate winrm/config/listener
