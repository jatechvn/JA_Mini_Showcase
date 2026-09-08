import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/main.dart';
import 'package:ja_mini_showcase/layout/dashboard_shell.dart';
import 'package:ja_mini_showcase/theme/language_provider.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';
import 'package:ja_mini_showcase/widgets/command_palette.dart';
import 'package:ja_mini_showcase/widgets/filter_search_dock.dart';
import 'package:provider/provider.dart';

Future<ThemeProvider> openApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const JaMiniShowcaseApp());
  final context = tester.element(find.byType(DashboardShell));
  context.read<LanguageProvider>().setLanguage(AppLanguage.en);
  await tester.pump();
  return context.read<ThemeProvider>();
}

void main() {
  testWidgets('Service toggle, device filters and command palette work', (
    tester,
  ) async {
    final theme = await openApp(tester, const Size(1400, 900));
    await tester.tap(find.text('DỪNG TIẾN TRÌNH'));
    await tester.pump();
    expect(find.text('BẮT ĐẦU HOẠT ĐỘNG'), findsOneWidget);
    await tester.tap(find.byTooltip('Devices'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    final search = find.descendant(
      of: find.byType(FilterSearchDock),
      matching: find.byType(TextField),
    );
    await tester.enterText(search, '192.168.10.102');
    await tester.pump();
    expect(
      find.text('iPhone 15 Pro Max (Thiết bị kiểm thử chính)'),
      findsOneWidget,
    );
    await tester.tap(find.text('Laptop / PC'));
    await tester.pump();
    expect(find.text('Không tìm thấy thiết bị phù hợp'), findsOneWidget);
    await tester.enterText(search, '');
    await tester.pump();
    expect(find.text('MacBook Pro M3 Max 64GB'), findsOneWidget);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CommandPalette), findsOneWidget);
    final paletteSearch = find.descendant(
      of: find.byType(CommandPalette),
      matching: find.byType(TextField),
    );
    await tester.enterText(paletteSearch, 'Chuyển Theme');
    await tester.pump();
    final wasDark = theme.isDark;
    await tester.tap(find.text('Chuyển Theme Sáng / Tối'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(theme.isDark, !wasDark);
    expect(find.byType(CommandPalette), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in [const Size(1400, 900), const Size(760, 520)]) {
    testWidgets('All tabs render at $size in every language and theme', (
      tester,
    ) async {
      final theme = await openApp(tester, size);
      final language = tester
          .element(find.byType(DashboardShell))
          .read<LanguageProvider>();
      for (final mode in ['light', 'dark']) {
        theme.setThemeMode(mode);
        for (final locale in AppLanguage.values) {
          language.setLanguage(locale);
          await tester.pump();
          for (final label in language.tabLabels) {
            final tab = size.width >= 880
                ? find.byTooltip(label)
                : find.text(label);
            await tester.tap(tab.first);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 350));
            expect(
              tester.takeException(),
              isNull,
              reason: '$mode / $locale / $label / $size',
            );
          }
        }
      }
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  }

  for (final dismiss in ['escape', 'outside', 'cancel', 'save']) {
    testWidgets('Settings preview handles $dismiss', (tester) async {
      final theme = await openApp(tester, const Size(1400, 900));
      final original = theme.cardBlur;
      await tester.tap(
        find.byWidgetPredicate(
          (w) =>
              w is TopBarExpandingButton &&
              w.icon is Icon &&
              (w.icon as Icon).icon == Icons.settings_rounded,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      final slider = tester.widget<Slider>(find.byType(Slider).first);
      slider.onChanged!(original == 5 ? 10 : 5);
      await tester.pump();
      expect(theme.cardBlur, isNot(original));
      switch (dismiss) {
        case 'escape':
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        case 'outside':
          await tester.tapAt(const Offset(5, 5));
        case 'cancel':
          await tester.tap(find.text('Cancel'));
        case 'save':
          await tester.tap(find.text('Save Settings'));
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(theme.cardBlur, dismiss == 'save' ? isNot(original) : original);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Dropdown closes on Escape', (tester) async {
    final theme = ThemeProvider();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GlassDropdown<String>(
              colors: theme.colors,
              value: 'a',
              items: const [
                GlassDropdownItem(value: 'a', label: 'Alpha'),
                GlassDropdownItem(value: 'b', label: 'Beta'),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Alpha'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Beta'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.text('Beta'), findsNothing);
  });
}
