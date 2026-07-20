<p align="center"><img src="../docs/images/temperature-tint-icon.png" width="72"></p>

# Temperature + Tint

**Native OBS Studio filter for real-time white balance — move the camera between cooler and warmer tones and correct green/magenta color casts, right inside OBS.**

Part of [OBS Filters by Yasunari Murayama](../README.md) · macOS (Windows planned).

## What it does

A simple, intuitive white-balance adjustment done **by eye**, the way temperature/tint corrections work in a color grade. It does not represent calibrated Kelvin values — it's a fast visual correction for mixed lighting and color casts.

**Good for:** warming or cooling a webcam · correcting green/magenta casts · improving skin tone under mixed lighting · matching different cameras · cleaner OBS Virtual Camera output.

## Controls

| Control | Purpose |
|---|---|
| Temperature | Cool ↔ warm shift |
| Tint | Green ↔ magenta shift |
| Mix | Blend between original and corrected |
| Reset | Return to neutral temperature/tint and full mix |

## Build (macOS)

Built from the official OBS plugin template (requires CMake 3.28+):

```bash
python3 -m venv .build-venv
.build-venv/bin/python -m pip install --upgrade pip "cmake>=3.30,<3.31"
.build-venv/bin/cmake --preset macos
.build-venv/bin/cmake --build --preset macos
.build-venv/bin/cmake --install build_macos --prefix dist --config RelWithDebInfo
```

Install into the user's OBS plugin folder, then restart OBS:

```bash
mkdir -p "$HOME/Library/Application Support/obs-studio/plugins"
ditto "dist/obs-temperature-tint-filter.plugin" "$HOME/Library/Application Support/obs-studio/plugins/obs-temperature-tint-filter.plugin"
```

## Source

- Filter logic — [`src/temperature-tint-filter.c`](src/temperature-tint-filter.c)
- GPU shader — [`data/effects/temperature-tint.effect`](data/effects/temperature-tint.effect)

## Download

Free (pay-what-you-want) → [yasunarimurayama.com/product/temperature-tint](https://yasunarimurayama.com/product/temperature-tint/)
