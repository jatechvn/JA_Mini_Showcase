# Global Coding Style Rules (Luật Phong Cách Mã Nguồn Toàn Workspace)

Áp dụng cho mọi ngôn ngữ lập trình trong workspace:

1. **Nguyên tắc Thiết kế (Design Principles):**
   - Tuân thủ nguyên tắc SOLID và Clean Architecture: phân tách rõ ràng giữa UI (Presentation), Logic (Business Logic), và Dữ liệu (Data/Repository).
   - Single Responsibility: Mỗi file và hàm chỉ thực hiện một nhiệm vụ duy nhất, rõ ràng và có thể kiểm thử độc lập.

2. **Khả năng Đọc & Bảo trì (Readability & Maintainability):**
   - Đặt tên biến, hàm, class có ý nghĩa, mang tính mô tả cao, tuân thủ quy ước đặt tên của từng ngôn ngữ (camelCase trong Dart/JS, snake_case trong Python/Rust, PascalCase trong C#).
   - Viết ghi chú (comments/docstrings) giải thích lý do "tại sao" (why) cho các đoạn logic phức tạp thay vì chỉ mô tả lại "nó làm gì" (what).

3. **Tính Bất biến & Hiệu năng (Immutability & Performance):**
   - Ưu tiên tính bất biến (`const`, `final`, `readonly`) bất cứ khi nào có thể để tối ưu bộ nhớ và tránh side-effects.
   - Hạn chế tối đa các biến toàn cục (global state) không kiểm soát.

4. **Xử lý Lỗi Chặt chẽ (Robust Error Handling):**
   - Luôn bao bọc các thao tác tiềm ẩn rủi ro (I/O, Network, Parse, FFI) bằng các khối `try/catch` có xử lý lỗi và ghi log cụ thể.
   - Không nuốt lỗi âm thầm (silent fail) hoặc để catch rỗng.
