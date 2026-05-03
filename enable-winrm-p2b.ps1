hostname
Get-Service WinRM | Select-Object Status, Name, StartType
Enable-PSRemoting -Force
Get-Service WinRM | Select-Object Status, Name, StartType
winrm enumerate winrm/config/listener
Get-NetFirewallRule | Where-Object {
    $_.DisplayName -like "*WinRM*" -or $_.Name -like "*WINRM*"
} | Select-Object DisplayName, Enabled, Direction, Action
