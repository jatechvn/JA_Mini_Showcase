# Hướng dẫn sử dụng Skills cho Antigravity / Claude Code

Bộ tài liệu này hướng dẫn cách sử dụng các AI Skills tùy chỉnh được thiết kế đặc biệt cho dự án Flutter/Dart (`PROJECT_DART/dart_sample/`). Các skill này sẽ biến trợ lý AI của bạn (Antigravity/Claude Code) thành một lập trình viên phụ việc đắc lực, tự động hóa các tác vụ lặp đi lặp lại.

## Cách thức hoạt động (Architecture)

### Vị trí lưu trữ & Nạp tự động
Mỗi project có 3 bản skill:
- `skills/` — **bản gốc/soạn thảo** (không được agent tự động quét)
- `.agents/skills/` — **Antigravity** tự động nạp từ đây khi mở project
- `.claude/skills/` — **Claude Code** tự động nạp từ đây khi mở project

⚠️ **Khi bạn tạo/sửa skill mới**, nhớ:
1. Chỉnh sửa file gốc trong `skills/` folder
2. Copy đè sang `.agents/skills/` (để Antigravity thấy)
3. Copy đè sang `.claude/skills/` (để Claude Code thấy)

Nếu chỉ sửa trong `skills/` mà quên copy, agent sẽ không nhận thấy thay đổi.

### Kích hoạt Skill
Mỗi skill có mục `description` — agent quét description này để quyết định khi nào kích hoạt skill:

```yaml
---
name: dart-cleaner
description: Kỹ năng tự động dọn dẹp, định dạng và tối ưu mã nguồn Dart/Flutter. Kích hoạt khi người dùng muốn dọn dẹp code, fix lỗi linter hoặc refactor code.
---
```

Khi bạn hỏi gì đó như:
- "Dọn dẹp lại code cho tôi" → description của `dart-cleaner` khớp → skill kích hoạt tự động
- "Hãy build app cho Windows" → description của `dart-build-pro` khớp → skill kích hoạt tự động

Bạn không cần gõ `/dart-cleaner` hay `/dart-build-pro` (khác với `/code-review` command) — chỉ nói bằng tiếng tự nhiên, agent tự khớp từ khóa.

## Danh sách các Skills có sẵn

### 1. `dart-build-pro`
- **Mô tả:** Tự động biên dịch, đóng gói ứng dụng Flutter Windows Desktop và tạo file ZIP release.
- **Cách dùng:** Yêu cầu AI: *"Hãy build app này cho Windows và đóng gói release"*.

### 2. `new-release`
- **Mô tả:** Đọc file `RELEASE_NOTES.md` và tự động tạo bản Draft Release trên GitHub, đính kèm file ZIP.
- **Cách dùng:** Yêu cầu AI: *"Hãy tạo một bản release mới trên GitHub dựa trên code hiện tại"*.

### 3. `auto-changelog`
- **Mô tả:** Phân tích lịch sử Git commit từ bản release trước để tự động viết file `RELEASE_NOTES.md`.
- **Cách dùng:** Yêu cầu AI: *"Hãy viết release notes từ tag gần nhất"* (Thực hiện bước này TRƯỚC khi gọi `new-release`).

### 4. `dart-cleaner`
- **Mô tả:** Dọn dẹp imports thừa, thêm `const`, định dạng lại toàn bộ code bằng `dart analyze` và `dart format`.
- **Cách dùng:** Yêu cầu AI: *"Dọn dẹp lại code cho tôi"*.

### 5. `flutter-l10n-sync`
- **Mô tả:** Hỗ trợ quét và tự động dịch các file ngôn ngữ `.arb` để hỗ trợ đa ngôn ngữ.
- **Cách dùng:** Yêu cầu AI: *"Hãy đồng bộ và dịch file l10n sang tiếng Anh"*.

### 6. `feature-scaffold`
- **Mô tả:** Tạo nhanh cấu trúc thư mục và file nền tảng (boilerplate) cho một tính năng mới chuẩn Clean Architecture.
- **Cách dùng:** Yêu cầu AI: *"Tạo cho tôi thư mục tính năng Thanh toán (payment) bằng Riverpod"*.

### 7. `asset-manager`
- **Mô tả:** Quản lý hình ảnh/icon, tự động cập nhật vào `pubspec.yaml` và sinh ra class tĩnh `app_assets.dart` để tái sử dụng.
- **Cách dùng:** Yêu cầu AI: *"Cập nhật lại assets vào pubspec và tạo file hằng số asset giúp tôi"*.

