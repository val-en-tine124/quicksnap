import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'db.dart';
import 'models/entry.dart';

final entriesProvider = StreamProvider<List<Entry>>((ref) {
  return isar.entrys.where().sortByCreatedAtDesc().watch(fireImmediately: true);
});

final addEntryProvider = Provider((ref) => _AddEntry(ref));

class _AddEntry {
  final Ref ref;
  _AddEntry(this.ref);

  Future<void> call({String? text, String? photoPath}) async {
    final entry = Entry()
      ..createdAt = DateTime.now()
      ..text = text?.trim().isNotEmpty == true ? text : null
      ..photoPath = photoPath;

    await isar.writeTxn(() => isar.entrys.put(entry));
  }
}
