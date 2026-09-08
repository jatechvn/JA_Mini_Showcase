TAG=v1.1.0
TITLE=JA Mini Showcase v1.1.0 - Interactive Terminal & Global Shortcuts Engine
BODY=
## JA Mini Showcase v1.1.0

This release introduces an Interactive Glass Terminal inspired by Fedora 44 Ptyxis, a comprehensive Global Keyboard Shortcuts Engine with Command Palette navigation, in-app documentation enhancements with direct external links, and 37 automated tests.

### 🚀 Major Features & Enhancements
- **Interactive Glass Terminal:**
  - Fedora 44 Ptyxis high-contrast styling with dark (Obsidian Velvet) and light (Adwaita Porcelain) themes.
  - Interactive command interpreter supporting `help`, `status`, `devices`, `ping`, `scan`, `theme`, `clear`, `echo`, `sysinfo`, and `exit`.
  - Arrow key history navigation (↑/↓), tab completion hints, auto-scroll toggle, and clipboard export.
  - Dedicated `Ctrl+L` shortcut to clear console output while preserving command history.
- **Global Keyboard Shortcuts Engine:**
  - Centralized shortcuts in `lib/modules/ui/app_shortcuts.dart` using Flutter `Shortcuts`/`Actions`.
  - `Ctrl+K` (Command Palette), `Ctrl+1..5` (Tab navigation), `Ctrl+,` (Settings), `Ctrl+Shift+L` (Theme toggle), `Ctrl+F` (Devices search focus), and `Esc` (Modal dismissal).
  - Platform-aware mapping for macOS (`Cmd`), with modal focus isolation preventing background actions during dialogs.
- **In-App Help & Navigation Refinements:**
  - Added Terminal documentation card to in-app User Guide tab with multilingual support (VI, EN, CN).
  - Added direct external links in About tab to JA Tech website (`https://jatechvn.github.io/`) and GitHub repository.
  - Smoothed TopBar hover scale expansion and mobile dock navigation.

### 🧪 Verification & Quality
- `dart analyze`: pass (0 issues)
- `dart format .`: pass
- `flutter test`: pass (37/37 automated tests passed)
