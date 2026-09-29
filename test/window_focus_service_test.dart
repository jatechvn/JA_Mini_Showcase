import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/window_focus_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WindowFocusService Tests', () {
    late WindowFocusService service;

    setUp(() {
      service = WindowFocusService();
    });

    tearDown(() {
      service.dispose();
    });

    test('initial state defaults to active (not efficiency mode)', () {
      expect(service.isFocused, isTrue);
      expect(service.isMinimized, isFalse);
      expect(service.isEfficiencyMode, isFalse);
    });

    test('onWindowBlur triggers efficiency mode and notifies listeners', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      service.onWindowBlur();

      expect(service.isFocused, isFalse);
      expect(service.isEfficiencyMode, isTrue);
      expect(notifyCount, 1);

      // Redundant call should not trigger another notification
      service.onWindowBlur();
      expect(notifyCount, 1);
    });

    test('onWindowFocus restores active mode and notifies listeners', () {
      service.onWindowBlur();
      expect(service.isEfficiencyMode, isTrue);

      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      service.onWindowFocus();

      expect(service.isFocused, isTrue);
      expect(service.isEfficiencyMode, isFalse);
      expect(notifyCount, 1);

      // Redundant call
      service.onWindowFocus();
      expect(notifyCount, 1);
    });

    test(
      'onWindowMinimize sets minimized & unfocused, triggering efficiency mode',
      () {
        int notifyCount = 0;
        service.addListener(() => notifyCount++);

        service.onWindowMinimize();

        expect(service.isMinimized, isTrue);
        expect(service.isFocused, isFalse);
        expect(service.isEfficiencyMode, isTrue);
        expect(notifyCount, 1);
      },
    );

    test('onWindowRestore resets minimized & restores focus', () {
      service.onWindowMinimize();
      expect(service.isEfficiencyMode, isTrue);

      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      service.onWindowRestore();

      expect(service.isMinimized, isFalse);
      expect(service.isFocused, isTrue);
      expect(service.isEfficiencyMode, isFalse);
      expect(notifyCount, 1);
    });

    test(
      'testing helpers setFocusedForTesting and setMinimizedForTesting work properly',
      () {
        int notifyCount = 0;
        service.addListener(() => notifyCount++);

        service.setFocusedForTesting(false);
        expect(service.isFocused, isFalse);
        expect(service.isEfficiencyMode, isTrue);
        expect(notifyCount, 1);

        service.setMinimizedForTesting(true);
        expect(service.isMinimized, isTrue);
        expect(service.isEfficiencyMode, isTrue);
        expect(notifyCount, 2);

        service.setMinimizedForTesting(false);
        expect(service.isMinimized, isFalse);
        expect(notifyCount, 3);

        service.setFocusedForTesting(true);
        expect(service.isFocused, isTrue);
        expect(service.isEfficiencyMode, isFalse);
        expect(notifyCount, 4);
      },
    );

    test(
      'init can be called safely without native window on test environment',
      () {
        expect(() => service.init(), returnsNormally);
        // Calling init twice is safe
        expect(() => service.init(), returnsNormally);
      },
    );
  });
}
