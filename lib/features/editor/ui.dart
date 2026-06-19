import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/editor/app_bar/providers.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/save_to_db/models.dart';
import 'package:quicksnap/features/save_to_db/providers.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:quicksnap/features/settings/providers.dart';
import 'package:quicksnap/features/settings/ui.dart';

import '../widgets.dart';

/// Editor scaffold with update checking functionality.
/// Uses the UpdateChecker widget for automatic update detection.
class EditorScaffold extends ConsumerWidget {
  final Widget settingsPage;
  final Widget drawer;

  const EditorScaffold({
    super.key,
    required this.settingsPage,
    required this.drawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileTitle = ref.watch(appBarTitleProvider);
    final settingsState = ref.watch(settingsStateProvider);
    final editorInitialContentState = ref.watch(editorInitialContentProvider);
    final isLoading =
        settingsState.isLoading || editorInitialContentState.isLoading;

    // Show error snackbar when settings encounter an error
    if (settingsState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customScaffoldMessenger(
          context,
          Text('Settings Error: ${settingsState.error}'),
        );
      });
    }

    // Show error snackbar when editor initial content encounters an error
    ref.listen(editorInitialContentProvider, (previous, next) {
      if (next.hasError) {
        customScaffoldMessenger(
          context,
          Text('Content Error: ${editorInitialContentState.error}'),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(fileTitle, style: const TextStyle(fontSize: 16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Safely extract note name, handling the trailing ' *' suffix
              final rawTitle = ref.read(appBarTitleProvider);
              final noteName = rawTitle.endsWith(' *')
                  ? rawTitle.substring(0, rawTitle.length - 2)
                  : rawTitle;
              final isEdited = ref.read(isEditedProvider);
              final controller = ref.read(quicksnapEditorProvider);
              final editorContent = controller.document.toDelta();
              final hiveBox = await ref.read(handleHiveBoxProvider.future);

              if (!isEdited) {
                if (context.mounted) {
                  customScaffoldMessenger(
                    context,
                    const Text('No changes to save'),
                  );
                }
                return;
              }

              if (!hiveBox.keys.contains(noteName)) {
                // New note — ask for a filename first
                if (!context.mounted) return;
                final suggestedName = await showDialog<String>(
                  context: context,
                  builder: (ctx) => const SaveAsExitDialog(),
                );
                if (suggestedName == null) return;
                await hiveBox.put(
                  suggestedName,
                  QuickSnapNote(deltaJson: jsonEncode(editorContent.toJson())),
                );
                ref
                    .read(appBarTitleProvider.notifier)
                    .changeTitle(suggestedName);
              } else {
                await hiveBox.put(
                  noteName,
                  QuickSnapNote(deltaJson: jsonEncode(editorContent.toJson())),
                );
              }

              ref.read(fileJustSavedProvider.notifier).signal();
              if (context.mounted) {
                customScaffoldMessenger(context, const Text('Saved'));
              }
            },
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              }
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const _Editor(),
      // Disable drawer when loading
      drawer: isLoading ? null : drawer,
      // Also disable drawer opening via gestures when loading
      drawerEnableOpenDragGesture: !isLoading,
    );
  }
}

///This is My app Editor
class _Editor extends ConsumerWidget {
  const _Editor();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(quicksnapEditorProvider);
    final quickSnapSettings =
        ref.watch(settingsStateProvider).value ??
        QuickSnapSettings.getDefault();

    return Column(
      children: [
        Expanded(
          // RepaintBoundary isolates the editor's frequent repaints
          // (cursor blink, text selection) from the parent widget tree,
          // preventing cascading repaints through the scaffold and drawer.
          child: RepaintBoundary(
            child: QuillEditor.basic(
              controller: controller,
              config: quickSnapSettings.quillEditorConfig(),
            ),
          ),
        ),
        _EditorToolBar(controller),
      ],
    );
  }
}

///This is the toolar that should be
///at the bottom of the screen or ontop of the keyboard on mobile devices.
class _EditorToolBar extends StatelessWidget {
  const _EditorToolBar(this.controller);
  final QuillController controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4.0)],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: QuillSimpleToolbar(controller: controller),
        ),
      ),
    );
  }
}
