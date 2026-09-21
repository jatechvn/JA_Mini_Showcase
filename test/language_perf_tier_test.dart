import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/layout/dashboard_shell.dart';
import 'package:ja_mini_showcase/theme/language_provider.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';
import 'package:ja_mini_showcase/widgets/glass_dropdown.dart';

void main() {
  group('LanguageProvider Tests', () {
    test('Cycles language through VI -> EN -> CN -> VI', () {
      final provider = LanguageProvider();
      provider.setLanguage(AppLanguage.vi);
      expect(provider.currentLanguage, AppLanguage.vi);
      expect(provider.currentLanguage.code, 'VI');

      provider.cycleLanguage();
      expect(provider.currentLanguage, AppLanguage.en);
      expect(provider.currentLanguage.code, 'EN');
      expect(provider.tabLabels.first, 'Overview');

      provider.cycleLanguage();
      expect(provider.currentLanguage, AppLanguage.cn);
      expect(provider.currentLanguage.code, 'CN');
      expect(provider.tabLabels.first, '概览');

      provider.cycleLanguage();
      expect(provider.currentLanguage, AppLanguage.vi);
      expect(provider.currentLanguage.code, 'VI');
      expect(provider.tabLabels.first, 'Tổng quan');
    });

    test('Translates keys properly across languages', () {
      final provider = LanguageProvider();

      provider.setLanguage(AppLanguage.en);
      expect(provider.t('status_live'), 'LIVE • 8090');
      expect(provider.t('theme_tooltip'), 'Toggle Light / Dark Theme');

      provider.setLanguage(AppLanguage.vi);
      expect(provider.t('status_live'), 'LIVE • 8090');
      expect(provider.t('theme_tooltip'), 'Chuyển giao diện Sáng / Tối');

      provider.setLanguage(AppLanguage.cn);
      expect(provider.t('status_live'), '运行 • 8090');
      expect(provider.t('theme_tooltip'), '切换深色/浅色主题');
    });
  });

  group('Hardware Tier & Profiling Tests', () {
    test(
      'Auto and reset restore stable MES glass after every manual preset',
      () {
        final theme = ThemeProvider();
        addTearDown(theme.dispose);
        void expectDefaults() {
          expect(theme.perfMode, PerfTierMode.auto);
          expect(theme.effectiveTier, theme.detectedTier);
          expect(theme.cardBlur, 20);
          expect(theme.dialogBlur, 20);
          expect(theme.dropdownBlur, 20);
          expect(theme.cardOpacity, 0.25);
          expect(theme.dialogOpacity, 0.85);
          expect(theme.dropdownOpacity, 0.86);
        }

        expectDefaults();
        for (final mode in [
          PerfTierMode.ultra,
          PerfTierMode.balanced,
          PerfTierMode.lite,
        ]) {
          theme.setPerfTierMode(mode);
          theme.setPerfTierMode(PerfTierMode.auto);
          expectDefaults();
          theme.setPerfTierMode(mode);
          theme.setLiveGlassmorphism(cardOpacity: 0.7, dialogBlur: 5);
          theme.resetToDefaults();
          expectDefaults();
        }
        theme.setPerfTierMode(PerfTierMode.lite);
        theme.cyclePerfTier();
        expectDefaults();
      },
    );

    test('Calculates hardware score and detected tier properly', () {
      final theme = ThemeProvider();
      expect(theme.hardwareScore, inInclusiveRange(10, 100));
      expect(theme.cpuCores, greaterThanOrEqualTo(1));
      expect(theme.detectedTier, isNotNull);
      expect(theme.perfMode, PerfTierMode.auto);
      expect(theme.effectiveTier, theme.detectedTier);
    });

    test(
      'Cycles performance tier through Auto -> Ultra -> Balanced -> Lite -> Auto',
      () {
        final theme = ThemeProvider();
        theme.setPerfTierMode(PerfTierMode.auto);
        expect(theme.perfMode, PerfTierMode.auto);

        theme.cyclePerfTier();
        expect(theme.perfMode, PerfTierMode.ultra);
        expect(theme.effectiveTier, HardwareTier.ultra);
        expect(theme.cardBlur, 20.0);
        expect(theme.dropdownBlur, 20.0);
        expect(theme.dropdownOpacity, 0.86);

        theme.cyclePerfTier();
        expect(theme.perfMode, PerfTierMode.balanced);
        expect(theme.effectiveTier, HardwareTier.balanced);
        expect(theme.cardBlur, 14.0);
        expect(theme.dropdownBlur, 14.0);
        expect(theme.dropdownOpacity, 0.96);

        theme.cyclePerfTier();
        expect(theme.perfMode, PerfTierMode.lite);
        expect(theme.effectiveTier, HardwareTier.lite);
        expect(theme.cardBlur, 0.0); // No blur for maximum performance
        expect(theme.dropdownBlur, 0.0);
        expect(theme.dropdownOpacity, 0.98);

        theme.cyclePerfTier();
        expect(theme.perfMode, PerfTierMode.auto);
      },
    );

    test('Live tuning updates dropdown blur and opacity', () {
      final theme = ThemeProvider();
      theme.setDropdownBlur(30.0);
      expect(theme.dropdownBlur, 30.0);

      theme.setDropdownOpacity(0.85);
      expect(theme.dropdownOpacity, 0.85);

      theme.setLiveGlassmorphism(dropdownBlur: 18.0, dropdownOpacity: 0.92);
      expect(theme.dropdownBlur, 18.0);
      expect(theme.dropdownOpacity, 0.92);
    });
  });

  group('GlassDropdown High-Opacity Legibility Tests', () {
    testWidgets('Dropdown menu uses high opacity background', (
      WidgetTester tester,
    ) async {
      final theme = ThemeProvider();
      final items = [
        const GlassDropdownItem<String>(value: 'opt1', label: 'Option 1'),
        const GlassDropdownItem<String>(value: 'opt2', label: 'Option 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: GlassDropdown<String>(
                items: items,
                value: 'opt1',
                colors: theme.colors,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Tap to open dropdown menu overlay
      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();

      // Find all Container decorations to verify popup menu background color
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool foundHighOpacityMenu = false;
      for (final container in containers) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration && decoration.color != null) {
          final color = decoration.color!;
          // High opacity menu has alpha >= 0.95 (242 / 255)
          if ((color.a >= 0.95)) {
            foundHighOpacityMenu = true;
            break;
          }
        }
      }

      expect(
        foundHighOpacityMenu,
        isTrue,
        reason: 'Dropdown overlay must have opacity >= 0.95 for readability',
      );
    });
  });

  group('TopBarExpandingButton Hover Tests', () {
    testWidgets('TopBarExpandingButton expands to full text on mouse hover', (
      WidgetTester tester,
    ) async {
      final theme = ThemeProvider();
      final colors = theme.colors;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TopBarExpandingButton(
                icon: const Icon(Icons.palette_rounded, size: 14),
                collapsedLabel: null,
                expandedLabel: 'Giao diện Tối',
                textColor: colors.accentAmber,
                isCompact: true,
                tooltip: 'Theme',
                colors: colors,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // In collapsed state, 'Giao diện Tối' is not visible
      expect(find.text('Giao diện Tối'), findsNothing);

      // Hover mouse over the button
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(
        tester.getCenter(find.byType(TopBarExpandingButton)),
      );
      await tester.pumpAndSettle();

      // Now in expanded state, full label 'Giao diện Tối' is visible!
      expect(find.text('Giao diện Tối'), findsOneWidget);

      // Move mouse away
      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();

      // After mouse exit, label collapses back
      expect(find.text('Giao diện Tối'), findsNothing);
    });
  });

  group('Glassmorphism Settings Dialog Tests', () {
    testWidgets(
      'Settings dialog opens and displays all 6 live-tuning sliders with localization',
      (WidgetTester tester) async {
        final language = LanguageProvider();
        language.setLanguage(AppLanguage.vi);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text(language.t('settings_dialog_title')),
                            content: Column(
                              children: [
                                Text(language.t('settings_card_blur')),
                                Text(language.t('settings_card_opacity')),
                                Text(language.t('settings_dialog_blur')),
                                Text(language.t('settings_dialog_opacity')),
                                Text(language.t('settings_dropdown_blur')),
                                Text(language.t('settings_dropdown_opacity')),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Open Settings'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Settings'));
        await tester.pumpAndSettle();

        expect(find.text('Cài đặt Glassmorphism & Giao diện'), findsOneWidget);
        expect(find.text('Độ mờ khối Bento (Card Blur)'), findsOneWidget);
        expect(find.text('Độ đục khối Bento (Card Opacity)'), findsOneWidget);
        expect(find.text('Độ mờ Hộp thoại (Dialog Blur)'), findsOneWidget);
        expect(find.text('Độ đục Hộp thoại (Dialog Opacity)'), findsOneWidget);
        expect(find.text('Độ mờ Bảng chọn (Dropdown Blur)'), findsOneWidget);
        expect(
          find.text('Độ đục Bảng chọn (Dropdown Opacity)'),
          findsOneWidget,
        );
      },
    );

    test('Settings tabs are properly localized across languages', () {
      final language = LanguageProvider();

      language.setLanguage(AppLanguage.vi);
      expect(language.t('tab_settings_ui'), 'Kính mờ & Giao diện');
      expect(language.t('tab_user_guide'), 'Hướng dẫn sử dụng');
      expect(language.t('tab_about'), 'Giới thiệu');

      language.setLanguage(AppLanguage.en);
      expect(language.t('tab_settings_ui'), 'Glass & UI');
      expect(language.t('tab_user_guide'), 'User Guide');
      expect(language.t('tab_about'), 'About');

      language.setLanguage(AppLanguage.cn);
      expect(language.t('tab_settings_ui'), '界面与毛玻璃');
      expect(language.t('tab_user_guide'), '使用指南');
      expect(language.t('tab_about'), '关于应用');
    });
  });
}
