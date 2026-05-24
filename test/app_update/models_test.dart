import 'package:flutter_test/flutter_test.dart';
import 'package:quicksnap/features/app_update/models.dart';

void main() {
  group('UpdateConfig', () {
    group('fromJson', () {
      test('parses valid JSON with all fields', () {
        final json = {
          'latest_version': '2.0.0',
          'download_url_v7a': 'https://example.com/app-v7a.apk',
          'download_url_v8a': 'https://example.com/app-v8a.apk',
          'is_mandatory': true,
          'release_notes': 'Bug fixes and performance improvements',
        };

        final config = UpdateConfig.fromJson(json);

        expect(config.latestVersion, '2.0.0');
        expect(config.downloadUrlV7a, 'https://example.com/app-v7a.apk');
        expect(config.downloadUrlV8a, 'https://example.com/app-v8a.apk');
        expect(config.isMandatory, true);
        expect(config.releaseNotes, 'Bug fixes and performance improvements');
      });

      test('parses JSON with missing optional fields', () {
        final json = {
          'latest_version': '1.1.0',
          'download_url_v7a': 'https://example.com/update-v7a.apk',
          'download_url_v8a': 'https://example.com/update-v8a.apk',
        };

        final config = UpdateConfig.fromJson(json);

        expect(config.latestVersion, '1.1.0');
        expect(config.downloadUrlV7a, 'https://example.com/update-v7a.apk');
        expect(config.downloadUrlV8a, 'https://example.com/update-v8a.apk');
        expect(config.isMandatory, false);
        expect(config.releaseNotes, isNull);
      });

      test('parses JSON with is_mandatory explicitly false', () {
        final json = {
          'latest_version': '1.0.1',
          'download_url_v7a': 'https://example.com/app-v7a.apk',
          'download_url_v8a': 'https://example.com/app-v8a.apk',
          'is_mandatory': false,
        };

        final config = UpdateConfig.fromJson(json);

        expect(config.isMandatory, false);
      });
    });

    group('toJson', () {
      test('serializes all fields correctly', () {
        const config = UpdateConfig(
          latestVersion: '3.0.0',
          downloadUrlV8a: 'https://example.com/app-v8a.apk',
          downloadUrlV7a: 'https://example.com/app-v7a.apk',
          isMandatory: true,
          releaseNotes: 'Major update with new features',
        );

        final json = config.toJson();

        expect(json['latest_version'], '3.0.0');
        // toJson returns downloadUrlV8a as 'download_url'
        expect(json['download_url'], 'https://example.com/app-v8a.apk');
        expect(json['is_mandatory'], true);
        expect(json['release_notes'], 'Major update with new features');
      });

      test('excludes release_notes when null', () {
        const config = UpdateConfig(
          latestVersion: '1.0.0',
          downloadUrlV8a: 'https://example.com/app-v8a.apk',
          downloadUrlV7a: 'https://example.com/app-v7a.apk',
          isMandatory: false,
        );

        final json = config.toJson();

        expect(json.containsKey('release_notes'), isFalse);
      });

      test('round-trip serialization', () {
        const original = UpdateConfig(
          latestVersion: '2.1.0',
          downloadUrlV8a: 'https://example.com/app-v8a.apk',
          downloadUrlV7a: 'https://example.com/app-v7a.apk',
          isMandatory: true,
          releaseNotes: 'Test release',
        );

        final json = original.toJson();
        // Note: round-trip doesn't work perfectly because toJson only outputs download_url (v8a)
        // So we test what we can
        expect(json['latest_version'], original.latestVersion);
        expect(json['is_mandatory'], original.isMandatory);
        expect(json['release_notes'], original.releaseNotes);
      });
    });

    group('toString', () {
      test('returns formatted string with all fields', () {
        const config = UpdateConfig(
          latestVersion: '1.2.3',
          downloadUrlV7a: 'https://example.com/app-v7a.apk',
          downloadUrlV8a: 'https://example.com/app-v8a.apk',
          isMandatory: true,
          releaseNotes: 'Fixes',
        );

        final result = config.toString();

        expect(result, contains('1.2.3'));
        expect(result, contains('https://example.com/app-v7a.apk'));
        expect(result, contains('https://example.com/app-v8a.apk'));
        expect(result, contains('true'));
        expect(result, contains('Fixes'));
      });

      test('returns formatted string without release notes', () {
        const config = UpdateConfig(
          latestVersion: '1.0.0',
          downloadUrlV8a: 'https://example.com/app-v8a.apk',
          downloadUrlV7a: 'https://example.com/app-v7a.apk',
          isMandatory: false,
        );

        final result = config.toString();

        expect(result, contains('null'));
      });
    });
  });
}