### 8. `flutter-debugger`
- **Mô tả:** Gỡ lỗi (fix bug) theo phương pháp "Giả thuyết" (Hypothesis-driven), giúp tìm gốc rễ vấn đề thay vì đoán code sửa lỗi bừa.
- **Cách dùng:** Yêu cầu AI: *"Hãy phân tích lỗi này dựa trên phương pháp giả thuyết"*.

### 9. `flutter-project-rules`
- **Mô tả:** Đóng vai trò là hệ thống nội quy ngầm (System Prompt) cho dự án, ép AI tuân thủ Clean Architecture, Null Safety và tối ưu hiệu năng (const).
- **Cách dùng:** Tự động kích hoạt khi bạn yêu cầu tạo tính năng mới hoặc yêu cầu: *"Hãy refactor đoạn code này chuẩn theo project rules"*.

### 10. `flutter-app-blueprint`
- **Mô tả:** Đặc tả kiến trúc & cấu trúc thư mục chuẩn cho dự án Flutter Desktop — là **nguồn sự thật duy nhất**, gộp cả 4 biến thể mẫu cũ (`key`/`nokey` × `fvm`/no-fvm) vào một tài liệu duy nhất bằng cơ chế baseline + 2 phụ lục (License Key, FVM).
- **Cách dùng:** Yêu cầu AI: *"Hãy tạo dự án Flutter mới theo blueprint"*. AI sẽ tự hỏi bạn 2 câu (có License Key không? có dùng FVM không?) trước khi áp dụng đúng biến thể, thay vì bạn phải tự chọn 1 trong 4 file mẫu.

### 11. `flutter-windows-themer`
- **Mô tả:** Hướng dẫn tùy biến giao diện cửa sổ Windows 10/11 (Acrylic/Aero Blur), single-instance mutex và tối ưu hiệu năng giao diện kính mờ (Glassmorphism).
- **Cách dùng:** Yêu cầu AI: *"Hãy áp dụng theme cửa sổ Windows 11 kiểu Acrylic cho app"*.

### 12. `flutter-mobile-build-pro`
- **Mô tả:** Build, ký (sign) và đóng gói ứng dụng cho Android (APK/AAB) và iOS (IPA) — tương đương `dart-build-pro` nhưng cho mobile.
- **Cách dùng:** Yêu cầu AI: *"Hãy build file APK/AAB cho Android"* hoặc *"Hướng dẫn đóng gói iOS release"*.

### 13. `flutter-linux-packager`
- **Mô tả:** Build và đóng gói ứng dụng Linux Desktop thành `.deb`, `.rpm` hoặc AppImage.
- **Cách dùng:** Yêu cầu AI: *"Hãy tạo AppImage cho app này"* hoặc *"Đóng gói bản release Linux"*.

### 14. `flutter-macos-packager`
- **Mô tả:** Build, codesign, đóng gói `.dmg` và notarize ứng dụng macOS Desktop.
- **Cách dùng:** Yêu cầu AI: *"Hãy tạo file dmg cho macOS"* hoặc *"Hướng dẫn codesign và notarize app macOS"*.

### 15. `python-build-pro`
- **Mô tả:** Quy trình chuẩn hóa biên dịch, đóng gói và bảo vệ mã nguồn ứng dụng Python Desktop bằng PyInstaller, Nuitka và Cython.
- **Cách dùng:** Yêu cầu AI: *"Build app Python sang file exe"* hoặc *"Biên dịch mã nguồn Python sang .pyd bằng Cython"*.

### 16. `app-docs-prep`
- **Mô tả:** Tự động chuẩn bị và cập nhật các file tài liệu `ABOUT.txt`, `README.md`, `CHANGELOG.md`, Hướng dẫn sử dụng, kiểm tra đồng bộ `version`, và kiểm tra `.gitignore` (build output, `.claude/`, secrets) trước khi đẩy (push) code lên GitHub.
- **Cách dùng:** Yêu cầu AI: *"Hãy cập nhật tài liệu ABOUT và README để chuẩn bị đẩy GitHub"*.

### 17. `permissioned-github`
- **Mô tả:** Hướng dẫn tương tác với GitHub (gh CLI, git remote, push/pull) và cách xin phép người dùng khi lệnh bị chặn do giới hạn quyền của môi trường agent.
- **Cách dùng:** Tự động kích hoạt khi thao tác git/GitHub gặp lỗi quyền hoặc cần xác nhận trước khi push/tạo PR.

