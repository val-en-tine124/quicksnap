import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'providers.dart';

/// A dialog that prompts the user to update the app.
///
/// This dialog displays information about the available update
/// and provides options to update now or dismiss.
class QuickSnapUpdateDialog extends ConsumerWidget {
  /// The update configuration containing version info and download URL.
  final UpdateConfig updateConfig;

  /// Whether this update is mandatory (disables dismiss option).
  final bool isMandatory;

  const QuickSnapUpdateDialog({
    super.key,
    required this.updateConfig,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopScope(
      // Prevent dismissal if update is mandatory
      canPop: !isMandatory,
      child: AlertDialog(
        title: const Text('Update Available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A new version (${updateConfig.latestVersion}) is available!',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (updateConfig.releaseNotes != null &&
                updateConfig.releaseNotes!.isNotEmpty) ...[
              const Text(
                'What\'s new:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                updateConfig.releaseNotes!,
                style: theme.textTheme.bodyMedium,
              ),
            ] else ...[
              Text(
                'Current version: ${updateConfig.latestVersion}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (isMandatory) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This update is required to continue using the app.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!isMandatory)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Later'),
            ),
          TextButton(
            onPressed: () async {
              if (!context.mounted) return;
              // Dismiss the dialog and start the update
              Navigator.of(context).pop(true);
              // Check android device architecture before download.
              final deviceArch = await checkArchitecture();
              final downloadUrl = deviceArch == DeviceArch.Armeabiv8a
                  ? updateConfig.downloadUrlV8a
                  : updateConfig.downloadUrlV7a;
              // Start the download in the background
              ref
                  .read(updateDownloadStateProvider.notifier)
                  .downloadAndUpdate(
                    downloadUrl: downloadUrl,
                    onProgress: (progress) => Center(
                      child: QuicksnapUpdateProgressBar(progress: progress),
                    ),
                  );
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}

/// A progress bar widget shown during the update download.
class QuicksnapUpdateProgressBar extends StatelessWidget {
  final double progress;
  const QuicksnapUpdateProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border.all(width: 2.0, style: BorderStyle.solid),
        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 16),
          const Text(
            'Updating QuickSnap ...',
            style: TextStyle(fontFamily: 'Unageo', color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// A decorator widget that checks for updates and shows the dialog if available.
///
/// Use this as a wrapper around your app's root widget to enable automatic
/// update checking on startup. It listens to the update availability provider
/// and displays the update dialog when a new version is detected.
///
/// Example:
/// ```dart
/// UpdateChecker(
///   child: SaveOnExit(
///     child: EditorScaffold(),
///   ),
/// )
/// ```
class UpdateChecker extends ConsumerStatefulWidget {
  /// The child widget to be wrapped by this decorator.
  final Widget child;

  /// Optional callback when an update is found and accepted.
  final VoidCallback? onUpdateStarted;

  /// Optional callback when update check completes with no update.
  final VoidCallback? onNoUpdate;

  const UpdateChecker({
    super.key,
    required this.child,
    this.onUpdateStarted,
    this.onNoUpdate,
  });

  @override
  ConsumerState<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends ConsumerState<UpdateChecker> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Check for updates after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updateAvailabilityProvider.notifier).checkForUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the update availability provider
    ref.listen<AsyncValue<UpdateAvailabilityState>>(
      updateAvailabilityProvider,
      (previous, next) {
        next.whenData((state) {
          if (state.isUpdateAvailable &&
              state.updateConfig != null &&
              !_dialogShown &&
              mounted) {
            _dialogShown = true;
            _showUpdateDialog(context, state.updateConfig!, state.isMandatory);
          } else if (!state.isUpdateAvailable && widget.onNoUpdate != null) {
            widget.onNoUpdate!();
          }
        });
      },
    );

    // Pass through the child widget — this is a decorator pattern
    return widget.child;
  }

  Future<void> _showUpdateDialog(
    BuildContext context,
    UpdateConfig config,
    bool isMandatory,
  ) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      barrierDismissible: !isMandatory,
      builder: (context) =>
          QuickSnapUpdateDialog(updateConfig: config, isMandatory: isMandatory),
    );

    _dialogShown = false;

    if (shouldUpdate == true && widget.onUpdateStarted != null) {
      widget.onUpdateStarted!();
    }
  }
}

/// Extension to easily show the update dialog from anywhere.
extension UpdateDialogExtension on BuildContext {
  /// Shows the update dialog if an update is available.
  ///
  /// Returns true if the user chose to update, false otherwise.
  Future<bool> showUpdateDialogIfAvailable() async {
    // This would require access to the provider, so it's a placeholder
    // In practice, use the UpdateChecker widget or directly access the provider
    return false;
  }
}
