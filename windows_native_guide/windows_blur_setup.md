# 🪟 Kiến Trúc Kính Mờ Xuyên Thấu Windows 10 & Windows 11 (Học từ JA_MES_Tool)

Để ứng dụng Flutter Desktop trên Windows đạt chuẩn kính mờ cao cấp nhất (**Desktop Acrylic trên Windows 11** và **Aero Blur 0ms lag trên Windows 10**), kiến trúc chuẩn mực nhất là **cấu hình trực tiếp tại tầng C++ Native Runner** thay vì dùng các package Dart như `flutter_acrylic`.

---

## ⚡ 1. Vì Sao Cấu Hình Trực Tiếp Tại C++ Runner Là Chuẩn Nhất?

1. **Hiển thị kính mờ ngay từ Frame đầu tiên (Zero-flicker Startup)**:
   - Khi khởi động, cửa sổ C++ (`CreateWindow`) lập tức được phủ kính mờ DWM trước khi Flutter Engine nạp xong. Không có hiện tượng chớp nháy từ nền trắng sang nền mờ.
2. **Khắc phục triệt để lỗi "Giao diện đục" của Mica trên Windows 11**:
   - `theme_win11.cpp` kích hoạt trực tiếp `DWMSBT_TRANSIENTWINDOW (Acrylic = 3)` kết hợp `DwmExtendFrameIntoClientArea(hwnd, {-1,-1,-1,-1})`.
   - Mang lại hiệu ứng kính mờ xuyên thấu Desktop Acrylic đích thực, không bị đục xám như vật liệu Mica (`DWMSBT_MAINWINDOW = 2`).
3. **Triệt tiêu hoàn toàn độ trễ kéo cửa sổ (0ms Drag Latency) trên Windows 10**:
   - `theme_win10.cpp` gọi `ACCENT_ENABLE_BLURBEHIND (3)` xử lý 100% bằng GPU, cửa sổ bám dính tuyệt đối theo con trỏ chuột.
4. **Tự động ẩn tiêu đề native trên Windows 10, hiển thị trên Windows 11**:
   - `win32_window.cpp` kiểm tra `IsWindows11OrGreater() ? title.c_str() : L""`.
   - Windows 10 không vẽ tiêu đề native -> triệt tiêu lỗi viền hộp đen của GDI.
   - Windows 11 vẽ tiêu đề native bằng DirectWrite -> sắc nét, hỗ trợ Immersive Dark Mode.
5. **Không xung đột giữa các plugin**:
   - Loại bỏ hoàn toàn sự phụ thuộc vào `flutter_acrylic`.
   - `window_manager` chỉ dùng để quản lý kích thước và sự kiện, tuyệt đối không gọi `waitUntilReadyToShow` với `backgroundColor` hay `SetTitleBarStyle` làm reset vùng kính mờ DWM.

---

## 📁 2. Cấu Trúc Các File C++ Trong `windows/runner/`

```text
windows/runner/
├── theme_win11.h / theme_win11.cpp   # Acrylic Windows 11 (DWMSBT_TRANSIENTWINDOW = 3)
├── theme_win10.h / theme_win10.cpp   # Aero Blur Windows 10 (ACCENT_ENABLE_BLURBEHIND = 3)
├── win32_window.h / win32_window.cpp # Điều phối phiên bản OS & áp dụng DWM Theme
└── CMakeLists.txt                    # Biên dịch theme_win10.cpp & theme_win11.cpp
```

### Chi tiết `theme_win11.cpp`:
```cpp
#include "theme_win11.h"

void ApplyThemeWin11(HWND hwnd, bool is_dark, bool is_startup) {
  BOOL enable_dark_mode = is_dark ? TRUE : FALSE;
  DwmSetWindowAttribute(hwnd, 20, &enable_dark_mode, sizeof(enable_dark_mode));

  if (is_startup) {
    // Set backdrop type to DWMSBT_TRANSIENTWINDOW (Acrylic = 3)
    int backdrop_type = 3;
    DwmSetWindowAttribute(hwnd, 38, &backdrop_type, sizeof(backdrop_type));

    // Extend frame into client area
    MARGINS margins = { -1, -1, -1, -1 };
    DwmExtendFrameIntoClientArea(hwnd, &margins);
  }
}
```

### Chi tiết `theme_win10.cpp`:
```cpp
void ApplyThemeWin10(HWND hwnd, bool is_dark) {
  BOOL enable_dark_mode = is_dark ? TRUE : FALSE;
  DwmSetWindowAttribute(hwnd, 19, &enable_dark_mode, sizeof(enable_dark_mode));
  DwmSetWindowAttribute(hwnd, 20, &enable_dark_mode, sizeof(enable_dark_mode));

  HMODULE hUser = GetModuleHandleA("user32.dll");
  if (hUser) {
    pSetWindowCompositionAttribute setWindowCompAttr = 
        (pSetWindowCompositionAttribute)GetProcAddress(hUser, "SetWindowCompositionAttribute");
    if (setWindowCompAttr) {
      int alpha = 0x66; // ~40% opacity
      int r = is_dark ? 0x1B : 0xF3;
      int g = is_dark ? 0x15 : 0xF4;
      int b = is_dark ? 0x14 : 0xF6;
      DWORD tint_color = (alpha << 24) | (b << 16) | (g << 8) | r;
      
      ACCENT_POLICY policy = { ACCENT_ENABLE_BLURBEHIND, 2, tint_color, 0 };
      WINDOWCOMPOSITIONATTRIBDATA data = { 19, &policy, sizeof(policy) };
      setWindowCompAttr(hwnd, &data);
    }
  }

  MARGINS margins = { 0, 0, 1, 0 };
  DwmExtendFrameIntoClientArea(hwnd, &margins);
  SendMessage(hwnd, WM_NCACTIVATE, FALSE, 0);
  SendMessage(hwnd, WM_NCACTIVATE, TRUE, 0);
}
```

---

## 🚀 3. Cấu Hình Phía Flutter (`lib/main.dart`)

```dart
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo window_manager cho resize / maximize listener:
  // KHÔNG gọi waitUntilReadyToShow với backgroundColor hay TitleBarStyle tại đây!
  await initGlassWindow(
    title: 'JA Mini Showcase',
    size: const Size(1200, 820),
    minSize: const Size(760, 520),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent, // Bắt buộc để lộ kính C++
      ),
      home: const MainWindow(),
    );
  }
}
```