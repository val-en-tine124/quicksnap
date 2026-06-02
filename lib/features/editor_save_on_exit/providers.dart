import 'dart:async';
import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_drawer/file_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class EditorInitialContent extends _$EditorInitialContent {
  @override
  FutureOr<List<Map<String, dynamic>>> build() {
    final platformFile = ref.watch(filePickerProvider);
    final quicksnapEditor = ref.read(quicksnapEditorProvider);
    final file = platformFile.asData?.value;

    if (file == null) {
      return quicksnapEditor.document.toDelta().toJson();
    }
    return FileContentUtils.fileToDeltaJson(file.identifier!);
  }
}

@riverpod
class IsEdited extends _$IsEdited {
  StreamSubscription<DocChange>? _changesSubscription;
  int? _initialContentHash;
  Timer? _debounceTimer;

  @override
  bool build() {
    final quicksnapEditor = ref.watch(quicksnapEditorProvider);
    final previousDeltaAsync = ref.watch(editorInitialContentProvider);

    // Cancel any existing subscription
    _changesSubscription?.cancel();
    _changesSubscription = null;

    // Set up cleanup
    ref.onDispose(() {
      _changesSubscription?.cancel();
      _debounceTimer?.cancel();
    });

    // Handle async state - only proceed when we have data
    return previousDeltaAsync.maybeMap(
      data: (previousDelta) {
        final previousDeltaJson = previousDelta.value;
        if (previousDeltaJson.isEmpty) return false;

        // Compute a hash of the initial content once.
        // Previously used DeepCollectionEquality().equals() which recursively
        // walks the entire nested delta tree on every keystroke (~5-20ms).
        // Using jsonEncode + hashCode is a single O(n) pass over the data.
        _initialContentHash = jsonEncode(previousDeltaJson).hashCode;

        // Compare current document with initial content using hash
        final currentDelta = quicksnapEditor.document.toDelta();
        final isDifferent =
            jsonEncode(currentDelta.toJson()).hashCode != _initialContentHash;

        // Add debounce timer of 50 milliseconds.        
        _debounceTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
          // Set up listener for future changes
          _changesSubscription = quicksnapEditor.changes.listen((_) {
            final newCurrentDelta = quicksnapEditor.document.toDelta();
            state =
                jsonEncode(newCurrentDelta.toJson()).hashCode !=
                _initialContentHash; // Updated comparison on every change
          });
        });

        return isDifferent; // Initial comparison result
      },
      orElse: () => false,
    );
  }
}
