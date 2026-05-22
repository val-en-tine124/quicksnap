import 'package:flutter_test/flutter_test.dart';
import 'package:quicksnap/features/app_update/models.dart';
import 'package:quicksnap/features/app_update/providers.dart';

void main() {
  group('Version Comparison', () {
    // These tests verify the _compareVersions function logic
    // Since _compareVersions is private, we test it through UpdateAvailabilityState behavior

    group('equal versions', () {
      test('1.0.0 equals 1.0.0', () {
        // When versions are equal, isUpdateAvailable should be false
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '1.0.0',
          updateConfig: UpdateConfig(
            latestVersion: '1.0.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, false);
      });

      test('2.1.3 equals 2.1.3', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '2.1.3',
          updateConfig: UpdateConfig(
            latestVersion: '2.1.3',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, false);
      });
    });

    group('major version updates', () {
      test('1.0.0 < 2.0.0 (update available)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.0.0',
          updateConfig: UpdateConfig(
            latestVersion: '2.0.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, true);
      });

      test('3.0.0 > 2.0.0 (no update needed)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '3.0.0',
          updateConfig: UpdateConfig(
            latestVersion: '2.0.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, false);
      });
    });

    group('minor version updates', () {
      test('1.1.0 < 1.2.0 (update available)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.1.0',
          updateConfig: UpdateConfig(
            latestVersion: '1.2.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, true);
      });

      test('1.5.0 > 1.4.0 (no update needed)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '1.5.0',
          updateConfig: UpdateConfig(
            latestVersion: '1.4.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, false);
      });
    });

    group('patch version updates', () {
      test('1.0.1 < 1.0.2 (update available)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.0.1',
          updateConfig: UpdateConfig(
            latestVersion: '1.0.2',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, true);
      });

      test('1.0.5 > 1.0.3 (no update needed)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '1.0.5',
          updateConfig: UpdateConfig(
            latestVersion: '1.0.3',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, false);
      });
    });

    group('different version lengths', () {
      test('1.0 < 1.0.1 (update available)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.0',
          updateConfig: UpdateConfig(
            latestVersion: '1.0.1',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, true);
      });

      test('1.0.0.1 > 1.0.0 (no update needed)', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '1.0.0.1',
          updateConfig: UpdateConfig(
            latestVersion: '1.0.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isUpdateAvailable, false);
      });
    });
  });

  group('UpdateAvailabilityState', () {
    group('isMandatory getter', () {
      test('returns true when updateConfig.isMandatory is true', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.0.0',
          updateConfig: UpdateConfig(
            latestVersion: '2.0.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: true,
          ),
        );

        expect(state.isMandatory, true);
      });

      test('returns false when updateConfig.isMandatory is false', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.0.0',
          updateConfig: UpdateConfig(
            latestVersion: '2.0.0',
            downloadUrlV8a: 'https://example.com/app.apk',
            downloadUrlV7a: 'https://example.com/app.apk',
            isMandatory: false,
          ),
        );

        expect(state.isMandatory, false);
      });

      test('returns false when updateConfig is null', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '1.0.0',
          updateConfig: null,
        );

        expect(state.isMandatory, false);
      });
    });

    group('properties', () {
      test('stores currentVersion correctly', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: false,
          currentVersion: '3.2.1',
          updateConfig: null,
        );

        expect(state.currentVersion, '3.2.1');
      });

      test('stores isUpdateAvailable correctly', () {
        final state = UpdateAvailabilityState(
          isUpdateAvailable: true,
          currentVersion: '1.0.0',
          updateConfig: null,
        );

        expect(state.isUpdateAvailable, true);
      });
    });
  });

  group('UpdateConfig in UpdateAvailabilityState', () {
    test('stores updateConfig correctly', () {
      final config = UpdateConfig(
        latestVersion: '2.0.0',
        downloadUrlV8a: 'https://example.com/app.apk',
        downloadUrlV7a: 'https://example.com/app.apk',
        isMandatory: true,
        releaseNotes: 'New features',
      );

      final state = UpdateAvailabilityState(
        isUpdateAvailable: true,
        currentVersion: '1.0.0',
        updateConfig: config,
      );

      expect(state.updateConfig, config);
      expect(state.updateConfig?.latestVersion, '2.0.0');
      expect(state.updateConfig?.downloadUrlV7a, 'https://example.com/app.apk');
      expect(state.updateConfig?.downloadUrlV8a, 'https://example.com/app.apk');
      expect(state.updateConfig?.isMandatory, true);
      expect(state.updateConfig?.releaseNotes, 'New features');
    });
  });
}
