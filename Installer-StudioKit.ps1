param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ProjectPath
)

$ErrorActionPreference = 'Stop'
$source = Split-Path -Parent $MyInvocation.MyCommand.Path
$dest = [System.IO.Path]::GetFullPath($ProjectPath)

if (-not (Test-Path -LiteralPath $dest -PathType Container)) {
    throw "Project directory does not exist: $dest"
}

$source = (Resolve-Path -LiteralPath $source).ProviderPath
$dest = (Resolve-Path -LiteralPath $dest).ProviderPath
if ([string]::Equals($source.TrimEnd('\', '/'), $dest.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'The destination must differ from the Studio Kit source directory.'
}

$studioSkills = @(
    'studio-product-discovery',
    'studio-art-direction',
    'studio-game-ux',
    'studio-visual-qa',
    'studio-mobile-release'
)
$studioDocs = @(
    'ART_BIBLE_TEMPLATE.md',
    'PROGRESSION_ARTISTIQUE.md',
    'RECETTE_VISUELLE_TEMPLATE.md'
)
$rootDocs = @('AGENTS.md', 'CODEX_PROMPT_DE_LANCEMENT.md')
$sourceSkills = Join-Path $source '.agents\skills'
$docsSource = Join-Path $source 'docs'

# Check the complete kit before creating anything in the destination.
foreach ($skillName in $studioSkills) {
    $skillFile = Join-Path (Join-Path $sourceSkills $skillName) 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
        throw "Studio skill source is missing: $skillFile"
    }
}
foreach ($filename in $studioDocs) {
    $docFile = Join-Path $docsSource $filename
    if (-not (Test-Path -LiteralPath $docFile -PathType Leaf)) {
        throw "Studio document source is missing: $docFile"
    }
}
foreach ($filename in $rootDocs) {
    $docFile = Join-Path $source $filename
    if (-not (Test-Path -LiteralPath $docFile -PathType Leaf)) {
        throw "Studio instruction source is missing: $docFile"
    }
}

$skillsDir = Join-Path $dest '.agents\skills'
New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
foreach ($skillName in $studioSkills) {
    $target = Join-Path $skillsDir $skillName
    if (Test-Path -LiteralPath $target) {
        Write-Warning "Skill already exists and was not overwritten: $skillName"
        continue
    }
    Copy-Item -LiteralPath (Join-Path $sourceSkills $skillName) -Destination $target -Recurse
}

$docsTarget = Join-Path $dest 'docs\studio-quality'
New-Item -ItemType Directory -Path $docsTarget -Force | Out-Null
foreach ($filename in $studioDocs) {
    $target = Join-Path $docsTarget $filename
    if (-not (Test-Path -LiteralPath $target)) {
        Copy-Item -LiteralPath (Join-Path $docsSource $filename) -Destination $target
    }
}

foreach ($filename in $rootDocs) {
    $target = Join-Path $dest $filename
    if (-not (Test-Path -LiteralPath $target)) {
        Copy-Item -LiteralPath (Join-Path $source $filename) -Destination $target
    }
    else {
        Write-Warning "Existing file preserved: $filename. Review this kit's equivalent manually."
    }
}

Write-Host 'Studio Kit copied (five local skills and three templates). Install the game-dev catalog separately, then verify discovery using /skills in Codex.'
