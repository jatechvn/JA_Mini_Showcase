import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/services/app_power_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppPowerManager 4-Tier Policy Tests', () {
    late AppPowerManager manager;

    setUp(() {
      manager = AppPowerManager.instance;
      manager.resetForTesting();
    });

    tearDown(() {
      manager.resetForTesting();
    });

    test('Initial active state has all 3 notifiers true', () {
      expect(manager.isWindowFocused, isTrue);
      expect(manager.isWindowVisible, isTrue);
      expect(manager.isUserIdle, isFalse);
      expect(manager.enableIdleSleep, isTrue);
      expect(manager.idleTimeoutSeconds, 12);

      expect(manager.shouldAnimateBackground, isTrue);
      expect(manager.shouldAnimateIndicators, isTrue);
      expect(manager.shouldAnimateMarquee, isTrue);
      expect(manager.isEfficiencyMode, isFalse);
    });

    test('onWindowBlur() stops all 3 notifiers and enters efficiency mode', () {
      manager.onWindowBlur();

      expect(manager.isWindowFocused, isFalse);
      expect(manager.isEfficiencyMode, isTrue);
      expect(manager.shouldAnimateBackground, isFalse);
      expect(manager.shouldAnimateIndicators, isFalse);
      expect(manager.shouldAnimateMarquee, isFalse);
    });

    test('onWindowFocus() restores all 3 notifiers and resets idle', () {
      manager.onWindowBlur();
      expect(manager.isEfficiencyMode, isTrue);

      manager.onWindowFocus();

      expect(manager.isWindowFocused, isTrue);
      expect(manager.isEfficiencyMode, isFalse);
      expect(manager.shouldAnimateBackground, isTrue);
      expect(manager.shouldAnimateIndicators, isTrue);
      expect(manager.shouldAnimateMarquee, isTrue);
      manager.resetForTesting();
    });

    test('onWindowMinimize() triggers Deep Sleep (all notifiers false)', () {
      manager.onWindowMinimize();

      expect(manager.isWindowVisible, isFalse);
      expect(manager.isWindowFocused, isFalse);
      expect(manager.isEfficiencyMode, isTrue);
      expect(manager.shouldAnimateBackground, isFalse);
      expect(manager.shouldAnimateIndicators, isFalse);
      expect(manager.shouldAnimateMarquee, isFalse);
    });

    testWidgets(
      'Idle sleep pauses background MeshOrb after timeout but keeps indicators and marquee',
      (tester) async {
        manager.setFocusedForTesting(true);
        expect(manager.shouldAnimateBackground, isTrue);
        expect(manager.shouldAnimateIndicators, isTrue);
        expect(manager.shouldAnimateMarquee, isTrue);

        // Advance 11 seconds: still active
        await tester.pump(const Duration(seconds: 11));
        expect(manager.isUserIdle, isFalse);
        expect(manager.shouldAnimateBackground, isTrue);

        // Advance past 12s threshold: enters Idle Sleep
        await tester.pump(const Duration(seconds: 2));
        expect(manager.isUserIdle, isTrue);
        expect(
          manager.shouldAnimateBackground,
          isFalse,
        ); // MeshOrb paused to save GPU
        expect(
          manager.shouldAnimateIndicators,
          isTrue,
        ); // Wave/Beam remains alive
        expect(manager.shouldAnimateMarquee, isTrue); // Marquee remains alive

        // User interaction wakes background MeshOrb immediately
        manager.recordUserInteraction();
        expect(manager.isUserIdle, isFalse);
        expect(manager.shouldAnimateBackground, isTrue);

        manager.resetForTesting();
      },
    );

    testWidgets(
      'recordUserInteraction throttles idle timer restarts to 600ms',
      (tester) async {
        DateTime fakeTime = DateTime(2026, 1, 1, 12, 0, 0);
        manager.nowProvider = () => fakeTime;
        manager.setFocusedForTesting(true);

        // Interaction within 100ms should be throttled
        fakeTime = fakeTime.add(const Duration(milliseconds: 100));
        manager.recordUserInteraction();
        await tester.pump(const Duration(milliseconds: 100));

        // Interaction within another 100ms should be throttled
        fakeTime = fakeTime.add(const Duration(milliseconds: 100));
        manager.recordUserInteraction();
        await tester.pump(const Duration(milliseconds: 100));

        // 11.5s later: still awake
        fakeTime = fakeTime.add(const Duration(seconds: 11, milliseconds: 300));
        await tester.pump(const Duration(seconds: 11, milliseconds: 300));
        expect(manager.isUserIdle, isFalse);

        // Cross 12s total: idle activates
        fakeTime = fakeTime.add(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
        expect(manager.isUserIdle, isTrue);

        manager.resetForTesting();
      },
    );

    testWidgets(
      'Disabling Idle Sleep mode keeps background running continuously',
      (tester) async {
        manager.setEnableIdleSleep(false);
        manager.setFocusedForTesting(true);

        // Advance 30 seconds: background remains active
        await tester.pump(const Duration(seconds: 30));
        expect(manager.isUserIdle, isFalse);
        expect(manager.shouldAnimateBackground, isTrue);

        manager.resetForTesting();
      },
    );

    testWidgets('setIdleTimeoutSeconds changes the threshold accurately', (
      tester,
    ) async {
      manager.setIdleTimeoutSeconds(30);
      manager.setFocusedForTesting(true);

      // At 15s, not idle yet
      await tester.pump(const Duration(seconds: 15));
      expect(manager.isUserIdle, isFalse);
      expect(manager.shouldAnimateBackground, isTrue);

      // At 31s, idle triggers
      await tester.pump(const Duration(seconds: 16));
      expect(manager.isUserIdle, isTrue);
      expect(manager.shouldAnimateBackground, isFalse);

      manager.resetForTesting();
    });
  });
}
