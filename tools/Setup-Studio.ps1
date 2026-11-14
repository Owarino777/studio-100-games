param(
    [string]$AndroidSdkPath,
    [string]$JavaSdkPath,
    [switch]$InstallAndroidPackages
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Studio.Common.ps1')
$paths = Get-StudioPaths -AndroidSdkPath $AndroidSdkPath -JavaSdkPath $JavaSdkPath
$releaseUrl = 'https://github.com/godotengine/godot-builds/releases/download/4.7.2-stable'
$downloadDir = Join-Path $paths.LocalRoot 'downloads'
$requiredTemplates = @('android_debug.apk', 'android_release.apk', 'android_source.zip', 'ios.zip', 'version.txt')
$assetHashes = @{
    'Godot_v4.7.2-stable_win64.exe.zip' = '83decd58fdf67b9d657958a1ae6bf1929c20785315a81effe245874cdc57acb709bf868e00778a96984338c1b29dafdb453c6847747694621c6ecf5da2259993'
    'Godot_v4.7.2-stable_export_templates.tpz' = 'ca4d71c4d7b81dfc15d1a98baa07534aa95b03fdda78a0075b06672e1648d2e5f40980c9adc28d23e1b92e732ee7bf3461997aa804af74ec2fcd7a93ccb84079'
}

function Get-OfficialGodotFile {
    param([string]$Name, [string]$ChecksumText)
    $path = Join-Path $downloadDir $Name
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $temporary = $path + '.download'
        Invoke-WebRequest -UseBasicParsing -Uri ($releaseUrl + '/' + $Name) -OutFile $temporary -TimeoutSec 600
        Move-Item -LiteralPath $temporary -Destination $path
    }
    $match = [regex]::Match($ChecksumText, '(?m)^([a-fA-F0-9]{128})\s+\*?' + [regex]::Escape($Name) + '\r?$')
    if (-not $match.Success) { throw "The official SHA512 manifest has no entry for $Name" }
    $actual = (Get-FileHash -LiteralPath $path -Algorithm SHA512).Hash
    if ($actual -ne $match.Groups[1].Value -or $actual -ne $assetHashes[$Name]) { throw "Checksum mismatch: $Name. The cached file was preserved for diagnosis." }
    return $path
}

