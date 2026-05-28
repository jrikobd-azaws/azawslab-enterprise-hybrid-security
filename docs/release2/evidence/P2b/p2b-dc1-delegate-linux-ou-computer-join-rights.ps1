<#
Purpose:
  Delegate OU-scoped Linux computer join permissions for the Release 2 Ansible service account model.

Run location:
  DC1 / Domain Controller PowerShell as Administrator.

Design:
  svc.ansible is a member of azw-hq-ansible-operators.
  The group is delegated computer-join rights only on:
    OU=Linux,OU=AzawsLab,DC=hq,DC=azawslab,DC=co,DC=uk

Security model:
  - svc.ansible is not Domain Admin.
  - Delegation is scoped to the Linux OU.
  - No passwords or secrets are used in this script.
#>

Import-Module ActiveDirectory

$LinuxOuDn = 'OU=Linux,OU=AzawsLab,DC=hq,DC=azawslab,DC=co,DC=uk'
$GroupSam = 'azw-hq-ansible-operators'
$Identity = New-Object System.Security.Principal.NTAccount("HQ\$GroupSam")

# Object / property / extended-right GUIDs.
$ComputerClassGuid = [Guid]'bf967a86-0de6-11d0-a285-00aa003049e2'
$UserAccountControlGuid = [Guid]'bf967a68-0de6-11d0-a285-00aa003049e2'
$ResetPasswordGuid = [Guid]'00299570-246d-11d0-a768-00aa006e0529'
$ValidatedDnsHostNameGuid = [Guid]'72e39547-7b18-11d1-adef-00c04fd8d5cd'
$ValidatedSpnGuid = [Guid]'f3a64788-5306-11d1-a9c5-0000f80367c1'

$ReadWritePropertyRights = (
    [System.DirectoryServices.ActiveDirectoryRights]::ReadProperty -bor
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty
)

$Acl = Get-Acl -Path "AD:\$LinuxOuDn"

$Rules = @()

# Allow creation of computer objects directly in the Linux OU.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::CreateChild,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $ComputerClassGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
)

# Allow deletion for controlled lab cleanup/rejoin operations.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::DeleteChild,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $ComputerClassGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
)

# Allow read/write on descendant computer objects.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    $ReadWritePropertyRights,
    [System.Security.AccessControl.AccessControlType]::Allow,
    [Guid]::Empty,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $ComputerClassGuid
)

# Explicitly allow userAccountControl updates required by realmd/adcli.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $UserAccountControlGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $ComputerClassGuid
)

# Allow computer account password reset.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $ResetPasswordGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $ComputerClassGuid
)

# Allow validated write to DNS host name.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::Self,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $ValidatedDnsHostNameGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $ComputerClassGuid
)

# Allow validated write to service principal name.
$Rules += [System.DirectoryServices.ActiveDirectoryAccessRule]::new(
    $Identity,
    [System.DirectoryServices.ActiveDirectoryRights]::Self,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $ValidatedSpnGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $ComputerClassGuid
)

foreach ($Rule in $Rules) {
    $Acl.AddAccessRule($Rule) | Out-Null
}

Set-Acl -Path "AD:\$LinuxOuDn" -AclObject $Acl

Write-Output 'Delegation applied. Effective ACEs for azw-hq-ansible-operators:'

Get-Acl -Path "AD:\$LinuxOuDn" |
    Select-Object -ExpandProperty Access |
    Where-Object {
        $_.IdentityReference -like '*azw-hq-ansible-operators*'
    } |
    Select-Object IdentityReference,ActiveDirectoryRights,AccessControlType,ObjectType,InheritanceType,InheritedObjectType |
    Format-Table -AutoSize

Write-Output ''
Write-Output 'Service account membership:'

Get-ADUser -Identity 'svc.ansible' -Properties MemberOf |
    Select-Object -ExpandProperty MemberOf

Write-Output ''
Write-Output 'Linux computer object validation command after join:'
Write-Output "Get-ADComputer -Identity 'HQ-LINUX-VM01' -Properties DistinguishedName,DNSHostName,Enabled | Select-Object Name,DNSHostName,Enabled,DistinguishedName"
