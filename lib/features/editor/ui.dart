import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_drawer/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:quicksnap/features/settings/providers.dart';
import 'package:quicksnap/features/settings/ui.dart';

import '../widgets.dart';

/// Editor scaffold with update checking functionality.
/// Uses the UpdateChecker widget for automatic update detection.
class EditorScaffold extends ConsumerWidget {
  final Widget settingsPage;
  final Widget drawer;

  const EditorScaffold({super.key,
  required this.settingsPage,required this.drawer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileTitle = ref.watch(appBarTitleProvider);
    final fileState = ref.watch(filePickerProvider);
    final settingsState = ref.watch(settingsStateProvider);
    final editorInitialContentState = ref.watch(editorInitialContentProvider);
    final isLoading =
        fileState.isLoading ||
        settingsState.isLoading ||
        editorInitialContentState.isLoading;

    // Show error snackbar when file picker encounters an error
    if (fileState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customScaffoldMessenger(context, Text('Error: ${fileState.error}'));
      });
    }

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
    if (editorInitialContentState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customScaffoldMessenger(
          context,
          Text('Content Error: ${editorInitialContentState.error}'),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(fileTitle, style: const TextStyle(fontSize: 16)),
        ),
        actions: [
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
      drawer: isLoading
          ? null
          : drawer,
      // Also disable drawer opening via gestures when loading
      drawerEnableOpenDragGesture: !isLoading,
    );
  }
}

///This is My app Editor
class _Editor extends ConsumerWidget {
  const _Editor();
  Widget _showSpinner(String spinnerText) {
    return Container(
      width: 150.0,
      height: 150.0,
      color: Colors.black26,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(spinnerText),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(quicksnapEditorProvider);
    final fileState = ref.watch(filePickerProvider);
    final quickSnapSettings =
        ref.watch(settingsStateProvider).value ??
        QuickSnapSettings.getDefault();

    return Stack(
      children: [
        Column(
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
        ),
        if (fileState.isLoading) Center(child: _showSpinner('Loading ...')),
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