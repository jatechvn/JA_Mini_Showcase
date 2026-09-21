TAG=v1.2.0
TITLE=JA Mini Showcase v1.2.0 - Corporate LAN OTA Updates, Desktop Installer Suite & Hardware Performance Tiers
BODY=
## JA Mini Showcase v1.2.0

Bản phát hành v1.2.0 mang đến hệ thống tự động cập nhật mạng nội bộ Corporate LAN OTA Updates, trọn bộ công cụ Cài đặt & Gỡ bỏ chuẩn Windows 1-Click (không cần Admin), cơ chế tối ưu hiệu năng Hardware Performance Tiers cho Mini PC, và kho lưu trữ lịch sử tìm kiếm Search History.

### 🚀 Nâng cấp & Tính năng chính
- **Corporate LAN Over-The-Air (OTA) Updates:**
  - Tích hợp `OtaUpdateService` kết nối UNC/SMB share (`net use` hỗ trợ credentials), phân tích Semantic Versioning và kiểm tra tính toàn vẹn gói cập nhật bằng mã băm SHA256.
  - Kịch bản tự cập nhật nguyên tử `apply_update.bat` dùng Robocopy tắt app, đè file nhị phân, bảo vệ toàn vẹn logs/configs và tự khởi động lại.
  - Dialog cập nhật Bento Frosted Glass đẹp mắt (`GlassUpdateDialog`) kèm thanh tiến trình và release notes.
  - Nút badge OTA mở rộng động trên TopBar và Tab cấu hình OTA chuyên biệt trong cửa sổ Settings.
- **Windows Desktop Installer & Uninstaller Suite:**
  - Bộ cài đặt 1-Click `install.bat` triển khai vào `%LOCALAPPDATA%\Programs\JA_Mini_Showcase` không cần quyền Admin, tạo Shortcut Desktop, Start Menu và đăng ký Windows Control Panel. Hỗ trợ tham số `/silent`.
  - Bộ gỡ bỏ `uninstall.bat` & `uninstall.ps1` staging qua `%TEMP%` chống lỗi khóa file, hỏi bảo lưu dữ liệu và dọn dẹp triệt để.
- **Hardware-Adaptive Performance Tiers:**
  - 3 cấp độ hiệu năng High / Balanced / Low (Lite) tự nhận diện phần cứng, tối ưu độ mờ kính (blur) và tốc độ vẽ để chạy mượt mà ngay cả trên Mini PC cấu hình thấp.
- **Search History & Glass Search Field:**
  - Lưu vết lịch sử tìm kiếm người dùng vào file JSON cục bộ kèm gợi ý dropdown và nút xóa nhanh.
- **Đồng bộ đa ngôn ngữ:**
  - Bổ sung bản dịch Tiếng Việt, Tiếng Anh, Tiếng Trung cho toàn bộ tính năng OTA và Performance Tiers.

### 🧪 Xác minh & Kiểm thử (Verification)
- `dart analyze`: Đạt tuyệt đối (0 issues)
- `dart format .`: Đã định dạng chuẩn
- `flutter test`: 70/70 tests passed (100%)
- Live installer verification: Đã kiểm thử cài đặt và gỡ cài đặt thành công trên môi trường Windows thực tế.

### 📦 Cài đặt
Giải nén file `JA_Mini_Showcase_v1.2.0_Windows_x64.zip`, chạy `install.bat` để cài đặt ứng dụng vào máy tính, hoặc chạy trực tiếp `ja_mini_showcase.exe` (bản portable sẵn sàng chạy ngay).
