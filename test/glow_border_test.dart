import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/widgets/glass_widgets.dart';

void main() {
  testWidgets('Border repaints when colors change while animation is paused', (
    tester,
  ) async {
    Widget app(Color color) => MaterialApp(
      home: TickerMode(
        enabled: false,
        child: Center(
          child: BorderBeam(
            colors: [color, Colors.white],
            child: const SizedBox(width: 100, height: 60),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(Colors.red));
    final before = tester
        .widgetList<CustomPaint>(
          find.descendant(
            of: find.byType(BorderBeam),
            matching: find.byType(CustomPaint),
          ),
        )
        .firstWhere((w) => w.foregroundPainter != null)
        .foregroundPainter!;
    await tester.pumpWidget(app(Colors.blue));
    final after = tester
        .widgetList<CustomPaint>(
          find.descendant(
            of: find.byType(BorderBeam),
            matching: find.byType(CustomPaint),
          ),
        )
        .firstWhere((w) => w.foregroundPainter != null)
        .foregroundPainter!;
    expect(after.shouldRepaint(before), isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
