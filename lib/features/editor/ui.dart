import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EditorScaffold extends ConsumerWidget {
  const EditorScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileData = ref.watch(appBarTitleProvider);
    final editorIsLoading = ref.watch(editorIsLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: RepaintBoundary(
          child: Text(fileData, style: TextStyle(fontSize: 16)),
        ),
      ),
      body: editorIsLoading
          ? const Center(child: CircularProgressIndicator())
          : const _Editor(),
      drawer: Drawer(
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
    );
  }
}

///This is My app Editor
class _Editor extends ConsumerStatefulWidget {
  const _Editor();
  @override
  ConsumerState<_Editor> createState() {
    return _EditorState();
  }
}

class _EditorState extends ConsumerState<_Editor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(quillControllerProvider);
    return Column(
      children: [
        Expanded(
          child: QuillEditor.basic(
            controller: controller,
            config: QuillEditorConfig(autoFocus: true),
          ),
        ),

        _EditorToolBar(controller),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
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
    );
  }
}

class DrawerFsOps extends ConsumerWidget {
  const DrawerFsOps({super.key});

  Widget _showSpinner(String spinnerText) {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsetsGeometry.all(4), child: Text(spinnerText)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileData = ref.read(filePickerProvider.notifier);
    final fileOpsButtons = <Widget>[
      ListTile(
        onTap: () {
          fileData.newFile();
          if (!context.mounted) return;
          Navigator.pop(context);
          ref
              .read(filePickerProvider)
              .when(
                data: (data) {},
                error: (e, s) =>
                    customScaffoldMessenger(context, Text("Error: $e")),
                loading: () => _showSpinner("Creating an empty file ...")
              );

        }, //TODO
        leading: const Icon(Icons.add),
        title: const Text("New File"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        onTap: () {
          fileData.saveFile();
          if (!context.mounted) return;
          Navigator.pop(context);
          ref
              .read(filePickerProvider)
              .when(
                data: (data) => customScaffoldMessenger(
                  context,
                  Text("File saved successfully"),
                ),
                error: (e, s) =>
                    customScaffoldMessenger(context, Text("Error: $e")),
                loading: () => _showSpinner("Saving file ..."),
              );

          
        },
        leading: const Icon(Icons.save),
        title: const Text("Save File"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        onTap: () async {
          await fileData.pickFile();
          if (!context.mounted) return;
          Navigator.pop(context);
          ref
              .read(filePickerProvider)
              .when(
                data: (data) => data != null
                    ? customScaffoldMessenger(
                        context,
                        Text("Opened file successfully: ${data.name}"),
                      )
                    : null,
                error: (e, s) =>
                    customScaffoldMessenger(context, Text("Error: $e")),
                loading: () {},
              );
        },
        leading: const Icon(Icons.folder_open),
        title: const Text("Open File"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    ];
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Center(
            child: Text(
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
customScaffoldMessenger(BuildContext context, Text content) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: content, duration: 7.seconds));
}
