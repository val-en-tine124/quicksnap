import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_drawer/file_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart';
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
        dialogTitle: 'Select a QuickSnap text file',
        type: FileType.custom,
        allowedExtensions: const ['txt', 'log'],
      );

      if (result != null && result.files.isNotEmpty) {
        //make sure the file picker picked a file.
        final firstFile = result.files.first;
        final delta = await FileContentUtils.fileToDelta(firstFile.identifier!);
        ref.read(quicksnapEditorProvider.notifier).updateEditorContent(delta);
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
    ref.read(quicksnapEditorProvider).clear();
    state = const AsyncData(null);
  }

  Future<void> saveFile() async {
    final documentAsText = ref
        .read(quicksnapEditorProvider)
        .document
        .toPlainText();
    final currentFileState = state;
    final bytesToSave = utf8.encode(documentAsText);
    state = const AsyncLoading();

    try {
      final fileToSave = currentFileState.value;
      if (fileToSave != null) {
        FileContentUtils.writeToFile(fileToSave.identifier!, bytesToSave);
        log(
          'got the file identifier:${fileToSave.identifier}',
          name: 'fileSave',
        );
        // Create a new PlatformFile with updated size
        final updatedFile = PlatformFile(
          name: fileToSave.name,
          path: fileToSave.path,
          size: bytesToSave.length,
        );
        state = AsyncData(updatedFile);
      } else {
        // "Save As" a new file
        final newPath = await FilePicker.platform.saveFile(
          type: FileType.custom,
          fileName: 'untitled.txt',
          allowedExtensions: ['txt'],
          bytes: bytesToSave,
        );

        if (newPath != null) {
          // If user saved the file, update the state with the new file info
          final fileSize = bytesToSave.length;
          final newPlatformFile = PlatformFile(
            name: newPath.split(Platform.pathSeparator).last,
            path: newPath,
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
