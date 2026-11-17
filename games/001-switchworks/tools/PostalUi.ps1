param(
    [ValidateSet('Run','Bench','BuildAssets','Test','Capture','Video','ExportAndroid','ExportWeb')][string]$Action='Run',
    [ValidatePattern('^\d{2,4}x\d{2,4}$')][string]$Resolution='390x844',
    [ValidateRange(1.0,2.0)][double]$TextScale=1.0,
    [switch]$Grayscale,
    [switch]$ReuseSources
)
$ErrorActionPreference='Stop'
$postalGame=Split-Path -Parent $PSScriptRoot
$postalRoot=Split-Path -Parent (Split-Path -Parent $postalGame)
. (Join-Path $postalRoot 'tools/Studio.Common.ps1')
$postalPaths=Get-StudioPaths
$postalArtifact=Join-Path $postalGame 'artifacts/ui-ux-refonte-2026-11-16'
[void][IO.Directory]::CreateDirectory($postalArtifact)
[IO.File]::WriteAllText((Join-Path $postalArtifact '.gdignore'),'')
$postalRun=Join-Path $postalArtifact ('runs/'+[DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffffffZ')+'-'+$Action)
[void][IO.Directory]::CreateDirectory($postalRun)
function Invoke-Postal {
 param([string[]]$Arguments,[string]$Name,[int]$Limit=120,[switch]$Negative)
 $postalResult=Invoke-StudioProcess -FilePath $postalPaths.Godot -Arguments $Arguments -LogPath (Join-Path $postalRun ($Name+'.log')) -TimeoutSeconds $Limit -AllowFailure:$Negative 6>$null
 if($Negative){
  if($postalResult.ExitCode -ne 1 -or $postalResult.Output -notmatch 'intentional negative control'){throw 'Negative control did not fail intentionally.'}
 }elseif($postalResult.ExitCode -ne 0 -or $postalResult.Output -match '(?m)SCRIPT ERROR:|SHADER ERROR:|^ERROR:'){throw ('Godot error in '+$Name)}
 Write-Output ($Name+': exit='+$postalResult.ExitCode)
 Write-Output ($postalResult.Output -split "`n" | Where-Object {$_ -match 'TESTS passed=|WORKSHOP_AUTHOR|WORKSHOP_BENCH'})
}
try {
 Assert-StudioGodot $postalPaths 6>$null
 Invoke-Postal @('--headless','--path',$postalGame,'--import') 'import'
 if($Action -eq 'BuildAssets'){
  $postalArgs=@('--headless','--path',$postalGame,'--script','res://experiments/postal_workshop/author_models.gd')
  if($ReuseSources){$postalArgs+=@('--','--reuse-sources')}
  Invoke-Postal $postalArgs 'author'
  Invoke-Postal @('--headless','--path',$postalGame,'--import') 'import-models'
 }elseif($Action -eq 'Test'){
  foreach($postalRunner in @('test_runner.gd','slice_gameplay_runner.gd','slice_ui_runner.gd','polish_state_runner.gd','littoral_composition_runner.gd','postal_ui_runner.gd')){
   Invoke-Postal @('--headless','--path',$postalGame,'--script',('res://tests/'+$postalRunner)) $postalRunner
  }
  Invoke-Postal @('--headless','--path',$postalGame,'--script','res://tests/postal_ui_runner.gd','--','--negative-control') 'negative-control' -Negative
 }elseif($Action -in @('ExportAndroid','ExportWeb')){
  $postalTarget=if($Action -eq 'ExportAndroid'){'build/android/switchworks-postal-ui-debug.apk'}else{'build/web-postal-ui/index.html'}
  $postalPreset=if($Action -eq 'ExportAndroid'){'Android Postal UI'}else{'Web Postal UI'}
  if($Action -eq 'ExportAndroid'){Set-StudioAndroidSettings $postalPaths}
  $postalTarget=Join-Path $postalGame $postalTarget
  [void][IO.Directory]::CreateDirectory((Split-Path -Parent $postalTarget))
  [IO.File]::WriteAllText((Join-Path (Split-Path -Parent $postalTarget) '.gdignore'),'')
  $postalExportMode=if($Action -eq 'ExportWeb'){'--export-release'}else{'--export-debug'}
  Invoke-Postal @('--headless','--path',$postalGame,$postalExportMode,$postalPreset,$postalTarget) 'export' 600
 }else{
  $postalArgs=@('--path',$postalGame,'--resolution',$Resolution)
  if($Action -eq 'Run'){$postalArgs+=@('res://experiments/postal_workshop/game.tscn')}
  elseif($Action -eq 'Bench'){$postalArgs=@('--path',$postalGame,'--resolution','960x800','res://experiments/postal_workshop/workbench.tscn','--',('--bench-out='+$postalRun))}
  else{
   if($Action -eq 'Video'){$postalArgs=@('--path',$postalGame,'--resolution','450x800','--write-movie',(Join-Path $postalRun 'gameplay.avi'),'--fixed-fps','30')}
   $postalArgs+=@('--script','res://tools/qa_uiux_capture.gd','--',('--qa-out='+$postalRun),'--qa-scene=res://experiments/postal_workshop/game.tscn',('--qa-text-scale='+$TextScale.ToString([Globalization.CultureInfo]::InvariantCulture)))
   if($Action -eq 'Video'){$postalArgs+='--qa-full-path'}
   if($Grayscale){$postalArgs+='--qa-grayscale'}
  }
  Invoke-Postal $postalArgs 'runtime' $(if($Action -eq 'Run'){86400}else{150})
 }
 Write-Output ('Postal UI artifacts: '+$postalRun)
 exit 0
}catch{Write-Error $_ -ErrorAction Continue;exit 1}
