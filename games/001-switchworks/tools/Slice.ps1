param(
    [ValidateSet('Run', 'Test', 'Capture', 'ExportAndroid')][string]$Action = 'Run',
    [ValidateSet('planning', 'failed', 'won', 'paused', 'hint')][string]$Scenario = 'planning',
    [ValidatePattern('^\d{2,4}x\d{2,4}$')][string]$Resolution = '390x844'
)

$ErrorActionPreference = 'Stop'
$gameRoot = Split-Path -Parent $PSScriptRoot
$studioDirectory = Split-Path -Parent (Split-Path -Parent $gameRoot)
. (Join-Path $studioDirectory 'tools\Studio.Common.ps1')
$paths = Get-StudioPaths
$logs = Join-Path $gameRoot 'artifacts\slice-tests'
$captures = Join-Path $gameRoot 'artifacts\slice-captures'
try {
    Assert-StudioGodot $paths
    $import = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $gameRoot, '--import') -LogPath (Join-Path $logs 'slice-import.log')
    if ($import.Output -match '(?m)SCRIPT ERROR:|^ERROR:') { throw 'Slice import reported an error.' }
    if ($Action -eq 'Test') {
        foreach ($runner in @('test_runner.gd', 'slice_gameplay_runner.gd', 'slice_ui_runner.gd')) {
            $result = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $gameRoot, '--script', ('res://tests/' + $runner)) -LogPath (Join-Path $logs ($runner + '.log'))
            if ($result.Output -match '(?m)SCRIPT ERROR:|^ERROR:') { throw "Runner reported an error: $runner" }
        }
    }
    elseif ($Action -eq 'ExportAndroid') {
        Set-StudioAndroidSettings $paths
        Set-StudioGradleSettings $paths
        $output = Join-Path $gameRoot 'build\android\switchworks-archipel-slice-debug.apk'
        [void][System.IO.Directory]::CreateDirectory((Split-Path -Parent $output))
        $result = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $gameRoot, '--export-debug', 'Android Archipel Slice', $output) -LogPath (Join-Path $logs 'export-slice.log') -TimeoutSeconds 600
        if ($result.Output -match '(?m)SCRIPT ERROR:|^ERROR:' -or -not (Test-Path -LiteralPath $output)) { throw 'Slice APK export failed validation.' }
        Write-Host "Experimental debug APK: $output"
    }
    else {
        $arguments = @('--path', $gameRoot, '--resolution', $Resolution, 'res://scenes/archipel_postal.tscn')
        if ($Action -eq 'Capture') {
            [void][System.IO.Directory]::CreateDirectory($captures)
            $output = Join-Path $captures ('desktop-' + $Resolution + '-' + $Scenario + '.png')
            $arguments += @('--', ('--slice-shot=' + $output), ('--slice-scenario=' + $Scenario))
        }
        $runtimeLog = if ($Action -eq 'Capture') { 'capture-' + $Resolution + '-' + $Scenario + '.log' } else { 'run.log' }
        $result = Invoke-StudioProcess -FilePath $paths.Godot -Arguments $arguments -LogPath (Join-Path $logs $runtimeLog) -TimeoutSeconds $(if ($Action -eq 'Run') { 86400 } else { 90 })
        if ($result.Output -match '(?m)SCRIPT ERROR:|^ERROR:') { throw 'Slice runtime reported an error.' }
    }
    exit 0
}
catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
