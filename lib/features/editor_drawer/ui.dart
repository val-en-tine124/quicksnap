import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/about.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/ui.dart';
import 'package:quicksnap/features/widgets.dart';

class _DrawerFsOps extends ConsumerWidget {
  const _DrawerFsOps();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileData = ref.read(filePickerProvider.notifier);
    final fileState = ref.watch(filePickerProvider);
    final isEdited = ref.watch(isEditedProvider);
    final isLoading = fileState.isLoading;

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
        title: const Text('New File'),
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
                    const Text('File saved successfully'),
                  );
                }
              },
        leading: const Icon(Icons.save),
        title: const Text('Save File'),
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
        title: const Text('Open File'),
        trailing: const Icon(Icons.arrow_forward_ios),
        enabled: !isLoading,
      ),
    ];
    return ListView(
      itemExtent: 80.0,
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

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('About'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutPage()),
          );
        }
      },
    );
  }
}

class EditorDrawer extends StatelessWidget {
  const EditorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: _DrawerFsOps(),
            ), // Let _DrawerFsOps take up the remaining space in the column
            //after _AboutSection has use up it required space.
            _AboutSection(),
          ],
        ),
      ),
    );
  }
}
