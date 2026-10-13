# Changelog

Release history of the three filters and of the Windows installer. Dates are
the day each build was made. Ready-made installers are on Gumroad; this file
records what each of them contains.

## Temperature + Tint

### Windows package 1.0.2 (2026-10-13)

Installer-only release. The plugin binary is the 1.0.1 build, byte for byte,
so the OBS log still reports `version 1.0.1`.

- **Fixed:** the filter did not appear when OBS Studio was installed anywhere
  other than `C:\Program Files\obs-studio`. The 1.0.1 installer always
  proposed that folder, did not look for OBS, and did not check the folder the
  customer chose, so the files landed where OBS never reads them.
- **New:** automatic mode installs to
  `%ProgramData%\obs-studio\plugins\obs-temperature-tint-filter`, which OBS
  loads from regardless of the drive or folder OBS itself is in.
- **New:** portable mode for OBS run from a portable folder, which ignores
  `%ProgramData%`. The chosen folder must contain `bin\64bit\obs64.exe`; a
  folder inside OBS or the folder holding it is corrected automatically.
- **New:** earlier installs (1.0.0 and 1.0.1) are uninstalled first, wherever
  they were placed, so an old copy cannot load instead of the new one.
- Tested on OBS Studio 32.2.1 (installed) and OBS Studio 31.1.1 (portable).

### 1.0.1 (2026-09-24), macOS and Windows

- More natural white balance and better handling of out-of-gamut colors.
- `Mix` is now labelled `Intensity`; Temperature and Tint labels show their
  direction (Cool ↔ Warm, Green ↔ Magenta).
- Tooltip explaining that Temperature is a relative adjustment, not Kelvin.
- Spanish interface (`es-ES`, `es-MX`).
- Windows build no longer downloads Qt; the filter only needs libobs.

### 1.0.0 (2026-07-09 macOS, 2026-07-21 Windows)

- First release.

## SkinSoft

### Windows package 1.0.1 (2026-10-13)

- Same plugin changes as 1.0.1 for macOS, below.
- Built with the new Windows installer, which works whichever drive or
  folder OBS Studio is installed on and removes earlier installs.

### 1.0.1 (2026-08-06), macOS

- Controls grouped into three steps: preview the mask, select the skin area,
  set the smoothing strength.
- Clearer control labels.
- New defaults: smooth amount 65, blur radius 4, detail protection 35,
  texture restore 20.

### 1.0.0 (2026-07-09 macOS, 2026-07-21 Windows)

- First release.

## Colorist Tone

### Windows package 1.0.0, new installer (2026-10-13)

- Plugin unchanged (the 2026-07-21 build).
- Repackaged with the new Windows installer, which works whichever drive or
  folder OBS Studio is installed on and removes earlier installs.

### 1.0.0 (2026-07-09 macOS, 2026-07-21 Windows)

- First release.
