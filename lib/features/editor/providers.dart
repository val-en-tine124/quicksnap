import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
part "providers.g.dart";

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
        allowedExtensions: ['txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        state = AsyncData(result.files.first);
      } else {
        state = AsyncData(null); // User canceled the picker
      }
    } on Exception catch (e) {
      state = AsyncError(e, StackTrace.current); // File picker failed with an exception
    }
  }

  Future<void> deleteFile() async {
    state = AsyncLoading(); // File delete started
    final stateValue = state.value;
    if (stateValue != null) {
      final stateValuePath = stateValue.path;
      if (stateValuePath != null) {
        final handle = File(stateValuePath);

        try {
          await handle.delete();
          state = AsyncData(null); // File delete has been completed
        } on Exception catch (e) {
          state = AsyncError(e, StackTrace.current); // Error on file delete
        }
      }
    }
  }
}
