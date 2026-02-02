import 'dart:io';
import 'dart:isolate';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
part "providers.g.dart";

@riverpod
class AppBarTitle extends _$AppBarTitle {
  @override
  String build() {
    final fileData = ref.watch(filePickerProvider);
    final appBarTitle = fileData.value?.name ?? "Untitled Document";
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
    state = AsyncLoading();
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "Select a QuickSnap text file",
        type: FileType.custom,
        allowedExtensions: ['txt', 'log'],
      );

      if (result != null && result.files.isNotEmpty) {
        final firstFile = result.files.first;
        final delta = await Isolate.run(() async {
          final handle = File(firstFile.path!);
          final lines = await handle.readAsLines();
          final joinedLines = "${lines.join("\n")}\n";
          final delta = Delta()..insert(joinedLines);
          return delta;
        });
        final editorController = ref.read(quillControllerProvider);
        editorController.document.replace(
          0,
          editorController.document.length,
          delta,
        );

        state = AsyncData(firstFile);
      } else {
        state = AsyncData(null); // User canceled the picker
      }
    } on Exception catch (e) {
      state = AsyncError(
        e,
        StackTrace.current,
      ); // File picker failed with an exception
    }
  }

  void newFile() {
    state = AsyncLoading();
    //ref.read(appBarTitleProvider.notifier).resetTitle();
    ref.read(quillControllerProvider).clear();
    state = AsyncData(null);
  }
}
