import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'models.dart';
import 'utils.dart';

part 'providers.g.dart';

@riverpod
class UpdateConfigCache extends _$UpdateConfigCache {
  @override
  Future<UpdateConfig?> build() async {
    if (!ref.mounted)return null;
    state = AsyncValue.data(await _loadFromHive());   // This cache provider can be used to store the last fetched update config
    // and return it when the network is unavailable.
     // Initially, there is no cached config.
     return state.value;
  }

  Future<void> saveToHive(UpdateConfig updateConfig) async {
    final box = await Hive.openBox<UpdateConfig>("UpdateConfig");
    await box.put("updateConfig", updateConfig);
  }

  Future<UpdateConfig?> _loadFromHive() async {
    final box = await Hive.openBox<UpdateConfig>("UpdateConfig");
    return box.get("updateConfig");
  }
}

/// Provider that returns the current app version information.
@riverpod
Future<PackageInfo> currentAppInfo(Ref ref) async {
  return PackageInfo.fromPlatform();
}

/// Provider that fetches the remote update configuration.
///
/// This provider fetches the update config from a remote JSON endpoint.
/// For demonstration, you would replace the URL with your actual update server.
@riverpod
Future<UpdateConfig?> remoteUpdateConfig(Ref ref) async {
  // TODO: Replace with your actual update server URL
  const updateUrl =
      'http://127.0.0.1:8000/update.json'; // change to 'http://10.0.2.2:8000/update.json' temporarily for testing with Android emulator
  try {
    final response = await Dio().get(updateUrl);
    if (response.statusCode == 200) {
      final config = UpdateConfig.fromJson(
        response.data as Map<String, dynamic>,
      );
      await ref.read(updateConfigCacheProvider.notifier).saveToHive(config);
      return config;
    }
    return null;
  } catch (e) {
    // Return cached config if available on network failure
    final updateConfigCache = ref.watch(updateConfigCacheProvider);
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
    // Get current app info
    final appInfo = await ref.watch(currentAppInfoProvider.future);
    final currentVersion = appInfo.version;

    // Get remote update config
    final remoteConfig = await ref.watch(remoteUpdateConfigProvider.future);

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
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

/// Provider for managing the download state of an update.
///
/// This provider handles the APK download and installation process.
@riverpod
class UpdateDownloadState extends _$UpdateDownloadState {
  @override
  AsyncValue<void> build() {
    // Cancel any pending work when the provider is disposed
    ref.onDispose(() {
      AppUpdateUtils.cancelNotification();
    });
    return const AsyncData(null);
  }

  /// Downloads and installs the update.
  ///
  /// This method:
  /// 1. Requests necessary permissions
  /// 2. Downloads the APK to the temporary directory
  /// 3. Triggers the Android package installer
  /// 4. Show progress info
  Future<void> downloadAndUpdate({
    required String downloadUrl,
    required void Function(double progress) onProgress,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Request permissions
      final hasPermission = await AppUpdateUtils.requestInstallPermission();
      if (!hasPermission) {
        state = AsyncValue.error(
          Exception('Installation permission denied'),
          StackTrace.current,
        );
        return;
      }

      // Download the APK with progress tracking
      final apkFile = await AppUpdateUtils.downloadApk(
        downloadUrl: downloadUrl,
        onProgress: (progress) {
          onProgress.call(progress);
        },
      );

      // Install the APK
      await AppUpdateUtils.installApk(apkFile);
      if (!ref.mounted) return;
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Cancels the current download.
  Future<void> cancelDownload() async {
    await AppUpdateUtils.cancelNotification();
    if (!(ref.mounted)) return;
    state = const AsyncValue.data(null);
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

enum DeviceArch {
  // ignore: constant_identifier_names
  Armeabiv7a,
  // ignore: constant_identifier_names
  Armeabiv8a,
}

Future<DeviceArch> checkArchitecture() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  // supportedAbis returns a list of ABIs supported by the device in order of preference
  List<String?> abis = androidInfo.supportedAbis;
  if (abis.contains('arm64-v8a')) {
    return DeviceArch.Armeabiv8a;
  }
  return DeviceArch.Armeabiv7a;
}
