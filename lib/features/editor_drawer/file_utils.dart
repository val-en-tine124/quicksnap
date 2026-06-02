import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:content_resolver/content_resolver.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Utility functions for file operations related to the editor
/// class that contains method for handle android files using URI content:// instead of a local cache path.
class FileContentUtils {
  ///Function to right to an existing file i.e Android content:// URI instead of a local cache path.
  /// Note: Previously used readAsLines() + join() which creates an
  /// intermediate List<String> allocation. readAsString() is a single
  /// I/O call with no intermediate allocation, faster for large files.

  static void writeToFile(String fileIdentifier, Uint8List bytes) async {
    log(
      'Wrote bytes of length ${bytes.length} to path $fileIdentifier',
      name: 'FileContentUtils',
    );
    await ContentResolver.writeContent(fileIdentifier, bytes);
  }

  static Future<Delta> fileToDelta(String fileIdentifier) async {
    final delta = Delta();
    final stopWatch = Stopwatch()..start();
    final bytesContent = await ContentResolver.resolveContent(fileIdentifier);
    final contentReslvTime = stopWatch.elapsed;
    stopWatch.stop();
    stopWatch.start();
    final data = utf8.decode(bytesContent.data);
    final utf8DecodingTime = stopWatch.elapsed;
    log(
      'Read  bytes of length ${bytesContent.data.length} from path $fileIdentifier.\nresolve path $fileIdentifier in ${contentReslvTime.inMilliseconds} ms and decoded bytes to utf-8 in ${utf8DecodingTime.inMilliseconds} ms.',
      name: 'FileContentUtils',
    );
    final normalized = data.endsWith('\n') ? data : '$data\n';
    delta.insert(normalized);
    return delta;
  }

  /// Reads a file and converts its content to Delta JSON format
  /// Used by save-on-exit providers
  static Future<List<Map<String, dynamic>>> fileToDeltaJson(
    String fileIdentifier,
  ) async {
    final delta = await fileToDelta(fileIdentifier);
    return delta.toJson();
  }
}
