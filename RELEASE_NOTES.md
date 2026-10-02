TAG=v1.4.0
TITLE=JA Mini Showcase v1.4.0 - AppPowerManager, Idle Sleep Mode & Motion Stabilization
BODY=
## JA Mini Showcase v1.4.0

Bản phát hành v1.4.0 nâng cấp toàn diện hệ thống quản lý năng lượng với `AppPowerManager` tập trung, chế độ Ngủ Rảnh Tay (Hands-free Idle Sleep Mode), bảo toàn hướng chuyển động (Direction Preservation) triệt tiêu giật hình, và bảo vệ phiên cuộn văn bản (Session Epoch Guard).

### 🚀 Nâng cấp & Tính năng chính
- **Single Source of Truth `AppPowerManager`:**
  - Quản lý tập trung 4 tầng trạng thái năng lượng: **Active**, **Idle Sleep**, **Efficiency/Blur**, và **Deep Sleep/Minimized**.
  - Phân tách 3 ValueNotifier độc lập điều khiển các nhóm hoạt ảnh khác nhau, tối ưu năng lượng thông minh.
- **Chế Độ Ngủ Rảnh Tay (Hands-free Idle Sleep Mode):**
  - Tự động phát hiện khi người dùng không tương tác qua hệ thống Listener toàn cục (throttled 600ms).
  - Tự động chuyển hiệu ứng nền `MeshOrb` về trạng thái nghỉ sau 12s (hoặc 30s/60s tùy chọn) giúp giảm tải GPU/CPU tối đa mà giao diện vẫn sống động.
  - Tích hợp giao diện bật/tắt và chọn thời gian chờ trong hộp thoại Cài đặt (Settings), hỗ trợ Rollback on Cancel.
- **Bảo Toàn Hướng Chuyển Động (Direction Preservation):**
  - `MeshOrb` và `WaveIndicator` lưu trữ hướng di chuyển và tiếp tục mượt mà từ đúng offset hiện tại khi tiếp tục chạy, loại bỏ hiện tượng giật giật (visual jitter).
- **Session Epoch Guard & Đóng Băng Cuộn (Marquee Offset Freeze):**
  - Đóng băng vị trí cuộn `jumpTo(currentOffset)` của `AsymmetricMarqueeText` khi ứng dụng mất focus, tăng số hiệu phiên `_sessionEpoch` loại bỏ hoàn toàn hiện tượng callback ma (ghost callbacks).
- **Khắc Phục Lỗi Native Win32 Focus:**
  - Sửa lỗi `WM_ACTIVATE` trong `win32_window.cpp` tránh chiếm tiêu điểm sai khi cửa sổ đang ở trạng thái inactive.
- **Đồng Bộ Đa Ngôn Ngữ:**
  - Hỗ trợ đầy đủ Tiếng Việt, Tiếng Anh và Tiếng Trung cho toàn bộ cài đặt Idle Sleep.

### 🧪 Xác minh & Kiểm thử (Verification)
- `dart analyze`: Đạt tuyệt đối **0 issues found!**
- `dart format .`: Đã định dạng chuẩn
- `flutter test`: **98/98 tests passed (100%)**

### 📦 Cài đặt
Giải nén file `JA_Mini_Showcase_v1.4.0_Windows_x64.zip`, chạy `install.bat` để cài đặt ứng dụng vào máy tính, hoặc chạy trực tiếp `ja_mini_showcase.exe` (bản portable sẵn sàng chạy ngay).
