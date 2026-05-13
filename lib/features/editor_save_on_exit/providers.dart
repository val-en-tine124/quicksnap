import 'dart:io';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
import 'package:quicksnap/features/editor/utils/file_utils.dart';
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
  @override
  bool build() {
    final quillController = ref.watch(quillControllerProvider);
    final previousDeltaAsync = ref.watch(editorInitialContentProvider);

    // Handle async state - only proceed when we have data
    return previousDeltaAsync.maybeMap(
      data: (previousDelta) {
        final previousDeltaJson = previousDelta.value;
        if (previousDeltaJson.isEmpty) return false;

        quillController.changes.listen((_) {
          final currentDelta = quillController.document.toDelta();
          final eq = DeepCollectionEquality();
          state =
              !eq.equals(currentDelta.toJson(), previousDeltaJson);
        });

        return false;
      },
      orElse: () => false,
    );
  }
}
