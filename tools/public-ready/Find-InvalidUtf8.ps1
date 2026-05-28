param(
    [string]$Root = '.'
)

$Utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)

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

$Invalid = New-Object System.Collections.Generic.List[object]

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

    $Bytes = [System.IO.File]::ReadAllBytes($File.FullName)

    try {
        $null = $Utf8Strict.GetString($Bytes)
    } catch {
        $Invalid.Add([pscustomobject]@{
            Path = $File.FullName
            Issue = 'Invalid UTF-8 bytes'
        }) | Out-Null
    }
}

$Invalid | Sort-Object Path | Format-Table -AutoSize

if ($Invalid.Count -gt 0) {
    exit 1
}