function Expand-StudioArchive {
    param([string]$Archive, [string]$Destination)
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($Archive, $Destination)
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    [void][System.IO.Directory]::CreateDirectory($downloadDir)
    $needEditor = -not (Test-Path -LiteralPath $paths.Godot -PathType Leaf)
    $missingTemplates = @($requiredTemplates | Where-Object { -not (Test-Path -LiteralPath (Join-Path $paths.Templates $_) -PathType Leaf) })
    $needTemplates = $missingTemplates.Count -gt 0
    if ($needTemplates -and (Test-Path -LiteralPath $paths.Templates)) {
        throw ('The existing template directory is incomplete. Review it before retrying. Missing: ' + ($missingTemplates -join ', '))
    }
    if ($needEditor -or $needTemplates) {
        $checksumFile = Join-Path $downloadDir 'SHA512-SUMS.txt'
        Invoke-WebRequest -UseBasicParsing -Uri ($releaseUrl + '/SHA512-SUMS.txt') -OutFile $checksumFile -TimeoutSec 60
        $checksums = [System.IO.File]::ReadAllText($checksumFile)
        if ($needEditor) {
            $archive = Get-OfficialGodotFile 'Godot_v4.7.2-stable_win64.exe.zip' $checksums
            [void][System.IO.Directory]::CreateDirectory($paths.GodotRoot)
            Expand-StudioArchive $archive $paths.GodotRoot
        }
        if ($needTemplates) {
            $archive = Get-OfficialGodotFile 'Godot_v4.7.2-stable_export_templates.tpz' $checksums
            $extractRoot = Join-Path $paths.LocalRoot ('templates-' + [guid]::NewGuid().ToString('N'))
            Expand-StudioArchive $archive $extractRoot
            $templateSource = Join-Path $extractRoot 'templates'
            $archiveVersion = [System.IO.File]::ReadAllText((Join-Path $templateSource 'version.txt')).Trim()
            if ($archiveVersion -ne '4.7.2.stable') { throw "Unexpected template version: $archiveVersion" }
            foreach ($templateFile in $requiredTemplates) {
                if (-not (Test-Path -LiteralPath (Join-Path $templateSource $templateFile) -PathType Leaf)) { throw "The template archive is incomplete: $templateFile" }
            }
            if (Test-Path -LiteralPath $paths.Templates) { throw 'An incomplete template directory already exists. Review it before retrying.' }
            [void][System.IO.Directory]::CreateDirectory((Split-Path -Parent $paths.Templates))
            Move-Item -LiteralPath $templateSource -Destination $paths.Templates
            $resolvedExtract = [System.IO.Path]::GetFullPath($extractRoot)
            $allowedRoot = [System.IO.Path]::GetFullPath($paths.LocalRoot).TrimEnd('\') + '\'
            if (-not $resolvedExtract.StartsWith($allowedRoot, [System.StringComparison]::OrdinalIgnoreCase)) { throw 'Temporary extraction escaped the local tools directory.' }
            Remove-Item -LiteralPath $resolvedExtract -Recurse -Force
        }
    }
    [System.IO.File]::WriteAllText((Join-Path $paths.GodotRoot '_sc_'), '')
    Assert-StudioGodot $paths
    foreach ($templateFile in $requiredTemplates) {
        if (-not (Test-Path -LiteralPath (Join-Path $paths.Templates $templateFile) -PathType Leaf)) { throw "Required export template is missing: $templateFile" }
    }
    if ([System.IO.File]::ReadAllText((Join-Path $paths.Templates 'version.txt')).Trim() -ne '4.7.2.stable') { throw 'Installed templates do not match Godot 4.7.2.' }
    if ($InstallAndroidPackages) {
        $manager = Join-Path $paths.AndroidSdk 'cmdline-tools\latest\bin\android.exe'
        if (-not (Test-Path -LiteralPath $manager)) { throw 'Android command-line tools 23 with android.exe are required for automatic package installation. Existing older tools were preserved.' }
        $packages = [ordered]@{
            'platform-tools' = 'platform-tools\adb.exe'
            'platforms/android-35' = 'platforms\android-35\android.jar'
            'platforms/android-36' = 'platforms\android-36\android.jar'
            'build-tools/35.0.1' = 'build-tools\35.0.1\aapt2.exe'
            'build-tools/36.1.0' = 'build-tools\36.1.0\aapt2.exe'
            'ndk/28.1.13356709' = 'ndk\28.1.13356709\source.properties'
            'cmake/3.10.2.4988404' = 'cmake\3.10.2.4988404\bin\cmake.exe'
            'emulator' = 'emulator\emulator.exe'
        }
        $missing = @($packages.Keys | Where-Object { -not (Test-Path -LiteralPath (Join-Path $paths.AndroidSdk $packages[$_])) })
        if ($missing.Count) {
            if (-not $paths.JavaSdk) { throw 'A JDK is required to run sdkmanager.' }
            $androidUser = Join-Path $paths.LocalRoot 'android\user'
            [void][System.IO.Directory]::CreateDirectory($androidUser)
            foreach ($package in $missing) {
                $arguments = @('--no-metrics', ('--sdk=' + $paths.AndroidSdk), 'sdk', '--ignore-outdated-xmls', 'install', $package)
                $result = Invoke-StudioProcess -FilePath $manager -Arguments $arguments -Environment @{ JAVA_HOME = $paths.JavaSdk; ANDROID_USER_HOME = $androidUser } -TimeoutSeconds 1200
                if ($result.ExitCode -ne 0) { throw 'Android package installation failed. No license was accepted automatically.' }
            }
        }
        foreach ($package in $packages.Keys) {
            if (-not (Test-Path -LiteralPath (Join-Path $paths.AndroidSdk $packages[$package]))) { throw "Required Android package is still missing: $package" }
        }
    }
    Set-StudioAndroidSettings $paths
    Write-Host 'Godot Standard and matching export templates are available. Run tools/Studio.ps1 -Action Doctor for Android readiness.'
    exit 0
}
catch {
    Write-Error $_ -ErrorAction Continue
    exit 1
}