## Nhóm Skills 9Router (AI Gateway & Multi-modal)
Bao gồm bộ công cụ kết nối và điều phối AI API chuẩn OpenAI/Anthropic:
- `9router`: Cấu hình Gateway và điều phối tổng thể.
- `9router-chat`: Chat completions, sinh mã nguồn với auto-fallback.
- `9router-embeddings`: Vector embeddings phục vụ RAG / Semantic Search.
- `9router-image`: Sinh ảnh AI (DALL-E, FLUX, Imagen, SD...).
- `9router-tts`: Text-to-Speech (chuyển văn bản thành giọng nói).
- `9router-stt`: Speech-to-Text (chuyển âm thanh thành văn bản qua Whisper).
- `9router-web-search`: Tìm kiếm web thời gian thực.
- `9router-web-fetch`: Bóc tách nội dung URL thành Markdown sạch.

## Skills ở `PROJECT_Hybrid/_sample/` (dùng chung cho đa platform)

### 1. `rust-native-core` (📍 `PROJECT_Hybrid/_sample/skills/rust-native-core/`)
- **Mô tả:** Hướng dẫn viết lõi compute bằng Rust dùng chung cho 5 nền tảng (Windows/Linux/macOS/Android/iOS) và cross-compile từng target. Skill này được đặt ở `PROJECT_Hybrid` vì logic Rust độc lập với framework UI (có thể dùng từ Flutter, Tauri, hoặc bất kỳ stack nào có FFI).
- **Khi nào dùng:** Bạn muốn tối ưu hiệu năng bằng native code, xử lý audio/video, mã hoá, ML inference, hoặc thuật toán tính toán lớn → cần lõi Rust chung.
- **Cách dùng:** Yêu cầu AI: *"Viết lõi Rust cho app đa nền tảng"* hoặc *"Setup FFI Dart-Rust"* → Agent hỏi nền tảng mục tiêu, rồi hướng dẫn cross-compile tương ứng.

## Bộ công cụ Everything-Claude-Code (ECC Toolkit)

Bộ công cụ quy trình chuẩn Kỹ sư phần mềm được đóng gói gọn gàng trong thư mục `skills/everything-claude-code/`. Dùng cho mọi dự án (Web, Mobile, Backend).

### 1. Nhóm Agent Cốt lõi (`ecc-agent-*`)
- **Mô tả:** Các đặc vụ chuyên môn hóa sâu (Subagents). Bao gồm `planner` (Lên kế hoạch), `architect` (Thiết kế kiến trúc), `build-error-resolver` (Chuyên gia fix lỗi build/deploy), `code-reviewer` (Kiểm tra chất lượng & bảo mật).
- **Cách dùng:** Gọi trực tiếp tên đặc vụ. Ví dụ: *"Hãy dùng ecc-agent-planner lên kế hoạch làm tính năng login"* hoặc *"Hãy gọi ecc-agent-build-error-resolver để fix lỗi CI/CD"*.

### 2. Nhóm Tối ưu Quy trình (`ecc-strategic-compact`, `ecc-continuous-learning`)
- **Mô tả:** Cải thiện trí nhớ và luồng làm việc của AI. `strategic-compact` giúp nén ngữ cảnh khi chat log quá dài tránh tràn RAM/ngáo AI. `continuous-learning` ép AI rút ra bài học sau khi fix bug.
- **Cách dùng:** Yêu cầu AI: *"Hãy nén ngữ cảnh (compact context)"* hoặc *"Hãy tổng hợp bài học sau khi fix xong bug này"*.

### 3. Nhóm Quy tắc Pattern (`ecc-rule-git-workflow`, `ecc-frontend-patterns`, `ecc-backend-patterns`)
- **Mô tả:** Chuẩn hóa quy trình Git, best practices cho giao diện Frontend (State, Responsive, Accessibility) và kiến trúc Backend (Clean Architecture, API contracts, Resilience).
- **Cách dùng:** Tự động kích hoạt khi thiết kế kiến trúc Frontend/Backend hoặc commit code.

## Skills Điều phối & Hướng dẫn sử dụng Antigravity (Meta-skills & Orchestrator)

### 1. `antigravity-orchestrator`
- **Mô tả:** Chuyên gia điều phối bầy subagent đa nhiệm (Multi-subagent Swarm), cấu hình vùng làm việc cô lập (branch/share workspace), định tuyến model động (`flash`/`pro`), và quản lý tác vụ nền bất đồng bộ (background tasks & watchdog timers).
- **Cách dùng:** Yêu cầu AI: *"Hãy phân tích bài toán lớn này thành các subagent chạy song song"* hoặc *"Lên kịch bản điều phối subagents"*.

