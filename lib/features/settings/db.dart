import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:quicksnap/features/settings/models.dart';

@GenerateAdapters(
  [AdapterSpec<QuickSnapSettings>()],
) // DO this to make QuickSnapSettings Hive compatible(i.e serialiazable and deserializable), and generate the adapter using build_runner
part 'db.g.dart';

interface class SettingsInDB {
  void save(QuickSnapSettings settings) {}
  QuickSnapSettings load() {
    throw UnimplementedError();
  }
}

class SettingsInHive implements SettingsInDB {
  final box = Hive.box<QuickSnapSettings>("QuickSnapSettings");

  @override
  QuickSnapSettings load() {
    final value = box.get("settings");
    if (value != null) {
      return value;
    } else {
      return QuickSnapSettings(
        theme: ThemeMode.system,
        autoFocus: true,
        expands: true,
        disableClipboard: false,
        scrollable: true,
        padding: EdgeInsets.zero,
      );
    }
  }

  @override
  void save(QuickSnapSettings settings) {
    box.put("settings", settings);
  }
}
