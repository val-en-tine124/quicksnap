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

    return Scaffold(
      appBar: AppBar(
        title: RepaintBoundary(
          child: Text(fileData, style: TextStyle(fontSize: 16)),
        ),
      ),
      body: _Editor(),
      drawer: Drawer(child: Center(child: const DrawerFsOps())).animate().shimmer().then().fadeIn(),
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

class DrawerFsOps extends ConsumerWidget {
  const DrawerFsOps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileData = ref.read(filePickerProvider.notifier);
    final fileOpsButtons = <Widget>[
      ListTile(
        onTap: () {
          fileData.newFile();
          ref
              .read(filePickerProvider)
              .when(
                data: (data) {},
                error: (e, s) =>
                    customScaffoldMessenger(context, Text("Error: $e")),
                loading: () => Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsetsGeometry.all(4),
                        child: Text("Creating an empty file ..."),
                      ),
                    ],
                  ),
                ),
              );
        }, //TODO
        leading: const Icon(Icons.add),
        title: const Text("New File"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        onTap: () {},
        leading: const Icon(Icons.save),
        title: const Text("Save File"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
      ListTile(
        onTap: () async {
          await fileData.pickFile();
          if (context.mounted) return;
          ref
              .read(filePickerProvider)
              .when(
                data: (data) => customScaffoldMessenger(
                  context,
                  Text("Opened file successfully: ${data?.name}"),
                ),
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