### 2. `agy-customizations`
- **Mô tả:** Hướng dẫn đầy đủ về hệ thống tùy biến của Antigravity (skills, rules, plugins, hooks, MCP servers) — thứ tự nạp, cơ chế discovery, cách tạo mới.
- **Cách dùng:** Yêu cầu AI: *"Antigravity nạp custom skill theo thứ tự ưu tiên nào?"* hoặc *"Hướng dẫn tôi tạo MCP server cho Antigravity"*.

### 3. `antigravity-guide` (thư mục `antigravity_guide/`)
- **Mô tả:** Sitemap & quick reference toàn bộ hệ sinh thái Antigravity (AGY) — CLI `agy`, Antigravity 2.0, IDE, Python SDK, slash commands, keybindings.
- **Cách dùng:** Yêu cầu AI: *"Antigravity CLI có lệnh gì?"* hoặc *"Sitemap của Antigravity IDE"*.

---


## Ghi chú đa nền tảng

`PROJECT_Hybrid/_sample/` chứa:
- `CROSS_PLATFORM_STACK_GUIDE.md` — kiến trúc tổng thể cho app chạy trên cả 5 nền tảng (Windows, Linux, macOS, Android, iOS)
- `LINUX_STACK_GUIDE.md` — variant hẹp cho Linux-only (nếu bạn chỉ target Linux Desktop)
- `skills/rust-native-core/` — skill dùng chung viết lõi Rust cross-platform

Nó tương tác với `flutter-app-blueprint` ở `PROJECT_DART/dart_sample/skills/` (Phụ lục C & D).

---

## Sử dụng với Antigravity

Mở project folder trong Antigravity IDE, hãy yêu cầu gì đó tự nhiên:

```
Hãy dọn dẹp lại code cho tôi
```

Antigravity sẽ:
1. Quét `.agents/skills/` và tìm `dart-cleaner/SKILL.md` có description khớp
2. Nạp file đó làm hướng dẫn bổ sung cho agent
3. Thực hiện quy trình: `dart analyze` → `dart fix --apply` → `dart format .` → báo cáo kết quả

## Sử dụng với Claude Code (trên máy này)

Claude Code cũng tự động nạp skill từ `.claude/skills/` khi mở project:

```
Dọn dẹp code cho tôi
```

Cơ chế tương tự Antigravity — Claude nạp skill từ `.claude/skills/dart-cleaner/SKILL.md` và thực hiện.

**Khác biệt:** Claude Code tích hợp với local shell (Bash/PowerShell) tốt hơn Antigravity, nên một số skill (build, release) chạy nhanh hơn trên Claude Code.

## Workflow khi chỉnh sửa Skill

1. **Mở file** `skills/<skill-name>/SKILL.md` trong thư mục này
2. **Chỉnh sửa** nội dung hoặc description
3. **Copy → .agents/skills/** — `cp -r skills/<skill-name> .agents/skills/`
4. **Copy → .claude/skills/** — `cp -r skills/<skill-name> .claude/skills/`
5. **Reload** Antigravity/Claude Code để nó nạp phiên bản mới (thường tự động, hoặc restart IDE)

Nếu chỉ sửa trong `skills/` mà quên copy, agent sẽ không thấy thay đổi.

## Luật nền luôn-bật (không cần kích hoạt theo từ khóa)

Ngoài skill cần kích hoạt theo description, project này và toàn workspace còn có:
- [`AGENTS.md`](AGENTS.md) — luật Dart/Flutter bắt buộc (const widget, no flutter clean, null-safety, analyze trước khi báo xong...)
- `~/.claude/rules/security.md` — luật bảo mật (không hardcode secret, XSS prevention, CSRF protection...)
- `~/.claude/rules/coding-style.md` — luật code quality (immutability, file size, error handling...)
- `~/.claude/rules/git-workflow.md` — luật git workflow (commit message format, PR process...)
- `~/.claude/agents/code-reviewer.md` — subagent chuyên review code chất lượng
- `~/.claude/agents/security-reviewer.md` — subagent chuyên security audit

Những luật này **không cần bạn nhắc lại** — agent tự đọc từ `AGENTS.md` + global rules khi mở project và áp dụng cho mọi request.
