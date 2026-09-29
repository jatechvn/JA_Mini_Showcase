TAG=v1.3.0
TITLE=JA Mini Showcase v1.3.0 - Low-Power Efficiency Sleep Mode (0 FPS) & 3D Crystal Branding
BODY=
## JA Mini Showcase v1.3.0

Bản phát hành v1.3.0 mang đến Chế độ Tiết kiệm Điện Năng Nâng Cao (Low-Power Efficiency Sleep Mode - 0 FPS) đóng băng hoạt ảnh và tắt blur khi ứng dụng không active, Bộ nhận diện thương hiệu 3D Crystal Prism Logo mới đa độ phân giải, và các nút chọn nhanh OTA tiện lợi.

### 🚀 Nâng cấp & Tính năng chính
- **Low-Power Efficiency Sleep Mode (0 FPS):**
  - Quản lý trạng thái focus cửa sổ qua `WindowFocusService` (kết hợp `WindowListener` native Win32 và `WidgetsBindingObserver` Flutter lifecycle).
  - Tự động tắt toàn bộ hiệu ứng kính mờ (Dynamic Zero-Blur: `cardBlur`, `dialogBlur`, `dropdownBlur` = 0.0) khi mất focus hoặc thu nhỏ xuống taskbar, giải phóng hoàn toàn gánh nặng GPU `BackdropFilter`.
  - Nền chuyển sang màu phẳng đặc, ẩn các quả cầu `MeshOrb` để triệt tiêu chi phí pha trộn alpha của Windows DWM.
  - Đóng băng 100% hoạt ảnh UI (`MeshOrb`, `WaveIndicator`, `BorderBeam`, `RotatingGlowBorder`, `AsymmetricMarqueeText`), hạ mức tiêu thụ render pipeline về đúng **0 FPS** và **~0% GPU**.
  - Các tác vụ ngầm (OTA LAN update, network sockets) vẫn duy trì hoạt động 100% không bị ngắt.
  - Đèn báo trạng thái trực quan trên `DynamicIslandCapsule`: Biểu tượng lá xanh (`Icons.eco_rounded`), dòng chữ `🌿 TIẾT KIỆM (0 FPS)` và phụ đề `Đã dừng hiệu ứng`.
  - Phím tắt mô phỏng nhanh trong Command Palette (`Ctrl+K`): **"Thử nghiệm Chế độ Tiết kiệm Điện (0 FPS)"**.
- **3D Crystal Prism Logo & Brand Identity:**
  - Biểu tượng ứng dụng lăng kính thủy tinh 3D tinh xảo đa độ phân giải (`app_icon.ico` & `logo.ico`: 256, 128, 64, 48, 32, 16 px).
  - Tích hợp logo 3D sắc nét (`logo.png`) vào góc trên bên trái thanh Header chính của Dashboard và hộp thoại About / Settings.
- **OTA Quick Selection Buttons:**
  - Cải tiến giao diện chọn phiên bản cập nhật OTA từ danh sách dropdown sang các nút chọn nhanh (Quick-action buttons).

### 🧪 Xác minh & Kiểm thử (Verification)
- `dart analyze`: Đạt tuyệt đối (0 issues)
- `dart format .`: Đã định dạng chuẩn
- `flutter test`: 82/82 tests passed (100%)

### 📦 Cài đặt
Giải nén file `JA_Mini_Showcase_v1.3.0_Windows_x64.zip`, chạy `install.bat` để cài đặt ứng dụng vào máy tính, hoặc chạy trực tiếp `ja_mini_showcase.exe` (bản portable sẵn sàng chạy ngay).
