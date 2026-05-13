import 'dart:io';
import 'package:flutter_quill/quill_delta.dart';

/// Utility functions for file operations related to the editor
class FileUtils {
  /// Reads a file and converts its content to a Quill Delta
  /// This is used by both file picking and save-on-exit features
  static Future<Delta> fileToDelta(File file) async {
    final lines = await file.readAsLines();
    final joinedLines = "${lines.join("\n")}\n";
    return Delta()..insert(joinedLines);
  }

  /// Reads a file and converts its content to Delta JSON format
  /// Used by save-on-exit providers
  static Future<List<Map<String, dynamic>>> fileToDeltaJson(File file) async {
    final delta = await fileToDelta(file);
    return delta.toJson();
  }
}