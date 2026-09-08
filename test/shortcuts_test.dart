import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/widgets/command_palette.dart';
import 'package:ja_mini_showcase/widgets/glass_dialog.dart';
import 'package:ja_mini_showcase/widgets/glass_terminal.dart';
import 'package:ja_mini_showcase/sample_views/sample_device_list_view.dart';
import 'package:ja_mini_showcase/sample_views/sample_bento_overview.dart';
import 'package:ja_mini_showcase/sample_views/sample_components_view.dart';
import 'package:ja_mini_showcase/sample_views/sample_stats_view.dart';
import 'feature_regression_test.dart' show openApp;

Future<void> press(
  WidgetTester tester,
  LogicalKeyboardKey key, {
  bool shift = false,
}) async {
  final modifier = defaultTargetPlatform == TargetPlatform.macOS
      ? LogicalKeyboardKey.metaLeft
      : LogicalKeyboardKey.controlLeft;
  await tester.sendKeyDownEvent(modifier);
  if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(key);
  if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyUpEvent(modifier);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

void main() {
  testWidgets('Palette wraps selection, scrolls and resets after filtering', (
    tester,
  ) async {
    await openApp(tester, const Size(1400, 900));
    var selected = -1;
    showCommandPalette(
      tester.element(find.byType(SampleBentoOverview)),
      items: [
        for (var i = 0; i < 20; i++)
          CommandPaletteItem(
            label: 'Command $i',
            icon: Icons.bolt,
            onSelect: () => selected = i,
          ),
      ],
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    final last = find.widgetWithText(ListTile, 'Command 19');
    expect(tester.widget<ListTile>(last).selected, isTrue);
    expect(last.hitTestable(), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(
      tester
          .widget<ListTile>(find.widgetWithText(ListTile, 'Command 0'))
          .selected,
      isTrue,
    );
    await tester.enterText(find.byType(TextField), 'Command 12');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(selected, 12);
    expect(find.byType(CommandPalette), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  for (final platform in [TargetPlatform.windows, TargetPlatform.macOS]) {
    testWidgets(
      'Navigation, scoped commands and modal isolation on $platform',
      (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final theme = await openApp(tester, const Size(1400, 900));
        final views = [
          SampleBentoOverview,
          SampleComponentsView,
          GlassTerminalPanel,
          SampleDeviceListView,
          SampleStatsView,
        ];
        final digits = [
          LogicalKeyboardKey.digit1,
          LogicalKeyboardKey.digit2,
          LogicalKeyboardKey.digit3,
          LogicalKeyboardKey.digit4,
          LogicalKeyboardKey.digit5,
        ];
        for (var i = 0; i < views.length; i++) {
          await press(tester, digits[i]);
          expect(find.byType(views[i]), findsOneWidget);
        }
        await press(tester, LogicalKeyboardKey.digit4);
        await press(tester, LogicalKeyboardKey.keyF);
        expect(
          tester.widget<TextField>(find.byType(TextField)).focusNode?.hasFocus,
          isTrue,
        );
        await tester.enterText(find.byType(TextField), 'draft');
        final dark = theme.isDark;
        await press(tester, LogicalKeyboardKey.keyL, shift: true);
        expect(theme.isDark, !dark);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller?.text,
          'draft',
        );
        await press(tester, LogicalKeyboardKey.digit3);
        await tester.enterText(find.byType(TextField), 'echo test-output');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
        expect(find.text('test-output'), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'keep draft');
        await press(tester, LogicalKeyboardKey.keyL);
        expect(find.text('test-output'), findsNothing);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller?.text,
          'keep draft',
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller?.text,
          'echo test-output',
        );
        await press(tester, LogicalKeyboardKey.comma);
        expect(find.byType(GlassDialog), findsOneWidget);
        final before = theme.isDark;
        await press(tester, LogicalKeyboardKey.keyL, shift: true);
        expect(theme.isDark, before);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(find.byType(GlassDialog), findsNothing);
        await press(tester, LogicalKeyboardKey.keyK);
        expect(find.byType(CommandPalette), findsOneWidget);
        final input = find.descendant(
          of: find.byType(CommandPalette),
          matching: find.byType(TextField),
        );
        await tester.enterText(input, 'no-such-command-123');
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        expect(find.byType(CommandPalette), findsOneWidget);
        await tester.enterText(input, 'Theme');
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(tester.widget<ListTile>(find.byType(ListTile)).selected, isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(theme.isDark, !before);
        expect(find.byType(CommandPalette), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        debugDefaultTargetPlatformOverride = null;
      },
    );
  }
}
