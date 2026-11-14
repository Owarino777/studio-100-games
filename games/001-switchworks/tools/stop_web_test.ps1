param([switch]$IncludeLoopbackPreview)

$ErrorActionPreference = 'Stop'
$gameDirectory = Split-Path -Parent $PSScriptRoot
$studioDirectory = Split-Path -Parent (Split-Path -Parent $gameDirectory)
$entries = @(
    @{ File = 'tools/.local/cloudflared/session-web-108e/owned.pid'; Name = 'cloudflared.exe'; Marker = '*tunnel*--url*127.0.0.1:8766*' },
    @{ File = 'games/001-switchworks/artifacts/web-test/server-tls-8766.pid'; Name = 'python.exe'; Marker = '*games/001-switchworks/tools/serve_web_test.py*--port 8766*' }
)
if ($IncludeLoopbackPreview) {
    $entries += @{ File = 'games/001-switchworks/artifacts/web-test/server-final-8765.pid'; Name = 'python.exe'; Marker = '*games/001-switchworks/tools/serve_web_test.py*--port 8765*' }
}
foreach ($entry in $entries) {
    $file = Join-Path $studioDirectory $entry.File
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { continue }
    $ownedPid = [int]([System.IO.File]::ReadAllText($file).Trim())
    $owned = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $ownedPid)
    if (-not $owned) { continue }
    if ($owned.Name -ne $entry.Name -or $owned.CommandLine -notlike $entry.Marker) {
        throw "PID no longer belongs to this test; refusing to stop: $ownedPid"
    }
    $executable = [System.IO.Path]::GetFullPath($owned.ExecutablePath)
    $expected = if ($entry.Name -eq 'cloudflared.exe') { Join-Path $studioDirectory 'tools/.local/cloudflared/2026.11.0/cloudflared.exe' } else { (Get-Command python.exe).Source }
    if ($executable -ne [System.IO.Path]::GetFullPath($expected)) {
        throw "Executable differs from the owned helper; refusing to stop: $ownedPid"
    }
    & (Join-Path $env:SystemRoot 'System32/taskkill.exe') /PID $ownedPid /F
    if ($LASTEXITCODE -ne 0) { throw "Could not stop owned process $ownedPid" }
}
