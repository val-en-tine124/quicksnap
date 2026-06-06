import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// A signal (toggled boolean) that indicates a file save just completed.
/// Watched by AppBarTitle to strip the asterisk from the title.
@riverpod
class FileJustSaved extends _$FileJustSaved {
  @override
  bool build() => false;

  void signal() => state = !state;
}

@riverpod
class QuicksnapEditor extends _$QuicksnapEditor {
  @override
  QuillController build() {
    final controller = QuillController.basic(); // Basic controller
    ref.onDispose(() => controller.dispose());
    return controller;
  }

  void updateEditorContent(Delta delta) {
    final editorController = state..clear(); // clear quill controller state
    //and the document it hold when opening a new file
    editorController.document.replace(
      0,
      editorController.document.length,
      delta,
    );
  }
}