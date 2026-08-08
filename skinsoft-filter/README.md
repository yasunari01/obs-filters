<p align="center"><img src="../docs/images/skinsoft-icon.png" width="72"></p>

# SkinSoft

**Native OBS Studio filter for controlled, real-time skin smoothing — using a skin-color mask instead of a full-frame blur.**

Part of [OBS Filters by Yasunari Murayama](../README.md) · macOS & Windows x64.

<p align="center"><img src="../docs/images/skinsoft-demo.gif" alt="SkinSoft controls inside OBS" width="700"></p>

## What it does

SkinSoft smooths skin inside OBS **without** blurring the whole image or producing a plastic face. It builds a mask from hue, saturation, and luminance ranges, so you control which areas are softened — then protects important edges and can restore part of the original texture.

## Controls

| Control | Purpose |
|---|---|
| Hue Center / Hue Range | Center and width of the skin hue selection |
| Saturation Min / Max | Saturation band kept in the mask |
| Luma Min / Max | Brightness band kept in the mask |
| Mask Softness | Softness of the mask edges |
| Smooth Amount | How much smoothing is applied inside the mask |
| Blur Radius | Size of the smoothing kernel |
| Detail Protection | Preserves stronger facial edges (eyes, hair, contours) |
| Texture Restore | Mixes original skin texture back into the result |
| Show Mask | Preview the mask as black/white before applying |
| Reset | Return all controls to defaults |

## Suggested workflow

1. Add **SkinSoft** *before* color/tone filters (see [recommended order](../README.md#how-they-work-together)).
2. Turn on **Show Mask**.
3. Adjust hue, saturation, and luma ranges until only the skin is selected (white).
4. Turn off **Show Mask**.
5. Set **Smooth Amount** and **Blur Radius** to taste.
6. Raise **Detail Protection** to keep strong edges.
7. Use **Texture Restore** to bring back natural texture.

## Starter settings

Starting points only — tune per camera, lighting, and skin tone.

**Natural**

```
Hue center 8   Hue range 10   Sat min 12   Sat max 80
Luma min 18    Luma max 95    Mask softness 35
Smooth amount 25–35   Blur radius 1.5–2.0
Detail protection 55–70   Texture restore 25–40
```

**Stronger streaming look**

```
Mask softness 45   Smooth amount 45–60   Blur radius 2.5–3.5
Detail protection 45–60   Texture restore 15–30
```

**Troubleshooting**

- *Filter hits walls/background* → turn on Show Mask, narrow Hue Range, raise Saturation Min, adjust Luma Min/Max.
- *Result looks too plastic* → lower Smooth Amount, lower Blur Radius, raise Detail Protection.

## Build (macOS)

Built from the official OBS plugin template (requires CMake 3.28+). A local build environment is used:

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
ditto "dist/obs-skinsoft-filter.plugin" "$HOME/Library/Application Support/obs-studio/plugins/obs-skinsoft-filter.plugin"
```

## Build (Windows x64)

Requires Visual Studio 2022 with the C++ desktop workload and the Windows SDK
(the `windows-x64` preset targets the `Visual Studio 17 2022` generator).
From this directory, in PowerShell:

```powershell
.github\scripts\Build-Windows.ps1
.github\scripts\Package-Windows.ps1
```

The scripts resolve the plugin root themselves and write the packaged plugin
to `release/`. A ready-made installer is available on the product page below.

## Source

- Filter logic — [`src/skinsoft-filter.c`](src/skinsoft-filter.c)
- GPU shader — [`data/effects/skinsoft.effect`](data/effects/skinsoft.effect)

## Download

Free (pay-what-you-want) → [yasunarimurayama.com/product/obs-skinsoft](https://yasunarimurayama.com/product/obs-skinsoft/)
