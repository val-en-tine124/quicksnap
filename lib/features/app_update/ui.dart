import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models.dart';
import 'providers.dart';

const _gitHubReleasesUrl =
    'https://github.com/val-en-tine124/quicksnap/releases';

class QuickSnapUpdateDialog extends ConsumerWidget {
  final UpdateConfig updateConfig;

  const QuickSnapUpdateDialog({super.key, required this.updateConfig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AlertDialog(
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Later'),
        ),
        TextButton(
          onPressed: () async {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
            final url = Uri.parse(_gitHubReleasesUrl);
            await launchUrl(url, mode: LaunchMode.externalApplication);
          },
          child: const Text('Download Update'),
        ),
      ],
    );
  }
}

class UpdateChecker extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onUpdateStarted;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updateAvailabilityProvider.notifier).checkForUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UpdateAvailabilityState>>(
      updateAvailabilityProvider,
      (previous, next) {
        next.whenData((state) {
          if (state.isUpdateAvailable &&
              state.updateConfig != null &&
              !_dialogShown &&
              mounted) {
            _dialogShown = true;
            _showUpdateDialog(context, state.updateConfig!);
          } else if (!state.isUpdateAvailable && widget.onNoUpdate != null) {
            widget.onNoUpdate!();
          }
        });
      },
    );

    return widget.child;
  }

  Future<void> _showUpdateDialog(BuildContext context, UpdateConfig config) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => QuickSnapUpdateDialog(updateConfig: config),
    );

    _dialogShown = false;

    if (shouldUpdate == true && widget.onUpdateStarted != null) {
      widget.onUpdateStarted!();
    }
  }
}

extension UpdateDialogExtension on BuildContext {
  Future<bool> showUpdateDialogIfAvailable() async {
    return false;
  }
}