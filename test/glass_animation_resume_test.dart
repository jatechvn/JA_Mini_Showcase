import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/services/app_power_manager.dart';
import 'package:ja_mini_showcase/theme/app_colors.dart';
import 'package:ja_mini_showcase/theme/styles_win11.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Glass Animation Direction Preservation & Idle Tests', () {
    late AppPowerManager manager;

    setUp(() {
      manager = AppPowerManager.instance;
      manager.resetForTesting();
    });

    tearDown(() {
      manager.resetForTesting();
    });

    testWidgets(
      'MeshOrb preserves reverse direction when paused by blur and resumed by focus',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MeshOrb(
                color: Colors.blue,
                size: 200,
                duration: Duration(milliseconds: 1000),
                travel: Offset(50, 50),
              ),
            ),
          ),
        );

        // Advance 1100ms: completes forward (1000ms) and enters reverse phase
        await tester.pump(const Duration(milliseconds: 1100));

        // Blur window: stops animation
        manager.onWindowBlur();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Find the Transform widget inside MeshOrb
        final transformFinder = find.descendant(
          of: find.byType(MeshOrb),
          matching: find.byType(Transform),
        );
        expect(transformFinder, findsOneWidget);
        final initialTransform = tester.widget<Transform>(transformFinder);
        final initialTranslation = initialTransform.transform.getTranslation();

        // Restore focus: resumes animation
        manager.onWindowFocus();
        await tester.pump();

        // Advance 200ms in reverse leg: offset should decrease towards (0, 0)
        await tester.pump(const Duration(milliseconds: 200));
        final resumedTransform = tester.widget<Transform>(transformFinder);
        final resumedTranslation = resumedTransform.transform.getTranslation();

        // Verifies direction was preserved: travel was heading towards 0, not snapping back to 0 or restarting forward
        expect(resumedTranslation.x, lessThanOrEqualTo(initialTranslation.x));
        expect(resumedTranslation.y, lessThanOrEqualTo(initialTranslation.y));

        manager.resetForTesting();
      },
    );

    testWidgets('WaveIndicator stops on blur and resumes smoothly on focus', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WaveIndicator(color: Colors.cyan, height: 20)),
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(WaveIndicator), findsOneWidget);

      // Pause on blur
      manager.onWindowBlur();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Resume on focus
      manager.onWindowFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(WaveIndicator), findsOneWidget);

      manager.resetForTesting();
    });

    testWidgets(
      'Idle Sleep pauses MeshOrb while WaveIndicator continues running',
      (tester) async {
        final AppColors colors = win11DarkColors;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  MeshOrb(
                    color: colors.orb1,
                    size: 150,
                    duration: const Duration(milliseconds: 800),
                    travel: const Offset(30, 30),
                  ),
                  const WaveIndicator(color: Colors.teal),
                ],
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 200));
        expect(manager.shouldAnimateBackground, isTrue);
        expect(manager.shouldAnimateIndicators, isTrue);

        // Trigger Idle Sleep mode directly
        manager.setIdleForTesting(true);
        await tester.pump();

        // Background paused, indicator alive
        expect(manager.shouldAnimateBackground, isFalse);
        expect(manager.shouldAnimateIndicators, isTrue);

        // Record interaction -> wakes MeshOrb immediately
        manager.recordUserInteraction();
        await tester.pump();

        expect(manager.shouldAnimateBackground, isTrue);
        expect(manager.shouldAnimateIndicators, isTrue);

        manager.resetForTesting();
      },
    );

    testWidgets(
      'MeshOrb starts frozen if initialized while window is unfocused',
      (tester) async {
        manager.onWindowBlur();

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MeshOrb(
                color: Colors.red,
                size: 100,
                duration: Duration(milliseconds: 1000),
                travel: Offset(40, 40),
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 200));
        final transformFinder = find.descendant(
          of: find.byType(MeshOrb),
          matching: find.byType(Transform),
        );
        final initialTransform = tester.widget<Transform>(transformFinder);
        final initialOffset = initialTransform.transform.getTranslation();

        // Offset should stay at 0 while unfocused
        expect(initialOffset.x, 0.0);
        expect(initialOffset.y, 0.0);

        // Focus window -> begins animating
        manager.onWindowFocus();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        final activeTransform = tester.widget<Transform>(transformFinder);
        final activeOffset = activeTransform.transform.getTranslation();
        expect(activeOffset.x, greaterThan(0.0));

        manager.resetForTesting();
      },
    );
  });
}
