import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ja_mini_showcase/modules/ota_update_service.dart';
import 'package:ja_mini_showcase/theme/language_provider.dart';

void main() {
  group('SemanticVersion parsing and comparison', () {
    test('parses standard semver versions', () {
      final v = SemanticVersion.tryParse('1.2.3');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 3);
      expect(v.build, isNull);
      expect(v.prerelease, isNull);
      expect(v.displayVersion, 'v1.2.3');
    });

    test('parses version with v prefix and build number', () {
      final v = SemanticVersion.tryParse('v2.0.1+45');
      expect(v, isNotNull);
      expect(v!.major, 2);
      expect(v.minor, 0);
      expect(v.patch, 1);
      expect(v.build, 45);
      expect(v.displayVersion, 'v2.0.1+45');
    });

    test('parses 2-digit version cleanly', () {
      final v = SemanticVersion.tryParse('1.0');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 0);
      expect(v.patch, 0);
    });

    test('returns null for invalid strings', () {
      expect(SemanticVersion.tryParse(null), isNull);
      expect(SemanticVersion.tryParse(''), isNull);
      expect(SemanticVersion.tryParse('abc'), isNull);
      expect(SemanticVersion.tryParse('v.1.2'), isNull);
    });

    test('compares versions accurately by major, minor, patch', () {
      final v1 = SemanticVersion.tryParse('1.0.0')!;
      final v2 = SemanticVersion.tryParse('1.0.1')!;
      final v3 = SemanticVersion.tryParse('1.1.0')!;
      final v4 = SemanticVersion.tryParse('2.0.0')!;

      expect(v2 > v1, isTrue);
      expect(v3 > v2, isTrue);
      expect(v4 > v3, isTrue);
      expect(v1 < v2, isTrue);
      expect(v1 <= v1, isTrue);
      expect(v1 >= v1, isTrue);
      expect(v1 == SemanticVersion.tryParse('1.0.0')!, isTrue);
    });

    test('build number acts as tie-breaker when version core is equal', () {
      final v1 = SemanticVersion.tryParse('1.1.0+1')!;
      final v2 = SemanticVersion.tryParse('1.1.0+2')!;
      expect(v2 > v1, isTrue);
      expect(v1 < v2, isTrue);
    });

    test('handles prereleases with lower precedence than final release', () {
      final beta = SemanticVersion.tryParse('1.0.0-beta')!;
      final release = SemanticVersion.tryParse('1.0.0')!;
      expect(release > beta, isTrue);
    });
  });

  group('OtaUpdateConfig serialization', () {
    test('defaults match standard configuration', () {
      final config = OtaUpdateConfig.defaults();
      expect(config.serverPath, contains('JA_Mini_Showcase'));
      expect(config.username, isEmpty);
      expect(config.checkInterval, 'daily');
      expect(config.autoDownload, isFalse);
      expect(config.lastCheckTime, isNull);
    });

    test('serializes to and from JSON faithfully', () {
      final now = DateTime(2026, 9, 21, 15, 0, 0);
      final orig = OtaUpdateConfig(
        serverPath: r'\\server\share\updates',
        username: 'admin',
        checkInterval: 'weekly',
        autoDownload: true,
        lastCheckTime: now,
      );

      final json = orig.toJson();
      final restored = OtaUpdateConfig.fromJson(json);

      expect(restored.serverPath, orig.serverPath);
      expect(restored.username, orig.username);
      expect(restored.checkInterval, orig.checkInterval);
      expect(restored.autoDownload, orig.autoDownload);
      expect(restored.lastCheckTime, orig.lastCheckTime);
    });

    test('copyWith produces correctly modified instances', () {
      final orig = OtaUpdateConfig.defaults();
      final modified = orig.copyWith(
        checkInterval: 'monthly',
        autoDownload: true,
      );
      expect(modified.checkInterval, 'monthly');
      expect(modified.autoDownload, isTrue);
      expect(modified.serverPath, orig.serverPath);
    });

    test('does not persist legacy plaintext passwords', () async {
      final tempDir = await Directory.systemTemp.createTemp('ota_config_test_');
      final configFile = File(
        '${tempDir.path}${Platform.pathSeparator}config.json',
      );
      final service = OtaUpdateService();
      service.setCustomConfigFileForTesting(configFile);
      addTearDown(() async {
        service.setCustomConfigFileForTesting(null);
        await tempDir.delete(recursive: true);
      });
      await configFile.writeAsString(
        jsonEncode({
          'serverPath': r'\\server\share\updates',
          'username': 'admin',
          'password': 'legacy-secret',
        }),
      );

      final config = await service.loadConfig();
      final persisted =
          jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;

      expect(config.username, 'admin');
      expect(persisted, isNot(contains('password')));
    });
  });

  group('OtaUpdateService helpers & validation', () {
    test('isValidPackageName validates correct zip package format', () {
      expect(
        OtaUpdateService.isValidPackageName('JA_Mini_Showcase_1.1.0+3.zip'),
        isTrue,
      );
      expect(
        OtaUpdateService.isValidPackageName('ja_mini_showcase_1.2.0.zip'),
        isTrue,
      );
      expect(
        OtaUpdateService.isValidPackageName(
          'JA_Mini_Showcase_2.0.0-beta.1.zip',
        ),
        isTrue,
      );

      // Invalids
      expect(
        OtaUpdateService.isValidPackageName('JA_LAN_Messenger_1.0.0.zip'),
        isFalse,
      );
      expect(
        OtaUpdateService.isValidPackageName('JA_Mini_Showcase_1.0.0.exe'),
        isFalse,
      );
      expect(
        OtaUpdateService.isValidPackageName('../JA_Mini_Showcase_1.0.0.zip'),
        isFalse,
      );
      expect(
        OtaUpdateService.isValidPackageName(
          r'JA_Mini_Showcase_1.0.0\\payload.zip',
        ),
        isFalse,
      );
    });

    test('validates SHA-256 and derives the SMB credential target', () {
      expect(OtaUpdateService.isValidSha256('a' * 64), isTrue);
      expect(OtaUpdateService.isValidSha256('A' * 64), isTrue);
      expect(OtaUpdateService.isValidSha256('a' * 63), isFalse);
      expect(OtaUpdateService.isValidSha256('g' * 64), isFalse);
      expect(
        OtaUpdateService.extractSmbServerName(r'\\10.0.0.8\updates\app'),
        '10.0.0.8',
      );
      expect(OtaUpdateService.extractSmbServerName('C:/updates'), isNull);
    });

    test('shouldCheckForUpdates respects interval conditions', () {
      final service = OtaUpdateService();

      // Disabled
      expect(
        service.shouldCheckForUpdates(interval: 'off', lastCheckTime: null),
        isFalse,
      );

      // Never checked before -> should check
      expect(
        service.shouldCheckForUpdates(interval: 'daily', lastCheckTime: null),
        isTrue,
      );

      // Daily: checked 10 minutes ago -> should NOT check
      final tenMinsAgo = DateTime.now().subtract(const Duration(minutes: 10));
      expect(
        service.shouldCheckForUpdates(
          interval: 'daily',
          lastCheckTime: tenMinsAgo,
        ),
        isFalse,
      );

      // Daily: checked 25 hours ago -> should check
      final dayAgo = DateTime.now().subtract(const Duration(hours: 25));
      expect(
        service.shouldCheckForUpdates(interval: 'daily', lastCheckTime: dayAgo),
        isTrue,
      );

      // Weekly: checked 3 days ago -> should NOT check
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      expect(
        service.shouldCheckForUpdates(
          interval: 'weekly',
          lastCheckTime: threeDaysAgo,
        ),
        isFalse,
      );

      // Weekly: checked 8 days ago -> should check
      final eightDaysAgo = DateTime.now().subtract(const Duration(days: 8));
      expect(
        service.shouldCheckForUpdates(
          interval: 'weekly',
          lastCheckTime: eightDaysAgo,
        ),
        isTrue,
      );
    });

    test('UpdatePackageInfo formattedSize returns human readable sizes', () {
      final infoZero = UpdatePackageInfo(
        version: SemanticVersion.tryParse('1.0.0')!,
        fileName: 'JA_Mini_Showcase_1.0.0.zip',
        fullPath: r'\\server\test.zip',
        fileSize: 0,
        sha256: 'a' * 64,
      );
      expect(infoZero.formattedSize, '0 B');

      final infoKb = UpdatePackageInfo(
        version: SemanticVersion.tryParse('1.0.0')!,
        fileName: 'JA_Mini_Showcase_1.0.0.zip',
        fullPath: r'\\server\test.zip',
        fileSize: 1024 * 512,
        sha256: 'a' * 64,
      );
      expect(infoKb.formattedSize, '512.00 KB');

      final infoMb = UpdatePackageInfo(
        version: SemanticVersion.tryParse('1.0.0')!,
        fileName: 'JA_Mini_Showcase_1.0.0.zip',
        fullPath: r'\\server\test.zip',
        fileSize: 45 * 1024 * 1024,
        sha256: 'a' * 64,
      );
      expect(infoMb.formattedSize, '45.00 MB');
    });
  });

  group('Signed update manifest', () {
    late Directory tempDir;
    late OtaUpdateService service;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ota_manifest_test_');
      service = OtaUpdateService();
      service.setCustomServerDirForTesting(tempDir);
      service.setCustomConfigFileForTesting(
        File('${tempDir.path}${Platform.pathSeparator}config.json'),
      );
    });

    tearDown(() async {
      service.setCustomServerDirForTesting(null);
      service.setCustomConfigFileForTesting(null);
      await tempDir.delete(recursive: true);
    });

    test('accepts an existing package with a valid SHA-256 manifest', () async {
      final package = File(
        '${tempDir.path}${Platform.pathSeparator}JA_Mini_Showcase_1.2.0.zip',
      );
      await package.writeAsBytes([1, 2, 3, 4]);
      final checksum = await OtaUpdateService.calculateSha256(package);
      await File(
        '${tempDir.path}${Platform.pathSeparator}version.json',
      ).writeAsString(
        jsonEncode({
          'version': '1.2.0',
          'fileName': package.uri.pathSegments.last,
          'sha256': checksum,
        }),
      );

      final result = await service.checkForUpdates(
        overrideCurrentVersion: '1.1.0',
      );

      expect(result.hasUpdate, isTrue);
      expect(result.packageInfo?.sha256, checksum);
    });

    test('rejects a manifest with no SHA-256 or unsafe package path', () async {
      final manifest = File(
        '${tempDir.path}${Platform.pathSeparator}version.json',
      );
      await manifest.writeAsString(
        jsonEncode({
          'version': '1.2.0',
          'fileName': '../JA_Mini_Showcase_1.2.0.zip',
        }),
      );

      final result = await service.checkForUpdates(
        overrideCurrentVersion: '1.1.0',
      );

      expect(result.hasUpdate, isFalse);
      expect(result.errorMessage, contains('SHA-256'));
    });

    test('rejects a package when the downloaded SHA-256 differs', () async {
      final package = File(
        '${tempDir.path}${Platform.pathSeparator}JA_Mini_Showcase_1.2.0.zip',
      );
      await package.writeAsBytes([1, 2, 3, 4]);
      final packageInfo = UpdatePackageInfo(
        version: SemanticVersion.tryParse('1.2.0')!,
        fileName: 'JA_Mini_Showcase_1.2.0.zip',
        fullPath: package.path,
        fileSize: await package.length(),
        sha256: '0' * 64,
      );

      await expectLater(
        service.validatePackageForTesting(packageInfo),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('LanguageProvider OTA translations & formatting', () {
    test('parameter substitution replaces %s and %d properly', () {
      final lang = LanguageProvider();
      lang.setLanguage(AppLanguage.vi);
      final formatted = lang.t('ota_update_available', ['v1.2.0']);
      expect(formatted, contains('v1.2.0'));
      expect(formatted, isNot(contains('%s')));

      final noUpdates = lang.t('ota_no_updates', ['v1.1.0']);
      expect(noUpdates, contains('v1.1.0'));
      expect(noUpdates, isNot(contains('%s')));
    });

    test('all OTA translation keys exist across VI, EN, CN', () {
      final lang = LanguageProvider();
      const otaKeys = [
        'tab_ota_update',
        'ota_title',
        'ota_desc',
        'ota_server_path',
        'ota_check_interval',
        'interval_daily',
        'interval_weekly',
        'interval_monthly',
        'interval_off',
        'ota_auth_title',
        'ota_username',
        'ota_password',
        'ota_open_config_folder',
        'ota_test_connection',
        'ota_testing_connection',
        'ota_connection_success',
        'ota_connection_failed',
        'ota_check_now',
        'ota_checking',
        'ota_no_updates',
        'ota_update_available',
        'ota_update_tooltip',
        'ota_current_version',
        'ota_latest_version',
        'ota_last_checked',
        'ota_never_checked',
        'ota_dialog_title',
        'ota_package_size',
        'ota_release_notes',
        'ota_update_now',
        'ota_update_later',
        'ota_downloading',
        'ota_extracting',
        'ota_ready_restart',
      ];

      for (final appLang in AppLanguage.values) {
        lang.setLanguage(appLang);
        for (final key in otaKeys) {
          final text = lang.t(key);
          expect(
            text,
            isNot(key),
            reason: 'Key "$key" should have translation in ${appLang.code}',
          );
        }
      }
    });
  });
}
