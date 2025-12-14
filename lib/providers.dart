import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_plus/isar_plus.dart';
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
    final entry = Entry(isar.entrys.autoIncrement())
      ..createdAt = DateTime.now()
      ..text = text?.trim().isNotEmpty == true ? text : null
      ..photoPath = photoPath;
    if (kIsWeb) {
      isar.write((isar) {
        isar.entrys.put(entry);
        return;
      });
    }
    await isar.writeAsync((isar) async {
      isar.entrys.put(entry);
    });
  }
}
