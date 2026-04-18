param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFolder,

    [string]$OutputFolder = "",

    [string]$WatermarkText = "AZAWSLAB LAB EVIDENCE",

    [string]$FooterText = "Release 1",

    [int]$DiagonalPointSize = 48,

    [int]$FooterPointSize = 20
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourceFolder)) {
    throw "Source folder not found: $SourceFolder"
}

if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
    $OutputFolder = Join-Path $SourceFolder "watermarked"
}

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

$magick = Get-Command magick -ErrorAction SilentlyContinue
if (-not $magick) {
    throw "ImageMagick is not installed or not in PATH. Run: winget install ImageMagick.ImageMagick"
}

$files = Get-ChildItem -Path $SourceFolder -File | Where-Object {
    $_.Extension -match '^\.(png|jpg|jpeg|webp)$'
}

if (-not $files) {
    Write-Host "No image files found in $SourceFolder"
    exit 0
}

foreach ($file in $files) {
    $outFile = Join-Path $OutputFolder $file.Name

    & magick $file.FullName `
        -gravity center `
        -fill "rgba(180,180,180,0.20)" `
        -pointsize $DiagonalPointSize `
        -annotate 45 $WatermarkText `
        -gravity southeast `
        -fill "rgba(255,255,255,0.65)" `
        -undercolor "rgba(0,0,0,0.35)" `
        -pointsize $FooterPointSize `
        -annotate +20+20 $FooterText `
        $outFile

    Write-Host "Created: $outFile"
}

Write-Host ""
Write-Host "Done. Watermarked files are in: $OutputFolder"