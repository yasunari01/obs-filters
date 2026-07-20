# OBS Colorist Tone Filter

Native OBS Studio source filter for live tone shaping without LUTs.

## Controls

- Exposure
- Contrast
- Pivot
- Shadows
- Lower mids
- Mids
- Upper mids
- Highlights
- Mix
- Reset

## macOS Build

```bash
python3 -m venv .build-venv
.build-venv/bin/python -m pip install --upgrade pip "cmake>=3.30,<3.31"
.build-venv/bin/cmake --preset macos
.build-venv/bin/cmake --build --preset macos
.build-venv/bin/cmake --install build_macos --prefix dist --config RelWithDebInfo
mkdir -p "$HOME/Library/Application Support/obs-studio/plugins"
ditto "dist/obs-colorist-tone-filter.plugin" "$HOME/Library/Application Support/obs-studio/plugins/obs-colorist-tone-filter.plugin"
```
