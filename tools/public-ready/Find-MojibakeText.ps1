param(
    [string]$Root = '.',
    [string]$OutFile = '.tmp-public-audit\mojibake-findings.txt'
)

$TextExtensions = @(
    '.md',
    '.txt',
    '.json',
    '.yml',
    '.yaml',
    '.tf',
    '.tfvars',
    '.ps1',
    '.sh',
    '.py',
    '.gitignore',
    '.gitattributes',
    '.editorconfig'
)

$SkipPatterns = @(
    '\.git',
    '\.terraform',
    'node_modules',
    '\.venv',
    'venv',
    '\.tmp',
    '\.tmp-public-audit'
)

$SuspiciousChars = @(
    [char]0x00C2,
    [char]0x00C3,
    [char]0x00E2,
    [char]0xFFFD
)

$Findings = New-Object System.Collections.Generic.List[string]

Get-ChildItem -Path $Root -Recurse -File | ForEach-Object {
    $File = $_

    foreach ($Pattern in $SkipPatterns) {
        if ($File.FullName -match $Pattern) {
            return
        }
    }

    if ($TextExtensions -notcontains $File.Extension -and $TextExtensions -notcontains $File.Name) {
        return
    }

    $Lines = Get-Content $File.FullName -Encoding UTF8
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $Line = $Lines[$i]
        foreach ($Char in $SuspiciousChars) {
            if ($Line.IndexOf($Char) -ge 0) {
                $RelativePath = Resolve-Path -Path $File.FullName -Relative
                $Findings.Add($RelativePath + ':' + ($i + 1) + ': ' + $Line) | Out-Null
                break
            }
        }
    }
}

$OutDir = Split-Path $OutFile -Parent
if ($OutDir) {
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
}

$Findings | Set-Content -Path $OutFile -Encoding UTF8

$Findings