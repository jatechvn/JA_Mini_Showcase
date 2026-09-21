import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/search_history_repository.dart';
import 'package:ja_mini_showcase/theme/language_provider.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';
import 'package:ja_mini_showcase/widgets/glass_search_history_field.dart';
import 'package:provider/provider.dart';

void main() {
  late File tempFile;
  late SearchHistoryRepository repo;

  setUp(() async {
    tempFile = File(
      '${Directory.systemTemp.path}/test_search_history_field_${DateTime.now().microsecondsSinceEpoch}.json',
    );
    repo = SearchHistoryRepository();
    repo.setStorageFileForTesting(tempFile);
    await repo.addQuery('test_cat', 'BentoCard');
  });

  tearDown(() async {
    try {
      repo.setStorageFileForTesting(null);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (_) {}
  });

  testWidgets('Tapping on history item selects it and populates text field', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    String changedVal = '';
    String submittedVal = '';

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: GlassSearchHistoryField(
                  controller: controller,
                  focusNode: focusNode,
                  category: 'test_cat',
                  hintText: 'Search...',
                  onChanged: (val) => changedVal = val,
                  onSubmitted: (val) => submittedVal = val,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap on the text field to open history
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify overlay shows item
    expect(find.text('BentoCard'), findsOneWidget);

    // Tap on the history item
    await tester.runAsync(() async {
      await tester.tap(find.text('BentoCard'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Check if controller.text is set
    expect(controller.text, equals('BentoCard'));
    expect(changedVal, equals('BentoCard'));
    expect(submittedVal, equals('BentoCard'));
  });

  testWidgets('Tapping delete button on history item deletes it', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: GlassSearchHistoryField(
                  controller: controller,
                  focusNode: focusNode,
                  category: 'test_cat',
                  hintText: 'Search...',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Tap text field to open overlay
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('BentoCard'), findsOneWidget);

    // Tap delete icon
    await tester.runAsync(() async {
      await tester.tap(find.byIcon(Icons.close_rounded).first);
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify item is removed from repo
    final history = await repo.getHistory('test_cat');
    expect(history, isEmpty);
  });
}
