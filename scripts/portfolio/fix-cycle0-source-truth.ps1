#requires -Version 5.1
<#
.SYNOPSIS
  Fix Cycle 0 source-truth issues before portfolio documentation migration.

.DESCRIPTION
  This script performs only the pending source-truth cleanup:
  - creates STATUS.md
  - fixes active branch namespace drift from br.azawslab.co.uk to br1.azawslab.co.uk
  - inserts/updates canonical Release 2 status notes
  - updates old Release 2 README A1-only status text if found
  - creates reports for remaining br namespace drift
  - creates reports for mojibake/encoding artifacts
  - does not mass-rewrite corrupted prose

.USAGE
  Dry run:
    pwsh .\scripts\portfolio\fix-cycle0-source-truth.ps1

  Apply changes:
    pwsh .\scripts\portfolio\fix-cycle0-source-truth.ps1 -Apply
#>

[CmdletBinding()]
param(
    [switch]$Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Info {
    param([string]$Message)
    Write-Host "    $Message" -ForegroundColor Gray
}

function Write-Change {
    param([string]$Message)
    Write-Host "    CHANGE: $Message" -ForegroundColor Yellow
}

function Write-Ok {
    param([string]$Message)
    Write-Host "    OK: $Message" -ForegroundColor Green
}

function Write-Warn2 {
    param([string]$Message)
    Write-Host "    WARN: $Message" -ForegroundColor Magenta
}

function Assert-RepoRoot {
    if (-not (Test-Path ".git")) {
        throw "Run this script from the repository root. The .git directory was not found."
    }
}

function Resolve-ExistingFileByLeaf {
    param(
        [string[]]$CandidatePaths,
        [string]$LeafName
    )

    foreach ($path in $CandidatePaths) {
        if (Test-Path $path) {
            return $path
        }
    }

    $matches = Get-ChildItem -Path . -Recurse -File -Filter $LeafName |
        Where-Object {
            $_.FullName -notmatch "[\\/]\.git[\\/]" -and
            $_.FullName -notmatch "[\\/]\.migration-backups[\\/]" -and
            $_.FullName -notmatch "[\\/]node_modules[\\/]"
        }

    if ($matches.Count -eq 1) {
        return (Resolve-Path -Relative $matches[0].FullName)
    }

    if ($matches.Count -gt 1) {
        Write-Warn2 "Multiple files found for leaf name '$LeafName'. Using first match: $($matches[0].FullName)"
        return (Resolve-Path -Relative $matches[0].FullName)
    }

    return $null
}

function Ensure-Directory {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        if ($Apply) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            Write-Change "Created directory: $Path"
        }
        else {
            Write-Info "Would create directory: $Path"
        }
    }
}

function Get-Utf8Text {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return $null
    }

    return [System.IO.File]::ReadAllText((Resolve-Path $Path).Path, [System.Text.Encoding]::UTF8)
}

function Set-Utf8NoBomText {
    param(
        [string]$Path,
        [string]$Content
    )

    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $fullPath = if (Test-Path $Path) {
        (Resolve-Path $Path).Path
    }
    else {
        Join-Path (Get-Location).Path $Path
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($fullPath, $Content, $utf8NoBom)
}

function Backup-File {
    param(
        [string]$Path,
        [string]$BackupRoot
    )

    if (-not (Test-Path $Path)) {
        return
    }

    $relative = $Path -replace "^[.][\\/]", ""
    $backupPath = Join-Path $BackupRoot $relative
    $backupDir = Split-Path -Parent $backupPath

    if ($Apply) {
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }

        Copy-Item -Path $Path -Destination $backupPath -Force
        Write-Info "Backup: $Path -> $backupPath"
    }
}

function Write-FileIfChanged {
    param(
        [string]$Path,
        [string]$Content,
        [string]$BackupRoot
    )

    $existing = Get-Utf8Text -Path $Path

    if ($existing -eq $Content) {
        Write-Ok "No change needed: $Path"
        return
    }

    if ($Apply) {
        Backup-File -Path $Path -BackupRoot $BackupRoot
        Set-Utf8NoBomText -Path $Path -Content $Content
        Write-Change "Wrote file: $Path"
    }
    else {
        Write-Info "Would write/update file: $Path"
    }
}

