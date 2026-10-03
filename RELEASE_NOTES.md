TAG=v1.4.1
TITLE=JA Mini Showcase v1.4.1 - Native Window Title Branding & PE Metadata Standardization
BODY=
## JA Mini Showcase v1.4.1

Bản phát hành v1.4.1 chuẩn hóa toàn diện tiêu đề cửa sổ hệ sinh thái và thông tin tệp thực thi Windows PE Metadata (Properties/Task Manager) hiển thị đồng nhất tên thương hiệu `JA Mini Showcase` thay vì tên file thực thi `ja_mini_showcase.exe`.

### 🚀 Nâng cấp & Tính năng chính
- **Chuẩn Hóa Tiêu Đề Cửa Sổ (Native Window Title):**
  - Đồng bộ tiêu đề cửa sổ hệ thống hiển thị chính xác tên thương hiệu `JA Mini Showcase` trên tất cả các phiên bản Windows (Windows 10/11) thay vì tên file exe `ja_mini_showcase.exe`.
  - Loại bỏ hoàn toàn điều kiện làm rỗng tiêu đề `MaterialApp.title` và `CreateWindow`, đảm bảo thanh Taskbar, Task Manager và Alt+Tab nhận diện tên app rõ ràng.
  - Tự động gọi `windowManager.setTitle('JA Mini Showcase')` khi khởi tạo ứng dụng.
- **Chuẩn Hóa Windows Executable Metadata (Runner.rc):**
  - Cập nhật trường `FileDescription` và `ProductName` thành `JA Mini Showcase`.
  - Cập nhật `CompanyName` và `LegalCopyright` thành `JA-Tech System`.

### 🧪 Xác minh & Kiểm thử (Verification)
- `dart analyze`: Đạt tuyệt đối **0 issues found!**
- `dart format .`: Đã định dạng chuẩn toàn bộ codebase
- `flutter test`: **98/98 tests passed (100%)**

### 📦 Cài đặt
Giải nén file `JA_Mini_Showcase_v1.4.1_Windows_x64.zip`, chạy `install.bat` để cài đặt ứng dụng vào máy tính, hoặc chạy trực tiếp `ja_mini_showcase.exe` (bản portable sẵn sàng chạy ngay).
