import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:quicksnap/features/editor_drawer/providers.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class AppBarTitle extends _$AppBarTitle {
  @override
  String build() {
    final fileData = ref.watch(filePickerProvider);
    var appBarTitle = fileData.value?.name ?? 'Untitled Document';
    final isEdited = ref.watch(isEditedProvider);
    if (isEdited) {
      appBarTitle += ' *';
    }
    return appBarTitle;
  }

  ///Change the  appBar name to `newTitle`.
  void changeTitle(String newTitle) {
    state = newTitle;
  }
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
