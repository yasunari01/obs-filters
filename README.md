# OBS Filters by Yasunari Murayama

**A small collection of real-time OBS Studio filters for shaping the color, tone, and skin of a webcam or camera image — built by a colorist, for creators.**

<!-- Optional badges. Uncomment and adjust once your links are final.
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20x64-lightgrey)
![License](https://img.shields.io/badge/license-Proprietary-blue)
![Download](https://img.shields.io/badge/download-Gumroad-ff90e8)
-->

> **About this repository.** This repo holds the **full source** of three OBS Studio plugins I designed and shipped — the C filter code, the `.effect` GPU shaders, the CMake build, and the design specs that drove development. Ready-to-install builds are free on Gumroad (pay-what-you-want, enter `0`). See [Repository contents](#repository-contents) for the map.
>
> **How these were built.** I'm not a hand-coder — I direct the work. I write the specs, define the scope and architecture, drive the implementation with AI tools, keep it under version control, and log decisions and fixes as I go. The `PROJECT_STATUS.md` and `docs/` files in this repo are that trail, kept intentionally so the *process* is as visible as the result.

---

## What these are

Three OBS Studio filters designed to work **together** to give a webcam or camera image a cleaner, more controlled, slightly cinematic look — without depending on a second camera app or a subscription service.

| Filter | Purpose | macOS | Windows |
|---|---|:---:|:---:|
| **SkinSoft** | Selective skin smoothing with detail protection | ✅ | ✅ (x64) |
| **Temperature + Tint** | Visual white balance & color-cast correction | ✅ | Planned |
| **Colorist Tone** | Exposure, contrast & tonal shaping | ✅ | Planned |

I have worked in video production, color correction, motion design, VFX, and post-production for **15+ years**. These filters bring the way I approach an image in DaVinci Resolve into a real-time OBS workflow.

<!-- SCREENSHOT: hero shot — before/after of the camera image with all three filters applied.
![Before and after](docs/images/before-after.png)
-->

---

## The filters

### 🎨 Temperature + Tint — visual white balance inside OBS

A simple, intuitive way to move the image between cooler and warmer tones and correct unwanted green/magenta color casts — balanced **by eye**, the way temperature/tint corrections work during a color grade. It does not represent calibrated Kelvin values; it is a visual adjustment.

**Helps with:** warming/cooling a webcam, correcting green/magenta casts, improving skin tone under mixed lighting, matching different cameras, and cleaning up OBS Virtual Camera output.

`Controls:` Temperature · Tint · Mix · Reset

---

### 🎞️ Colorist Tone — a more cinematic camera image

Focused control over the tonal structure of the image: exposure, contrast, a contrast pivot, and independent control of shadows, lower mids, mids, upper mids, and highlights. The goal is not a generic "cinematic preset" — it's a set of controls to shape each setup deliberately, including lifted/washed blacks and controlled highlights.

**Helps with:** flat webcam images, exposure, contrast and pivot, lifting/deepening shadows, shaping midtones, controlling highlights, and adding depth.

`Controls:` Exposure · Contrast · Pivot · Shadows · Lower Mids · Mids · Upper Mids · Highlights · Mix · Reset

---

### ✨ SkinSoft — subtle skin smoothing without blurring everything

Skin smoothing that softens harsh webcam texture **without** turning the whole frame into a blur or producing a plastic face. It builds a **skin mask from hue, saturation, and luminance ranges**, so you control exactly which areas are softened — and includes dedicated **Detail Protection** (preserves facial edges) and **Texture Restore** (mixes original skin texture back in). A **Show Mask** preview lets you dial the mask in before applying the effect.

**Helps with:** softening harsh skin texture, reducing the appearance of blemishes, preserving facial detail while smoothing, and cleaner on-camera skin for TikTok Live, YouTube, Zoom, tutorials, and recordings.

`Controls:` Hue Center · Hue Range · Saturation Range · Luma Range · Mask Softness · Smooth Amount · Blur Radius · Detail Protection · Texture Restore · Show Mask · Reset

<!-- SCREENSHOT: SkinSoft mask + controls panel inside OBS.
![SkinSoft mask](docs/images/skinsoft-mask.png)
-->

---

## How they're designed to work together

The three filters solve **different** parts of the same problem, so they stack cleanly:

- **SkinSoft** → selective skin smoothing
- **Temperature + Tint** → overall color balance
- **Colorist Tone** → exposure, contrast, and tonal shaping

### Recommended filter order

```
1. SkinSoft
2. Temperature + Tint
3. Colorist Tone
```

**Why SkinSoft goes first:** it builds its mask from the *hue, saturation, and luminance* of the source. If a strong temperature or color correction runs before it, the selected skin tones shift and the mask becomes harder to isolate. Letting SkinSoft analyze the original tones first — then balancing color, then shaping tone — keeps the mask clean. This is a starting point, not an absolute rule: every camera, skin tone, and lighting setup may need different adjustments.

---

## Design notes (the "how", without the source)

A few decisions behind the filters, for anyone curious about the approach:

- **Perceptual skin masking.** Isolating skin by HSL ranges (rather than a fixed color key) keeps the mask stable across skin tones and lighting, and makes the *Show Mask* preview genuinely useful for tuning.
- **Detail preservation over brute blur.** Naïve smoothing destroys eyes, hair edges, and pores. *Detail Protection* + *Texture Restore* let the result stay soft where it should be and sharp where it matters.
- **Tonal control modeled on a grading workflow.** Colorist Tone's pivot + banded midtones mirror how I'd shape an image in Resolve, instead of a single brightness/contrast pair.
- **Real-time first.** Every choice is constrained by running live on a camera source inside OBS, including feeding the OBS Virtual Camera.

*The full shader and C implementations live in this repo — see each filter's `src/` and `data/effects/` folder.*

---

## Repository contents

```
obs-filters/
├── skinsoft-filter/          # SkinSoft plugin — C source + skin-mask shader
│   ├── src/                  #   filter logic (C, libobs API)
│   └── data/effects/         #   skinsoft.effect (GPU shader)
├── temperature-tint-filter/  # Temperature + Tint plugin
│   └── data/effects/         #   temperature-tint.effect
├── colorist-tone-filter/     # Colorist Tone plugin
│   └── data/effects/         #   colorist-tone.effect
├── docs/                     # design specs that drove development
└── PROJECT_STATUS.md         # status, task history, decision log
```

Each filter is an independent OBS plugin generated from the official [obs-plugintemplate](https://github.com/obsproject/obs-plugintemplate) — its own CMake build, CI workflow, and installer. Build artifacts and dependencies are intentionally excluded (see `.gitignore`); the ready-made installers are on Gumroad.

---

## Download

Free to download (pay-what-you-want — enter `0` for free, or contribute to support development).

- **SkinSoft** → [yasunarimurayama.com/product/obs-skinsoft](https://yasunarimurayama.com/product/obs-skinsoft/)
- **Temperature + Tint** → [yasunarimurayama.com/product/temperature-tint](https://yasunarimurayama.com/product/temperature-tint/)
- **Colorist Tone** → [yasunarimurayama.com/product/obs-colorist-tone](https://yasunarimurayama.com/product/obs-colorist-tone/)

📄 Full write-up & FAQ: **[yasunarimurayama.com](https://yasunarimurayama.com/free-obs-filters-by-yasunari-murayama/)**

---

## Who they're for

Livestreamers · YouTube & TikTok Live creators · gamers · online teachers · course creators · podcasters · church livestream teams · remote workers · video producers · anyone who wants a better camera image inside OBS.

---

## About

I'm **Yasunari Murayama** — video producer, motion designer, colorist, and developer of creative tools, with 15+ years in audiovisual production. My work combines video production, color correction, livestreaming, motion graphics, VFX, automation, and software development. These filters are part of a growing collection of practical tools built to solve real production problems.

- 🌐 Website: [yasunarimurayama.com](https://yasunarimurayama.com)
- 🛍️ All products: [murayama7.gumroad.com](https://murayama7.gumroad.com) · [yasunarimurayama.com/products](https://yasunarimurayama.com/products/)

---

<sub>© Yasunari Murayama. Filters distributed as products; source not included in this repository.</sub>
