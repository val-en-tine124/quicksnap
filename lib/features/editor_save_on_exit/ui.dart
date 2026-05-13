import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor/ui.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/widgets.dart';

class SaveOnExit extends ConsumerWidget {
  final EditorScaffold editorScaffold;
  const SaveOnExit({super.key, required this.editorScaffold});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isEdited = ref.watch(isEditedProvider);
    return PopScope(
      canPop: !isEdited,
      child: editorScaffold,
      onPopInvokedWithResult: (wasPoped, _) async {
        if (wasPoped) return; // Already popped.
        final bool? shouldPop = await saveOnExitDialog(context, ref);
        if (shouldPop == true && context.mounted) Navigator.pop(context);
      },
    );
  }
}

Future<bool?> saveOnExitDialog(BuildContext context, WidgetRef ref) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Unsaved changes"),
        content: const Text(
          "You have unsaved changes. Do you wish to save your changes ?",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await ref.read(filePickerProvider.notifier).saveFile();
                if (!context.mounted) return;
                Navigator.pop(context, true);
              } on Exception catch (_) {
                Navigator.pop(context, false);
                customScaffoldMessenger(
                  context,
                  Text("Failed to save file, an exception occurred."),
                );
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Discard"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("cancel"),
          ),
        ],
      );
    },
  );
}
