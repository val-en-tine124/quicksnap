import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

/// This is a QuickSnapSettings Class that wraps the QuillEditorConfig
/// and add some other important settings i can use.
///   It also has a quillEditorConfig static method to create
/// a QuillEditorConfig instance.
@freezed
abstract class QuickSnapSettings with _$QuickSnapSettings {
  const QuickSnapSettings._();
  const factory QuickSnapSettings({
    @Default(ThemeMode.system) ThemeMode theme,
    @Default(true) bool autoFocus,
    @Default(true) bool expands,
    @Default(0.0) double padding,
    @Default(UserColorEnum.amber) UserColorEnum userColor,
  }) = _QuickSnapSettings;

  static QuickSnapSettings getDefault() {
    return const QuickSnapSettings(
      theme: ThemeMode.system,
      autoFocus: true,
      expands: true,
      padding: 0,
    );
  }
}

extension EditorConfigFromSetting on QuickSnapSettings {
  QuillEditorConfig quillEditorConfig() {
    return QuillEditorConfig(
      autoFocus: autoFocus,
      expands: expands,
      padding: EdgeInsets.all(padding),
      placeholder: 'Type your text here.',
      // Performance: disable smooth cursor blink animation.
      // The default cursor blink uses AnimationController.animateTo()
      // with Curves.easeOut (250ms fade), which fires ~15 animation frames
      // per blink. Each frame triggers _onColorTick → safeMarkNeedsPaint
      // on every cursor-containing RenderEditableTextLine, causing a
      // repaint cascade that saturates the main thread (~289ms overdue timer).
      //
      // Setting showCursor: true uses a simpler blink (toggle visibility
      // every 500ms) without the smooth opacity animation, reducing
      // per-blink paint overhead from ~15 frames to 1 toggle.
      showCursor: true,
      // Paint cursor above text to avoid unnecessary repaint merging.
      paintCursorAboveText: true,
    );
  }
}

enum UserColorEnum { amber, blue, pink, green }

extension ToMaterialColor on UserColorEnum {
  MaterialColor toMaterialColor() {
    switch (name) {
      case 'amber':
        return Colors.amber;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
    }
    throw Exception('Invalid Enum value.');
  }
}