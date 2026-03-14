import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// This is aQuickSnapSettingss Class that wraps the QuillEditorConfig
/// and add some other important settings i can use.
///   It also has a quillEditorConfig static method to create
/// a QuillEditorConfig instance.
class QuickSnapSettings {
  ThemeMode theme = ThemeMode.system;
  bool autoFocus = true;
  bool expands = true;
  bool disableClipboard = false;
  bool scrollable = true;
  EdgeInsets padding = .zero;
 QuickSnapSettings({
    required this.theme,
    required this.autoFocus,
    required this.expands,
    required this.disableClipboard,
    required this.scrollable,
    required this.padding,
  });

  QuillEditorConfig quillEditorConfig() {
    return QuillEditorConfig(
      autoFocus:autoFocus,
      expands: expands,
      disableClipboard: disableClipboard,
      scrollable: scrollable,
      padding:padding,
    );
  }
}