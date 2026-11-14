param(
    [ValidateSet('Start', 'Stop', 'Status')][string]$Action = 'Start',
    [string]$AndroidSdkPath,
    [string]$JavaSdkPath,
    [ValidateSet('host', 'swiftshader', 'swangle')][string]$Gpu = 'host',
    [ValidateRange(30, 600)][int]$BootTimeoutSeconds = 240
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Studio.Common.ps1')
$paths = Get-StudioPaths -AndroidSdkPath $AndroidSdkPath -JavaSdkPath $JavaSdkPath
$avdName = 'Studio_API_36'
$adbPort = 5041
$consolePort = 5580
$serial = 'emulator-' + $consolePort
$androidRoot = Join-Path $paths.LocalRoot 'android'
$avdHome = Join-Path $androidRoot 'avd'
$avdPath = Join-Path $avdHome ($avdName + '.avd')
$userHome = Join-Path $androidRoot 'user'
$logRoot = Join-Path $paths.Project 'artifacts\emulator'
$adb = Join-Path $paths.AndroidSdk 'platform-tools\adb.exe'
$emulator = Join-Path $paths.AndroidSdk 'emulator\emulator.exe'
$cliRoot = Join-Path $paths.AndroidSdk 'cmdline-tools\latest'
$systemImage = 'system-images;android-36;google_apis_playstore;x86_64'
$imageFile = Join-Path $paths.AndroidSdk 'system-images\android-36\google_apis_playstore\x86_64\system.img'
$environment = @{
    ANDROID_HOME = $paths.AndroidSdk
    ANDROID_SDK_ROOT = $paths.AndroidSdk
    ANDROID_USER_HOME = $userHome
    ANDROID_EMULATOR_HOME = $userHome
    ANDROID_AVD_HOME = $avdHome
    ANDROID_ADB_SERVER_PORT = [string]$adbPort
    ADB_SERVER_SOCKET = 'tcp:127.0.0.1:' + $adbPort
}

function Invoke-StudioAdb {
    param([string[]]$AdbArguments, [switch]$AllowFailure)
    Invoke-StudioProcess -FilePath $adb -Arguments (@('-P', [string]$adbPort) + $AdbArguments) -Environment $environment -TimeoutSeconds 30 -AllowFailure:$AllowFailure
}

function Test-StudioDevice {
    $state = Invoke-StudioAdb -AdbArguments @('-s', $serial, 'get-state') -AllowFailure 6>$null
    if ($state.ExitCode -ne 0 -or $state.Output.Trim() -ne 'device') { return $false }
    $identity = Invoke-StudioAdb -AdbArguments @('-s', $serial, 'emu', 'avd', 'name') 6>$null
    $actualName = ($identity.Output -split '\r?\n')[0].Trim()
    if (-not $actualName) { throw 'The device console identity could not be read. No emulator will be stopped or replaced.' }
    if ($actualName -ne $avdName) {
        throw "Port $consolePort belongs to another AVD. It will not be modified."
    }
    return $true
}

try {
    foreach ($required in @($adb, $emulator)) {
        if (-not (Test-Path -LiteralPath $required -PathType Leaf)) { throw "Missing Android tool: $required" }
    }
    foreach ($directory in @($avdHome, $userHome, $logRoot)) { [void][System.IO.Directory]::CreateDirectory($directory) }
    $locator = Join-Path $avdHome ($avdName + '.ini')
    if (Test-Path -LiteralPath $locator -PathType Leaf) {
        $locatorText = [System.IO.File]::ReadAllText($locator)
        $locatorMatch = [regex]::Match($locatorText, '(?m)^path=(.+)$')
        if (-not $locatorMatch.Success -or -not [string]::Equals([System.IO.Path]::GetFullPath($locatorMatch.Groups[1].Value.Trim()), [System.IO.Path]::GetFullPath($avdPath), [System.StringComparison]::OrdinalIgnoreCase)) {
            throw 'The studio AVD locator points outside its expected directory. It will not be used.'
        }
    }

    if ($Action -eq 'Status') {
        $running = Test-StudioDevice
        [PSCustomObject]@{ Avd = $avdName; Serial = $serial; AdbServerPort = $adbPort; Running = $running; AvdDirectory = $avdPath } | ConvertTo-Json
        exit 0
    }
    if ($Action -eq 'Stop') {
        if (Test-StudioDevice) {
            [void](Invoke-StudioAdb -AdbArguments @('-s', $serial, 'emu', 'kill'))
            $stopDeadline = [DateTime]::UtcNow.AddSeconds(30)
            do {
                $remaining = Invoke-StudioAdb -AdbArguments @('-s', $serial, 'get-state') -AllowFailure 6>$null
                if ($remaining.ExitCode -ne 0 -or $remaining.Output.Trim() -ne 'device') { break }
                Start-Sleep -Milliseconds 500
            } while ([DateTime]::UtcNow -lt $stopDeadline)
            if ($remaining.ExitCode -eq 0 -and $remaining.Output.Trim() -eq 'device') { throw 'The studio emulator acknowledged shutdown but is still connected after 30 seconds.' }
        }
        Write-Host 'Studio emulator stopped (the shared ADB server on 5037 was not touched).'
        exit 0
    }
    if (Test-StudioDevice) {
        $existingBoot = Invoke-StudioAdb -AdbArguments @('-s', $serial, 'shell', 'getprop', 'sys.boot_completed') -AllowFailure 6>$null
        if ($existingBoot.ExitCode -ne 0 -or $existingBoot.Output.Trim() -ne '1') { throw 'The studio device is connected but still booting. Retry after boot completes.' }
        Write-Host "Studio emulator already running: $serial (ADB server $adbPort)."
        exit 0
    }
    if (-not (Test-Path -LiteralPath $imageFile -PathType Leaf)) {
        throw "Required installed image is missing: $systemImage. Install it explicitly before starting."
    }
    $avdConfig = Join-Path $avdPath 'config.ini'
    if (-not (Test-Path -LiteralPath $avdConfig -PathType Leaf)) {
        $java = if ($paths.JavaSdk) { Join-Path $paths.JavaSdk 'bin\java.exe' } else { '' }
        $classpath = Join-Path $cliRoot 'lib\avdmanager-classpath.jar'
        if (-not $java -or -not (Test-Path -LiteralPath $java) -or -not (Test-Path -LiteralPath $classpath)) {
            throw 'Creating the studio AVD requires an existing JDK and Android command-line tools.'
        }
        # Use the class shipped by the official avdmanager wrapper. No existing AVD is overwritten.
        $createArguments = @(
            ('-Dcom.android.sdkmanager.toolsdir=' + $cliRoot),
            '-classpath', $classpath,
            'com.android.sdklib.tool.AvdManagerCli',
            'create', 'avd', '--name', $avdName, '--package', $systemImage,
            '--device', 'pixel_8', '--path', $avdPath
        )
        [void](Invoke-StudioProcess -FilePath $java -Arguments $createArguments -Environment $environment -LogPath (Join-Path $logRoot 'create-avd.log') -TimeoutSeconds 120)
        if (-not (Test-Path -LiteralPath $avdConfig -PathType Leaf)) { throw 'AVD creation did not produce config.ini.' }
    }

    [void](Invoke-StudioAdb -AdbArguments @('start-server'))
    $arguments = @(
        '-avd', $avdName, '-port', [string]$consolePort,
        '-no-window', '-no-audio', '-no-snapshot', '-no-boot-anim',
        '-camera-back', 'none', '-camera-front', 'none',
        '-gpu', $Gpu, '-memory', '2048', '-cores', '2',
        '-adb-path', $adb, '-no-metrics', '-crash-report-mode', 'never'
    )
    $oldEnvironment = @{}
    try {
        foreach ($key in $environment.Keys) {
            $oldEnvironment[$key] = [Environment]::GetEnvironmentVariable($key, 'Process')
            [Environment]::SetEnvironmentVariable($key, [string]$environment[$key], 'Process')
        }
        $process = Start-Process -FilePath $emulator -ArgumentList (($arguments | ForEach-Object { ConvertTo-StudioArgument $_ }) -join ' ') -WorkingDirectory $paths.Root -WindowStyle Hidden -RedirectStandardOutput (Join-Path $logRoot 'emulator.stdout.log') -RedirectStandardError (Join-Path $logRoot 'emulator.stderr.log') -PassThru
    }
    finally {
        foreach ($key in $oldEnvironment.Keys) { [Environment]::SetEnvironmentVariable($key, $oldEnvironment[$key], 'Process') }
    }
    $emulatorProcessId = $process.Id
    $deadline = [DateTime]::UtcNow.AddSeconds($BootTimeoutSeconds)
    while ([DateTime]::UtcNow -lt $deadline) {
        if (Test-StudioDevice) {
            $boot = Invoke-StudioAdb -AdbArguments @('-s', $serial, 'shell', 'getprop', 'sys.boot_completed') -AllowFailure 6>$null
            if ($boot.ExitCode -eq 0 -and $boot.Output.Trim() -eq '1') {
                [PSCustomObject]@{ Avd = $avdName; Serial = $serial; AdbServerPort = $adbPort; ConsolePort = $consolePort; LauncherProcessId = $emulatorProcessId; BootCompleted = $true; Gpu = $Gpu; AvdDirectory = $avdPath } | ConvertTo-Json
                $process.Dispose()
                exit 0
            }
        }
        Start-Sleep -Seconds 2
    }
    $process.Dispose()
    throw "Studio emulator did not complete boot within $BootTimeoutSeconds seconds. Inspect $logRoot and run -Action Status."
}
catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
