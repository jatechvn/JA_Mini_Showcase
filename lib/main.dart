import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme_provider.dart';
import 'theme/language_provider.dart';
import 'layout/dashboard_shell.dart';
import 'widgets/command_palette.dart';
import 'widgets/app_toast.dart';
import 'modules/build_info.dart';
import 'modules/logger_config.dart';
import 'modules/window_helper.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.contains('-debug') ||
      args.contains('--debug') ||
      args.contains('-d')) {
    BuildInfo.isCliDebug = true;
  }
  setupLogger();

  await initGlassWindow(
    title: 'JA Mini Showcase - UI Framework Playground',
    size: const Size(1200, 820),
    minSize: const Size(760, 520),
  );

  runApp(const JaMiniShowcaseApp());
}

class JaMiniShowcaseApp extends StatelessWidget {
  const JaMiniShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final colors = theme.colors;
    final effectiveTitle = (!kIsWeb && Platform.isWindows && !theme.isWin11)
        ? ''
        : 'JA Mini Showcase';

    return MaterialApp(
      title: effectiveTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: theme.isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: Builder(
        builder: (ctx) {
          return CommandPaletteShortcut(
            items: () => [
              CommandPaletteItem(
                label: 'Chuyển Theme Sáng / Tối',
                subtitle: 'Đổi chế độ giao diện 1-Click',
                icon: Icons.brightness_4_rounded,
                onSelect: () => theme.toggleTheme(),
              ),
              CommandPaletteItem(
                label: 'Khôi phục Glass Tuning',
                subtitle: 'Đặt lại Blur và Opacity về chuẩn mặc định',
                icon: Icons.refresh_rounded,
                onSelect: () {
                  theme.resetToDefaults();
                  showAppToast(
                    ctx,
                    colors: colors,
                    message: 'Đã khôi phục Glass Tuning!',
                    icon: Icons.check_circle_rounded,
                    accentColor: colors.accentCyan,
                  );
                },
              ),
              CommandPaletteItem(
                label: 'Toast Thành công',
                subtitle: 'Gửi thông báo thành công kính mờ',
                icon: Icons.check_circle_outline_rounded,
                onSelect: () => showAppToast(
                  ctx,
                  colors: colors,
                  message: 'Kiểm thử thông báo thành công!',
                  icon: Icons.check_circle_rounded,
                  accentColor: colors.accentEmerald,
                ),
              ),
              CommandPaletteItem(
                label: 'Toast Cảnh báo',
                subtitle: 'Gửi thông báo cảnh báo kính mờ',
                icon: Icons.warning_amber_rounded,
                onSelect: () => showAppToast(
                  ctx,
                  colors: colors,
                  message: 'Kiểm thử thông báo cảnh báo!',
                  icon: Icons.warning_rounded,
                  accentColor: colors.accentAmber,
                ),
              ),
            ],
            child: DashboardShell(
              appTitle: 'JA UI Showcase',
              appVersion: BuildInfo.version,
              isDebug: BuildInfo.isDebug,
              buildTimestamp: BuildInfo.debugTimestamp,
            ),
          );
        },
      ),
    );
  }
}
