
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/save_to_db/models.dart';
import 'package:quicksnap/features/save_to_db/providers.dart';

class NotesList extends ConsumerStatefulWidget {
  const NotesList({super.key});

  @override
  ConsumerState<NotesList> createState() => NoteListState();
}

class NoteListState extends ConsumerState<NotesList>{
  late final ScrollController controller;
  @override
  Future<void> initState() async {
    super.initState();
    final noteNotifier = ref.read(quickSnapNotesProvider.notifier);
    controller = ScrollController();
    controller.addListener(() async {
      if (controller.position.pixels <= controller.position.maxScrollExtent * 0.8 
      && 
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
    return ref.watch(quickSnapNotesProvider)
    .when(data: (data)=>NoteListTiles(noNotes: data.length,
     notes: data,controller: controller,),
     loading: ()=> const CircularProgressIndicator(),
     error: (err,st)=>const Text("Can't load notes something happened",
     style: TextStyle(fontFamily: 'Gilroy',fontWeight: .w300),)
     );
  }
}

class NoteListTiles extends ConsumerWidget {
  final List<(String, QuickSnapNote)> notes;
  final int noNotes;
  final ScrollController controller;
  const NoteListTiles({super.key,required this.noNotes,
  required this.notes,required this.controller});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ListView.builder(
        itemCount: noNotes,
        prototypeItem: const ListTile(),
        itemBuilder: (_, index) {
          if (index != noNotes -1) {
            return const Padding(padding: .symmetric(vertical: 25),
          child: Center(child: CircularProgressIndicator(),),);
          }
          return ListTile(
            leading: const Icon(FontAwesome.note_sticky),
            title: Text(notes[index].$1),
            dense: true,
            onTap: () {
              final editorController = ref.read(quicksnapEditorProvider)
                ..clear(); // clear quill controller state and
              //document it hold when opening a new file
              editorController.document.replace(
                0,
                editorController.document.length,
                notes[index].$2.delta,
              );
            },
          );
        },
      );
  }
}