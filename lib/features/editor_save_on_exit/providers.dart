import 'dart:async';
import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class EditorInitialContent extends _$EditorInitialContent {
  @override
  FutureOr<List<Map<String, dynamic>>> build() {
    final quicksnapEditor = ref.read(quicksnapEditorProvider);
    return quicksnapEditor.document.toDelta().toJson();
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

    // Cancel any previous subscription + timer before creating new ones.
    _changesSubscription?.cancel();
    _changesSubscription = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;

    // Set up cleanup
    ref.onDispose(() {
      _changesSubscription?.cancel();
      _debounceTimer?.cancel();
    });

    // When a file save signal fires, re-baseline the initial content hash
    // to the current document content so the * (edited indicator) clears.
    ref.listen(fileJustSavedProvider, (previous, next) {
      if (previous != next) {
        final currentDelta = quicksnapEditor.document.toDelta();
        _initialContentHash = jsonEncode(currentDelta.toJson()).hashCode;
        state = false;
      }
    });

    // Handle async state - only proceed when we have data
    return previousDeltaAsync.maybeMap(
      data: (previousDelta) {
        final previousDeltaJson = previousDelta.value;
        if (previousDeltaJson.isEmpty) return false;

        // Compute a hash of the initial content once.
        _initialContentHash ??= jsonEncode(previousDeltaJson).hashCode;

        // Set up a SINGLE listener for future changes, debounced with a
        // one-shot Timer (not Timer.periodic). Cancelling the old subscription
        // and timer above prevents accumulating listeners.
        _changesSubscription = quicksnapEditor.changes.listen((_) {
          // Reset the debounce timer on each keystroke.
          _debounceTimer?.cancel();
          _debounceTimer = Timer(const Duration(milliseconds: 50), () {
            final currentDelta = quicksnapEditor.document.toDelta();
            state =
                jsonEncode(currentDelta.toJson()).hashCode !=
                _initialContentHash;
          });
        });

        // Initial comparison
        final currentDelta = quicksnapEditor.document.toDelta();
        return jsonEncode(currentDelta.toJson()).hashCode !=
            _initialContentHash;
      },
      orElse: () => false,
    );
  }
}