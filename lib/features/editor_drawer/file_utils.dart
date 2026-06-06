import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:path_provider/path_provider.dart';

/// Utility functions for file operations related to the editor
/// using the file_selector package for cross-platform file dialogs.
class FileContentUtils {
  /// Opens a file picker dialog and reads the selected file as a Delta.
  /// Returns a tuple of (XFile, Delta) on success, or null if cancelled.
  static Future<(XFile, Delta)?> pickFileAndReadDelta() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Text files',
      extensions: <String>['txt', 'log'],
      uniformTypeIdentifiers: <String>['public.text'],
    );
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );
    if (file == null) return null;

    final stopWatch = Stopwatch()..start();
    final bytes = await file.readAsBytes();
    final readTime = stopWatch.elapsed;
    log(
      'Read bytes of length ${bytes.length} from path ${file.path} in ${readTime.inMilliseconds} ms.',
      name: 'FileContentUtils',
    );
    final data = utf8.decode(bytes);
    final normalized = data.endsWith('\n') ? data : '$data\n';
    final delta = Delta()..insert(normalized);
    return (file, delta);
  }

  /// Reads an already-known [XFile] and converts its content to a [Delta].
  /// Used to re-read the current file when needed (e.g. after save).
  static Future<Delta> readFileToDelta(XFile file) async {
    final bytes = await file.readAsBytes();
    final data = utf8.decode(bytes);
    final normalized = data.endsWith('\n') ? data : '$data\n';
    final delta = Delta()..insert(normalized);
    log(
      'Read bytes of length ${bytes.length} from path ${file.path}',
      name: 'FileContentUtils',
    );
    return delta;
  }

  /// Opens a "Save As" dialog and writes [bytes] to the user-chosen location.
  /// Returns the resulting [XFile], or null if the user cancelled.
  static Future<XFile?> saveFileAs(Uint8List bytes, {String suggestedName = 'untitled.txt'}) async {
    // Start with a "Save As" dialog using the platform file selector
    try {
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: suggestedName,
      );
      if (result == null) {
        return null; // User cancelled
      }

      // Write bytes directly using dart:io (works on all platforms including Android)
      await File(result.path).writeAsBytes(bytes);
      log(
        'Wrote bytes of length ${bytes.length} to path ${result.path}',
        name: 'FileContentUtils',
      );
      return XFile(result.path);
    } catch (e) {
      // Fallback for platforms where getSaveLocation is not available (e.g. Android).
      // Save to external storage directory under /quicksnap/ with the suggested name.
      log(
        'getSaveLocation failed ($e), falling back to external storage directory.',
        name: 'FileContentUtils',
      );
      final Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        log('External storage not available, cannot save.', name: 'FileContentUtils');
        return null;
      }
      final String quickSnapDirPath = '${externalDir.path}/quicksnap';
      await Directory(quickSnapDirPath).create(recursive: true);
      final String filePath = '$quickSnapDirPath/$suggestedName';
      await File(filePath).writeAsBytes(bytes);
      log(
        'Wrote bytes of length ${bytes.length} to path $filePath (fallback)',
        name: 'FileContentUtils',
      );
      return XFile(filePath);
    }
  }

  /// Reads a file to Delta JSON format (for save-on-exit provider compat).
  static Future<List<Map<String, dynamic>>> readFileToDeltaJson(XFile file) async {
    final delta = await readFileToDelta(file);
    return delta.toJson();
  }
}