function Replace-TextInFile {
    param(
        [string]$Path,
        [string]$Search,
        [string]$Replace,
        [string]$BackupRoot
    )

    if (-not $Path -or -not (Test-Path $Path)) {
        return
    }

    $content = Get-Utf8Text -Path $Path

    if (-not $content.Contains($Search)) {
        return
    }

    $newContent = $content.Replace($Search, $Replace)

    if ($Apply) {
        Backup-File -Path $Path -BackupRoot $BackupRoot
        Set-Utf8NoBomText -Path $Path -Content $newContent
        Write-Change "Updated text in: $Path"
    }
    else {
        Write-Info "Would update text in: $Path"
        Write-Info "Search : $Search"
        Write-Info "Replace: $Replace"
    }
}

function Replace-RegexInFile {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Replacement,
        [string]$BackupRoot,
        [string]$Description
    )

    if (-not $Path -or -not (Test-Path $Path)) {
        return
    }

    $content = Get-Utf8Text -Path $Path

    if ($content -notmatch $Pattern) {
        return
    }

    $newContent = [System.Text.RegularExpressions.Regex]::Replace(
        $content,
        $Pattern,
        $Replacement,
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )

    if ($newContent -eq $content) {
        return
    }

    if ($Apply) {
        Backup-File -Path $Path -BackupRoot $BackupRoot
        Set-Utf8NoBomText -Path $Path -Content $newContent
        Write-Change "Updated $Description in: $Path"
    }
    else {
        Write-Info "Would update $Description in: $Path"
    }
}

function Insert-Or-Replace-CanonicalNote {
    param(
        [string]$Path,
        [string]$NoteTitle,
        [string]$NoteContent,
        [string]$BackupRoot
    )

    if (-not $Path -or -not (Test-Path $Path)) {
        return
    }

    $content = Get-Utf8Text -Path $Path

    $startMarker = "<!-- portfolio-source-truth:start -->"
    $endMarker = "<!-- portfolio-source-truth:end -->"

    $block = @"
$startMarker

## $NoteTitle

$NoteContent

$endMarker

"@

    if ($content.Contains($startMarker) -and $content.Contains($endMarker)) {
        $pattern = "(?s)<!-- portfolio-source-truth:start -->.*?<!-- portfolio-source-truth:end -->\s*"
        $newContent = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $block)
    }
    else {
        $lines = $content -split "`r?`n", 2
        if ($lines.Count -eq 2 -and $lines[0].StartsWith("#")) {
            $newContent = $lines[0] + [Environment]::NewLine + [Environment]::NewLine + $block + $lines[1]
        }
        else {
            $newContent = $block + $content
        }
    }

    if ($newContent -eq $content) {
        Write-Ok "Canonical note already current: $Path"
        return
    }

    if ($Apply) {
        Backup-File -Path $Path -BackupRoot $BackupRoot
        Set-Utf8NoBomText -Path $Path -Content $newContent
        Write-Change "Inserted/updated canonical note in: $Path"
    }
    else {
        Write-Info "Would insert/update canonical note in: $Path"
    }
}

Assert-RepoRoot

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = ".migration-backups/cycle0-source-truth-$timestamp"
$reportRoot = "docs/portfolio-migration-reports"

Write-Step "Cycle 0 source-truth cleanup"
Write-Info "Apply mode: $Apply"
Write-Info "Backup root: $backupRoot"

Ensure-Directory "scripts/portfolio"
Ensure-Directory $reportRoot

$release2PhaseGuide = Resolve-ExistingFileByLeaf `
    -CandidatePaths @("docs/release2/Phases-with-steps.md", "Phases-with-steps.md") `
    -LeafName "Phases-with-steps.md"

$release2Readme = Resolve-ExistingFileByLeaf `
    -CandidatePaths @("docs/release2/README.md", "release2/README.md") `
    -LeafName "README.md"

$implementationTracker = Resolve-ExistingFileByLeaf `
    -CandidatePaths @("docs/release2/implementation-tracker.md", "implementation-tracker.md") `
    -LeafName "implementation-tracker.md"

$buildChecklist = Resolve-ExistingFileByLeaf `
    -CandidatePaths @("docs/release2/build_checklist.md", "build_checklist.md") `
    -LeafName "build_checklist.md"

