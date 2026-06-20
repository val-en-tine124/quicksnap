import 'package:dio/dio.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models.dart';

part 'providers.g.dart';

/// The owner of the GitHub repository.
const _repoOwner = 'val-en-tine124';

/// The name of the GitHub repository.
const _repoName = 'quicksnap';

/// The GitHub API base URL.
const _githubApiBase = 'https://api.github.com';

@riverpod
class UpdateConfigCache extends _$UpdateConfigCache {
  @override
  Future<UpdateConfig?> build() async {
    return _loadFromHive();
  }

  Future<void> saveToHive(UpdateConfig updateConfig) async {
    final box = await Hive.openBox<UpdateConfig>('UpdateConfig');
    await box.put('updateConfig', updateConfig);
  }

  Future<UpdateConfig?> _loadFromHive() async {
    final box = await Hive.openBox<UpdateConfig>('UpdateConfig');
    return box.get('updateConfig');
  }
}

/// Provider that returns the current app version information.
@riverpod
Future<PackageInfo> currentAppInfo(Ref ref) async {
  return PackageInfo.fromPlatform();
}

/// Provider that fetches the remote update configuration from GitHub Releases.
///
/// Fetches the latest release from:
///   GET /repos/{owner}/{repo}/releases?per_page=1
///
/// Compares the build number from the latest release tag with the
/// current app's build number to determine if an update is available.
@riverpod
Future<UpdateConfig?> remoteUpdateConfig(Ref ref) async {
  final appInfo = await ref.watch(currentAppInfoProvider.future);
  final currentBuildNumber = int.tryParse(appInfo.buildNumber) ?? 0;

  try {
    final response = await Dio().get<List<dynamic>>(
      '$_githubApiBase/repos/$_repoOwner/$_repoName/releases',
      queryParameters: {'per_page': 1},
      options: Options(
        headers: {
          'Accept': 'application/vnd.github+json',
          'User-Agent': 'QuickSnap-App',
        },
      ),
    );

    if (response.statusCode == 200) {
      final releases = response.data as List<dynamic>;
      if (releases.isEmpty) return null;

      final latestRelease = releases.first as Map<String, dynamic>;
      final config = UpdateConfig.fromGitHubRelease(latestRelease);

      // Compare semantic version first, then fall back to build number
      // when versions are equal.
      final versionComparison =
          _compareVersions(appInfo.version, config.latestVersion);
      if (versionComparison < 0) {
        // Remote semantic version is strictly higher → update available
        await ref.read(updateConfigCacheProvider.notifier).saveToHive(config);
        return config;
      } else if (versionComparison == 0) {
        // Same version → compare build numbers
        if (config.buildNumber > currentBuildNumber) {
          await ref.read(updateConfigCacheProvider.notifier).saveToHive(config);
          return config;
        }
      }
    }
    return null;
  } catch (e) {
    // Return cached config if available on network failure
    final updateConfigCache = ref.read(updateConfigCacheProvider);
    return updateConfigCache.value;
  }
}

/// State class for update availability.
class UpdateAvailabilityState {
  final bool isUpdateAvailable;
  final String currentVersion;
  final UpdateConfig? updateConfig;

  /// Whether the update is mandatory (user cannot skip it).
  bool get isMandatory => updateConfig?.isMandatory ?? false;

  UpdateAvailabilityState({
    required this.isUpdateAvailable,
    required this.currentVersion,
    this.updateConfig,
  });
}

/// Provider that checks if an update is available.
///
/// Compares the current app version with the remote version
/// and returns whether an update is available along with the update config.
@riverpod
class UpdateAvailability extends _$UpdateAvailability {
  @override
  Future<UpdateAvailabilityState> build() async {
    final [
      appInfo as PackageInfo,
      remoteConfig as UpdateConfig?,
    ] = await Future.wait([
      ref.watch(currentAppInfoProvider.future), // Get current app info
      ref.watch(remoteUpdateConfigProvider.future), // Get remote update config
    ]);
    final currentVersion = appInfo.version;

    if (remoteConfig == null) {
      return UpdateAvailabilityState(
        isUpdateAvailable: false,
        currentVersion: currentVersion,
        updateConfig: null,
      );
    }

    // Compare versions
    final isUpdateAvailable =
        _compareVersions(currentVersion, remoteConfig.latestVersion) < 0;

    return UpdateAvailabilityState(
      isUpdateAvailable: isUpdateAvailable,
      currentVersion: currentVersion,
      updateConfig: remoteConfig,
    );
  }

  /// Refreshes the update check.
  Future<void> checkForUpdates() async {
    ref.invalidateSelf();
  }
}

/// Compares two version strings.
///
/// Returns:
/// - negative number if version1 < version2
/// - 0 if version1 == version2
/// - positive number if version1 > version2
int _compareVersions(String version1, String version2) {
  final v1Parts = version1.split('.');
  final v2Parts = version2.split('.');

  final maxLength = v1Parts.length > v2Parts.length
      ? v1Parts.length
      : v2Parts.length;

  for (int i = 0; i < maxLength; i++) {
    final v1Num = i < v1Parts.length ? int.parse(v1Parts[i]) : 0;
    final v2Num = i < v2Parts.length ? int.parse(v2Parts[i]) : 0;

    if (v1Num != v2Num) {
      return v1Num - v2Num;
    }
  }

  return 0;
}
