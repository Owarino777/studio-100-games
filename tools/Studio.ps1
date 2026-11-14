param(
    [ValidateSet('Doctor', 'Import', 'Test', 'Run', 'ExportAndroid')]
    [string]$Action = 'Doctor',
    [ValidateSet('apk', 'aab')][string]$Format = 'apk',
    [string]$AndroidSdkPath,
    [string]$JavaSdkPath,
    [switch]$ForceTestFailure
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Studio.Common.ps1')
$paths = Get-StudioPaths -AndroidSdkPath $AndroidSdkPath -JavaSdkPath $JavaSdkPath
$logDir = Join-Path $paths.Project 'artifacts\logs'

try {
    Assert-StudioGodot $paths
    if ($Action -eq 'Doctor') {
        $missingTemplates = @(@('android_debug.apk', 'android_release.apk', 'android_source.zip', 'ios.zip', 'version.txt') | Where-Object { -not (Test-Path -LiteralPath (Join-Path $paths.Templates $_) -PathType Leaf) })
        $checks = [ordered]@{
            GodotStandard472 = $true
            AndroidTemplate = $missingTemplates.Count -eq 0
            AndroidPlatform35 = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'platforms\android-35\android.jar')
            AndroidPlatform36 = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'platforms\android-36\android.jar')
            AndroidBuildTools3501 = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'build-tools\35.0.1\aapt2.exe')
            AndroidBuildTools3610 = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'build-tools\36.1.0\aapt2.exe')
            AndroidPlatformTools = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'platform-tools\adb.exe')
            AndroidNdk281 = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'ndk\28.1.13356709\source.properties')
            AndroidCmake3102 = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'cmake\3.10.2.4988404\bin\cmake.exe')
            AndroidEmulator = Test-Path -LiteralPath (Join-Path $paths.AndroidSdk 'emulator\emulator.exe')
            JavaCompiler = [bool]($paths.JavaSdk -and (Test-Path -LiteralPath (Join-Path $paths.JavaSdk 'bin\javac.exe')))
            Project = Test-Path -LiteralPath (Join-Path $paths.Project 'project.godot')
        }
        $checks | ConvertTo-Json
        if (@($checks.Values | Where-Object { $_ -eq $false }).Count) { exit 1 }
        exit 0
    }
    if (-not (Test-Path -LiteralPath (Join-Path $paths.Project 'project.godot'))) { throw 'The game project is missing.' }
    if ($Action -eq 'Run') {
        $result = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--path', $paths.Project) -LogPath (Join-Path $logDir 'run.log') -TimeoutSeconds 86400
        exit $result.ExitCode
    }
    $import = Invoke-StudioProcess -FilePath $paths.Godot -Arguments @('--headless', '--path', $paths.Project, '--import') -LogPath (Join-Path $logDir 'import.log')
    if ($import.Output -match '(?m)SCRIPT ERROR:|^ERROR:') { throw 'Godot import logged an error.' }
    if ($Action -eq 'Import') { exit 0 }
    if ($Action -eq 'Test') {
        $arguments = @('--headless', '--path', $paths.Project, '--script', 'res://tests/test_runner.gd')
        if ($ForceTestFailure) { $arguments += @('--', '--force-failure') }
        $testLog = if ($ForceTestFailure) { 'tests-failure-control.log' } else { 'tests.log' }
        $result = Invoke-StudioProcess -FilePath $paths.Godot -Arguments $arguments -LogPath (Join-Path $logDir $testLog) -AllowFailure
        if ($result.ExitCode -ne 0) { exit $result.ExitCode }
        if ($result.Output -match '(?m)SCRIPT ERROR:|^ERROR:') { throw 'The test runner logged an error despite exit code zero.' }
        exit 0
    }
    Set-StudioAndroidSettings $paths
    Set-StudioGradleSettings $paths
    $exportArguments = @('--headless', '--path', $paths.Project)
    if ($Format -eq 'aab') {
        $wrapper = Join-Path $paths.Project 'android\build\gradlew.bat'
        if (-not (Test-Path -LiteralPath $wrapper -PathType Leaf)) {
            $exportArguments += '--install-android-build-template'
        }
    }
    $preset = if ($Format -eq 'apk') { 'Android APK' } else { 'Android AAB' }
    $outputDir = Join-Path $paths.Project 'build\android'
    [void][System.IO.Directory]::CreateDirectory($outputDir)
    $outputFile = Join-Path $outputDir ('switchworks-verification-debug.' + $Format)
    $exportArguments += @('--export-debug', $preset, $outputFile)
    $result = Invoke-StudioProcess -FilePath $paths.Godot -Arguments $exportArguments -LogPath (Join-Path $logDir ('export-' + $Format + '.log')) -TimeoutSeconds 1200
    if ($result.Output -match '(?m)SCRIPT ERROR:|^ERROR:' -or -not (Test-Path -LiteralPath $outputFile -PathType Leaf)) { throw 'Android export did not produce a clean artifact.' }
    if ($Format -eq 'aab' -and -not (Test-Path -LiteralPath $wrapper -PathType Leaf)) { throw 'The Android Gradle wrapper is missing after export.' }
    Write-Host "Debug verification artifact: $outputFile"
    exit 0
}
catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
