# Temperature Tint Filter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a native OBS plugin skeleton with a working `Temperature + Tint` source filter.

**Architecture:** The plugin registers one OBS video filter implemented in C. The filter loads one OBS `.effect` shader and exposes standard OBS properties for Temperature, Tint, and Mix.

**Tech Stack:** OBS Studio libobs C API, OBS effect shaders, CMake, Xcode on macOS.

---

### Task 1: Documentation Baseline

**Files:**
- Create: `/Users/yazu/Documents/Apps By Yasu + IA/Filtros OBS/README.md`
- Modify: `/Users/yazu/Documents/Apps By Yasu + IA/Filtros OBS/PROJECT_STATUS.md`

- [x] **Step 1: Document project strategy**

Write a README that states the native plugin strategy, phase plan, and macOS build path.

- [x] **Step 2: Update status**

Mark stack selection complete and Phase 1 in progress.

### Task 2: Plugin Skeleton

**Files:**
- Create directory: `/Users/yazu/Documents/Apps By Yasu + IA/Filtros OBS/obs-colorist-filters`
- Create: `CMakeLists.txt`
- Create: `CMakePresets.json`
- Create: `buildspec.json`
- Create: `src/plugin-main.c`
- Create: `src/temperature-tint-filter.c`
- Create: `src/temperature-tint-filter.h`
- Create: `data/locale/en-US.ini`
- Create: `data/effects/temperature-tint.effect`

- [x] **Step 1: Create plugin files**

Create a minimal OBS plugin project with one registered source filter.

- [x] **Step 2: Add shader**

Create `temperature-tint.effect` with parameters `temperature`, `tint`, and `mix_amount`.

### Task 3: Build Verification

**Files:**
- Read: `/Users/yazu/Documents/Apps By Yasu + IA/Filtros OBS/obs-colorist-filters/CMakeLists.txt`

- [x] **Step 1: Check local tools**

Run `cmake --version` and `xcodebuild -version`.

- [x] **Step 2: Configure**

Run `cmake --preset macos` from the plugin directory.

- [x] **Step 3: Build**

Run `cmake --build --preset macos`.

### Task 4: Manual OBS Test

**Files:**
- Read: `/Users/yazu/Documents/Apps By Yasu + IA/Filtros OBS/README.md`

- [x] **Step 1: Install locally**

Run `cmake --install build_macos --prefix dist` if build succeeds.

- [ ] **Step 2: Test in OBS**

Add the filter to a video source and confirm that Temperature, Tint, and Mix affect the image.
