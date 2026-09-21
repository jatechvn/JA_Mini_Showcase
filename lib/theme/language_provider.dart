import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Supported application languages.
enum AppLanguage {
  vi('VI', 'Tiếng Việt', '🇻🇳'),
  en('EN', 'English', '🇬🇧'),
  cn('CN', '中文', '🇨🇳');

  final String code;
  final String label;
  final String flag;

  const AppLanguage(this.code, this.label, this.flag);
}

/// Language and localization provider for instant 1-click language switching.
class LanguageProvider extends ChangeNotifier {
  late AppLanguage _currentLanguage;

  LanguageProvider() {
    _currentLanguage = _detectSystemLanguage();
  }

  AppLanguage get currentLanguage => _currentLanguage;

  static AppLanguage _detectSystemLanguage() {
    try {
      final locale = Platform.localeName.toLowerCase();
      if (locale.startsWith('zh') || locale.contains('cn')) {
        return AppLanguage.cn;
      } else if (locale.startsWith('en')) {
        return AppLanguage.en;
      } else if (locale.startsWith('vi')) {
        return AppLanguage.vi;
      }
    } catch (_) {}
    return AppLanguage.vi; // Default to Vietnamese
  }

  /// Cycles to the next language: VI -> EN -> CN -> VI
  void cycleLanguage() {
    switch (_currentLanguage) {
      case AppLanguage.vi:
        _currentLanguage = AppLanguage.en;
        break;
      case AppLanguage.en:
        _currentLanguage = AppLanguage.cn;
        break;
      case AppLanguage.cn:
        _currentLanguage = AppLanguage.vi;
        break;
    }
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  /// Localized Tab Labels
  List<String> get tabLabels {
    switch (_currentLanguage) {
      case AppLanguage.vi:
        return const [
          'Tổng quan',
          'Linh kiện',
          'Terminal',
          'Thiết bị',
          'Băng thông',
        ];
      case AppLanguage.en:
        return const [
          'Overview',
          'Components',
          'Terminal',
          'Devices',
          'Bandwidth',
        ];
      case AppLanguage.cn:
        return const ['概览', '组件', '终端', '设备', '带宽'];
    }
  }

  /// Localized String dictionary lookup with parameter substitution
  String t(String key, [List<dynamic>? args]) {
    final entry = _translations[key];
    if (entry == null) return key;
    var str = entry[_currentLanguage.code.toLowerCase()] ?? entry['vi'] ?? key;
    if (args != null && args.isNotEmpty) {
      for (final arg in args) {
        if (str.contains('%s')) {
          str = str.replaceFirst('%s', arg.toString());
        } else if (str.contains('%d')) {
          str = str.replaceFirst('%d', arg.toString());
        }
      }
    }
    return str;
  }

  /// Backward-compatible alias for shared JA modules
  String tr(String key, [List<dynamic>? args]) => t(key, args);

  static const Map<String, Map<String, String>> _translations = {
    'perf_tooltip': {
      'vi': 'Chế độ đồ họa & Hiệu năng máy',
      'en': 'Graphic Tier & Hardware Profile',
      'cn': '图形档位与硬件配置',
    },
    'lang_tooltip': {
      'vi': 'Chuyển ngôn ngữ nhanh (EN/VI/CN)',
      'en': 'Quick Language Switch (EN/VI/CN)',
      'cn': '快速切换语言 (EN/VI/CN)',
    },
    'theme_tooltip': {
      'vi': 'Chuyển giao diện Sáng / Tối',
      'en': 'Toggle Light / Dark Theme',
      'cn': '切换深色/浅色主题',
    },
    'settings_tooltip': {
      'vi': 'Cài đặt hiệu ứng kính mờ',
      'en': 'Glass Tuning Settings',
      'cn': '毛玻璃微调设置',
    },
    'status_live': {
      'vi': 'LIVE • 8090',
      'en': 'LIVE • 8090',
      'cn': '运行 • 8090',
    },
    'status_standby': {'vi': 'STANDBY', 'en': 'STANDBY', 'cn': '待机'},
    'status_devices': {'vi': '3 dev', 'en': '3 dev', 'cn': '3设备'},
    'lang_changed_msg': {
      'vi': '🌐 Đã chuyển ngôn ngữ: Tiếng Việt',
      'en': '🌐 Language switched: English',
      'cn': '🌐 语言已切换: 中文',
    },
    'settings_dialog_title': {
      'vi': 'Cài đặt Glassmorphism & Giao diện',
      'en': 'Glassmorphism & UI Settings',
      'cn': '毛玻璃效果与界面设置',
    },
    'settings_card_header': {
      'vi': 'Điều chỉnh Liquid Glass & Bento Card',
      'en': 'Liquid Glass & Bento Card Tuning',
      'cn': '液体玻璃与 Bento 卡片微调',
    },
    'settings_default': {'vi': 'Mặc định', 'en': 'Default', 'cn': '默认'},
    'settings_card_blur': {
      'vi': 'Độ mờ khối Bento (Card Blur)',
      'en': 'Bento Card Blur',
      'cn': 'Bento 卡片模糊度',
    },
    'settings_card_opacity': {
      'vi': 'Độ đục khối Bento (Card Opacity)',
      'en': 'Bento Card Opacity',
      'cn': 'Bento 卡片不透明度',
    },
    'settings_dialog_blur': {
      'vi': 'Độ mờ Hộp thoại (Dialog Blur)',
      'en': 'Dialog Blur',
      'cn': '弹窗模糊度',
    },
    'settings_dialog_opacity': {
      'vi': 'Độ đục Hộp thoại (Dialog Opacity)',
      'en': 'Dialog Opacity',
      'cn': '弹窗不透明度',
    },
    'settings_dropdown_blur': {
      'vi': 'Độ mờ Bảng chọn (Dropdown Blur)',
      'en': 'Dropdown Blur',
      'cn': '下拉菜单模糊度',
    },
    'settings_dropdown_opacity': {
      'vi': 'Độ đục Bảng chọn (Dropdown Opacity)',
      'en': 'Dropdown Opacity',
      'cn': '下拉菜单不透明度',
    },
    'action_cancel': {'vi': 'Hủy', 'en': 'Cancel', 'cn': '取消'},
    'action_save': {'vi': 'Lưu Cài Đặt', 'en': 'Save Settings', 'cn': '保存设置'},
    'theme_light': {'vi': 'Sáng', 'en': 'Light', 'cn': '浅色'},
    'theme_dark': {'vi': 'Tối', 'en': 'Dark', 'cn': '深色'},
    'settings_btn_label': {'vi': 'Cài đặt', 'en': 'Settings', 'cn': '设置'},
    'tab_settings_ui': {
      'vi': 'Kính mờ & Giao diện',
      'en': 'Glass & UI',
      'cn': '界面与毛玻璃',
    },
    'tab_ota_update': {
      'vi': 'Cập nhật OTA',
      'en': 'OTA Update',
      'cn': 'OTA 更新',
    },
    'tab_user_guide': {
      'vi': 'Hướng dẫn sử dụng',
      'en': 'User Guide',
      'cn': '使用指南',
    },
    'tab_about': {'vi': 'Giới thiệu', 'en': 'About', 'cn': '关于应用'},
    // OTA Update Keys
    'ota_title': {
      'vi': 'Cập nhật tự động qua mạng LAN (OTA)',
      'en': 'Over-The-Air LAN Updates (OTA)',
      'cn': '局域网自动更新 (OTA)',
    },
    'ota_desc': {
      'vi':
          'Tự động kiểm tra và nâng cấp phiên bản mới từ thư mục chia sẻ nội bộ SMB/UNC.',
      'en':
          'Automatically checks and applies updates from internal SMB/UNC shares.',
      'cn': '从内部 SMB/UNC 共享文件夹自动检查并应用新版本更新。',
    },
    'ota_server_path': {
      'vi': 'Đường dẫn máy chủ cập nhật (SMB/UNC)',
      'en': 'Update Server Path (SMB/UNC)',
      'cn': '更新服务器路径 (SMB/UNC)',
    },
    'ota_server_path_hint': {
      'vi': r'\\10.81.141.226\temp\FBT\JA_PROJECT\JA_Update\JA_Mini_Showcase',
      'en': r'\\10.81.141.226\temp\FBT\JA_PROJECT\JA_Update\JA_Mini_Showcase',
      'cn': r'\\10.81.141.226\temp\FBT\JA_PROJECT\JA_Update\JA_Mini_Showcase',
    },
    'ota_check_interval': {
      'vi': 'Chu kỳ kiểm tra tự động',
      'en': 'Automatic Check Interval',
      'cn': '自动检查周期',
    },
    'interval_daily': {'vi': 'Hàng ngày', 'en': 'Daily', 'cn': '每日'},
    'interval_weekly': {'vi': 'Hàng tuần', 'en': 'Weekly', 'cn': '每周'},
    'interval_monthly': {'vi': 'Hàng tháng', 'en': 'Monthly', 'cn': '每月'},
    'interval_off': {'vi': 'Tắt', 'en': 'Disabled', 'cn': '关闭'},
    'ota_auth_title': {
      'vi': 'Thông tin xác thực mạng nội bộ (Tùy chọn)',
      'en': 'Network Credentials (Optional)',
      'cn': '局域网身份验证 (可选)',
    },
    'ota_username': {
      'vi': 'Tài khoản (Username)',
      'en': 'Username',
      'cn': '用户名',
    },
    'ota_password': {'vi': 'Mật khẩu (Password)', 'en': 'Password', 'cn': '密码'},
    'ota_open_config_folder': {
      'vi': 'Mở thư mục cấu hình',
      'en': 'Open Config Folder',
      'cn': '打开配置目录',
    },
    'ota_test_connection': {
      'vi': 'Kiểm tra kết nối',
      'en': 'Test Connection',
      'cn': '测试连接',
    },
    'ota_testing_connection': {
      'vi': 'Đang kiểm tra kết nối...',
      'en': 'Testing connection...',
      'cn': '正在测试连接...',
    },
    'ota_connection_success': {
      'vi': 'Kết nối máy chủ thành công!',
      'en': 'Server connection successful!',
      'cn': '服务器连接成功！',
    },
    'ota_connection_failed': {
      'vi': 'Không thể truy cập máy chủ cập nhật: %s',
      'en': 'Cannot access update server: %s',
      'cn': '无法访问更新服务器: %s',
    },
    'ota_check_now': {
      'vi': 'Kiểm tra bản cập nhật ngay',
      'en': 'Check for Updates Now',
      'cn': '立即检查更新',
    },
    'ota_checking': {
      'vi': 'Đang quét máy chủ tìm bản mới...',
      'en': 'Scanning server for updates...',
      'cn': '正在扫描服务器新版本...',
    },
    'ota_no_updates': {
      'vi': 'Bạn đang sử dụng phiên bản mới nhất (%s)',
      'en': 'You are using the latest version (%s)',
      'cn': '当前已是最新版本 (%s)',
    },
    'ota_update_available': {
      'vi': 'Đã có bản cập nhật mới: %s',
      'en': 'New version available: %s',
      'cn': '发现新版本: %s',
    },
    'ota_update_tooltip': {
      'vi': 'Bản cập nhật mới: %s. Nhấp để nâng cấp!',
      'en': 'New version available: %s. Click to update!',
      'cn': '发现新版本: %s。点击立即更新！',
    },
    'ota_current_version': {
      'vi': 'Phiên bản hiện tại:',
      'en': 'Current version:',
      'cn': '当前版本:',
    },
    'ota_latest_version': {
      'vi': 'Phiên bản mới nhất:',
      'en': 'Latest version:',
      'cn': '最新版本:',
    },
    'ota_last_checked': {
      'vi': 'Kiểm tra lần cuối:',
      'en': 'Last checked:',
      'cn': '最后检查时间:',
    },
    'ota_never_checked': {
      'vi': 'Chưa kiểm tra',
      'en': 'Never checked',
      'cn': '从未检查',
    },
    'ota_dialog_title': {
      'vi': 'Cập nhật phiên bản mới',
      'en': 'New Version Update',
      'cn': '新版本更新',
    },
    'ota_package_size': {
      'vi': 'Dung lượng gói: %s',
      'en': 'Package size: %s',
      'cn': '安装包大小: %s',
    },
    'ota_release_notes': {
      'vi': 'Thông tin phát hành & Điểm mới',
      'en': 'Release Notes & Highlights',
      'cn': '版本更新说明与亮点',
    },
    'ota_update_now': {'vi': 'Cập nhật ngay', 'en': 'Update Now', 'cn': '立即更新'},
    'ota_update_later': {'vi': 'Để sau', 'en': 'Later', 'cn': '稍后再说'},
    'ota_downloading': {
      'vi': 'Đang tải bản cập nhật...',
      'en': 'Downloading update...',
      'cn': '正在下载更新...',
    },
    'ota_extracting': {
      'vi': 'Đang giải nén gói cập nhật...',
      'en': 'Extracting update package...',
      'cn': '正在解压更新包...',
    },
    'ota_ready_restart': {
      'vi': 'Đã chuẩn bị xong. Đang khởi động lại...',
      'en': 'Ready! Restarting application...',
      'cn': '准备就绪，正在重启应用程序...',
    },
    'guide_shortcuts_title': {
      'vi': 'Phím tắt toàn cục',
      'en': 'Global Shortcuts',
      'cn': '全局快捷键',
    },
    'guide_shortcuts_desc': {
      'vi':
          '• Ctrl+K: Mở Command Palette. Dùng ↑/↓ chọn lệnh, Enter thực thi.\n• Ctrl+1…5: Overview, Components, Terminal, Devices, Bandwidth.\n• Ctrl+,: Mở Settings. Ctrl+Shift+L: Đổi sáng/tối.\n• Ctrl+F: Focus tìm kiếm trong Devices.\n• Ctrl+L: Xóa màn hình Terminal, giữ lịch sử lệnh.\n• Esc: Đóng dialog, dropdown hoặc palette; Settings chưa lưu sẽ hoàn tác.\n• macOS: dùng Cmd thay Ctrl. Các phím theo tab chỉ hoạt động trong tab tương ứng, không tác động phía sau dialog.',
      'en':
          '• Ctrl+K: Open Command Palette. Use ↑/↓ to select, Enter to run.\n• Ctrl+1…5: Overview, Components, Terminal, Devices, Bandwidth.\n• Ctrl+,: Open Settings. Ctrl+Shift+L: Toggle light/dark.\n• Ctrl+F: Focus search in Devices.\n• Ctrl+L: Clear Terminal output, keeping command history.\n• Esc: Close dialogs, dropdowns or palette; unsaved Settings are reverted.\n• macOS: use Cmd instead of Ctrl. Tab shortcuts apply only within their tab and do not affect content behind dialogs.',
      'cn':
          '• Ctrl+K：打开命令面板。↑/↓ 选择，Enter 执行。\n• Ctrl+1…5：Overview、Components、Terminal、Devices、Bandwidth。\n• Ctrl+,：打开设置。Ctrl+Shift+L：切换明暗主题。\n• Ctrl+F：聚焦 Devices 搜索框。\n• Ctrl+L：清空 Terminal 输出，保留命令历史。\n• Esc：关闭弹窗、下拉菜单或命令面板；撤销未保存的设置。\n• macOS 使用 Cmd 代替 Ctrl。标签页快捷键仅在对应页面生效，不影响弹窗后面的内容。',
    },
    'guide_topbar_title': {
      'vi': 'Tương tác TopBar phóng lớn',
      'en': 'TopBar Hover Expansion',
      'cn': '顶栏悬停放大交互',
    },
    'guide_topbar_desc': {
      'vi':
          'Rê chuột qua các nút Cấu hình máy, Ngôn ngữ, Sáng/Tối và Cài đặt để phóng lớn (scale 1.05) và trượt mượt hiển thị nhãn đầy đủ.',
      'en':
          'Hover over Graphic Tier, Language, Light/Dark, and Settings buttons to scale up (1.05x) and smoothly reveal full labels.',
      'cn': '悬停于图形档位、语言、明暗主题与设置按钮，可放大 (1.05x) 并平滑展开完整标签文字。',
    },
    'guide_tier_title': {
      'vi': 'Phân tầng đồ họa máy tính',
      'en': 'Hardware Graphic Tiers',
      'cn': '硬件图形性能档位',
    },
    'guide_tier_desc': {
      'vi':
          '• Auto: Giữ kính chuẩn MES Tool trên mọi cấu hình: blur 20, opacity card 25%, dialog 85%, dropdown 86%.\n• Ultra/Balanced/Lite: Preset chọn thủ công để điều chỉnh blur và opacity. Lite tắt blur card/dropdown, giữ blur dialog 8.\n• Chuyển về Auto hoặc Reset sẽ khôi phục kính chuẩn; vẫn có thể tinh chỉnh bằng slider.',
      'en':
          '• Auto: Stable MES Tool glass on every machine: blur 20, card opacity 25%, dialog 85%, dropdown 86%.\n• Ultra/Balanced/Lite: Manually selected blur and opacity presets. Lite disables card/dropdown blur and retains dialog blur 8.\n• Returning to Auto or Reset restores the baseline; sliders still allow live tuning.',
      'cn':
          '• Auto：所有机器保持 MES Tool 标准玻璃：模糊 20，卡片不透明度 25%，弹窗 85%，下拉菜单 86%。\n• Ultra/Balanced/Lite：手动选择模糊和不透明度预设。Lite 关闭卡片和下拉模糊，保留弹窗模糊 8。\n• 返回 Auto 或重置恢复标准值；仍可通过滑块实时调整。',
    },
    'guide_scroll_title': {
      'vi': 'Cuộn bật nảy & Bảng chọn dài',
      'en': 'Bouncing Scroll & Dropdown',
      'cn': '弹性滚动与长下拉列表',
    },
    'guide_scroll_desc': {
      'vi':
          'BouncingScrollPhysics mang lại cảm giác cuộn đàn hồi cao cấp. Bảng chọn kính mờ GlassDropdown tự động kích hoạt ô tìm kiếm trực tiếp khi danh sách vượt quá 5 mục.',
      'en':
          'BouncingScrollPhysics delivers premium elastic physics. GlassDropdown automatically embeds a live search box when items exceed 5.',
      'cn':
          'BouncingScrollPhysics 带来高端弹性物理滚动。当列表超过 5 项时，GlassDropdown 自动启用即时搜索输入框。',
    },
    'guide_terminal_title': {
      'vi': 'Dòng lệnh mô phỏng Glass Terminal',
      'en': 'Glass Terminal Simulator',
      'cn': '玻璃拟态终端模拟器',
    },
    'guide_terminal_desc': {
      'vi':
          'Mô phỏng console tương phản cao Fedora 44 Ptyxis. Hỗ trợ các lệnh help, status, devices, ping, scan, theme, clear, echo, sysinfo kèm lịch sử lệnh ↑/↓, auto-scroll và sao chép nhật ký.',
      'en':
          'Fedora 44 Ptyxis-inspired high-contrast console. Supports commands: help, status, devices, ping, scan, theme, clear, echo, sysinfo with ↑/↓ command history, auto-scroll, and log copying.',
      'cn':
          '灵感源自 Fedora 44 Ptyxis 的高对比度终端。支持命令：help、status、devices、ping、scan、theme、clear、echo、sysinfo，具备 ↑/↓ 历史记录、自动滚动和日志复制功能。',
    },
    'about_app_name': {
      'vi': 'JA Mini Showcase',
      'en': 'JA Mini Showcase',
      'cn': 'JA Mini Showcase',
    },
    'about_app_desc': {
      'vi':
          'Bộ showcase Flutter Desktop cho JA-HUB Bento Glassmorphism, Dynamic Island navigation, live glass tuning, Command Palette, bộ lọc thiết bị và các mẫu motion UI tái sử dụng.',
      'en':
          'Flutter Desktop showcase for JA-HUB Bento Glassmorphism, Dynamic Island navigation, live glass tuning, Command Palette, device filters, and reusable UI motion patterns.',
      'cn':
          '面向 JA-HUB 的 Flutter Desktop 展示工程，涵盖 Bento 毛玻璃、Dynamic Island 导航、实时玻璃调校、Command Palette、设备筛选与可复用 UI 动效。',
    },
    'about_dev_title': {
      'vi': 'Thông tin phát triển & Bản quyền',
      'en': 'Development & Licensing',
      'cn': '开发信息与授权',
    },
    'about_sys_title': {
      'vi': 'Môi trường hệ thống & Phần cứng',
      'en': 'System & Hardware Runtime',
      'cn': '系统环境与硬件运行时',
    },
    'terminal_title': {
      'vi': 'Giả Lập Dòng Lệnh',
      'en': 'Command Terminal',
      'cn': '命令终端',
    },
    'terminal_clear': {
      'vi': 'Xóa màn hình',
      'en': 'Clear console',
      'cn': '清空控制台',
    },
    'terminal_copy': {
      'vi': 'Sao chép nhật ký',
      'en': 'Copy console log',
      'cn': '复制日志',
    },
    'terminal_copied': {
      'vi': 'Đã sao chép nhật ký vào bộ nhớ tạm',
      'en': 'Terminal log copied to clipboard',
      'cn': '终端日志已复制到剪贴板',
    },
    'terminal_autoscroll': {
      'vi': 'Tự động cuộn',
      'en': 'Auto-scroll',
      'cn': '自动滚动',
    },
    'terminal_prompt_hint': {
      'vi': 'Nhập lệnh (gõ help để xem danh sách)...',
      'en': 'Enter command (type help for list)...',
      'cn': '输入命令 (输入 help 查看列表)...',
    },
    'search_history_title': {
      'vi': 'Lịch sử tìm kiếm gần đây',
      'en': 'Recent search history',
      'cn': '最近搜索历史',
    },
    'search_history_clear': {
      'vi': 'Xóa toàn bộ',
      'en': 'Clear all history',
      'cn': '清除全部',
    },
    'search_history_empty': {
      'vi': 'Chưa có lịch sử tìm kiếm',
      'en': 'No search history',
      'cn': '暂无搜索历史',
    },
    'search_history_delete_item': {
      'vi': 'Xóa khỏi lịch sử',
      'en': 'Remove from history',
      'cn': '从历史中删除',
    },
    'terminal_subsystem_init': {
      'vi': 'Khởi chạy Phân hệ Terminal JA thành công',
      'en': 'JA Terminal Subsystem Initialized',
      'cn': 'JA 终端子系统已初始化',
    },
    'terminal_default_banner': {
      'vi': 'Bảng Điều Khiển Lệnh JA Bento Terminal [Phiên bản 1.2.0]',
      'en': 'JA Bento Terminal Command Console [Version 1.2.0]',
      'cn': 'JA 便当玻璃终端控制台 [版本 1.2.0]',
    },
    'terminal_default_help_hint': {
      'vi':
          'Gõ "help" để xem danh sách các lệnh chẩn đoán và hệ thống khả dụng.',
      'en': 'Type "help" to view available diagnostic and system commands.',
      'cn': '输入 "help" 查看可用诊断与系统命令。',
    },
    'terminal_current_time': {
      'vi': 'Thời gian hiện tại của hệ thống',
      'en': 'Current system time',
      'cn': '系统当前时间',
    },
    'terminal_help_header': {
      'vi': 'Danh sách lệnh chẩn đoán & Shell khả dụng:',
      'en': 'Available Diagnostic & Shell Commands:',
      'cn': '可用诊断与 Shell 命令：',
    },
    'terminal_cmd_not_found': {
      'vi': 'Lệnh không hợp lệ',
      'en': 'Command not recognized',
      'cn': '未识别的命令',
    },
  };
}

extension LanguageExtension on BuildContext {
  LanguageProvider get language => watch<LanguageProvider>();
  String t(String key) => watch<LanguageProvider>().t(key);
}
