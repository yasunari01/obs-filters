# OBS SkinSoft Filter

Native OBS Studio source filter for controlled skin smoothing.

## Controls

- Hue center
- Hue range
- Saturation min/max
- Luma min/max
- Mask softness
- Smooth amount
- Blur radius
- Detail protection
- Texture restore
- Show mask
- Reset

## macOS Build

```bash
python3 -m venv .build-venv
.build-venv/bin/python -m pip install --upgrade pip "cmake>=3.30,<3.31"
.build-venv/bin/cmake --preset macos
.build-venv/bin/cmake --build --preset macos
.build-venv/bin/cmake --install build_macos --prefix dist --config RelWithDebInfo
mkdir -p "$HOME/Library/Application Support/obs-studio/plugins"
ditto "dist/obs-skinsoft-filter.plugin" "$HOME/Library/Application Support/obs-studio/plugins/obs-skinsoft-filter.plugin"
```
