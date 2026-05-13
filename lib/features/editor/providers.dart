import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quicksnap/features/editor_save_on_exit/providers.dart';
import 'package:quicksnap/features/editor/utils/file_utils.dart';
part "providers.g.dart";

@riverpod
class AppBarTitle extends _$AppBarTitle {
  @override
  String build() {
    final fileData = ref.watch(filePickerProvider);
    var appBarTitle = fileData.value?.name ?? "Untitled Document";
    final isEdited = ref.watch(isEditedProvider);
    if (isEdited) {
      appBarTitle += " *";
    }
    return appBarTitle;
  }

  ///Change the  appBar name to `newTitle`.
  void changeTitle(String newTitle) {
    state = newTitle;
  }
}

final quillControllerProvider = Provider.autoDispose<QuillController>((ref) {
  final controller = QuillController.basic(); // Basic controller
  ref.onDispose(() {
    // Dispose the controller when the provider is disposed
    controller.dispose();
  });
  return controller;
});

///This notifier contains methods for various file operation.
@riverpod
class FilePickerNotifier extends AsyncNotifier<PlatformFile?> {
  @override
  Future<PlatformFile?> build() async {
    // Initial state or potentially load last picked file if persisted (future)
    return null;
  }

  Future<void> pickFile() async {
    state = const AsyncLoading();
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "Select a QuickSnap text file",
        type: FileType.custom,
        allowedExtensions: ['txt', 'log'],
      );

      if (result != null && result.files.isNotEmpty) {
        //make sure the file picker picked a file.
        final firstFile = result.files.first;
        final delta = await Isolate.run(
          () => FileUtils.fileToDelta(File(firstFile.path!)),
        );
        final editorController = ref.read(quillControllerProvider)
          ..clear(); // clear quill controller state and
        //document it hold when opening a new file
        editorController.document.replace(
          0,
          editorController.document.length,
          delta,
        );
        state = AsyncData(firstFile);
      } else {
        state = const AsyncData(null); // User cancelled the picker
      }
    } on Exception catch (e) {
      state = AsyncError(
        e,
        StackTrace.current,
      ); // File picker failed with an exception
    }
  }

  void newFile() {
    state = const AsyncLoading();
    //ref.read(appBarTitleProvider.notifier).resetTitle();
    ref.read(quillControllerProvider).clear();
    state = const AsyncData(null);
  }

  Future<void> saveFile() async {
    final editorController = ref.read(quillControllerProvider);
    final documentAsText = editorController.document.toPlainText();
    final currentFileState = state;

    state = const AsyncLoading();

    try {
      final fileToSave = currentFileState.value;
      if (fileToSave != null) {
        // Overwrite existing file
        final file = File(fileToSave.path!);
        await file.writeAsString(documentAsText);
        // Create a new PlatformFile with updated size
        final updatedFile = PlatformFile(
          name: fileToSave.name,
          path: fileToSave.path,
          size: await file.length(),
        );
        state = AsyncData(updatedFile);
      } else {
        // "Save As" a new file
        final newPath = await FilePicker.platform.saveFile(
          type: FileType.custom,
          fileName: "untitled.txt",
          allowedExtensions: ["txt",],
          bytes: utf8.encode(documentAsText),
        );

        if (newPath != null) {
          // If user saved the file, update the state with the new file info
          final file = File(newPath);
          int fileSize = 0;
          try {
            fileSize = await file.length();
          } catch (e) {
            state = AsyncError(e, StackTrace.current);
            return;
          }
          final newPlatformFile = PlatformFile(
            name: file.path.split(Platform.pathSeparator).last,
            path: file.path,
            size: fileSize,
          );
          state = AsyncData(newPlatformFile);
        } else {
          // User cancelled the "Save As" dialog, restore the previous state
          state = currentFileState;
        }
      }
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
