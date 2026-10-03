import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ja_mini_showcase/layout/dashboard_shell.dart';
import 'package:ja_mini_showcase/modules/services/app_power_manager.dart';
import 'package:ja_mini_showcase/modules/window_focus_service.dart';
import 'package:ja_mini_showcase/theme/language_provider.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Dialog Idle Sleep & Rollback Tests', () {
    late AppPowerManager powerManager;
    late WindowFocusService focusService;
    late ThemeProvider themeProvider;
    late LanguageProvider languageProvider;

    setUp(() {
      powerManager = AppPowerManager.instance;
      powerManager.resetForTesting();
      focusService = WindowFocusService();
      themeProvider = ThemeProvider();
      languageProvider = LanguageProvider();
    });

    tearDown(() {
      focusService.dispose();
      themeProvider.dispose();
      languageProvider.dispose();
      powerManager.resetForTesting();
    });

    Widget createTestApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: focusService),
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: languageProvider),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: DashboardShell(
              appTitle: 'JA UI Showcase',
              appVersion: '1.4.1',
            ),
          ),
        ),
      );
    }

    testWidgets(
      'Settings dialog displays Idle Sleep card, toggles switch, and selects timeout chips',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestApp());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Find settings button in the top bar (settings icon) and tap it
        final settingsButtonFinder = find.byIcon(Icons.settings_rounded).first;
        expect(settingsButtonFinder, findsOneWidget);
        await tester.tap(settingsButtonFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Scroll to make Idle Sleep card visible
        final switchFinder = find.byType(Switch);
        await tester.ensureVisible(switchFinder);
        await tester.pump();

        expect(switchFinder, findsOneWidget);
        expect(tester.widget<Switch>(switchFinder).value, isTrue);

        // Verify timeout chips (12s, 30s, 60s) exist
        expect(find.textContaining('12'), findsWidgets);
        expect(find.textContaining('30'), findsWidgets);
        expect(find.textContaining('60'), findsWidgets);

        // Tap 30s chip
        final chip30Finder = find.textContaining('30').first;
        await tester.ensureVisible(chip30Finder);
        await tester.pump();
        await tester.tap(chip30Finder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Tap Save button
        final saveButtonFinder = find.text(languageProvider.t('action_save'));
        expect(saveButtonFinder, findsOneWidget);
        await tester.tap(saveButtonFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Verify power manager updated
        expect(powerManager.idleTimeoutSeconds, 30);

        powerManager.resetForTesting();
      },
    );

    testWidgets(
      'Rollback on Cancel restores original idle sleep settings when dialog is dismissed without saving',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        // Ensure baseline
        powerManager.setEnableIdleSleep(true);
        powerManager.setIdleTimeoutSeconds(12);

        await tester.pumpWidget(createTestApp());
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Open settings dialog
        final settingsButtonFinder = find.byIcon(Icons.settings_rounded).first;
        await tester.tap(settingsButtonFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Scroll to chip and tap 60s
        final chip60Finder = find.textContaining('60').first;
        await tester.ensureVisible(chip60Finder);
        await tester.pump();
        await tester.tap(chip60Finder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Toggle switch off
        final switchFinder = find.byType(Switch);
        await tester.ensureVisible(switchFinder);
        await tester.pump();
        await tester.tap(switchFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Tap Cancel
        final cancelButtonFinder = find.text(
          languageProvider.t('action_cancel'),
        );
        expect(cancelButtonFinder, findsOneWidget);
        await tester.tap(cancelButtonFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        // Verify rollback: values restored to true and 12s
        expect(powerManager.enableIdleSleep, isTrue);
        expect(powerManager.idleTimeoutSeconds, 12);

        powerManager.resetForTesting();
      },
    );
  });
}
