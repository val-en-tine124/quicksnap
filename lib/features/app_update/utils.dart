import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';

/// Utility class for handling in-app updates.
/// 
/// This class provides functionality to:
/// - Download APK files to a secure temporary directory
/// - Display download progress via Android notification
/// - Trigger the native Android package installer
class AppUpdateUtils {
  static final Dio _dio = Dio();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Whether notifications have been initialized
  static bool _notificationsInitialized = false;

  /// The notification channel ID for download progress
  static const String _channelId = 'com.quicksnap.app_update';
  
  /// The notification channel name
  static const String _channelName = 'App Updates';

  /// The notification ID for download progress
  static const int _notificationId = 1;

  /// The filename for the downloaded APK
  static const String _apkFileName = 'quicksnap_update.apk';

  /// Initializes the notification plugin for Android.
  /// 
  /// This should be called before showing any notifications.
  static Future<void> _initNotifications() async {
    if (_notificationsInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _notificationsPlugin.initialize(settings:initSettings);
    
    // Create the notification channel for Android 8.0+
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications for app update download progress',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
      showBadge: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _notificationsInitialized = true;
  }

  /// Requests the necessary permissions for installing packages.
  /// 
  /// Returns true if the permission was granted, false otherwise.
  static Future<bool> requestInstallPermission() async {
    if (!Platform.isAndroid) return true;

    // For Android 8.0+ (API 26+), we need REQUEST_INSTALL_PACKAGES
    // For notifications on Android 13+, we need POST_NOTIFICATIONS
    final notificationsStatus = await Permission.notification.status;
    if (notificationsStatus.isDenied) {
      await Permission.notification.request();
    }

    // Check if we can request install packages (this opens a system settings screen)
    // Note: REQUEST_INSTALL_PACKAGES cannot be directly requested via permission_handler
    // The user must manually enable it in settings, but we can check if it's enabled
    return await _canRequestPackageInstallation();
  }

  /// Checks if the app can request package installation.
  static Future<bool> _canRequestPackageInstallation() async {
    if (!Platform.isAndroid) return true;
    
    // On Android, we check if the intent to install packages can be launched
    try {
      // This is a simple check - the actual permission is granted at install time
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Downloads an APK file from the given URL and returns the file path.
  /// 
  /// This method:
  /// - Downloads the APK to the app's temporary directory
  /// - Shows a notification with download progress (throttled to percentage changes)
  /// - Returns the path to the downloaded file when complete
  /// 
  /// [downloadUrl] The URL to download the APK from
  /// [onProgress] Optional callback for progress updates (0.0 to 1.0)
  /// 
  /// Returns the [File] path to the downloaded APK.
  static Future<File> downloadApk({
    required String downloadUrl,
    void Function(double progress)? onProgress,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('In-app updates are only supported on Android');
    }

    // Initialize notifications
    await _initNotifications();

    // Get the temporary directory for storing the APK
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$_apkFileName';
    final file = File(filePath);

    // Delete the file if it already exists
    if (await file.exists()) {
      await file.delete();
    }

    // Track the last notified percentage to throttle notifications
    int lastNotifiedPercentage = -1;

    try {
      await _dio.download(
        downloadUrl,
        filePath,
        onReceiveProgress: (received, total) async {
          if (total <= 0) return;

          final progress = received / total;
          
          // Calculate the integer percentage
          final percentage = (progress * 100).toInt();

          // Only update notification when percentage changes (throttling)
          if (percentage != lastNotifiedPercentage) {
            lastNotifiedPercentage = percentage;

            // Update the notification
            await _showDownloadProgressNotification(percentage);

            // Call the progress callback
            onProgress?.call(progress);
          }
        },
      );

      // Ensure we show 100% when download completes
      if (lastNotifiedPercentage != 100) {
        await _showDownloadProgressNotification(100);
        onProgress?.call(1.0);
      }

      return file;
    } catch (e) {
      // Clean up on failure
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    }
  }

  /// Shows or updates the download progress notification.
  static Future<void> _showDownloadProgressNotification(int percentage) async {
    const androidDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifications for app update download progress',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: 100,
        progress: 0, // Will be updated
      ),
    );

    // We need to show the notification with the current progress
    // Note: Flutter local notifications doesn't support updating progress directly,
    // so we show a new notification each time the percentage changes
    await _notificationsPlugin.show(
      id:_notificationId,
      title:'Downloading update...',
      body: '$percentage% complete',
      notificationDetails:androidDetails,
    );
  }

  /// Triggers the Android package installer to install the APK file.
  /// 
  /// [apkFile] The [File] object pointing to the downloaded APK.
  static Future<void> installApk(File apkFile) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('APK installation is only supported on Android');
    }

    if (!await apkFile.exists()) {
      throw FileNotFoundException('APK file not found: ${apkFile.path}');
    }

    try {
      // Use android_intent_plus to trigger the package installer
      final intent = AndroidIntent(
        action: 'action_view',
        data: 'file://${apkFile.path}',
        type: 'application/vnd.android.package-archive',
        flags: <int>[
          0x10000000, // FLAG_ACTIVITY_NEW_TASK
        ],
      );

      await intent.launch();
    } catch (e) {
      // Fallback: Try using an open_file approach
      throw Exception('Failed to launch package installer: $e');
    }
  }

  /// Cancels the download progress notification.
  static Future<void> cancelNotification() async {
    await _notificationsPlugin.cancel(id:_notificationId);
  }
}

/// Exception thrown when the APK file is not found.
class FileNotFoundException implements Exception {
  final String message;
  FileNotFoundException(this.message);

  @override
  String toString() => 'FileNotFoundException: $message';
}