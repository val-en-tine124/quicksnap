import 'dart:convert';

import 'package:flutter_quill/quill_delta.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:quicksnap/features/save_to_db/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Future<LazyBox<QuickSnapNote>> handleHiveBox(Ref ref) async {
  return Hive.openLazyBox<QuickSnapNote>('QuickSnapNotes');
}

@riverpod
class QuickSnapNotes extends _$QuickSnapNotes {
  int _currentIndex = 0;
  LazyBox<QuickSnapNote>? _box;

  @override
  Future<List<(String, QuickSnapNote)>> build() async {
    // Initialize the box reference on build
    _box = await ref.read(handleHiveBoxProvider.future);
    return fetchNotes(7);
  }

  /// Saves a delta with the given title to the Hive box.
  Future<void> saveToDB(Delta delta, String title) async {
    _box ??= await ref.read(handleHiveBoxProvider.future);
    await _box!.put(
      title,
      QuickSnapNote(deltaJson: jsonEncode(delta.toJson())),
    );
  }

  /// Removes a note by title from the Hive box.
  Future<void> removefromDB(String title) async {
    _box ??= await ref.read(handleHiveBoxProvider.future);
    await _box!.delete(title);
    ref.invalidateSelf();
  }

  /// Fetches [count] items from the box starting at [_currentIndex].
  ///
  /// Returns the newly fetched items. Appends them to the existing state.
  Future<List<(String, QuickSnapNote)>> fetchNotes(int count) async {
    state = const AsyncLoading();
    _box ??= await ref.read(handleHiveBoxProvider.future);

    final List<(String, QuickSnapNote)> items = [];
    final limit = _currentIndex + count;
    while (_currentIndex < _box!.length && _currentIndex < limit) {
      final item = await _box!.getAt(_currentIndex);
      final itemKey = _box!.keyAt(_currentIndex);
      if (item != null) items.add((itemKey as String, item));
      _currentIndex++;
    }

    state = AsyncValue.data([...state.value ?? [], ...items]);
    return items;
  }

  /// Resets the cursor back to the beginning.
  void reset() => _currentIndex = 0;

  /// Whether there are more notes to fetch from the box.
  bool hasMore() => _box != null && _currentIndex < _box!.length;

  /// Total number of notes in the Hive box.
  int get totalNotes => _box?.length ?? 0;

  /// Total number of notes accessed so far.
  int get loadedNotes => _currentIndex + 1;
}
