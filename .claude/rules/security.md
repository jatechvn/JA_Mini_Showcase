# Global Security Rules (Luật Bảo Mật Toàn Workspace)

Áp dụng cho mọi dự án, mọi ngôn ngữ (Dart/Flutter, Rust, Python, JavaScript, C#, Shell...):

1. **Quản lý thông tin nhạy cảm (Secrets Management):**
   - TUYỆT ĐỐI KHÔNG hardcode API keys, tokens, mật khẩu, private keys hoặc chuỗi nhạy cảm trực tiếp trong mã nguồn.
   - Sử dụng biến môi trường (`.env`), cấu hình bên ngoài (`config.ini`/`config.json` nằm trong `.gitignore`), hoặc hệ thống quản lý bí mật (`SecretManagement`, Keyring).

2. **Xác thực dữ liệu đầu vào (Input Sanitization & Validation):**
   - Luôn kiểm tra và làm sạch tất cả dữ liệu từ người dùng hoặc API bên ngoài trước khi truyền vào câu lệnh SQL, shell script hoặc render UI.
   - Chống tấn công XSS, Command Injection, Path Traversal.

3. **Nguyên tắc quyền tối thiểu (Least Privilege):**
   - Hạn chế chạy các script hoặc lệnh với quyền Administrator/Root trừ khi thực sự cần thiết và phải được người dùng xác nhận.

4. **An toàn kết nối (Network & Transport Security):**
   - Luôn sử dụng HTTPS/TLS cho các kết nối mạng ra bên ngoài.
   - Xử lý chứng chỉ SSL hợp lệ, không tự ý vô hiệu hóa tính năng xác thực chứng chỉ (`rejectUnauthorized: false` hoặc tương đương).
