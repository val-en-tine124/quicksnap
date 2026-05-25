import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor/utils/file_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class EditorInitialContent extends _$EditorInitialContent {
  @override
  FutureOr<List<Map<String, dynamic>>> build() {
    final platformFile = ref.watch(filePickerProvider);
    final quillController = ref.read(quillControllerProvider);
    final file = platformFile.asData?.value;

    if (file == null) {
      return quillController.document.toDelta().toJson();
    }

    final handle = File(file.path!);
    return FileUtils.fileToDeltaJson(handle);
  }
}

@riverpod
class IsEdited extends _$IsEdited {
  StreamSubscription? _changesSubscription;

  @override
  bool build() {
    final quillController = ref.watch(quillControllerProvider);
    final previousDeltaAsync = ref.watch(editorInitialContentProvider);

    // Cancel any existing subscription
    _changesSubscription?.cancel();
    _changesSubscription = null;

    // Set up cleanup
    ref.onDispose(() {
      _changesSubscription?.cancel();
    });

    // Handle async state - only proceed when we have data
    return previousDeltaAsync.maybeMap(
      data: (previousDelta) {
        final previousDeltaJson = previousDelta.value;
        if (previousDeltaJson.isEmpty) return false;

        // Compare current document with initial content
        final currentDelta = quillController.document.toDelta();
        const eq = DeepCollectionEquality();
        final isDifferent = !eq.equals(
          currentDelta.toJson(),
          previousDeltaJson,
        );

        // Set up listener for future changes
        _changesSubscription = quillController.changes.listen((_) {
          final newCurrentDelta = quillController.document.toDelta();
          state = !eq.equals(newCurrentDelta.toJson(), previousDeltaJson);
        });

        return isDifferent;
      },
      orElse: () => false,
    );
  }
}
