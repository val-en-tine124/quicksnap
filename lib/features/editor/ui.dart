import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:flutter_animate/flutter_animate.dart';

final quillControllerProvider = Provider.autoDispose<QuillController>((ref) {
  final _controller = QuillController.basic(); // Basic controller
  ref.onDispose(() {
    // Dispose the controller when the provider is disposed
    _controller.dispose();
  });
  return _controller;
});

class EditorScaffold extends ConsumerWidget {
  const EditorScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileData = ref.watch(filePickerProvider);

    return fileData.when(
      data: (data) {
        final appBarTitle = data?.name ?? "Untitled Document";
        return Scaffold(
          appBar: AppBar(title: RepaintBoundary(child: Text(appBarTitle))),
          body: _Editor(),
          drawer: Drawer(child: Center(child: const DrawerFsOps())),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              duration: const Duration(seconds: 7),
            ),
          );
        });
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error: $error')),
        );
      },
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

class DrawerFsOps extends StatelessWidget {
  const DrawerFsOps({super.key});

  @override
  Widget build(BuildContext context) {
    final fileOpsButtons = <Widget>[
      ListTile(
        onTap: () {},
        leading: const Icon(Icons.add),
        title: const Text("New File"),
      ),
      ListTile(
        onTap: () {},
        leading: const Icon(Icons.save),
        title: const Text("Save File"),
      ),
      ListTile(
        onTap: () {},
        leading: const Icon(Icons.folder_open),
        title: const Text("Open File"),
      ),
      ListTile(
        onTap: () {},
        leading: const Icon(Icons.delete),
        title: const Text("Delete File"),
      ),
    ];
    return ListView(
      children: [DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  'QuickSnap',
                  style: TextStyle(
                    fontSize: 24,)).animate().fadeIn(duration: 4.seconds).then().effect().shake(),
              )),
                  ...fileOpsButtons.map((entry) => entry),
    ],
    );
  }
}
