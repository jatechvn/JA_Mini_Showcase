import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/theme/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider Efficiency Mode Tests', () {
    late ThemeProvider theme;

    setUp(() {
      theme = ThemeProvider();
    });

    test('default state has non-zero blurs and isEfficiencyMode is false', () {
      expect(theme.isEfficiencyMode, isFalse);
      expect(theme.cardBlur, 20.0);
      expect(theme.dialogBlur, 20.0);
      expect(theme.dropdownBlur, 20.0);
    });

    test(
      'enabling efficiency mode zeroes blurs and boosts opacity without losing raw values',
      () {
        int notifyCount = 0;
        theme.addListener(() => notifyCount++);

        theme.setEfficiencyMode(true);

        expect(theme.isEfficiencyMode, isTrue);
        expect(theme.cardBlur, 0.0);
        expect(theme.dialogBlur, 0.0);
        expect(theme.dropdownBlur, 0.0);
        expect(theme.cardOpacity, 0.95);
        expect(theme.dialogOpacity, 0.98);
        expect(theme.dropdownOpacity, 0.98);

        // Raw values preserved
        expect(theme.rawCardBlur, 20.0);
        expect(theme.rawDialogBlur, 20.0);
        expect(theme.rawDropdownBlur, 20.0);
        expect(notifyCount, 1);

        // Disabling efficiency mode restores original blurs and opacities
        theme.setEfficiencyMode(false);

        expect(theme.isEfficiencyMode, isFalse);
        expect(theme.cardBlur, 20.0);
        expect(theme.dialogBlur, 20.0);
        expect(theme.dropdownBlur, 20.0);
        expect(theme.cardOpacity, 0.25);
        expect(notifyCount, 2);
      },
    );

    test('syncEfficiencyMode updates mode silently', () {
      theme.syncEfficiencyMode(true);
      expect(theme.isEfficiencyMode, isTrue);
      expect(theme.cardBlur, 0.0);

      theme.syncEfficiencyMode(false);
      expect(theme.isEfficiencyMode, isFalse);
      expect(theme.cardBlur, 20.0);
    });
  });
}
