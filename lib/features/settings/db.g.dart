// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class QuickSnapSettingsAdapter extends TypeAdapter<QuickSnapSettings> {
  @override
  final typeId = 0;

  @override
  QuickSnapSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuickSnapSettings(
      theme: fields[0] as ThemeMode,
      autoFocus: fields[1] as bool,
      expands: fields[2] as bool,
      disableClipboard: fields[3] as bool,
      scrollable: fields[4] as bool,
      padding: fields[5] as EdgeInsets,
    );
  }

  @override
  void write(BinaryWriter writer, QuickSnapSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.theme)
      ..writeByte(1)
      ..write(obj.autoFocus)
      ..writeByte(2)
      ..write(obj.expands)
      ..writeByte(3)
      ..write(obj.disableClipboard)
      ..writeByte(4)
      ..write(obj.scrollable)
      ..writeByte(5)
      ..write(obj.padding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickSnapSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