$namingConventions = Resolve-ExistingFileByLeaf `
    -CandidatePaths @("docs/release2/naming-conventions.md", "naming-conventions.md") `
    -LeafName "naming-conventions.md"

$architectureAdr = Resolve-ExistingFileByLeaf `
    -CandidatePaths @("docs/release2/architechture.md", "architechture.md") `
    -LeafName "architechture.md"

Write-Step "Resolved files"
Write-Info "Phase guide          : $release2PhaseGuide"
Write-Info "Release 2 README     : $release2Readme"
Write-Info "Implementation track : $implementationTracker"
Write-Info "Build checklist      : $buildChecklist"
Write-Info "Naming conventions   : $namingConventions"
Write-Info "ADR / architecture   : $architectureAdr"

$statusMd = @'
# Project Status

## Portfolio Identity

This repository is one flagship enterprise platform portfolio, structured as three staged releases.

The project presents a staged enterprise platform journey from hybrid Microsoft operations into Azure platform engineering, multi-cloud security, automation, private platform operations, AI-assisted CloudOps, and future multi-cloud Kubernetes delivery.

## Release Status

| Release | Theme | Status |
|---|---|---|
| Release 1 | Hybrid Microsoft Foundation | Complete and evidenced |
| Release 2 | Azure Platform Engineering, Security, Automation, Private Platform, and AI Operations | Implemented; documentation reorganization and O6 closeout in progress |
| Release 3 | Multi-Cloud Kubernetes, GitOps, and DevSecOps | Roadmap |

## Canonical Decisions

- This is one flagship platform repository, not multiple disconnected projects.
- Keep release1, release2, and release3 naming.
- Use the six portfolio capability tracks.
- Final branch namespace is br1.azawslab.co.uk.
- A2 AWX automation control plane is complete and evidenced.
- O4 Private AKS is complete.
- O5 AVD + FSLogix is complete.
- O6 is the remaining Release 2 closeout / AI Operations Enclave work.
- Release 3 direction includes AKS, EKS, Argo CD, DevSecOps controls, image scanning, policy gates, protected ingress, observability, and resilience.

## Six Portfolio Capability Tracks

| Track | Name | Release | What it proves |
|---|---|---|---|
| 1 | Modern Workplace and Hybrid Identity | Release 1 | Entra ID, Active Directory, Microsoft 365, Intune, Autopilot, Purview, endpoint security, recovery |
| 2 | Azure Landing Zone, IaC and Governance | Release 2 | Terraform, GitHub Actions OIDC, remote state, Azure Policy, RBAC, naming, controlled delivery |
| 3 | Secure Hybrid and Multi-Cloud Networking | Release 2 | Azure and AWS connectivity, hub-spoke, FortiGate, VyOS, Cisco, IPSec, BGP, transit routing |
| 4 | Automation, SecOps and Resilience | Release 2 | Ansible, AWX, runtime secrets, monitoring, backup, validation, operational runbooks |
| 5 | Private Platform, Secure Workspace and AI Operations | Release 2 | Private AKS, AVD, FSLogix, O6 AI Operations Enclave, RAG/MCP/tool boundary |
| 6 | Multi-Cloud Kubernetes, GitOps and DevSecOps | Release 3 | AKS, EKS, Argo CD, image scanning, policy gates, secure ingress, observability, resilience |

## Documentation Migration Rules

- Use STATUS.md as the source-truth lock during portfolio migration.
- Do not let stale Release 2 status text override this file.
- Do not use mojibake/corrupted Markdown as final prose.
- Use corrupted files only for facts until encoding cleanup is complete.
- Public-facing documentation should use confident, evidence-led language.
- Missing evidence links should be marked as placeholders until final proof paths are added.
'@

Write-Step "Creating STATUS.md"
Write-FileIfChanged -Path "STATUS.md" -Content $statusMd -BackupRoot $backupRoot

$canonicalNote = @'
This note is the source-truth lock for portfolio migration.

- Final branch namespace is br1.azawslab.co.uk.
- A2 AWX automation control plane is complete and evidenced.
- O4 Private AKS is complete.
- O5 AVD + FSLogix is complete.
- O6 is the remaining Release 2 closeout / AI Operations Enclave work.
- Release 3 direction is AKS + EKS + Argo CD + DevSecOps.
- If older sections conflict with this note, use STATUS.md and update the stale section during the migration.
- Files with mojibake/encoding artifacts should not be used as final public prose until cleaned.
'@

