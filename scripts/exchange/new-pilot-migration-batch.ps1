param(
    [string]$CsvPath = "C:\migration\pilot-users.csv",
    [string]$BatchName = "Pilot-Onboarding-Batch-01",
    [string]$SourceEndpoint = "Hybrid Migration Endpoint - EWS (Default Web Site)",
    [string]$TargetDeliveryDomain = "AZAWSLABUK.mail.onmicrosoft.com"
)

New-MigrationBatch `
    -Name $BatchName `
    -SourceEndpoint $SourceEndpoint `
    -TargetDeliveryDomain $TargetDeliveryDomain `
    -CSVData ([System.IO.File]::ReadAllBytes($CsvPath)) `
    -AutoStart