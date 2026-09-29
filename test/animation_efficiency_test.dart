import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ja_mini_showcase/modules/window_focus_service.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('WaveIndicator pauses animation when efficiency mode is active', (
    tester,
  ) async {
    final focus = WindowFocusService();
    final theme = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: focus),
          ChangeNotifierProvider.value(value: theme),
        ],
        child: const MaterialApp(
          home: Scaffold(body: WaveIndicator(color: Colors.blue)),
        ),
      ),
    );

    // Initial state: animating
    await tester.pump(const Duration(milliseconds: 100));

    // Switch to efficiency mode (blur window)
    focus.setFocusedForTesting(false);
    theme.setEfficiencyMode(true);
    await tester.pump();

    // Verify it doesn't throw and renders cleanly in paused state
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(WaveIndicator), findsOneWidget);

    // Restore focus
    focus.setFocusedForTesting(true);
    theme.setEfficiencyMode(false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    focus.dispose();
    theme.dispose();
  });

  testWidgets('GlassScaffold hides MeshBackground in efficiency mode', (
    tester,
  ) async {
    final focus = WindowFocusService();
    final theme = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: focus),
          ChangeNotifierProvider.value(value: theme),
        ],
        child: const MaterialApp(
          home: GlassScaffold(
            enableMeshOrbs: true,
            body: Center(child: Text('Content')),
          ),
        ),
      ),
    );

    // Normal active mode: MeshBackground is present
    expect(find.byType(MeshBackground), findsOneWidget);

    // Switch to efficiency mode: MeshBackground is removed completely
    focus.setFocusedForTesting(false);
    theme.setEfficiencyMode(true);
    await tester.pump();

    expect(find.byType(MeshBackground), findsNothing);

    // Restore active mode: MeshBackground returns
    focus.setFocusedForTesting(true);
    theme.setEfficiencyMode(false);
    await tester.pump();

    expect(find.byType(MeshBackground), findsOneWidget);

    focus.dispose();
    theme.dispose();
  });
}