Write-Step "Inserting canonical status note into active Release 2 docs"
Insert-Or-Replace-CanonicalNote -Path $release2PhaseGuide -NoteTitle "Portfolio Migration Source-Truth Note" -NoteContent $canonicalNote -BackupRoot $backupRoot
Insert-Or-Replace-CanonicalNote -Path $release2Readme -NoteTitle "Portfolio Migration Source-Truth Note" -NoteContent $canonicalNote -BackupRoot $backupRoot
Insert-Or-Replace-CanonicalNote -Path $implementationTracker -NoteTitle "Portfolio Migration Source-Truth Note" -NoteContent $canonicalNote -BackupRoot $backupRoot
Insert-Or-Replace-CanonicalNote -Path $buildChecklist -NoteTitle "Portfolio Migration Source-Truth Note" -NoteContent $canonicalNote -BackupRoot $backupRoot
Insert-Or-Replace-CanonicalNote -Path $namingConventions -NoteTitle "Portfolio Migration Source-Truth Note" -NoteContent $canonicalNote -BackupRoot $backupRoot

Write-Step "Fixing br -> br1 in active Release 2 documentation"

$activeDocs = @(
    $release2PhaseGuide,
    $release2Readme,
    $implementationTracker,
    $buildChecklist,
    $namingConventions,
    $architectureAdr
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique

foreach ($file in $activeDocs) {
    Replace-TextInFile -Path $file -Search "br.azawslab.co.uk" -Replace "br1.azawslab.co.uk" -BackupRoot $backupRoot
}

Write-Step "Updating old Release 2 README A1-only status text"

$oldA1Pattern = '> Current implemented milestone:\s*\*\*A1 Ansible Network/Security Automation Baseline completed\*\*, with FortiGate, VyOS, and Cisco read-only validation, sanitized backup evidence, runtime secrets from Azure Key Vault and AWS SSM, and post-merge Terraform no-drift checks completed\.'

$newStatus = '> Current implemented milestone: **A2 AWX Automation Control Plane, O4 Private AKS, and O5 AVD + FSLogix secure workspace are complete and evidenced**. O6 remains the active Release 2 closeout area for the AI Operations Enclave and documentation migration.'

Replace-RegexInFile `
    -Path $release2Readme `
    -Pattern $oldA1Pattern `
    -Replacement $newStatus `
    -BackupRoot $backupRoot `
    -Description "Release 2 README milestone status"

Replace-TextInFile `
    -Path $release2Readme `
    -Search "> Status: **In progress** - see [implementation tracker](./implementation-tracker.md)" `
    -Replace "> Status: **Implemented / final documentation and O6 closeout in progress** - see [implementation tracker](./implementation-tracker.md)" `
    -BackupRoot $backupRoot

Replace-TextInFile `
    -Path $release2Readme `
    -Search "> Status: **In progress** Ã¢â‚¬â€œ see [implementation tracker](./implementation-tracker.md)" `
    -Replace "> Status: **Implemented / final documentation and O6 closeout in progress** - see [implementation tracker](./implementation-tracker.md)" `
    -BackupRoot $backupRoot

Write-Step "Creating remaining namespace drift report"

$driftReportPath = Join-Path $reportRoot "cycle0-remaining-namespace-drift.md"
$driftLines = New-Object System.Collections.Generic.List[string]
$driftLines.Add("# Cycle 0 Remaining Namespace Drift")
$driftLines.Add("")
$driftLines.Add("Final active namespace: br1.azawslab.co.uk")
$driftLines.Add("")
$driftLines.Add("Remaining br.azawslab.co.uk references below require manual review.")
$driftLines.Add("")
$driftLines.Add("| File | Line | Text |")
$driftLines.Add("|---|---:|---|")

$mdFiles = Get-ChildItem -Path . -Recurse -File -Include *.md |
    Where-Object {
        $_.FullName -notmatch "[\\/]\.git[\\/]" -and
        $_.FullName -notmatch "[\\/]\.migration-backups[\\/]" -and
        $_.FullName -notmatch "[\\/]node_modules[\\/]"
    }

foreach ($file in $mdFiles) {
    $relative = Resolve-Path -Relative $file.FullName
    $lines = [System.IO.File]::ReadAllLines($file.FullName, [System.Text.Encoding]::UTF8)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -like "*br.azawslab.co.uk*") {
            $safeText = $lines[$i].Trim().Replace("|", "\|")
            $driftLines.Add("| `$relative` | $($i + 1) | $safeText |")
        }
    }
}

$driftReport = ($driftLines -join [Environment]::NewLine) + [Environment]::NewLine
Write-FileIfChanged -Path $driftReportPath -Content $driftReport -BackupRoot $backupRoot

Write-Step "Creating mojibake/encoding artifact report"

$encodingReportPath = Join-Path $reportRoot "cycle0-encoding-artifact-report.md"
$badPatterns = @(
    "Ãƒ",
    "Ã‚",
    "Ã¢â‚¬",
    "ÃƒÆ’",
    "Ãƒâ€š",
    "ÃƒÂ¢",
    "Ãƒâ€¦",
    "Ãƒâ€ ",
    "Ã‚Â¢",
    "Ã‚Â¬"
)

$encodingLines = New-Object System.Collections.Generic.List[string]
$encodingLines.Add("# Cycle 0 Encoding Artifact Report")
$encodingLines.Add("")
$encodingLines.Add("This report identifies likely mojibake/encoding artifacts.")
$encodingLines.Add("")
$encodingLines.Add("Cycle 0 does not mass-repair corrupted text because automatic repair can damage technical documentation.")
$encodingLines.Add("")
$encodingLines.Add("Use affected files for factual reference only until cleaned.")
$encodingLines.Add("")
$encodingLines.Add("| File | Line | Artifact | Text |")
$encodingLines.Add("|---|---:|---|---|")

foreach ($file in $mdFiles) {
    $relative = Resolve-Path -Relative $file.FullName
    $lines = [System.IO.File]::ReadAllLines($file.FullName, [System.Text.Encoding]::UTF8)

    for ($i = 0; $i -lt $lines.Count; $i++) {
        foreach ($pattern in $badPatterns) {
            if ($lines[$i].Contains($pattern)) {
                $safeText = $lines[$i].Trim().Replace("|", "\|")
                $safePattern = $pattern.Replace("|", "\|")
                $encodingLines.Add("| `$relative` | $($i + 1) | `$safePattern` | $safeText |")
                break
            }
        }
    }
}

$encodingReport = ($encodingLines -join [Environment]::NewLine) + [Environment]::NewLine
Write-FileIfChanged -Path $encodingReportPath -Content $encodingReport -BackupRoot $backupRoot

Write-Step "Creating Copilot ingestion warning file"

$ingestionWarningPath = Join-Path $reportRoot "cycle0-copilot-ingestion-warning.md"
$ingestionWarning = @'
# Cycle 0 Copilot Ingestion Warning

Before using VS Code Copilot, local DeepSeek, gpt-oss, or any RAG pipeline for final portfolio prose, follow this rule:

Use these files as canonical truth:
- STATUS.md
- ADR / architecture decision notes
- A2 closure evidence
- O4 evidence
- O5 evidence
- verified evidence folders

Use these files carefully until cleaned:
- any file listed in `cycle0-encoding-artifact-report.md`

Reason:
Some Release 2 Markdown files contain mojibake/encoding artifacts. These files can still contain valid technical facts, but they should not be used as final public-facing prose until cleaned.

Mandatory instruction for Copilot prompts:
"Read STATUS.md first. If older docs conflict with STATUS.md, treat STATUS.md as authoritative."
'@

Write-FileIfChanged -Path $ingestionWarningPath -Content $ingestionWarning -BackupRoot $backupRoot

Write-Step "Git status"
git status --short

if (-not $Apply) {
    Write-Host ""
    Write-Host "DRY RUN COMPLETE" -ForegroundColor Yellow
    Write-Host "Run this to apply changes:" -ForegroundColor Yellow
    Write-Host "pwsh .\scripts\portfolio\fix-cycle0-source-truth.ps1 -Apply" -ForegroundColor Yellow
}
else {
    Write-Host ""
    Write-Host "APPLY COMPLETE" -ForegroundColor Green
    Write-Host "Review changes before commit:" -ForegroundColor Green
    Write-Host "git diff -- STATUS.md docs/release2 docs/portfolio-migration-reports" -ForegroundColor Green
}

