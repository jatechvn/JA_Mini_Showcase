# CHANGELOG - JA Mini Showcase

All notable changes to **JA Mini Showcase** will be documented in this file.

---

## [v1.1.0] - 2026-09-08

### 🚀 Major Features & Enhancements
- **💻 Interactive Glass Terminal:**
  - Integrated full command terminal tab inspired by Fedora 44 Ptyxis / GNOME Console with high-contrast Obsidian Velvet (dark) and Adwaita Porcelain (light) palettes.
  - Built-in command interpreter supporting `help`, `status`, `devices`, `ping`, `scan`, `theme`, `clear`, `echo`, `sysinfo`, and `exit`.
  - Arrow key command history navigation (↑/↓), command suggestion chips, auto-scroll toggle, clipboard log export, and execution callbacks.
  - Added dedicated `Ctrl+L` shortcut to clear the terminal stream while maintaining command history and prompt state.
- **⌨️ Global Keyboard Shortcuts Engine:**
  - Implemented centralized keyboard shortcut bindings in `lib/modules/ui/app_shortcuts.dart` using Flutter `Shortcuts`/`Actions`.
  - Added `Ctrl+K` (Command Palette), `Ctrl+1..5` (Tab navigation), `Ctrl+,` (Settings dialog), `Ctrl+Shift+L` (Theme toggle), `Ctrl+F` (Devices search focus), and `Esc` (Modal dismissal).
  - Configured platform-aware key routing with automatic `Cmd` remapping on macOS and modal focus isolation preventing background triggers.
- **🧭 In-App Help & Navigation Refinements:**
  - Added interactive Terminal guide card to the in-app User Guide tab with multilingual support (VI, EN, CN).
  - Enhanced About tab with direct external launcher buttons for the JA Tech website (`https://jatechvn.github.io/`) and GitHub repository.
  - Polished TopBar hover expand animation (1.05x scale) and mobile dock layout.

### 🧪 Testing & Quality Assurance
- **Automated Regression Suite:**
  - Added comprehensive widget test suite `shortcuts_test.dart` verifying Command Palette wrapping, filtering, tab navigation, and modal isolation on both Windows and macOS.
  - Expanded `feature_regression_test.dart` and `glass_terminal_test.dart` to 37 passing automated tests covering all responsive breakpoints and theme/language variations.

---

## [v1.0.1] - 2026-09-07

### Bug Fixes
- **Logger lifecycle hardening:**
  - Made debug and release logger setup idempotent by cancelling existing `Logger.root.onRecord` subscriptions before creating a new one.
  - Updated `disposeLogger()` to dispose both logger modes so tests and CLI debug switches cannot leave stale listeners alive.
  - Added a regression test proving repeated logger setup does not duplicate emitted records.

### Refactoring
- **Phased UI module split:**
  - Split `dashboard_shell.dart`, `glass_widgets.dart`, and `sample_components_view.dart` into focused part files while preserving existing widget tree, spacing, colors, and public imports.
  - Kept every Dart UI file under 800 lines for easier future review and maintenance.

### Documentation
- **Release documentation sync:**
  - Updated app version metadata, project About card, README, in-app About/User Guide strings, and release notes for GitHub Draft Release packaging.

---

## [v1.0.0] - 2026-09-04

### Initial Release
- **JA-HUB UI showcase foundation:**
  - Introduced Bento Grid overview, glass widgets, Dynamic Island capsule, Sliding Pill navigation, mobile dock navigation, live glass tuning, Command Palette, toast notifications, device filters, and telemetry sample views.
