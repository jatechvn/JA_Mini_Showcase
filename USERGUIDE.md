# Hướng Dẫn Sử Dụng JA Mini Showcase v1.4.0

Tài liệu hướng dẫn cài đặt, cấu hình và sử dụng trọn bộ tính năng của **JA Mini Showcase v1.4.0** — Nền tảng trình diễn giao diện Bento Glassmorphism, Quản lý năng lượng tập trung AppPowerManager, Chế độ Ngủ Rảnh Tay (Hands-free Idle Sleep Mode), Chế độ Tiết kiệm Điện Năng Nâng Cao (0 FPS), Terminal tương tác và Cập nhật tự động OTA trên Windows Desktop.

---

## 📦 1. Cài Đặt & Khởi Chạy

### Cách 1: Sử dụng Bản Cài Đặt 1-Click (Khuyên Dùng)
1. Tải về gói nén: `JA_Mini_Showcase_v1.4.0_Windows_x64.zip`.
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
- Giải nén `JA_Mini_Showcase_v1.4.0_Windows_x64.zip` vào bất kỳ thư mục nào bạn muốn.
- Chạy trực tiếp tệp tin `ja_mini_showcase.exe`. Ứng dụng mang tính di động cao, không tạo file rác ngoài thư mục.

### Gỡ Cài Đặt (Uninstall)
- Vào Windows Settings > Apps > gỡ bỏ **JA Mini Showcase**, hoặc nhấp đúp vào `uninstall.bat` trong thư mục cài đặt.

---

## 🌿 2. Quản Lý Năng Lượng & Chế Độ Ngủ Rảnh Tay (Idle Sleep Mode)

Ứng dụng tích hợp kiến trúc quản lý năng lượng tập trung `AppPowerManager` 4 cấp độ:
- **Active (Hoạt động)**: Đầy đủ hoạt ảnh và hiệu ứng kính mờ thời gian thực khi người dùng đang tương tác.
- **Idle Sleep (Ngủ Rảnh Tay)**:
  - Khi không có thao tác chuột hoặc bàn phím sau một khoảng thời gian (mặc định 12 giây, tùy chọn 30s hoặc 60s), ứng dụng tự động dừng chuyển động nền `MeshOrb` để giảm tải GPU/CPU.
  - Các chỉ báo hoạt động (`WaveIndicator`, `BorderBeam`, `MarqueeText`) vẫn duy trì hiển thị để không làm gián đoạn mắt người xem.
  - Tùy chỉnh bật/tắt và chọn thời gian chờ ngay trong **Cài đặt (Ctrl+,) > Chế độ Ngủ Rảnh Tay (Idle Sleep Mode)**.
  - Hỗ trợ **Rollback on Cancel**: Nếu bạn đóng hộp thoại bằng phím `Esc` hoặc bấm Hủy, cấu hình sẽ hoàn nguyên về giá trị trước đó.
- **Efficiency Mode (Mất tiêu điểm / Blur)**:
  - Khi bạn bấm chuyển sang cửa sổ khác, toàn bộ hiệu ứng kính mờ (BackdropFilter = 0) và hoạt ảnh sẽ lập tức đóng băng, hạ mức tiêu thụ về đúng **0 FPS**.
  - Hoạt ảnh lưu trữ hướng di chuyển và tiếp tục mượt mà khi cửa sổ được kích hoạt lại (Direction Preservation).
  - Vị trí dòng chữ cuộn `AsymmetricMarqueeText` được đóng băng tức thì và bảo vệ chống trùng lặp timer callback (Session Epoch Guard).
- **Deep Sleep (Thu nhỏ xuống Taskbar / Minimized)**:
  - Tối ưu hóa sâu nhất, tạm dừng toàn bộ pipeline render khi cửa sổ bị ẩn.
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
