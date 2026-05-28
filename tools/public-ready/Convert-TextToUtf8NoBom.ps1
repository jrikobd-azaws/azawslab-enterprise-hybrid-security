param(
    [string]$Root = '.'
)

try {
    [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance)
} catch {
}

$Utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$Windows1252 = [System.Text.Encoding]::GetEncoding(1252)

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

$Changed = New-Object System.Collections.Generic.List[object]

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
        $Text = $Utf8Strict.GetString($Bytes)
        $SourceEncoding = 'utf-8'
    } catch {
        $Text = $Windows1252.GetString($Bytes)
        $SourceEncoding = 'windows-1252'
    }

    $Text = $Text -replace "`r`n", "`n"
    $Text = $Text -replace "`r", "`n"

    [System.IO.File]::WriteAllText($File.FullName, $Text, $Utf8NoBom)

    $Changed.Add([pscustomobject]@{
        Path = $File.FullName
        SourceEncoding = $SourceEncoding
        OutputEncoding = 'utf-8-no-bom'
    }) | Out-Null
}

$Changed | Sort-Object Path | Format-Table -AutoSize