import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';

void main() {
  testWidgets(
    'GlassScaffold renders body, header and MeshBackground properly',
    (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
          child: MaterialApp(
            home: GlassScaffold(
              header: const Text('Custom Header Title'),
              body: Center(
                child: Builder(
                  builder: (context) {
                    return BentoCard(
                      colors: context.watch<ThemeProvider>().colors,
                      child: const Text('Custom Glass Card'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Custom Header Title'), findsOneWidget);
      expect(find.text('Custom Glass Card'), findsOneWidget);
      expect(find.byType(MeshBackground), findsOneWidget);
      expect(find.byType(GlassScaffold), findsOneWidget);
    },
  );

  testWidgets('GlassScaffold functions gracefully without ThemeProvider', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GlassScaffold(
          body: Center(child: Text('Fallback Without Provider')),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Fallback Without Provider'), findsOneWidget);
    expect(find.byType(MeshBackground), findsOneWidget);
  });

  testWidgets(
    'BentoCard reactively updates blur and opacity from ThemeProvider',
    (tester) async {
      final theme = ThemeProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: theme,
          child: MaterialApp(
            home: Scaffold(
              body: BentoCard(
                colors: theme.colors,
                child: const Text('Dynamic Card'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Change blur to 0 (Lite mode behavior)
      theme.setLiveGlassmorphism(cardBlur: 0.0, cardOpacity: 0.8);
      await tester.pump();

      // When blur is 0, BackdropFilter is omitted for performance
      expect(find.byType(BackdropFilter), findsNothing);

      // Change blur to 30.0
      theme.setLiveGlassmorphism(cardBlur: 30.0, cardOpacity: 0.5);
      await tester.pump();

      expect(find.byType(BackdropFilter), findsOneWidget);
    },
  );
}
