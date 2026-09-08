# Global Git Workflow Rules (Quy Trình Git Toàn Workspace)

Áp dụng cho mọi hoạt động quản lý mã nguồn qua Git:

1. **Chuẩn Định Dạng Commit (Semantic Commit Messages):**
   - Định dạng: `<type>(<scope>): <mô tả ngắn gọn>`
   - Các type chuẩn:
     - `feat`: Tính năng mới cho người dùng.
     - `fix`: Sửa lỗi (bug fix).
     - `refactor`: Tái cấu trúc mã nguồn (không đổi tính năng, không sửa bug).
     - `docs`: Cập nhật tài liệu (`README.md`, `ABOUT.txt`, `CHANGELOG.md`).
     - `chore`: Cập nhật cấu hình build, dependencies, tooling.
     - `style`: Định dạng code, dấu cách, dấu chấm phẩy...

2. **Vòng Kiểm Chứng Trước Khi Commit/Push (Pre-push Verification):**
   - Đảm bảo linter / analyzer đã chạy sạch lỗi (`dart analyze`, `cargo check`, `eslint`...).
   - Đảm bảo code đã được format chuẩn (`dart format`, `cargo fmt`, `prettier`...).
   - Đảm bảo các file cấu hình chứa token/secrets đã nằm trong `.gitignore`.

3. **Quản Lý Phiên Bản & Release (Semantic Versioning):**
   - Tuân thủ định dạng `MAJOR.MINOR.PATCH` (`v1.0.0`).
   - Luôn cập nhật `CHANGELOG.md` và đồng bộ số phiên bản trong file cấu hình (`pubspec.yaml`, `constants.dart`, `Cargo.toml`, `package.json`) trước khi gắn Tag/Release.
