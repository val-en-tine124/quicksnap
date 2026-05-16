import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor/ui.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';

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
        if (shouldPop == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
    );
  }
}

Future<bool?> saveOnExitDialog(BuildContext context, WidgetRef ref) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return _SaveOnExitDialog(ref: ref);
    },
  );
}

class _SaveOnExitDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _SaveOnExitDialog({required this.ref});

  @override
  ConsumerState<_SaveOnExitDialog> createState() => _SaveOnExitDialogState();
}

class _SaveOnExitDialogState extends ConsumerState<_SaveOnExitDialog> {
  bool _isSaving = false;
  String? _errorMessage;

  Future<void> _handleSave() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await widget.ref.read(filePickerProvider.notifier).saveFile();

      // The edit state should automatically update because:
      // 1. filePickerProvider updates after save
      // 2. editorInitialContentProvider watches filePickerProvider and rebuilds
      // 3. isEditedProvider watches editorInitialContentProvider and recalculates

      // Use a post-frame callback to ensure we're in a valid frame
      // This is important because saveFile() shows a native dialog
      // which can cause the widget tree to rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        // Small delay to ensure UI is stable
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;

          // Close the dialog
          if (Navigator.canPop(context)) {
            Navigator.pop(context, true);
          } else {
            // Fallback: if we can't pop, at least reset the saving state
            if (mounted) {
              setState(() {
                _isSaving = false;
              });
            }
          }
        });
      });
    } on Exception catch (e) {
      // Reset saving state on error
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = e.toString();
        });
      }

      // Don't close the dialog - let user choose another option
    } catch (e) {
      // Reset saving state on unexpected error
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = "An unexpected error occurred";
        });
      }
    }
  }

  void _handleDiscard() {
    if (!mounted) return;
    if (Navigator.canPop(context)) {
    Navigator.pop(context, true);
    }
  }

  void _handleCancel() {
    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Unsaved changes"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "You have unsaved changes. Do you wish to save your changes?",
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              "Save failed: $_errorMessage",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can still discard your changes or cancel.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        if (_isSaving)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          TextButton(onPressed: _handleSave, child: const Text("Save")),
        TextButton(
          onPressed: _isSaving ? null : _handleDiscard,
          child: const Text("Discard"),
        ),
        TextButton(
          onPressed: _isSaving ? null : _handleCancel,
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
