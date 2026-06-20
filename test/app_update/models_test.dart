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
          'build_number': 5,
        };

        final config = UpdateConfig.fromJson(json);

        expect(config.latestVersion, '2.0.0');
        expect(config.downloadUrlV7a, 'https://example.com/app-v7a.apk');
        expect(config.downloadUrlV8a, 'https://example.com/app-v8a.apk');
        expect(config.isMandatory, true);
        expect(config.releaseNotes, 'Bug fixes and performance improvements');
        expect(config.buildNumber, 5);
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
        expect(config.buildNumber, 0);
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

    group('fromGitHubRelease', () {
      // Uses a real GitHub API release response from flutter/flutter repo.
      // Fetched from: https://api.github.com/repos/flutter/flutter/releases?per_page=1
      // This ensures our parser works with actual GitHub's response format.
      final realFlutterRelease = {
        'url':
            'https://api.github.com/repos/flutter/flutter/releases/136714249',
        'assets_url':
            'https://api.github.com/repos/flutter/flutter/releases/136714249/assets',
        'upload_url':
            'https://uploads.github.com/repos/flutter/flutter/releases/136714249/assets{?name,label}',
        'html_url':
            'https://github.com/flutter/flutter/releases/tag/3.19.0-0.1.pre',
        'id': 136714249,
        'author': {
          'login': 'itsjustkevin',
          'id': 11145366,
          'node_id': 'MDQ6VXNlcjExMTQ1MzY2',
          'avatar_url': 'https://avatars.githubusercontent.com/u/11145366?v=4',
          'gravatar_id': '',
          'url': 'https://api.github.com/users/itsjustkevin',
          'html_url': 'https://github.com/itsjustkevin',
        },
        'node_id': 'RE_kwDOAeUeuM4IJhgJ',
        'tag_name': '3.19.0-0.1.pre',
        'target_commitish': 'master',
        'name': 'Flutter 3.19 beta (January 10, 2024)',
        'draft': false,
        'immutable': false,
        'prerelease': false,
        'created_at': '2024-01-10T21:38:09Z',
        'updated_at': '2024-01-12T00:32:29Z',
        'published_at': '2024-01-11T18:31:57Z',
        'assets': <dynamic>[],
        'tarball_url':
            'https://api.github.com/repos/flutter/flutter/tarball/3.19.0-0.1.pre',
        'zipball_url':
            'https://api.github.com/repos/flutter/flutter/zipball/3.19.0-0.1.pre',
        'body':
            'The release of the Flutter 3.19 beta contains the changes noted below.\n\n'
            'To try out the newest beta run: \n```\n'
            'flutter channel beta\nflutter upgrade\n```\n\n'
            '# Flutter 3.19 beta (January 10, 2024)\n\n'
            '## Flutter Framework\n### Framework\n'
            '* Retry on transient Skia failure.\n'
            '* Add Impeller complex layout impeller benchmarks.\n'
            '* Enable TapRegion to detect all mouse button click\n'
            '* Removed deprecated NavigatorState.focusScopeNode\n'
            '* [Android] Bump template & integration test Gradle version to 7.6.4\n'
            '* Add accessibility identifier to `SemanticsProperties`\n'
            '* Animate TextStyle.fontVariations',
      };

      test(
        'parses a real GitHub release (flutter/flutter) with no APK assets',
        () {
          final config = UpdateConfig.fromGitHubRelease(realFlutterRelease);

          // tag_name: "3.19.0-0.1.pre" → no "v" prefix, version is "3.19.0"
          expect(config.latestVersion, '3.19.0');
          expect(config.buildNumber, 0); // no +N suffix
          // No APK assets in the flutter/flutter release
          expect(config.downloadUrlV8a, '');
          expect(config.downloadUrlV7a, '');
          expect(config.downloadUrlUniversal, '');
          expect(config.isMandatory, false);
          expect(
            config.releaseNotes,
            contains('Retry on transient Skia failure'),
          );
          expect(config.releaseNotes, contains('Flutter 3.19 beta'));
        },
      );

      test('handles tag with v prefix and build number', () {
        final release = {
          ...realFlutterRelease,
          'tag_name': 'v1.2.0+3',
          'assets': [
            {
              'name': 'quicksnap_android_v1.2.0+3_arm64-v8a.apk',
              'browser_download_url':
                  'https://github.com/val-en-tine124/quicksnap/releases/download/v1.2.0+3/quicksnap_android_v1.2.0+3_arm64-v8a.apk',
            },
            {
              'name': 'quicksnap_android_v1.2.0+3_armeabi-v7a.apk',
              'browser_download_url':
                  'https://github.com/val-en-tine124/quicksnap/releases/download/v1.2.0+3/quicksnap_android_v1.2.0+3_armeabi-v7a.apk',
            },
            {
              'name': 'quicksnap_android_v1.2.0+3_universal.apk',
              'browser_download_url':
                  'https://github.com/val-en-tine124/quicksnap/releases/download/v1.2.0+3/quicksnap_android_v1.2.0+3_universal.apk',
            },
          ],
        };

        final config = UpdateConfig.fromGitHubRelease(release);

        expect(config.latestVersion, '1.2.0');
        expect(config.buildNumber, 3);
        expect(config.downloadUrlV8a, contains('arm64-v8a.apk'));
        expect(config.downloadUrlV7a, contains('armeabi-v7a.apk'));
        expect(config.downloadUrlUniversal, contains('universal.apk'));
        expect(config.isMandatory, false);
      });

      test('falls back to universal APK when per-arch APKs are missing', () {
        final release = {
          ...realFlutterRelease,
          'tag_name': 'v1.0.0+1',
          'body': null,
          'assets': [
            {
              'name': 'quicksnap_android_v1.0.0+1_universal.apk',
              'browser_download_url':
                  'https://github.com/val-en-tine124/quicksnap/releases/download/v1.0.0+1/quicksnap_android_v1.0.0+1_universal.apk',
            },
          ],
        };

        final config = UpdateConfig.fromGitHubRelease(release);

        expect(config.latestVersion, '1.0.0');
        expect(config.buildNumber, 1);
        // When per-arch APKs are missing, falls back to universal
        expect(config.downloadUrlV8a, contains('universal.apk'));
        expect(config.downloadUrlV7a, contains('universal.apk'));
        expect(config.downloadUrlUniversal, contains('universal.apk'));
        expect(config.releaseNotes, isNull);
      });

      test('handles release with no body', () {
        final release = {
          ...realFlutterRelease,
          'tag_name': 'v2.0.0+5',
          'body': null,
          'assets': <dynamic>[],
        };

        final config = UpdateConfig.fromGitHubRelease(release);

        expect(config.latestVersion, '2.0.0');
        expect(config.buildNumber, 5);
        expect(config.releaseNotes, isNull);
      });

      test('handles empty tag name', () {
        final release = {
          ...realFlutterRelease,
          'tag_name': '',
          'assets': <dynamic>[],
        };

        final config = UpdateConfig.fromGitHubRelease(release);

        expect(config.latestVersion, '');
        expect(config.buildNumber, 0);
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
          buildNumber: 10,
        );

        final json = config.toJson();

        expect(json['latest_version'], '3.0.0');
        // toJson returns downloadUrlV8a as 'download_url'
        expect(json['download_url'], 'https://example.com/app-v8a.apk');
        expect(json['is_mandatory'], true);
        expect(json['build_number'], 10);
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
    });

    group('toString', () {
      test('returns formatted string with all fields', () {
        const config = UpdateConfig(
          latestVersion: '1.2.3',
          downloadUrlV7a: 'https://example.com/app-v7a.apk',
          downloadUrlV8a: 'https://example.com/app-v8a.apk',
          isMandatory: true,
          releaseNotes: 'Fixes',
          buildNumber: 4,
        );

        final result = config.toString();

        expect(result, contains('1.2.3'));
        expect(result, contains('https://example.com/app-v7a.apk'));
        expect(result, contains('https://example.com/app-v8a.apk'));
        expect(result, contains('true'));
        expect(result, contains('Fixes'));
        expect(result, contains('4'));
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
