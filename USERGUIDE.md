# Hướng Dẫn Sử Dụng JA Mini Showcase v1.3.0

Tài liệu hướng dẫn cài đặt, cấu hình và sử dụng trọn bộ tính năng của **JA Mini Showcase v1.3.0** — Nền tảng trình diễn giao diện Bento Glassmorphism, Chế độ Tiết kiệm Điện Năng Nâng Cao (0 FPS), Terminal tương tác và Cập nhật tự động OTA trên Windows Desktop.

---

## 📦 1. Cài Đặt & Khởi Chạy

### Cách 1: Sử dụng Bản Cài Đặt 1-Click (Khuyên Dùng)
1. Tải về gói nén: `JA_Mini_Showcase_v1.3.0_Windows_x64.zip`.
2. Giải nén toàn bộ thư mục.
3. Nhấp đúp chuột vào file `install.bat`.
   - Ứng dụng sẽ được cài đặt tự động vào `%LOCALAPPDATA%\Programs\JA_Mini_Showcase` (**hoàn toàn không cần quyền Quản trị viên / Admin**).
   - Tự động tạo Shortcut ngoài màn hình Desktop và thư mục trong Start Menu.
   - Tự động đăng ký mục gỡ cài đặt trong Windows Control Panel (`Settings > Apps > Installed apps`).
4. **Triển khai tự động cho Quản trị viên IT (Silent Install)**:
   ```cmd
   install.bat /silent
   ```

### Cách 2: Chạy Trực Tiếp (Portable Mode)
- Giải nén `JA_Mini_Showcase_v1.3.0_Windows_x64.zip` vào bất kỳ thư mục nào bạn muốn.
- Chạy trực tiếp tệp tin `ja_mini_showcase.exe`. Ứng dụng mang tính di động cao, không tạo file rác ngoài thư mục.

### Gỡ Cài Đặt (Uninstall)
- Vào Windows Settings > Apps > gỡ bỏ **JA Mini Showcase**, hoặc nhấp đúp vào `uninstall.bat` trong thư mục cài đặt.

---

## 🌿 2. Chế Độ Tiết Kiệm Điện Năng (Low-Power Sleep Mode - 0 FPS)

Ứng dụng tích hợp công nghệ tối ưu hóa năng lượng tự động:
- **Tự động kích hoạt**: Khi cửa sổ ứng dụng mất tiêu điểm (bấm sang Chrome/Notepad/Word...) hoặc khi thu nhỏ xuống Taskbar:
  - Tắt hoàn toàn hiệu ứng kính mờ (BackdropFilter = 0).
  - Đóng băng 100% hoạt ảnh UI (Wave, Orbs, Laser beam, Marquee).
  - Tốc độ khung hình hạ xuống đúng **0 FPS** và mức tiêu thụ GPU rơi về **0.0%**.
- **Đèn báo trạng thái trực quan**: Viên nang trạng thái trên Header chuyển sang biểu tượng lá xanh `Icons.eco_rounded` cùng dòng chữ `🌿 TIẾT KIỆM (0 FPS)`.
- **Thử nghiệm thủ công**: Bấm `Ctrl + K` > chọn **"Thử nghiệm Chế độ Tiết kiệm Điện (0 FPS)"** để quan sát sự chuyển đổi trực tiếp trên màn hình.

---

## ⌨️ 3. Phím Tắt Tiện Ích Toàn Cục (Global Shortcuts)

| Phím Tắt | Chức Năng |
| :--- | :--- |
| **`Ctrl + K`** | Mở **Command Palette** (Thanh tìm kiếm lệnh nhanh 1-Click) |
| **`Ctrl + 1` .. `5`** | Chuyển nhanh giữa 5 Tab (Tổng quan, Components, Terminal, Thiết bị, Hiệu năng) |
| **`Ctrl + Shift + L`** | Chuyển đổi giao diện Sáng (Light) / Tối (Dark) |
| **`Ctrl + ,`** | Mở bảng Cài đặt hệ thống (Settings Dialog) |
| **`Ctrl + F`** | Đặt con trỏ chuột vào ô Tìm kiếm thiết bị (Search field) |
| **`Ctrl + L`** | Xóa màn hình Terminal (giữ nguyên lịch sử lệnh) |
| **`Esc`** | Đóng hộp thoại, menu dropdown hoặc thoát Command Palette |

---

## 📡 4. Tự Động Cập Nhật Qua Mạng Nội Bộ (Corporate LAN OTA)

- **Cấu hình đường dẫn**: Trong `Settings > Cập nhật OTA`, cấu hình đường dẫn chia sẻ mạng nội bộ SMB/UNC (mặc định: `\\10.81.141.226\temp\FBT\JA_PROJECT\JA_Update\JA_Mini_Showcase`).
- **Nút chọn nhanh**: Bản phát hành v1.3.0 cung cấp các nút chọn nhanh trực quan để chuyển đổi phiên bản.
- **Cập nhật nguyên tử**: Khi có bản mới, ứng dụng tự động kiểm tra mã băm SHA256, chạy kịch bản `apply_update.bat` sao chép nhị phân và tự khởi động lại an toàn, bảo tồn toàn vẹn dữ liệu cá nhân (`search_history.json`, `logs/`).
