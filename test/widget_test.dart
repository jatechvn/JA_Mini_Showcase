import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/main.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';

void main() {
  testWidgets('App renders dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JaMiniShowcaseApp());
    expect(find.byType(JaMiniShowcaseApp), findsOneWidget);
  });

  group('RotatingGlowBorder Showcase Tests', () {
    testWidgets('RotatingGlowBorder renders child directly when inactive', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RotatingGlowBorder(
              isActive: false,
              color: Colors.cyan,
              child: Text('Inactive Card'),
            ),
          ),
        ),
      );

      expect(find.text('Inactive Card'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(RotatingGlowBorder),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    testWidgets(
      'RotatingGlowBorder activates CustomPaint and animates when active',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RotatingGlowBorder(
                isActive: true,
                color: Colors.cyan,
                child: Text('Active Card'),
              ),
            ),
          ),
        );

        expect(find.text('Active Card'), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(RotatingGlowBorder),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );

        // Advance clock to verify continuous rotation
        await tester.pump(const Duration(milliseconds: 500));
        expect(
          find.descendant(
            of: find.byType(RotatingGlowBorder),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'RotatingGlowBorder dynamically responds to isActive toggling',
      (tester) async {
        bool active = false;
        late StateSetter setStateCallback;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  setStateCallback = setState;
                  return RotatingGlowBorder(
                    isActive: active,
                    color: Colors.cyan,
                    child: const Text('Toggle Card'),
                  );
                },
              ),
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(RotatingGlowBorder),
            matching: find.byType(CustomPaint),
          ),
          findsNothing,
        );

        setStateCallback(() => active = true);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(RotatingGlowBorder),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );

        setStateCallback(() => active = false);
        await tester.pump();
        expect(
          find.descendant(
            of: find.byType(RotatingGlowBorder),
            matching: find.byType(CustomPaint),
          ),
          findsNothing,
        );
      },
    );

    test(
      'RotatingGlowBorderPainter paints on canvas and handles shouldRepaint',
      () {
        final painter1 = RotatingGlowBorderPainter(
          animationProgress: 0.25,
          color: Colors.cyan,
          borderRadius: 20.0,
          borderWidth: 2.0,
          glowBlur: 6.0,
        );
        final painter2 = RotatingGlowBorderPainter(
          animationProgress: 0.50,
          color: Colors.cyan,
          borderRadius: 20.0,
          borderWidth: 2.0,
          glowBlur: 6.0,
        );
        final painterIdentical = RotatingGlowBorderPainter(
          animationProgress: 0.25,
          color: Colors.cyan,
          borderRadius: 20.0,
          borderWidth: 2.0,
          glowBlur: 6.0,
        );

        expect(painter1.shouldRepaint(painter2), isTrue);
        expect(painter1.shouldRepaint(painterIdentical), isFalse);

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        expect(
          () => painter1.paint(canvas, const Size(200, 80)),
          returnsNormally,
        );
        expect(() => painter1.paint(canvas, Size.zero), returnsNormally);
        recorder.endRecording();
      },
    );

    testWidgets('BorderBeam renders with glowBlur properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BorderBeam(glowBlur: 4.0, child: Text('Beam Child')),
          ),
        ),
      );

      expect(find.text('Beam Child'), findsOneWidget);
      expect(find.byType(BorderBeam), findsOneWidget);
    });
  });
}
