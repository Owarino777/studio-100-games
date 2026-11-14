param(
    [ValidateSet('Export', 'PackSmoke', 'All')][string]$Action = 'All',
    [switch]$DebugBuild
)

$ErrorActionPreference = 'Stop'
$gameRoot = Split-Path -Parent $PSScriptRoot
$studioDirectory = Split-Path -Parent (Split-Path -Parent $gameRoot)
. (Join-Path $studioDirectory 'tools\Studio.Common.ps1')
$paths = Get-StudioPaths
$logs = Join-Path $gameRoot 'artifacts\web-test\export'
$outputRoot = Join-Path $gameRoot 'build\web-safari'

function Assert-WebProcess {
    param($Result, [string]$Label)
    if ($Result.Output -match '(?m)SCRIPT ERROR:|^ERROR:') { throw "$Label reported an engine error." }
}

try {
    Assert-StudioGodot $paths
    foreach ($template in @('web_nothreads_release.zip', 'web_nothreads_debug.zip')) {
        if (-not (Test-Path -LiteralPath (Join-Path $paths.Templates $template) -PathType Leaf)) {
            throw "Matching local Web template is missing: $template. No automatic download is performed."
        }
    }
    [void][System.IO.Directory]::CreateDirectory($outputRoot)
    [System.IO.File]::WriteAllText((Join-Path $outputRoot '.gdignore'), '', (New-Object System.Text.UTF8Encoding($false)))
    $import = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $gameRoot, '--import') -LogPath (Join-Path $logs 'import.log')
    Assert-WebProcess $import 'Import'
    if ($Action -in @('Export', 'All')) {
        $html = Join-Path $outputRoot 'index.html'
        $exportMode = if ($DebugBuild) { '--export-debug' } else { '--export-release' }
        $export = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $gameRoot, $exportMode, 'Web Safari Test', $html) -LogPath (Join-Path $logs 'web-export.log') -TimeoutSeconds 600
        Assert-WebProcess $export 'Web export'
        foreach ($name in @('index.html', 'index.js', 'index.wasm', 'index.pck')) {
            if (-not (Test-Path -LiteralPath (Join-Path $outputRoot $name) -PathType Leaf)) { throw "Missing Web output: $name" }
        }
        $page = [System.IO.File]::ReadAllText($html)
        if ($page -notmatch 'GODOT_THREADS_ENABLED\s*=\s*false') { throw 'Generated HTML does not confirm the single-threaded template.' }
        $records = @(Get-ChildItem -LiteralPath $outputRoot -File | Where-Object { $_.Extension -ne '.import' -and $_.Name -ne '.gdignore' } | Sort-Object Name | ForEach-Object {
            [PSCustomObject]@{ File = $_.Name; Bytes = $_.Length; SHA256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant() }
        })
        [void][System.IO.Directory]::CreateDirectory($logs)
        [System.IO.File]::WriteAllText((Join-Path $logs 'web-files.json'), ($records | ConvertTo-Json -Depth 4) + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host "Local Web build: $outputRoot"
    }
    if ($Action -in @('PackSmoke', 'All')) {
        $pack = Join-Path $outputRoot 'index.pck'
        if ($Action -eq 'PackSmoke') {
            $smokeRoot = Join-Path $gameRoot 'build\web-safari-smoke'
            [void][System.IO.Directory]::CreateDirectory($smokeRoot)
            [System.IO.File]::WriteAllText((Join-Path $smokeRoot '.gdignore'), '', (New-Object System.Text.UTF8Encoding($false)))
            $pack = Join-Path $smokeRoot 'smoke.pck'
            $exportPack = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $gameRoot, '--export-pack', 'Web Safari Test', $pack) -LogPath (Join-Path $logs 'pack-export.log') -TimeoutSeconds 300
            Assert-WebProcess $exportPack 'Pack export'
        }
        $smoke = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--main-pack', $pack, '--quit-after', '120') -LogPath (Join-Path $logs 'pack-smoke.log') -TimeoutSeconds 60
        Assert-WebProcess $smoke 'Packed scene smoke'
        if ($smoke.Output -notmatch 'SLICE_READY') { throw 'Packed data did not start Archipel Postal.' }
    }
    exit 0
}
catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
