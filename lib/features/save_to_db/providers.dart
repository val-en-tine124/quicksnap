import 'package:flutter_quill/quill_delta.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:quicksnap/features/save_to_db/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart';

@riverpod
Future<LazyBox<QuickSnapNote>> handleHiveBox() async {
  return Hive.openLazyBox<QuickSnapNote>('QuickSnapNotes');
}

@riverpod
class QuickSnapNotes extends _$QuickSnapNotes {
  int _currentIndex = 0;
  
  @override
  Future<List<(String,QuickSnapNote)>> build() async {
    return fetchNotes(7);
  }

  ///`title:` This is the model index.
  ///
  ///`delta:` This is note delta insance to save.
  Future<void> saveToDB(Delta delta, String title) async {
    final box = ref.read(handleHiveBoxProvider).value;
    box?.put(title, QuickSnapNote(delta: delta,dateCreated:
     DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> removefromDB(String title) async {
    final box = ref.read(handleHiveBoxProvider).value;
    box?.delete(title);
  }

  /// Fetches [count] items from the box.
  /// 
  /// Pauses automatically by saving the current index.
  Future<List<(String,QuickSnapNote)>> fetchNotes(int count) async {
    state = const AsyncLoading();
    final box = ref.read(handleHiveBoxProvider).value;

    final List<(String,QuickSnapNote)> items = [];
    // Calculate where the current batch should end an
    final limit = _currentIndex + count;
    if(box == null)return [];
    // loop until we hit a bacth limit or the end of the box.
    while (_currentIndex < box.length && _currentIndex < limit) {
      final item = await box.getAt(_currentIndex);
      final itemKey = box.keyAt(_currentIndex);
      if (item != null) items.add((itemKey as String,item));
      _currentIndex++;
    }
    
    state =AsyncValue.data( [...state.value ?? [],...items]);
    return items;
      
  }
  /// Reset the cursor to start from the biginning.
  void reset()=> _currentIndex = 0;
  ///Optional : check if there's more data to fetch.
  bool hasMore(){
    final box = ref.watch(handleHiveBoxProvider).value;
   if(box == null)return false;
   return _currentIndex < box.length;
  }
  /// Total notes in the Hive Box.
  int get totalNotes => ref.watch(handleHiveBoxProvider).value?.length ?? 0;

  /// Total Acessed notes in the Hive box  
  int get loadedNotes => _currentIndex + 1;
}
