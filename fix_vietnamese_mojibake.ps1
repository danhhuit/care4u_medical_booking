chcp 65001 | Out-Null

$enc1252 = [System.Text.Encoding]::GetEncoding(1252)
$utf8 = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$pattern = 'Ã|Ä|Æ|Å|áº|á»|Â'

function Count-BadText([string]$s) {
    return ([regex]::Matches($s, $pattern)).Count
}

function Fix-Line([string]$line) {
    if ($line -notmatch $pattern) {
        return $line
    }

    try {
        $before = Count-BadText $line
        $bytes = $enc1252.GetBytes($line)
        $fixed = $utf8.GetString($bytes)
        $after = Count-BadText $fixed

        if ($after -lt $before -and $fixed -notmatch '�') {
            return $fixed
        }

        return $line
    } catch {
        return $line
    }
}

$files = Get-ChildItem ".\lib" -Recurse -Include *.dart,*.arb,*.json

foreach ($file in $files) {
    $text = [System.IO.File]::ReadAllText($file.FullName, $utf8)

    if ($text -match $pattern) {
        $lines = $text -split "`r?`n"
        $fixedLines = foreach ($line in $lines) {
            Fix-Line $line
        }

        $fixedText = $fixedLines -join "`r`n"
        [System.IO.File]::WriteAllText($file.FullName, $fixedText, $utf8NoBom)

        Write-Host "Fixed:" $file.FullName
    }
}

Write-Host "DONE"
