<p align="center">
  <img src="windows/runner/resources/app_icon.ico" width="96" alt="JA Mini Showcase icon">
</p>

<h1 align="center">JA Mini Showcase</h1>

<p align="center">
  Flutter desktop showcase for JA-HUB Bento Glassmorphism, Dynamic Island navigation, interactive terminal, global shortcuts, live glass tuning, command palette, device list filters, telemetry widgets, and reusable UI motion patterns.
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.44.2-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white">
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Windows%20Desktop-0078D4?logo=windows&logoColor=white">
  <img alt="Release" src="https://img.shields.io/badge/Release-v1.2.0-10B981">
  <img alt="License" src="https://img.shields.io/badge/License-MIT-lightgrey">
</p>

---

## Table of Contents

- [Core Capabilities](#core-capabilities)
- [Architecture & UX System](#architecture--ux-system)
- [Directory & Technical Architecture](#directory--technical-architecture)
- [Quick Start](#quick-start)
- [Configuration & Runtime Notes](#configuration--runtime-notes)
- [Changelog Recap](#changelog-recap)
- [Release Workflow](#release-workflow)
- [License & Author](#license--author)

---

## Core Capabilities

### Glass appearance baseline

Windows 10/11 light and dark color tokens match JA_MES_Tool, including the
background, topbar, sidebar, cards, borders and mesh orbs. Auto detects hardware
for reporting but always uses blur 20 and opacity 25% (cards), 85% (dialogs),
86% (dropdowns). Manual Ultra/Balanced/Lite presets remain available; returning
to Auto or resetting restores this baseline. Live tuning still overrides it.

### Keyboard shortcuts

Use **Cmd** instead of **Ctrl** on macOS.

| Shortcut | Action |
| --- | --- |
| Ctrl+K | Open Command Palette; ↑/↓ selects, Enter runs the selected command (or first result). |
| Ctrl+1…5 | Overview, Components, Terminal, Devices, Bandwidth. |
| Ctrl+, | Open Settings. |
| Ctrl+Shift+L | Toggle light/dark theme. |
| Ctrl+F | Focus the search field in Devices. |
| Ctrl+L | Clear Terminal output; preserve command history and draft input. |
| Esc | Close dialog, dropdown or palette; discard unsaved Settings preview. |

Tab shortcuts are scoped to the active view. Dialogs isolate keyboard focus from
the dashboard. Normal typing and editing shortcuts remain available.
Bindings live in `lib/modules/ui/app_shortcuts.dart` and use Flutter
`Shortcuts`/`Actions`; register a callback in the appropriate view to reuse them.

### Bento Overview
- **Hero Core Controller:** Live/Standby control card with `GlowingActionButton`, status badges, and dashboard-style operational state.
- **Telemetry Cards:** Bandwidth, device count, latency, CPU/RAM, and connection samples for UI stress testing.
- **Quick Actions:** Scan network, change port, clear cache, export report, and toast feedback patterns.

### Interactive Glass Terminal
- **Fedora 44 Styling:** High-contrast console inspired by Fedora 44 Ptyxis / GNOME Console with Dark (`Obsidian Velvet`) and Light (`Adwaita Porcelain`) modes ensuring WCAG AAA legibility.
- **Built-in Commands:** Interactive command interpreter supporting `help`, `status`, `devices`, `ping`, `scan`, `theme`, `clear`, `echo`, `sysinfo`, and `exit`.
- **Developer Experience:** Command history buffer with Up/Down arrow navigation, command suggestion chips, auto-scroll toggle, single-click clipboard log copy, and execution callbacks.
- **Quick Clear:** Global shortcut `Ctrl+L` to clear output while preserving active draft inputs and history.

### Component Sandbox
- **Glass Surfaces:** `BentoCard`, `GlassContainer`, `GlassDialog`, and `DetailDialog` for repeatable JA-HUB desktop UI composition.
- **Motion Effects:** `BorderBeam`, `SpotlightGlow`, `WaveIndicator`, and `AsymmetricMarqueeText` with lifecycle-aware animation pausing.
- **Controls:** `GlowingActionButton`, `PillBadge`, `KbdTag`, hover-expanding topbar buttons, sliders, and preset chips.
- **Overlays:** Command Palette, app toast notifications, searchable dropdown overlays, and modal dialog samples.

### Device List & Filters
- **FilterSearchDock:** Search input, filter pills, and VLAN dropdown in one reusable glass toolbar.
- **Device Cards:** Compact device rows with IP, traffic, VLAN badge, type grouping, and resettable empty state.

### Navigation & Responsive Layout
- **Dynamic Island Capsule:** LIVE/STANDBY status, wave indicator, and optional secondary telemetry text.
- **Sliding Pill Tab Bar:** Adaptive icon/text navigation with hover preview on compact desktop widths.
- **Mobile Dock:** Bottom glass dock for narrow windows while preserving the same tab model.

### Settings, About, And User Guide
- **Live Glass Tuning:** Card, dialog, and dropdown blur/opacity controls with reset/save/cancel flow.
- **Localized Runtime Help:** Vietnamese, English, and Chinese strings for About/User Guide, settings, tabs, tooltips, and status labels.
- **Version Display:** Runtime version comes from `lib/modules/constants.dart` via `BuildInfo.version`.

### LAN OTA updates

- **Credential storage:** The Settings password field writes to Windows Credential Manager for the SMB server; `update_config.json` never stores a password. Existing plaintext `password` entries are removed when the app loads its configuration.
- **Required manifest:** OTA only accepts an existing `version.json` containing a safe JA Mini Showcase ZIP name and a lowercase or uppercase SHA-256 digest. The downloaded local ZIP is hashed again before extraction.

```json
{
  "version": "1.2.0",
  "fileName": "JA_Mini_Showcase_1.2.0.zip",
  "sha256": "<64-character SHA-256 hex digest>",
  "releaseNotes": "Optional release notes"
}
```

Generate the digest for a release package with:

```powershell
(Get-FileHash .\JA_Mini_Showcase_1.2.0.zip -Algorithm SHA256).Hash.ToLower()
```

---

## Architecture & UX System

| Area | Implementation |
|---|---|
| State management | Provider / ChangeNotifier (`ThemeProvider`, `LanguageProvider`) |
| Theme routing | Win10/Win11 color tokens split across `styles_win10.dart` and `styles_win11.dart` |
| Window effects | `window_manager` plus `flutter_acrylic` Mica/Aero setup in `main.dart` |
| UI composition | Focused widgets under `lib/widgets/`, dashboard orchestration under `lib/layout/` |
| Sample views | Overview, Components, Devices, Stats under `lib/sample_views/` |
| Logging | Debug and release loggers with idempotent subscription lifecycle |
| Verification | `dart analyze`, `dart format .`, and `flutter test` |

---

## Directory & Technical Architecture

```text
JA_Mini_Showcase/
├── lib/
│   ├── main.dart                         # App bootstrap, providers, desktop window effect setup
│   ├── layout/
│   │   ├── dashboard_shell.dart           # Main shell orchestration and tab routing
│   │   └── dashboard_shell_settings.dart  # Topbar buttons, settings dialog, About/User Guide tabs
│   ├── modules/
│   │   ├── constants.dart                 # appName, appVersion, appId
│   │   ├── build_info.dart                # Runtime version/debug timestamp helpers
│   │   ├── window_helper.dart             # Windows desktop window sizing and glass helpers
│   │   ├── logger_config.dart             # Logger mode dispatcher
│   │   ├── logger_debug.dart              # Debug logger with 7-day rotation
│   │   ├── logger_release.dart            # Release logger with 30-day rotation
│   │   └── ui/
│   │       └── app_shortcuts.dart         # Centralized keyboard shortcuts system
│   ├── sample_views/
│   │   ├── sample_bento_overview.dart     # Dashboard overview samples
│   │   ├── sample_components_view.dart    # Components view entrypoint
│   │   ├── sample_components_*.dart       # Focused component sandbox sections
│   │   ├── sample_device_list_view.dart   # Device filter/list demo
│   │   └── sample_stats_view.dart         # Telemetry and gauge demo
│   ├── theme/
│   │   ├── app_colors.dart                # Shared design tokens
│   │   ├── language_provider.dart         # VI/EN/CN runtime strings
│   │   ├── styles_win10.dart              # Windows 10 token set
│   │   ├── styles_win11.dart              # Windows 11 token set
│   │   └── theme_provider.dart            # Theme, hardware tier, glass tuning state
│   └── widgets/
│       ├── glass_widgets.dart             # Public barrel for reusable glass widgets
│       ├── glass_*.dart                   # Focused glass widget implementation parts
│       ├── glass_dialog.dart              # Modal dialog widgets
│       ├── glass_dropdown.dart            # Searchable glass dropdown
│       ├── glass_terminal.dart            # Interactive glass terminal (Fedora 44 style)
│       ├── command_palette.dart           # Ctrl+K command palette
│       ├── filter_search_dock.dart        # Search/filter/dropdown toolbar
│       ├── mobile_dock_nav.dart           # Responsive bottom navigation
│       └── app_toast.dart                 # Overlay toast notifications
├── test/                                  # Widget, provider, dropdown, marquee, logger, shortcuts tests
├── windows/                               # Flutter Windows runner and generated plugin glue
├── windows_native_guide/                  # Windows Acrylic/Mica native theming guide
├── ABOUT.txt                              # JA Auto Git project information card
├── CHANGELOG.md                           # Permanent release history
├── RELEASE_NOTES.md                       # GitHub release notes source
├── LICENSE                                # MIT license
├── build.bat                              # Windows build helper
├── debug.bat                              # Release/debug binary launcher
├── run.bat                                # Flutter desktop run helper
└── pubspec.yaml                           # Flutter dependencies and version
```

---

## Quick Start

### Option A: Portable Run

1. Download the latest `JA_Mini_Showcase_v*_Windows_x64.zip` from GitHub Releases.
2. Extract the archive.
3. Run `ja_mini_showcase.exe`.
4. Use `debug.bat` in the extracted folder to launch the binary with `-debug`.

### Option B: Building From Source

Prerequisites:
- Flutter `3.44.2` stable or newer compatible Flutter 3.x SDK
- Dart `3.12.2`
- Windows 10/11 with desktop development enabled

```powershell
git clone https://github.com/jatechvn/JA_Mini_Showcase.git
cd JA_Mini_Showcase
flutter pub get
flutter run -d windows
flutter build windows --release
```

Validation commands:

```powershell
dart analyze
dart format .
flutter test
```

---

## Configuration & Runtime Notes

JA Mini Showcase has no required external configuration file for normal use.

Generated runtime/build folders are intentionally ignored:

```text
build/
dist/
dist_pack/
backup/
logs/
windows/flutter/ephemeral/
```

The in-app theme toggle updates Flutter-level colors immediately. Native Windows backdrop tint is initialized through `flutter_acrylic`; if future work adds deeper native tint synchronization, document it in this section and in `CHANGELOG.md`.

---

## Changelog Recap

- **v1.2.0:** Corporate LAN Over-The-Air (OTA) self-update mechanism with UNC SMB share mounting and atomic Robocopy installer, Windows Desktop 1-Click Installer & Uninstaller suite (`install.bat`, `uninstall.bat`, `uninstall.ps1`), hardware-adaptive performance tiers (High/Balanced/Lite), persistent search history repository, and 70 automated tests.
- **v1.1.0:** Interactive Glass Terminal with Fedora 44 styling and command interpreter, centralized Global Keyboard Shortcuts engine (`Ctrl+K/1..5/F/L/Esc`), in-app About external links and User Guide terminal card, 37 automated tests.
- **v1.0.1:** Logger lifecycle hardening, phased split of the largest UI files, docs/version/About/User Guide release sync.
- **v1.0.0:** Initial JA-HUB UI showcase with Bento overview, component sandbox, device filters, telemetry samples, Dynamic Island navigation, glass tuning, Command Palette, and toast notifications.

Full history is available in [CHANGELOG.md](CHANGELOG.md).

---

## Release Workflow

Current release metadata:

```text
Version : 1.2.0+4
Tag     : v1.2.0
Target  : Windows x64
Artifact: dist/JA_Mini_Showcase_v1.2.0_Windows_x64.zip
```

Standard release checks:

```powershell
dart analyze
dart format .
flutter test
flutter build windows --release
```

The GitHub Draft Release is created from `dist/RELEASE_NOTES.md` and the generated ZIP artifact.

---

## License & Author

MIT License. See [LICENSE](LICENSE).

Author: Johnny (`jatechvn`) / JA Tech  
Website: [https://jatechvn.github.io/](https://jatechvn.github.io/)  
Repository: [https://github.com/jatechvn/JA_Mini_Showcase](https://github.com/jatechvn/JA_Mini_Showcase)
