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
    @Default(false) bool disableClipboard,
    @Default(0.0) double padding,
    @Default(UserColorEnum.amber) UserColorEnum userColor,
  }) = _QuickSnapSettings;

  static  QuickSnapSettings getDefault(){
    return QuickSnapSettings(
        theme: ThemeMode.system,
        autoFocus: true,
        expands: true,
        disableClipboard: false,
        padding: 0,
      );
  }

}
extension EditorConfigFromSetting on QuickSnapSettings{
  QuillEditorConfig quillEditorConfig() {
    return QuillEditorConfig(
      autoFocus: autoFocus,
      expands: expands,

     disableClipboard: disableClipboard,
      padding: EdgeInsets.all(padding),
      placeholder:"Type your text here." 
    );
}}


enum UserColorEnum { amber, blue, pink }
extension ToMaterialColor on UserColorEnum{
  MaterialColor toMaterialColor(){
    switch (name) {
      case "amber":
        return Colors.amber;
      case "blue":
        return Colors.blue;
      case "pink":
        return Colors.pink;
    }
    throw Exception("Invalid Enum value.");
  }
}