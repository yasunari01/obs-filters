<#
.SYNOPSIS
  Builds the Windows installer (.exe) for one of the OBS filters.

.DESCRIPTION
  Compiles obs-filter-installer.iss with the values of the chosen filter.
  The plugin must already be built: pass the compiled .dll, or let the script
  take it from <filter>\build_x64\rundir\RelWithDebInfo.

.EXAMPLE
  .\build-installers.ps1 -Filter temperature-tint -PackageVersion 1.0.2 -OutDir C:\obs-build\out

.EXAMPLE
  .\build-installers.ps1 -Filter skinsoft -PackageVersion 1.0.1 `
      -Dll C:\obs-build\skinsoft\build_x64\rundir\RelWithDebInfo\obs-skinsoft-filter.dll
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('temperature-tint', 'colorist-tone', 'skinsoft')]
    [string]$Filter,

    # Version shown by the installer and used in the file name.
    [Parameter(Mandatory)]
    [string]$PackageVersion,

    # Compiled plugin .dll. Defaults to the filter's own build output.
    [string]$Dll,

    # Folder with effects\ and locale\. Defaults to <filter>-filter\data.
    [string]$DataDir,

    [string]$OutDir = (Join-Path $PSScriptRoot 'out'),

    [string]$Iscc,

    # Test build: needs no admin rights, detects OBS, logs where it would
    # install and stops. Run it with /VERYSILENT /LOG=file to read the result.
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')

# AppId keeps the value of the installer each filter already shipped with, so
# Windows shows one entry per filter. LegacyAppIds lists the ids of every other
# installer ever released; those are uninstalled before the new files go in.
$filters = @{
    'temperature-tint' = @{
        PluginId     = 'obs-temperature-tint-filter'
        FilterName   = 'Temperature + Tint'
        FilterNameEs = 'Temperatura + Tinte'
        AppIdRaw     = 'OBS Temperature + Tint Filter'
        LegacyAppIds = '{A7F3C1E2-1001-4B10-9F00-6D2A1B0C7E01}'
        AppURL       = 'https://yasunarimurayama.com/product/temperature-tint/'
        OutBase      = 'OBS-Temperature-Tint-Filter-Windows-Installer'
    }
    'colorist-tone'    = @{
        PluginId     = 'obs-colorist-tone-filter'
        FilterName   = 'Colorist Tone'
        FilterNameEs = 'Colorist Tone'
        AppIdRaw     = '{A7F3C1E2-1002-4B10-9F00-6D2A1B0C7E02}'
        LegacyAppIds = 'OBS Colorist Tone Filter'
        AppURL       = 'https://yasunarimurayama.com/product/obs-colorist-tone/'
        OutBase      = 'OBS-Colorist-Tone-Filter-Windows-Installer'
    }
    'skinsoft'         = @{
        PluginId     = 'obs-skinsoft-filter'
        FilterName   = 'SkinSoft'
        FilterNameEs = 'SkinSoft'
        AppIdRaw     = '{A7F3C1E2-1003-4B10-9F00-6D2A1B0C7E03}'
        LegacyAppIds = 'OBS SkinSoft Filter'
        AppURL       = 'https://yasunarimurayama.com/product/obs-skinsoft/'
        OutBase      = 'OBS-SkinSoft-Filter-Windows-Installer'
    }
}
$f = $filters[$Filter]
$filterDir = Join-Path $repoRoot "$Filter-filter"

if (-not $Dll) {
    $Dll = Join-Path $filterDir "build_x64\rundir\RelWithDebInfo\$($f.PluginId).dll"
}
if (-not $DataDir) {
    $DataDir = Join-Path $filterDir 'data'
}
if (-not (Test-Path $Dll)) { throw "Plugin .dll not found: $Dll. Build the filter first or pass -Dll." }
if (-not (Test-Path (Join-Path $DataDir 'effects'))) { throw "No effects folder in: $DataDir" }

if (-not $Iscc) {
    $Iscc = @(
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $Iscc) { throw 'Inno Setup 6 (ISCC.exe) not found. Install it or pass -Iscc.' }

New-Item -ItemType Directory -Force $OutDir | Out-Null

# Inno Setup reads accented text correctly only from a file with a UTF-8 BOM.
$template = Join-Path $PSScriptRoot 'obs-filter-installer.iss'
$staged = Join-Path ([IO.Path]::GetTempPath()) "obs-filter-installer-$Filter.iss"
[IO.File]::WriteAllText($staged, [IO.File]::ReadAllText($template), (New-Object Text.UTF8Encoding $true))

$outBase = "$($f.OutBase)-v$PackageVersion"
if ($DryRun) { $outBase += '-DRYRUN' }

$isccArgs = @(
    $(if ($DryRun) { '/DDryRun' }),
    "/DPluginId=$($f.PluginId)",
    "/DFilterName=$($f.FilterName)",
    "/DFilterNameEs=$($f.FilterNameEs)",
    "/DAppIdRaw=$($f.AppIdRaw)",
    "/DLegacyAppIds=$($f.LegacyAppIds)",
    "/DAppURL=$($f.AppURL)",
    "/DPackageVersion=$PackageVersion",
    "/DDllPath=$((Resolve-Path $Dll).Path)",
    "/DDataDir=$((Resolve-Path $DataDir).Path)",
    "/DOutDir=$((Resolve-Path $OutDir).Path)",
    "/DOutBase=$outBase",
    '/Q',
    $staged
) | Where-Object { $_ }
& $Iscc @isccArgs
if ($LASTEXITCODE -ne 0) { throw "ISCC failed with exit code $LASTEXITCODE" }
Remove-Item $staged -ErrorAction SilentlyContinue

$exe = Join-Path $OutDir "$outBase.exe"
Write-Host "Built: $exe"
