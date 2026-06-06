import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/editor/providers.dart';
import 'package:quicksnap/features/editor_drawer/file_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart';
///This notifier contains methods for various file operation.
@riverpod
class FilePickerNotifier extends AsyncNotifier<XFile?> {
  @override
  Future<XFile?> build() async {
    // Initial state or potentially load last picked file if persisted (future)
    return null;
  }

  Future<void> pickFile() async {
    state = const AsyncLoading();
    try {
      final result = await FileContentUtils.pickFileAndReadDelta();
      if (result != null) {
        final (file, delta) = result;
        ref.read(quicksnapEditorProvider.notifier).updateEditorContent(delta);
        state = AsyncData(file);
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
    ref.read(quicksnapEditorProvider).clear();
    state = const AsyncData(null);
  }

  Future<void> saveFile({String? suggestedName}) async {
    final documentAsText = ref
        .read(quicksnapEditorProvider)
        .document
        .toPlainText();
    final currentFileState = state;
    final bytesToSave = utf8.encode(documentAsText);
    state = const AsyncLoading();

    try {
      final currentFile = currentFileState.value;
      if (currentFile != null) {
        // Overwrite the existing file using its path
        await File(currentFile.path).writeAsBytes(bytesToSave);
        log(
          'Wrote bytes of length ${bytesToSave.length} to path ${currentFile.path}',
          name: 'fileSave',
        );
        ref.read(fileJustSavedProvider.notifier).signal();
        state = AsyncData(currentFile);

      } else {
        // "Save As" — no file is open
        final savedFile = await FileContentUtils.saveFileAs(
          bytesToSave,
          suggestedName: suggestedName ?? 'untitled.txt',
        );
        if (savedFile != null) {
          ref.read(fileJustSavedProvider.notifier).signal();
          state = AsyncData(savedFile);
        } else {
          // User cancelled the "Save As" dialog, restore previous state
          state = currentFileState;
        }
      }
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}