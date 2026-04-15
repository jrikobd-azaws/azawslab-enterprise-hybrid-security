param(
    [string]$SmtpServer = "EXCH1.corp.azawslab.co.uk",
    [int]$Port = 25,
    [string]$From = "administrator@corp.azawslab.co.uk"
)

$recipients = @(
    "u.finance01@corp.azawslab.co.uk",
    "u.hr01@corp.azawslab.co.uk"
)

foreach ($recipient in $recipients) {
    1..3 | ForEach-Object {
        $subject = "Pilot validation mail $_ for $recipient"
        $body = "This is pilot migration validation message $_ for $recipient. Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        Send-MailMessage `
            -SmtpServer $SmtpServer `
            -Port $Port `
            -From $From `
            -To $recipient `
            -Subject $subject `
            -Body $body
    }
}