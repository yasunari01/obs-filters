# OBS Colorist Filters Design

## Goal

Build native OBS Studio video filters for real-time camera color correction, distributed as independent plugins so each filter can be downloaded and installed separately.

## Product Direction

The product lives inside OBS as installable source filters. It does not use an external app, Syphon, NDI, or fixed LUT packs for the MVP. Each correction tool appears as a separate OBS filter and ships as its own plugin/package.

## Recommended Architecture

Use native OBS plugins created from the official OBS plugin template. Each plugin registers one `OBS_SOURCE_TYPE_FILTER` entry:

- `temperature-tint-filter`: `Temperature + Tint`.
- `colorist-curves-filter`: `Colorist Curves`.
- `skinsoft-filter`: `SkinSoft`.

Each plugin owns a small C source file for settings, properties, lifecycle, and rendering. Each plugin uses one or more OBS `.effect` shader files for GPU processing.

## Why Native Plugin First

`obs-shaderfilter` is useful as a shader laboratory, but it should not be the production dependency. Native plugins give us stable filter names, controlled sliders, reset/defaults, localization, packaging, future presets, and cross-platform CI. ShaderFilter remains a reference and prototyping tool only.

## Phase 1 Scope

`Temperature + Tint` applies a fast RGB shader to a source/camera.

Controls:

- `Temperature`: -100 cold to +100 warm.
- `Tint`: -100 green to +100 magenta.
- `Mix`: 0 to 100 percent.
- `Reset`: implemented through OBS defaults and normal property reset behavior for the MVP.

The MVP does not add a custom preview toggle because OBS already provides filter enable/disable and source preview behavior. A custom bypass can be added later if it is useful for A/B comparison or presets.

## Initial File Layout

```text
Filtros OBS/
  PROJECT_STATUS.md
  README.md
  docs/
    superpowers/
      specs/
        2026-07-09-obs-colorist-filters-design.md
      plans/
        2026-07-09-temperature-tint-filter.md
  obs-colorist-filters/
    CMakeLists.txt
    CMakePresets.json
    buildspec.json
    src/
      plugin-main.c
      temperature-tint-filter.c
      temperature-tint-filter.h
    data/
      locale/
        en-US.ini
      effects/
        temperature-tint.effect
```

## Rendering Model

The filter loads `temperature-tint.effect` through `gs_effect_create_from_file()`. During `video_render`, it calls `obs_source_process_filter_begin()`, sets shader parameters, then calls `obs_source_process_filter_end()`.

The shader samples the original image, computes warm/cool and green/magenta channel offsets, blends the corrected result with the original by `Mix`, and preserves alpha.

## macOS First, Windows Later

macOS is viable for the first implementation with Xcode and CMake. Packaging will require codesigning decisions later. Windows should be approachable because the core plugin uses libobs C APIs and OBS effect shaders rather than platform-specific APIs.

## Non-Goals For Phase 1

- No SkinSoft implementation yet.
- No graphical curves editor.
- No custom Qt dock or panel.
- No LUT dependency.
- No external camera processing app.
- No installer polish beyond what the template can produce.

## References

- OBS plugin template: https://github.com/obsproject/obs-plugintemplate
- OBS plugin docs: https://docs.obsproject.com/plugins
- OBS source/filter API: https://docs.obsproject.com/reference-sources
- OBS graphics/rendering docs: https://docs.obsproject.com/graphics
- OBS effects docs: https://docs.obsproject.com/reference-libobs-graphics-effects
- ShaderFilter reference: https://github.com/exeldro/obs-shaderfilter
