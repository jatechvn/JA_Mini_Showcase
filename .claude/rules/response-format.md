# Quy tắc Phản hồi & Gợi ý tự động (Global Rule)

Áp dụng cho tất cả các workspace và dự án:

1. Cuối mỗi câu trả lời của AI, bắt buộc phải đính kèm phần **Gợi ý bước tiếp theo & Skill liên quan**.
2. Phần gợi ý phải chứa từ 2-4 gợi ý hành động (prompt mẫu) ngắn gọn, phù hợp với ngữ cảnh hiện tại.
3. Với mỗi câu gợi ý, phải kèm theo tên cụ thể của **Skill** sẽ tự động kích hoạt khi người dùng chọn/gõ câu lệnh đó.

Cấu trúc định dạng mẫu:
```markdown
---
### 💡 Gợi ý bước tiếp theo & Skill liên quan:

* **Gợi ý 1:** "[Nội dung prompt mẫu 1]"
  * 🛠️ Skill kích hoạt: `[ten-skill-1]`

* **Gợi ý 2:** "[Nội dung prompt mẫu 2]"
  * 🛠️ Skill kích hoạt: `[ten-skill-2]`
```
