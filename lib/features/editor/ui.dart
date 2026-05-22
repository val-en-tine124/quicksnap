import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quicksnap/features/editor/about.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/ui.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:quicksnap/features/settings/providers.dart';
import 'package:quicksnap/features/settings/ui.dart';
import '../widgets.dart';

/// Editor scaffold with update checking functionality.
/// Uses the UpdateChecker widget for automatic update detection.
class EditorScaffold extends ConsumerWidget {
  const EditorScaffold({super.key});

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
        customScaffoldMessenger(context, Text("Error: ${fileState.error}"));
      });
    }

    // Show error snackbar when settings encounter an error
    if (settingsState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customScaffoldMessenger(
          context,
          Text("Settings Error: ${settingsState.error}"),
        );
      });
    }

    // Show error snackbar when editor initial content encounters an error
    if (editorInitialContentState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customScaffoldMessenger(
          context,
          Text("Content Error: ${editorInitialContentState.error}"),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: RepaintBoundary(
          child: Center(child: Text(fileTitle, style: TextStyle(fontSize: 16))),
        ),
        actions: [
          IconButton(
            tooltip: "Settings",
            onPressed: () {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsUI()),
                );
              }
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _Editor(),
      // Disable drawer when loading
      drawer: isLoading
          ? null
          : Drawer(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: const DrawerFsOps(),
                    ), // Let DrawerFsOps take up the remaining space in the column
                    //after AboutSection has use up it required space.
                    AboutSection(),
                  ],
                ),
              ),
            ),
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
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(spinnerText),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(quillControllerProvider);
    final fileState = ref.watch(filePickerProvider);
    final quickSnapSettings =
        ref.watch(settingsStateProvider).value ??
        QuickSnapSettings.getDefault();

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: QuillEditor.basic(
                controller: controller,
                config: quickSnapSettings.quillEditorConfig(),
              ),
            ),

            _EditorToolBar(controller),
          ],
        ),
        if (fileState.isLoading) Center(child: _showSpinner("Loading ...")),
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
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.0)],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: QuillSimpleToolbar(controller: controller),
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text("About"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AboutPage()),
          );
        }
      },
    );
  }
}

class DrawerFsOps extends ConsumerWidget {
  const DrawerFsOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileData = ref.read(filePickerProvider.notifier);
    final fileState = ref.watch(filePickerProvider);
    final settingsState = ref.watch(settingsStateProvider);
    final isEdited = ref.watch(isEditedProvider);
    final isLoading = fileState.isLoading || settingsState.isLoading;

    final fileOpsButtons = <Widget>[
      ListTile(
        onTap: isLoading
            ? null
            : () async {
                if (isEdited) await saveOnExitDialog(context, ref);
                fileData.newFile();
                if (!context.mounted) return;
                Navigator.pop(context);
              },
        leading: const Icon(Icons.add),
        title: const Text("New File"),
        trailing: const Icon(Icons.arrow_forward_ios),
        enabled: !isLoading,
      ),
      ListTile(
        onTap: isLoading
            ? null
            : () {
                fileData.saveFile();
                if (!context.mounted) return;
                Navigator.pop(context);
                if (fileState.hasValue) {
                  customScaffoldMessenger(
                    context,
                    Text("File saved successfully"),
                  );
                }
              },
        leading: const Icon(Icons.save),
        title: const Text("Save File"),
        trailing: const Icon(Icons.arrow_forward_ios),
        enabled: !isLoading,
      ),
      ListTile(
        onTap: isLoading
            ? null
            : () async {
                if (isEdited) await saveOnExitDialog(context, ref);
                await fileData.pickFile();
                if (!context.mounted) return;
                Navigator.pop(context);
                if (fileState.hasValue) {
                  customScaffoldMessenger(
                    context,
                    Text(
                      "Opened file successfully: ${fileState.asData?.value?.name ?? ""}",
                    ),
                  );
                }
              },
        leading: const Icon(Icons.folder_open),
        title: const Text("Open File"),
        trailing: const Icon(Icons.arrow_forward_ios),
        enabled: !isLoading,
      ),
    ];
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Center(
            child: const Text(
              'QuickSnap',
              style: TextStyle(fontSize: 24),
            ).animate().fadeIn(duration: 4.seconds).then().effect().shake(),
          ),
        ),
        ...fileOpsButtons.map((entry) => entry),
      ],
    );
  }
}
