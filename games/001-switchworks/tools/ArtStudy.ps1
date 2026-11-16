param(
    [ValidateSet('BuildAssets','Test','Run','Capture','Modules','Video','ExportAndroid')][string]$Action = 'Run',
    [ValidateSet('planning','failed','won','paused','hint')][string]$Scenario = 'planning',
    [ValidatePattern('^\d{2,4}x\d{2,4}$')][string]$Resolution = '390x844',
    [switch]$ReuseSources
)
$ErrorActionPreference = 'Stop'
$studyGame = Split-Path -Parent $PSScriptRoot
$studyStudio = Split-Path -Parent (Split-Path -Parent $studyGame)
. (Join-Path $studyStudio 'tools/Studio.Common.ps1')
$studyPaths = Get-StudioPaths
$studyRun = Join-Path $studyGame ('artifacts/art-study-2026-11-16/runs/' + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ') + '-' + $Action)
[void][IO.Directory]::CreateDirectory($studyRun)
function Invoke-Study {
    param([string[]]$ProcessArguments, [string]$LogName, [int]$Limit = 120, [switch]$ExpectedFailure)
    $studyResult = Invoke-StudioProcess -FilePath $studyPaths.Godot -Arguments $ProcessArguments -LogPath (Join-Path $studyRun ($LogName+'.log')) -TimeoutSeconds $Limit -AllowFailure:$ExpectedFailure 6>$null
    if($ExpectedFailure) {
        if($studyResult.ExitCode -ne 1 -or $studyResult.Output -notmatch 'intentional negative control') {throw 'Runner negative control did not fail as intended.'}
    } elseif($studyResult.ExitCode -ne 0 -or $studyResult.Output -match '(?m)SCRIPT ERROR:|^ERROR:') {throw ('Godot reported an error; inspect ' + $LogName)}
    Write-Output ($LogName + ': exit=' + $studyResult.ExitCode)
    Write-Output ($studyResult.Output -split "`n" | Where-Object {$_ -match 'TESTS passed=|LITTORAL_AUTHOR|LITTORAL_RENDER_CONTRACT|SLICE_METRICS|SLICE_FIRST_FRAME'})
}
try {
    Assert-StudioGodot $studyPaths 6>$null
    Invoke-Study @('--headless','--path',$studyGame,'--import') 'import'
    if($Action -eq 'BuildAssets') {
        $studyAuthorArguments = @('--headless','--path',$studyGame,'--script','res://experiments/littoral/author_models.gd')
        if($ReuseSources) {$studyAuthorArguments += @('--','--reuse-sources')}
        Invoke-Study $studyAuthorArguments 'author'
        Invoke-Study @('--headless','--path',$studyGame,'--import') 'import-models'
    } elseif($Action -eq 'Test') {
        foreach($studyRunner in @('test_runner.gd','slice_gameplay_runner.gd','slice_ui_runner.gd','polish_state_runner.gd','littoral_composition_runner.gd')) {
            Invoke-Study @('--headless','--path',$studyGame,'--script',('res://tests/'+$studyRunner)) $studyRunner
        }
        Invoke-Study @('--headless','--path',$studyGame,'--script','res://tests/littoral_composition_runner.gd','--','--negative-control') 'negative-control' -ExpectedFailure
    } elseif($Action -eq 'ExportAndroid') {
        Set-StudioAndroidSettings $studyPaths
        $studyApk=Join-Path $studyGame 'build/android/switchworks-littoral-study-debug.apk'
        [void][IO.Directory]::CreateDirectory((Split-Path -Parent $studyApk))
        Invoke-Study @('--headless','--path',$studyGame,'--export-debug','Android Littoral Study',$studyApk) 'export-android' 600
    } else {
        $studyArgs=@('--path',$studyGame,'--resolution',$Resolution,'res://experiments/littoral/composition.tscn')
        if($Action -eq 'Capture') {$studyArgs+=@('--',('--slice-shot='+(Join-Path $studyRun ($Scenario+'.png'))),('--slice-scenario='+$Scenario))}
        elseif($Action -eq 'Modules') {$studyArgs=@('--path',$studyGame,'--resolution','960x720','res://experiments/littoral/module_sheet.tscn','--',('--sheet-shot='+(Join-Path $studyRun 'modules.png')))}
        elseif($Action -eq 'Video') {
            # Movie Maker initializes its AVI dimensions from project overrides.
            # A different --resolution cropped the recorded viewport in 4.7.2.
            $studyConfig=[IO.File]::ReadAllText((Join-Path $studyGame 'project.godot'))
            $studyMovieWidth=[regex]::Match($studyConfig,'(?m)^window/size/window_width_override=(\d+)').Groups[1].Value
            $studyMovieHeight=[regex]::Match($studyConfig,'(?m)^window/size/window_height_override=(\d+)').Groups[1].Value
            if(-not $studyMovieWidth -or -not $studyMovieHeight){throw 'Video requires explicit project window overrides.'}
            $studyMovieSize=$studyMovieWidth+'x'+$studyMovieHeight
            Write-Output ('Movie Maker records the configured viewport '+$studyMovieSize+'; use Capture for other resolutions.')
            $studyArgs=@('--path',$studyGame,'--resolution',$studyMovieSize,'--write-movie',(Join-Path $studyRun 'gameplay.avi'),'--fixed-fps','30','res://experiments/littoral/composition.tscn','--','--study-video',('--study-frames='+(Join-Path $studyRun 'frames')))
        }
        Invoke-Study $studyArgs 'runtime' $(if($Action -eq 'Run'){86400}else{120})
    }
    Write-Output ('Study artifacts: '+$studyRun)
    exit 0
} catch {Write-Error $_ -ErrorAction Continue; exit 1}
