import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/services/app_power_manager.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlassMarquee Session Epoch & Frozen Offset Tests', () {
    late AppPowerManager manager;

    setUp(() {
      manager = AppPowerManager.instance;
      manager.resetForTesting();
    });

    tearDown(() {
      manager.resetForTesting();
    });

    testWidgets(
      'AsymmetricMarqueeText freezes offset on blur and resumes without resetting to 0',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                child: AsymmetricMarqueeText(
                  text:
                      'A very long long long text headline string that definitely overflows container constraints',
                  pauseStart: Duration(milliseconds: 200),
                  pauseEnd: Duration(milliseconds: 200),
                  velocity: 100.0,
                  forwardCurve: Curves.linear,
                  returnCurve: Curves.linear,
                ),
              ),
            ),
          ),
        );

        // Initial frame to run postFrameCallback
        await tester.pump();
        // Advance past pauseStart (200ms) to trigger _animateForward
        await tester.pump(const Duration(milliseconds: 250));
        // Advance frames to allow ScrollController.animateTo to scroll
        await tester.pump(const Duration(milliseconds: 300));

        final scrollableFinder = find.byType(SingleChildScrollView);
        expect(scrollableFinder, findsOneWidget);
        final scrollable = tester.widget<SingleChildScrollView>(
          scrollableFinder,
        );
        final controller = scrollable.controller!;

        // Expect it has started scrolling
        expect(controller.offset, greaterThan(0.0));
        final frozenOffset = controller.offset;

        // Blur window: should freeze offset immediately
        manager.onWindowBlur();
        await tester.pump();

        // Advance 1000ms while blurred: offset must stay strictly equal to frozenOffset
        await tester.pump(const Duration(milliseconds: 1000));
        expect(controller.offset, equals(frozenOffset));

        // Restore focus: resumes scrolling from frozenOffset
        manager.onWindowFocus();
        await tester.pump();
        // Allow postFrameCallback and animation ticks
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump(const Duration(milliseconds: 400));

        // Offset should continue advancing, NOT jump back to 0
        expect(controller.offset, greaterThan(frozenOffset));

        manager.resetForTesting();
      },
    );

    testWidgets(
      'Completed Future callbacks during blurred state are rejected by session epoch',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 80,
                child: AsymmetricMarqueeText(
                  text: 'Overflow text headline ticker sample',
                  pauseStart: Duration(milliseconds: 100),
                  pauseEnd: Duration(milliseconds: 100),
                  velocity: 100.0,
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump(const Duration(milliseconds: 150));

        final scrollable = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        final controller = scrollable.controller!;
        final offsetAtBlur = controller.offset;

        // Blur window
        manager.onWindowBlur();
        await tester.pump();

        // Advance past all former callback times
        await tester.pump(const Duration(seconds: 3));

        // Offset remains exactly where it was frozen
        expect(controller.offset, equals(offsetAtBlur));

        manager.resetForTesting();
      },
    );
  });
}
