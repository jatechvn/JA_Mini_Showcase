import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/theme/language_provider.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';
import 'package:ja_mini_showcase/widgets/glass_terminal.dart';
import 'package:provider/provider.dart';

Widget _createTerminalTestApp({
  String? title,
  String? welcomeText,
  Future<String?> Function(String)? onCommand,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: GlassTerminalPanel(
          terminalTitle: title,
          initialWelcomeText: welcomeText,
          onCommand: onCommand,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Failed custom command is printed and terminal remains usable', (
    tester,
  ) async {
    await tester.pumpWidget(
      _createTerminalTestApp(
        onCommand: (command) async {
          if (command == 'fail') throw StateError('test failure');
          return null;
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'fail');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.textContaining('Command failed:'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), 'echo recovered');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('recovered'), findsOneWidget);
  });

  group('GlassTerminalPanel Tests', () {
    testWidgets(
      'Renders terminal window chrome, badge and initial welcome message',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _createTerminalTestApp(
            title: 'test@ja-host:~',
            welcomeText: 'Welcome to JA Test Terminal',
          ),
        );
        await tester.pump();

        expect(find.text('test@ja-host:~'), findsOneWidget);
        expect(find.text('LIVE • READY'), findsOneWidget);
        expect(find.text('Welcome to JA Test Terminal'), findsOneWidget);
        expect(find.text('➜ ~'), findsOneWidget);
      },
    );

    testWidgets('Executes "help" command and displays command list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_createTerminalTestApp());
      await tester.pump();

      final inputFinder = find.byType(TextField);
      expect(inputFinder, findsOneWidget);

      await tester.enterText(inputFinder, 'help');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('➜ ~ help'), findsOneWidget);
      expect(
        find.text('Available Diagnostic & Shell Commands:'),
        findsOneWidget,
      );
      expect(
        find.text(
          '  status          Print runtime status, graphic tier & hardware specs',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Tapping quick action chip executes command immediately', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_createTerminalTestApp());
      await tester.pump();

      // Find 'nodes' chip and tap it
      final nodesChip = find.text('nodes');
      expect(nodesChip, findsOneWidget);

      await tester.tap(nodesChip);
      await tester.pump();

      expect(find.text('➜ ~ nodes'), findsOneWidget);
      expect(find.textContaining('JA-EDGE-01'), findsOneWidget);
      expect(find.textContaining('Primary Core'), findsOneWidget);
    });

    testWidgets('Clear button wipes the terminal stream buffer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _createTerminalTestApp(welcomeText: 'Initial Buffer Text'),
      );
      await tester.pump();

      expect(find.text('Initial Buffer Text'), findsOneWidget);

      // Find clear button
      final clearBtn = find.byIcon(Icons.delete_sweep_rounded);
      expect(clearBtn, findsOneWidget);

      await tester.tap(clearBtn);
      await tester.pump();

      expect(find.text('Initial Buffer Text'), findsNothing);
    });

    testWidgets(
      'Custom onCommand hook intercepts execution and displays response',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _createTerminalTestApp(
            onCommand: (cmd) async {
              if (cmd == 'whoami') return 'ja-operator (Administrator)';
              return null;
            },
          ),
        );
        await tester.pump();

        final inputFinder = find.byType(TextField);
        await tester.enterText(inputFinder, 'whoami');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(find.text('➜ ~ whoami'), findsOneWidget);
        expect(find.text('ja-operator (Administrator)'), findsOneWidget);
      },
    );

    testWidgets('Renders properly in both Light and Dark modes', (
      WidgetTester tester,
    ) async {
      final themeProvider = ThemeProvider(initialMode: 'dark');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: themeProvider),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: GlassTerminalPanel(terminalTitle: 'theme-test@ja:~'),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify Dark mode rendering
      expect(themeProvider.isDark, isTrue);
      expect(find.text('theme-test@ja:~'), findsOneWidget);

      // Switch to Light mode
      themeProvider.toggleTheme();
      await tester.pumpAndSettle();

      expect(themeProvider.isDark, isFalse);
      expect(find.text('theme-test@ja:~'), findsOneWidget);
    });

    testWidgets(
      'Up and Down arrow keys navigate command history and restore draft',
      (WidgetTester tester) async {
        await tester.pumpWidget(_createTerminalTestApp());
        await tester.pump();

        final inputFinder = find.byType(TextField);

        // Execute 2 commands: 'status' and 'version'
        await tester.enterText(inputFinder, 'status');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        await tester.enterText(inputFinder, 'version');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        // TextField should be empty and focused
        expect(find.widgetWithText(TextField, ''), findsOneWidget);

        // Press Up arrow: should show most recent command 'version'
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(find.widgetWithText(TextField, 'version'), findsOneWidget);

        // Press Up arrow again: should show older command 'status'
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(find.widgetWithText(TextField, 'status'), findsOneWidget);

        // Press Down arrow: should go forward to 'version'
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(find.widgetWithText(TextField, 'version'), findsOneWidget);

        // Press Down arrow again: should restore empty draft
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(find.widgetWithText(TextField, ''), findsOneWidget);
      },
    );

    testWidgets('Cursor remains focused after submitting a command', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_createTerminalTestApp());
      await tester.pump();

      final inputFinder = find.byType(TextField);
      await tester.enterText(inputFinder, 'echo hello');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      final textField = tester.widget<TextField>(inputFinder);
      expect(textField.focusNode!.hasFocus, isTrue);
      expect(textField.showCursor, isTrue);
    });

    testWidgets(
      'GlassTerminalController appends lines, clears buffer, and focuses prompt',
      (WidgetTester tester) async {
        final controller = GlassTerminalController();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GlassTerminalPanel(
                  controller: controller,
                  quickCommands: const ['ping', 'status', 'custom_run'],
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // 1. Verify custom quick command chips render
        expect(find.text('custom_run'), findsOneWidget);

        // 2. Programmatically append lines via controller
        controller.appendLine(
          '[DEPLOY] Service package deployed successfully',
          type: TerminalLineType.success,
        );
        controller.appendLines([
          '[WARN] High memory load detected: 84%',
          '[ERROR] Connection to 10.0.0.1 reset by peer',
        ], type: TerminalLineType.warn);
        await tester.pump();

        expect(
          find.text('[DEPLOY] Service package deployed successfully'),
          findsOneWidget,
        );
        expect(
          find.text('[WARN] High memory load detected: 84%'),
          findsOneWidget,
        );
        expect(
          find.text('[ERROR] Connection to 10.0.0.1 reset by peer'),
          findsOneWidget,
        );
        expect(controller.lineCount, greaterThanOrEqualTo(4));

        // 3. Focus prompt via controller
        controller.focusPrompt();
        await tester.pump();
        final promptField = tester.widget<TextField>(find.byType(TextField));
        expect(promptField.focusNode?.hasFocus, isTrue);

        // 4. Clear stream via controller
        controller.clear();
        await tester.pump();
        expect(
          find.text('[DEPLOY] Service package deployed successfully'),
          findsNothing,
        );
        expect(controller.lineCount, equals(0));
      },
    );

    testWidgets(
      'promptFocusNode auto-focuses terminal prompt on initial build',
      (WidgetTester tester) async {
        final promptFocus = FocusNode();
        addTearDown(promptFocus.dispose);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GlassTerminalPanel(promptFocusNode: promptFocus),
              ),
            ),
          ),
        );
        await tester.pump();

        promptFocus.requestFocus();
        await tester.pump();

        final promptField = tester.widget<TextField>(find.byType(TextField));
        expect(promptField.focusNode?.hasFocus, isTrue);
      },
    );
  });
}
