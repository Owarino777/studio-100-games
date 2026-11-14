Set-StrictMode -Version Latest
$script:StudioRoot = Split-Path -Parent $PSScriptRoot
$script:GodotVersion = '4.7.2'

function Get-StudioPaths {
    param([string]$AndroidSdkPath, [string]$JavaSdkPath)

    if (-not $AndroidSdkPath) {
        if ($env:ANDROID_HOME) { $AndroidSdkPath = $env:ANDROID_HOME }
        elseif ($env:ANDROID_SDK_ROOT) { $AndroidSdkPath = $env:ANDROID_SDK_ROOT }
        else { $AndroidSdkPath = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
    }
    if (-not $JavaSdkPath) {
        if ($env:JAVA_HOME -and (Test-Path -LiteralPath (Join-Path $env:JAVA_HOME 'bin\javac.exe'))) {
            $JavaSdkPath = $env:JAVA_HOME
        }
        else {
            $javac = Get-Command javac.exe -ErrorAction SilentlyContinue
            if ($javac) { $JavaSdkPath = Split-Path -Parent (Split-Path -Parent $javac.Source) }
        }
    }
    $localRoot = Join-Path $script:StudioRoot 'tools\.local'
    $godotRoot = Join-Path $localRoot ('godot\' + $script:GodotVersion)
    [PSCustomObject]@{
        Root = $script:StudioRoot
        LocalRoot = $localRoot
        GodotRoot = $godotRoot
        Godot = Join-Path $godotRoot 'Godot_v4.7.2-stable_win64_console.exe'
        Templates = Join-Path $godotRoot 'editor_data\export_templates\4.7.2.stable'
        Settings = Join-Path $godotRoot 'editor_data\editor_settings-4.7.tres'
        RuntimeUser = Join-Path $godotRoot 'editor_data\runtime-user'
        AndroidSdk = $AndroidSdkPath
        JavaSdk = $JavaSdkPath
        Project = Join-Path $script:StudioRoot 'games\001-switchworks'
    }
}

function ConvertTo-StudioArgument {
    param([string]$Value)
    if ($Value -match '[\r\n"]') { throw 'Process arguments may not contain quotes or newlines.' }
    if ($Value -match '\s' -or $Value.Length -eq 0) {
        # Double trailing separators so Windows does not escape the closing quote.
        return '"' + ($Value -replace '(\\+)$', '$1$1') + '"'
    }
    return $Value
}

function Stop-StudioProcessTree {
    param([System.Diagnostics.Process]$Process)
    if ($Process.HasExited) { return }
    # This PID belongs to the process created by this helper, never a discovered Java process.
    $killInfo = New-Object System.Diagnostics.ProcessStartInfo
    $killInfo.FileName = Join-Path $env:SystemRoot 'System32\taskkill.exe'
    $killInfo.Arguments = '/PID ' + $Process.Id + ' /T /F'
    $killInfo.UseShellExecute = $false
    $killInfo.CreateNoWindow = $true
    $killer = New-Object System.Diagnostics.Process
    $killer.StartInfo = $killInfo
    try {
        [void]$killer.Start()
        if (-not $killer.WaitForExit(10000)) { throw 'Timed out while stopping the studio process tree.' }
        if (-not $Process.WaitForExit(10000)) { throw 'The studio process tree could not be stopped.' }
    }
    finally { $killer.Dispose() }
}

function Invoke-StudioProcess {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [string[]]$Arguments = @(),
        [string]$WorkingDirectory = $script:StudioRoot,
        [string]$LogPath,
        [int]$TimeoutSeconds = 300,
        [hashtable]$Environment = @{},
        [switch]$AllowFailure
    )
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $FilePath
    $info.Arguments = ($Arguments | ForEach-Object { ConvertTo-StudioArgument $_ }) -join ' '
    $info.WorkingDirectory = $WorkingDirectory
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.StandardOutputEncoding = New-Object System.Text.UTF8Encoding($false)
    $info.StandardErrorEncoding = New-Object System.Text.UTF8Encoding($false)
    if ([System.IO.Path]::GetFileName($FilePath) -like 'Godot_v*.exe') {
        $runtimeRoot = Join-Path (Split-Path -Parent $FilePath) 'editor_data\runtime-user'
        [void][System.IO.Directory]::CreateDirectory($runtimeRoot)
        $info.EnvironmentVariables['APPDATA'] = $runtimeRoot
        $info.EnvironmentVariables['ANDROID_USER_HOME'] = Join-Path $script:StudioRoot 'tools\.local\android\user'
        $info.EnvironmentVariables['GRADLE_USER_HOME'] = Join-Path $script:StudioRoot 'tools\.local\gradle'
    }
    foreach ($name in $Environment.Keys) { $info.EnvironmentVariables[$name] = [string]$Environment[$name] }
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    try {
        [void]$process.Start()
        $clock = [System.Diagnostics.Stopwatch]::StartNew()
        $outputTask = $process.StandardOutput.ReadToEndAsync()
        $errorTask = $process.StandardError.ReadToEndAsync()
        $timedOut = $false
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            Stop-StudioProcessTree $process
            $timedOut = $true
        }
        $drainTimeout = if ($timedOut) { 10000 } else { [Math]::Max(1000, ($TimeoutSeconds * 1000) - [int]$clock.ElapsedMilliseconds) }
        $streams = [System.Threading.Tasks.Task[]]@($outputTask, $errorTask)
        if (-not [System.Threading.Tasks.Task]::WaitAll($streams, $drainTimeout)) {
            throw 'Output streams remained open after the studio process exited; a child may still hold an inherited handle.'
        }
        $output = $outputTask.GetAwaiter().GetResult()
        $errorOutput = $errorTask.GetAwaiter().GetResult()
        $text = $output + $errorOutput
        if ($LogPath) {
            [void][System.IO.Directory]::CreateDirectory((Split-Path -Parent $LogPath))
            [System.IO.File]::WriteAllText($LogPath, $text, (New-Object System.Text.UTF8Encoding($false)))
        }
        if ($text) { Write-Host $text.TrimEnd() }
        if ($timedOut) { throw "Process timed out after $TimeoutSeconds seconds: $FilePath. Log: $LogPath" }
        $code = $process.ExitCode
        if (-not $AllowFailure -and $code -ne 0) { throw "Process failed with exit code $code. Log: $LogPath" }
        [PSCustomObject]@{ ExitCode = $code; Output = $text }
    }
    finally { $process.Dispose() }
}

