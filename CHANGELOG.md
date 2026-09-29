# CHANGELOG - JA Mini Showcase

All notable changes to **JA Mini Showcase** will be documented in this file.

---

## [v1.3.0] - 2026-09-29

### 🚀 Nâng cấp & Tính năng mới
- **🌿 Chế độ Tiết kiệm Điện Năng Nâng Cao (Low-Power Efficiency Sleep Mode - 0 FPS):**
  - Quản lý trạng thái focus cửa sổ qua `WindowFocusService` kết hợp hai tầng quan sát Native Win32 (`WindowListener`) và Flutter Lifecycle (`WidgetsBindingObserver`).
  - Tự động chuyển đổi về chế độ Sleep khi cửa sổ mất focus (unfocused/blurred) hoặc bị thu nhỏ xuống Taskbar (minimized).
  - Tự động tắt toàn bộ hiệu ứng kính mờ (Dynamic Zero-Blur: `cardBlur`, `dialogBlur`, `dropdownBlur` = 0.0) giúp GPU bỏ qua hoàn toàn các lệnh tính toán `BackdropFilter`.
  - Chuyển `GlassScaffold` sang nền màu đặc phẳng (`#0F172A` / `#F8FAFC`), ẩn toàn bộ đốm màu `MeshOrb` nhằm loại bỏ gánh nặng hòa trộn Alpha của Windows DWM.
  - Đóng băng 100% hoạt ảnh UI (`MeshOrb`, `WaveIndicator`, `BorderBeam`, `RotatingGlowBorder`, `AsymmetricMarqueeText`), hạ mức tiêu thụ render pipeline về đúng **0 FPS** và **~0% GPU**.
  - Tác vụ ngầm (kiểm tra cập nhật OTA qua mạng LAN, kết nối network) vẫn duy trì hoạt động 100% không bị gián đoạn.
  - Đèn báo trạng thái trực quan trên `DynamicIslandCapsule`: Chuyển sang biểu tượng lá xanh (`Icons.eco_rounded`), chữ `🌿 TIẾT KIỆM (0 FPS)` và phụ đề `Đã dừng hiệu ứng`.
  - Bổ sung lệnh phím tắt trong Command Palette (`Ctrl+K`): **"Thử nghiệm Chế độ Tiết kiệm Điện (0 FPS)"** giúp kích hoạt mô phỏng trực tiếp tức thì.
- **💎 Bộ Nhận Diện Thương Hiệu Mới & 3D Crystal Prism Logo:**
  - Thiết kế và đóng gói biểu tượng ứng dụng lăng kính thủy tinh 3D tinh xảo đa độ phân giải (`windows/runner/resources/app_icon.ico` và `assets/logo.ico`) chuẩn Windows gồm 256x256, 128x128, 64x64, 48x48, 32x32, 16x16.
  - Tích hợp biểu tượng lăng kính 3D phát quang (`assets/logo.png`) lên góc trên bên trái thanh Header chính của Dashboard và hộp thoại About / Settings.
  - Khai báo chuẩn `assets/` trong `pubspec.yaml`.
- **⚡ Tinh Chỉnh Giao Diện Cập Nhật OTA:**
  - Nâng cấp các tùy chọn cập nhật trong OTA từ dropdown list thành các nút chọn nhanh (Quick-action buttons) trực quan, giảm số thao tác click chuột.

### 🧪 Testing & Quality Assurance
- Bổ sung bộ kiểm thử chuyên sâu cho chế độ tiết kiệm điện:
  - `window_focus_service_test.dart` (7 tests).
  - `theme_efficiency_test.dart` (3 tests).
  - `animation_efficiency_test.dart` (2 tests).
- Đảm bảo 100% các bài test hồi quy tính năng cũ vượt qua thành công: **82/82 tests PASS**.
- `flutter analyze` đạt tuyệt đối `No issues found!`.

### 📦 Phát hành
- Đồng bộ version 1.3.0+5 trong `pubspec.yaml`, `lib/modules/constants.dart`, `ABOUT.txt`, `README.md`, `RELEASE_NOTES.md`, `USERGUIDE.md`.

---

## [v1.2.0] - 2026-09-21

