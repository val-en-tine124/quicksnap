import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/about.dart';
import 'package:quicksnap/features/editor/app_bar/providers.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/save_to_db/models.dart';
import 'package:quicksnap/features/save_to_db/providers.dart';

class NotesList extends ConsumerStatefulWidget {
  const NotesList({super.key});

  @override
  ConsumerState<NotesList> createState() => NoteListState();
}

class NoteListState extends ConsumerState<NotesList> {
  late final ScrollController controller;
  @override
  void initState() {
    super.initState();
    final noteNotifier = ref.read(quickSnapNotesProvider.notifier);
    controller = ScrollController();
    controller.addListener(() async {
      if (controller.position.pixels <=
              controller.position.maxScrollExtent * 0.8 &&
          noteNotifier.loadedNotes != noteNotifier.totalNotes) {
        await noteNotifier.fetchNotes(7);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(quickSnapNotesProvider)
        .when(
          data: (data) {
            final hasMore = ref.read(quickSnapNotesProvider.notifier).hasMore();
            return AnimatedNoteList(
              noNotes: data.length,
              notes: data,
              controller: controller,
              hasMore: hasMore,
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, st) => const Text(
            "Can't load notes something happened",
            style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w300),
          ),
        );
  }
}

class DBNotesDrawer extends ConsumerWidget {
  const DBNotesDrawer({super.key});
  final divider = const Divider(
    height: 40.0,
    indent: 80.0,
    endIndent: 80.0,
    thickness: 1.2,
  );
  final textStyle = const TextStyle(
    fontFamily: 'Gilroy',
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            divider,
            ListTile(
              title: Text('New note', style: textStyle),
              trailing: const Icon(Icons.note_add_outlined),
              onTap: () {
                ref.invalidate(quicksnapEditorProvider);
                ref.invalidate(appBarTitleProvider);
                ref.invalidate(isEditedProvider);
                ref.read(appBarTitleProvider.notifier).reset();
                Navigator.pop(context);
              },
            ),

            ListTile(
              trailing: const Icon(Icons.info_outline),
              title: Text('About Quicksnap', style: textStyle),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                ),
              },
            ),
            divider,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Saved notes', style: textStyle),
            ),
            const Expanded(child: NotesList()),
          ],
        ),
      ),
    );
  }
}

class AnimatedNoteList extends ConsumerWidget {
  final ScrollController controller;
  final List<(String, QuickSnapNote)> notes;
  final int noNotes;
  final bool hasMore;
  const AnimatedNoteList({
    super.key,
    required this.noNotes,
    required this.notes,
    required this.controller,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (noNotes < 1) {
      return const Center(
        child: Text(
          'No saved notes',
          style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w300),
        ),
      );
    }

    return AnimatedList(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      initialItemCount: noNotes + (hasMore ? 1 : 0),
      itemBuilder: (context, index, animation) {
        // Last item — loading spinner for infinite scroll
        if (index == noNotes) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ListTile(
          leading: const Icon(Icons.bookmark),
          title: Text(
            notes[index].$1,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: InkWell(
            child: const Icon(Icons.delete_outline),
            onTap: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (_) => const _DeleteNoteDialog(),
              );
              if (shouldDelete == null) return; // User cancelled dialog
              if (!shouldDelete) return; // Option No was clicked
              await ref
                  .read(quickSnapNotesProvider.notifier)
                  .removefromDB(notes[index].$1);
              if (!context.mounted) return;
              AnimatedList.of(context).removeItem(index, (context, aimation) {
                return FadeTransition(
                  opacity: animation,
                  child: ListTile(
                    leading: const Icon(Icons.bookmark),
                    title: Text(notes[index].$1),
                  ),
                );
              });
            },
          ),
          dense: true,
          onTap: () => _onTap(context, notes, index, ref),
        );
      },
    );
  }

  void _onTap(
    BuildContext context,
    List<(String, QuickSnapNote)> note,
    int index,
    WidgetRef ref,
  ) {
    final delta = Delta.fromJson(
      jsonDecode(notes[index].$2.deltaJson) as List<dynamic>,
    );
    ref.read(quicksnapEditorProvider.notifier).updateEditorContent(delta);
    ref.read(appBarTitleProvider.notifier).changeTitle(notes[index].$1);
    ref.read(fileJustSavedProvider.notifier).signal();
    Navigator.pop(context);
  }
}

class _DeleteNoteDialog extends StatelessWidget {
  const _DeleteNoteDialog();
  final textStyle = const TextStyle(fontFamily: 'Unageo', fontWeight: .w500);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Do you wish to delete this note ?', style: textStyle),
      title: Text('Delete Note', style: textStyle),
      shape: const RoundedRectangleBorder(
        borderRadius: .all(Radius.circular(10.0)),
      ),
      actionsAlignment: .spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Yes', style: textStyle),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('No', style: textStyle),
        ),
      ],
    );
  }
}
