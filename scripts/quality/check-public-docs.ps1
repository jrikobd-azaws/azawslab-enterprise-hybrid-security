[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot = (& git rev-parse --show-toplevel).Trim()
Set-Location $RepoRoot

$script:Failures = New-Object System.Collections.Generic.List[string]

function Get-TrackedTextFiles {
    $TrackedFiles = & git ls-files

    $TextFilePattern = '\.(md|markdown|txt|yml|yaml|ps1|py|json|tf|tfvars|hcl)$'
    $ExcludedPathPatterns = @(
        '^docs/release2/10-phase-reference/archive/',
        '^docs/release3/10-roadmap-reference/archive/',
        '^site/assets/images/',
        '^screenshots/',
        '^diagrams/'
    )

    foreach ($File in $TrackedFiles) {
        if ($File -notmatch $TextFilePattern) {
            continue
        }

        $Excluded = $false
        foreach ($Pattern in $ExcludedPathPatterns) {
            if ($File -match $Pattern) {
                $Excluded = $true
                break
            }
        }

        if (-not $Excluded) {
            $File
        }
    }
}

function Write-Matches {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CheckName,

        [Parameter(Mandatory = $true)]
        [object[]] $Matches
    )

    Write-Host ""
    Write-Host "FAILED: $CheckName"
    Write-Host "----------------------------------------"

    foreach ($Match in $Matches) {
        $RelativePath = $Match.Path.Replace($RepoRoot + [System.IO.Path]::DirectorySeparatorChar, '')
        Write-Host ("{0}:{1}: {2}" -f $RelativePath, $Match.LineNumber, $Match.Line.Trim())
    }
}

function Test-Pattern {
    param(
        [Parameter(Mandatory = $true)]
        [string] $CheckName,

        [Parameter(Mandatory = $true)]
        [string] $Pattern,

        [Parameter(Mandatory = $true)]
        [string[]] $Files
    )

    $Matches = @()

    foreach ($File in $Files) {
        $FullPath = Join-Path $RepoRoot $File
        $FileMatches = Select-String -Path $FullPath -Pattern $Pattern -Encoding UTF8 -ErrorAction Stop
        if ($FileMatches) {
            $Matches += $FileMatches
        }
    }

    if ($Matches.Count -gt 0) {
        Write-Matches -CheckName $CheckName -Matches $Matches
        $script:Failures.Add($CheckName)
    }
}

Write-Host "Running public documentation quality checks..."
Write-Host "Repository: $RepoRoot"

$Files = @(Get-TrackedTextFiles)
Write-Host ("Text files scanned: {0}" -f $Files.Count)

$PlaceholderPattern = 'proof link to be inserted|Diagram placeholder|diagram placeholder|insert-link|path-to-gif|raw\.githubusercontent\.com/\.\.\.|google\.com/search|google\.com/url|\[cite:'

$MojibakePattern = (
    [regex]::Escape([string][char]0x00E2) + '|' +
    [regex]::Escape([string][char]0x00C3) + '|' +
    [regex]::Escape([string][char]0x00C2)
)

Test-Pattern `
    -CheckName 'Placeholder, fake-link, or generated citation artifact scan' `
    -Pattern $PlaceholderPattern `
    -Files $Files

Test-Pattern `
    -CheckName 'Common mojibake / encoding damage scan' `
    -Pattern $MojibakePattern `
    -Files $Files

$TrackedFiles = & git ls-files

$ForbiddenTrackedPatterns = @(
    '(^|/)\.site(/|$)',
    '(^|/)\.venv-mkdocs(/|$)',
    '(^|/)\.env$',
    '(^|/)\.env\.',
    '(^|/)terraform\.tfstate(\..*)?$',
    '\.tfstate(\..*)?$',
    '(^|/)crash\.log$',
    '(^|/)kubeconfig(\..*)?$',
    '(^|/)id_rsa$',
    '\.(pem|pfx|p12|key)$'
)

$ForbiddenFiles = @()
foreach ($File in $TrackedFiles) {
    foreach ($Pattern in $ForbiddenTrackedPatterns) {
        if ($File -match $Pattern) {
            $ForbiddenFiles += $File
            break
        }
    }
}

if ($ForbiddenFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "FAILED: Forbidden tracked build output, secret, state, key, or kubeconfig-style file"
    Write-Host "----------------------------------------"
    $ForbiddenFiles | Sort-Object -Unique | ForEach-Object { Write-Host $_ }
    $script:Failures.Add('Forbidden tracked build output, secret, state, key, or kubeconfig-style file')
}

$LegacyPlanFiles = @(
    $TrackedFiles |
        Where-Object {
            $_ -match '(^|/)tfplan' -or
            $_ -match '\.tfplan$'
        }
)

if ($LegacyPlanFiles.Count -gt 0) {
    Write-Host ""
    Write-Warning "Legacy Terraform plan-looking files are tracked. This check is advisory only for the existing repository state."
    $LegacyPlanFiles | Sort-Object -Unique | ForEach-Object { Write-Host "WARN: $_" }
}

if ($script:Failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Public documentation quality checks failed:"
    $script:Failures | Sort-Object -Unique | ForEach-Object { Write-Host "- $_" }
    exit 1
}

Write-Host ""
Write-Host "Public documentation quality checks passed."