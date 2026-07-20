# OBS Temperature + Tint Filter

Native OBS Studio plugin for real-time camera white balance correction.

## Current Filter

- Temperature: cold to warm.
- Tint: green to magenta.
- Mix: original/corrected blend.
- Reset: returns controls to neutral temperature/tint and full mix.

## macOS Build

The official OBS plugin template currently requires CMake 3.28 or newer. This project has a local build tool environment:

```bash
python3 -m venv .build-venv
.build-venv/bin/python -m pip install --upgrade pip "cmake>=3.30,<3.31"
```

Configure, build, and package:

```bash
.build-venv/bin/cmake --preset macos
.build-venv/bin/cmake --build --preset macos
.build-venv/bin/cmake --install build_macos --prefix dist --config RelWithDebInfo
```

Install into the current user's OBS plugin folder:

```bash
mkdir -p "$HOME/Library/Application Support/obs-studio/plugins"
ditto "dist/obs-temperature-tint-filter.plugin" "$HOME/Library/Application Support/obs-studio/plugins/obs-temperature-tint-filter.plugin"
```

Then restart OBS and add `Temperature + Tint` as a filter on a video source.