function Set-StudioGradleSettings {
    param($Paths)
    $gradleRoot = Join-Path $Paths.LocalRoot 'gradle'
    [void][System.IO.Directory]::CreateDirectory($gradleRoot)
    $propertiesPath = Join-Path $gradleRoot 'gradle.properties'
    $properties = if (Test-Path -LiteralPath $propertiesPath) { [System.IO.File]::ReadAllText($propertiesPath) } else { '' }
    $pattern = '(?m)^org\.gradle\.daemon\s*=.*$'
    if ([regex]::IsMatch($properties, $pattern)) {
        $properties = [regex]::Replace($properties, $pattern, 'org.gradle.daemon=false')
    }
    else { $properties = $properties.TrimEnd() + "`norg.gradle.daemon=false`n" }
    [System.IO.File]::WriteAllText($propertiesPath, $properties, (New-Object System.Text.UTF8Encoding($false)))
}

function Assert-StudioGodot {
    param($Paths)
    if (-not (Test-Path -LiteralPath $Paths.Godot -PathType Leaf)) {
        throw 'Godot is missing. Run tools/Setup-Studio.ps1 first.'
    }
    $version = Invoke-StudioProcess -FilePath $Paths.Godot -Arguments @('--headless', '--version')
    if ($version.Output.Trim() -notmatch '^4\.7\.2\.stable\.' -or $version.Output -match '(?i)mono') {
        throw 'Expected Godot 4.7.2 stable Standard.'
    }
}

function Set-StudioAndroidSettings {
    param($Paths)
    if (-not (Test-Path -LiteralPath (Join-Path $Paths.AndroidSdk 'platform-tools\adb.exe'))) {
        throw 'Android SDK platform-tools are missing.'
    }
    if (-not $Paths.JavaSdk -or -not (Test-Path -LiteralPath (Join-Path $Paths.JavaSdk 'bin\javac.exe'))) {
        throw 'A JDK is required. Pass -JavaSdkPath or expose javac on PATH.'
    }
    # The portable marker keeps these settings isolated from every other Godot installation.
    [void][System.IO.Directory]::CreateDirectory($Paths.GodotRoot)
    [System.IO.File]::WriteAllText((Join-Path $Paths.GodotRoot '_sc_'), '')
    [void][System.IO.Directory]::CreateDirectory((Split-Path -Parent $Paths.Settings))
    if (Test-Path -LiteralPath $Paths.Settings) {
        $settings = [System.IO.File]::ReadAllText($Paths.Settings)
    }
    else { $settings = "[gd_resource type=`"EditorSettings`" format=3]`n`n[resource]`n" }
    $values = @{
        'export/android/android_sdk_path' = $Paths.AndroidSdk
        'export/android/java_sdk_path' = $Paths.JavaSdk
    }
    foreach ($key in $values.Keys) {
        $value = $values[$key].Replace('\', '/').Replace('"', '\"')
        $line = $key + ' = "' + $value + '"'
        $pattern = '(?m)^' + [regex]::Escape($key) + '\s*=.*$'
        if ([regex]::IsMatch($settings, $pattern)) { $settings = [regex]::Replace($settings, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $line }) }
        else { $settings = $settings.TrimEnd() + "`n" + $line + "`n" }
    }
    [System.IO.File]::WriteAllText($Paths.Settings, $settings, (New-Object System.Text.UTF8Encoding($false)))
}