### 🚀 Nâng cấp & Tính năng mới
- **📡 Corporate LAN Over-The-Air (OTA) Updates:**
  - Tích hợp module tự động cập nhật phiên bản qua mạng nội bộ LAN (`OtaUpdateService`) sử dụng đường dẫn chia sẻ SMB/UNC (`\\server\share`).
  - Hỗ trợ kết nối mạng UNC có xác thực (`net use`), kiểm tra mã băm SHA256 gói cập nhật và so sánh phiên bản chuẩn Semantic Versioning (`SemanticVersion`).
  - Kịch bản cập nhật nguyên tử `apply_update.bat` sử dụng Windows Robocopy tự động tắt tiến trình, ghi đè file nhị phân mới, tự động bảo lưu dữ liệu người dùng (`logs/`, cấu hình, `search_history.json`) và khởi động lại ứng dụng với cơ chế rollback khi lỗi.
  - Giao diện Bento Frosted Glass update dialog (`GlassUpdateDialog`) đồng bộ theme hiển thị thanh tiến trình download/extract, release notes dạng cuộn, nút thao tác trực quan.
  - Nút badge OTA dạng mở rộng động (`TopBarExpandingButton`) trên thanh tiêu đề TopBar tự động báo hiệu khi có bản cập nhật mới.
  - Bổ sung tab cấu hình OTA chuyên biệt trong cửa sổ Settings (`_SettingsOtaUpdateTab`) cho phép tùy chỉnh đường dẫn server, tài khoản kết nối, chu kỳ kiểm tra và nút test kết nối trực tiếp.
- **📦 Windows Desktop 1-Click Installer & Uninstaller Suite:**
  - Bộ cài đặt chuẩn Windows `install.bat` triển khai ứng dụng vào `%LOCALAPPDATA%\Programs\JA_Mini_Showcase` hoàn toàn không cần quyền Admin.
  - Tự động tạo Shortcut trên Desktop, thư mục Start Menu và đăng ký thông tin gỡ cài đặt vào Windows Control Panel (`HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall`).
  - Hỗ trợ cờ `/silent` cho phép quản trị viên IT triển khai hàng loạt tự động.
  - Bộ gỡ cài đặt thông minh `uninstall.bat` & `uninstall.ps1` tự động sao chép sang `%TEMP%` chống lỗi khóa file, hỏi xác nhận bảo lưu dữ liệu và dọn dẹp sạch registry/shortcuts.
- **⚡ Hardware-Adaptive Performance Tiers:**
  - Cơ chế nhận diện cấu hình phần cứng theo 3 cấp độ: `High` (máy mạnh - Full Mica/Acrylic blur & 60fps animations), `Balanced` (máy trung bình), `Low/Lite` (Mini PC / máy yếu - lược bỏ blur nặng, tối ưu render để chạy mượt mà không giật lag).
  - Tùy chọn chuyển đổi Performance Tier ngay trong Settings và TopBar.
- **🔍 Search History Repository & Glass Search Field:**
  - Triển khai `SearchHistoryRepository` lưu trữ lịch sử tìm kiếm người dùng vào file JSON cục bộ (`search_history.json`).
  - Widget `GlassSearchHistoryField` tích hợp gợi ý tìm kiếm gần đây với giao diện Frosted Glass và nút xóa nhanh.
- **🌐 Trilingual Localization Sync:**
  - Bổ sung đầy đủ chuỗi đa ngôn ngữ (Tiếng Việt, Tiếng Anh, Tiếng Trung) cho toàn bộ hệ thống OTA và Performance Tiers.

### 🧪 Testing & Quality Assurance
- **Mở rộng bộ kiểm thử tự động:**
  - Bổ sung `ota_update_service_test.dart` (37 test cases) kiểm tra SemVer, SMB connection, Robocopy generation và parameter formatting.
  - Bổ sung `search_history_repository_test.dart`, `glass_search_history_field_test.dart`, `glow_border_test.dart`, `language_perf_tier_test.dart`.
  - Tổng số unit/widget tests vượt qua: 70/70 tests (100% pass).
  - `flutter analyze` đạt tuyệt đối `No issues found!`.

### 📦 Phát hành
- Đồng bộ version 1.2.0+4 trong `pubspec.yaml`, `lib/modules/constants.dart`, `install.bat`, `build.bat`, `ABOUT.txt`, `README.md`, `RELEASE_NOTES.md`.

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
