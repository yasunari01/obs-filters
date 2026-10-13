# Windows installer

One Inno Setup script builds the `.exe` installer of all three filters.

| File | Purpose |
| --- | --- |
| `obs-filter-installer.iss` | The installer. Shared by the three filters. |
| `build-installers.ps1` | Compiles it for one filter. Always use this. |

## Why it works on any drive

Customers install OBS Studio wherever they like, so the installer does not
depend on finding it.

- **Automatic (default).** Files go to
  `%ProgramData%\obs-studio\plugins\<plugin>\bin\64bit` and `...\data`. OBS
  Studio reads that folder no matter where OBS itself is installed.
- **Portable OBS.** OBS started from a portable folder ignores `%ProgramData%`,
  so the customer picks the OBS folder and the files go to
  `<obs>\obs-plugins\64bit` and `<obs>\data\obs-plugins\<plugin>`. The folder
  must contain `bin\64bit\obs64.exe`. Picking a folder inside OBS, or the
  folder that holds it, is corrected automatically.

Before copying files the installer runs the uninstaller of every earlier
release of the same filter and deletes stray copies from the OBS folders it
finds. Without that, an old copy inside the OBS folder loads first and the
update never shows up.

OBS folders are found through the running `obs64.exe`, the registry keys the
OBS installer writes, Start Menu, desktop and taskbar shortcuts, Steam, and a
scan of every fixed and removable drive. Detection is only used to suggest the
portable folder and to clean old copies; automatic mode does not need it.

## Build

Requires [Inno Setup 6.3 or newer](https://jrsoftware.org/isinfo.php) and the
compiled plugin `.dll`.

```powershell
# Plugin already built in <filter>-filter\build_x64\rundir\RelWithDebInfo
.\build-installers.ps1 -Filter temperature-tint -PackageVersion 1.0.2

# Or point at a .dll built elsewhere
.\build-installers.ps1 -Filter skinsoft -PackageVersion 1.0.1 -Dll C:\path\obs-skinsoft-filter.dll
```

The `.exe` is written to `installer\windows\out` unless `-OutDir` is given.
`-PackageVersion` is the version of the download; it can be newer than the
plugin when only the installer changed.

## Test without installing

`-DryRun` builds an installer that needs no admin rights, detects OBS, writes
to the log where it would install, and stops.

```powershell
.\build-installers.ps1 -Filter temperature-tint -PackageVersion 1.0.2 -DryRun
.\out\OBS-Temperature-Tint-Filter-Windows-Installer-v1.0.2-DRYRUN.exe /VERYSILENT /LOG=dry.log
.\out\OBS-Temperature-Tint-Filter-Windows-Installer-v1.0.2-DRYRUN.exe /VERYSILENT /LOG=dry.log /OBSDIR="D:\obs-portable"
```

`/OBSDIR="<folder>"` selects portable mode with that folder on the real
installer too, which is useful for support.

Every install also writes a log to `%TEMP%\Setup Log <date> #<n>.txt`. Ask a
customer for that file when an install goes wrong.

## Adding a filter

Add an entry to the `$filters` table in `build-installers.ps1`. Keep `AppIdRaw`
stable across releases, and list in `LegacyAppIds` the id of any installer that
was released with a different one.
