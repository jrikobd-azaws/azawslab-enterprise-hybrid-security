param(
    [string]$SmtpServer = "EXCH1.corp.azawslab.co.uk",
    [int]$Port = 25,
    [string]$From = "administrator@corp.azawslab.co.uk",
    [string]$AttachmentPath = "C:\migration\pilot-attachment.txt"
)

if (-not (Test-Path $AttachmentPath)) {
    "Pilot attachment validation file created on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Set-Content $AttachmentPath
}

$recipients = @(
    "u.finance01@corp.azawslab.co.uk",
    "u.hr01@corp.azawslab.co.uk"
)

foreach ($recipient in $recipients) {
    Send-MailMessage `
        -SmtpServer $SmtpServer `
        -Port $Port `
        -From $From `
        -To $recipient `
        -Subject "Pilot attachment validation test" `
        -Body "Attachment validation message." `
        -Attachments $AttachmentPath
}