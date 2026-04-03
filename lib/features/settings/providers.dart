import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import './models.dart';

@GenerateAdapters(
  [AdapterSpec<QuickSnapSettings>(), AdapterSpec<ThemeMode>(),AdapterSpec<UserColorEnum>()],
) // DO this to make QuickSnapSettings Hive compatible(i.e serialiazable and deserializable), and generate the adapter using build_runner
part 'providers.g.dart';

@riverpod
Box<QuickSnapSettings> settingsInHive(Ref ref) {
  throw UnimplementedError();
}

@riverpod
class SettingsState extends _$SettingsState {
  @override
  Future<QuickSnapSettings> build() async {
    final box = ref.read(settingsInHiveProvider);
    final value = box.get('settings');
    if (value != null) {
      return value;
    } else {
      return QuickSnapSettings.getDefault();
    }
  }

  void _saveSettings(AsyncValue<QuickSnapSettings> settingsState) async {
    final stateTemp = settingsState;
    final stateValue = stateTemp.value!;
    final box = ref.read(settingsInHiveProvider);
    state = AsyncLoading();
    box.put("settings", stateValue);
    state = AsyncData(stateValue);
  }

  void changeColor(UserColorEnum color) async {
    final settings = await future;
    state = AsyncValue.data(settings.copyWith(userColor: color));
    _saveSettings(state);
  }

  //Update ThemeMode(light,dark or system).
  void changeTheme(ThemeMode theme) async {
    final settings = await future;
    state = AsyncData(
      settings.copyWith(theme: theme),
    ); // Update Theme Settings state.
    _saveSettings(state); // Then save the settings.
  }

  /// Update auto focus Settings state.
  void changeAutoFocus(bool autoFocus) async {
    final settings = await future;
    state = AsyncData(
      settings.copyWith(autoFocus: autoFocus),
    ); // Update auto focus Settings state.
    _saveSettings(state); // Then save the settings.
  }

  /// Update editor expand Settings state.
  void changeEditorExpand(bool expands) async {
    final settings = await future;
    state = AsyncData(
      settings.copyWith(expands: expands),
    ); // Update editor expand Settings state.
    _saveSettings(state); // Then save the settings.
  }

  /// Update disable clipboard Settings state.
  void changeDisableClipboard(bool disableClipboard) async {
    final settings = await future;
    state = AsyncData(
      settings.copyWith(disableClipboard: disableClipboard),
    ); // Update disable clipboard Settings state.
    _saveSettings(state); // Then save the settings.
  }

  // Update editor padding  Settings state.
  void changeEditorPadding(double padding) async {
    final settings = await future;
    state = AsyncData(
      settings.copyWith(padding: padding),
    ); // Update editor padding  Settings state.
    _saveSettings(state); // Then save the settings.
  }
}

@riverpod
UserColorEnum currentUserColor(Ref ref) {
  final userColor = ref.watch(
    settingsStateProvider.select((s) => s.value?.userColor),
  );
  return userColor ?? UserColorEnum.amber;
}

@riverpod
ThemeMode currentTheme(Ref ref) {
  final theme = ref.watch(settingsStateProvider.select((s) => s.value?.theme));
  return theme ?? ThemeMode.system;
}

@riverpod
bool currentAutoFocus(Ref ref) {
  final autoFocus = ref.watch(
    settingsStateProvider.select((s) => s.value?.autoFocus),
  );
  return autoFocus ?? true;
}

@riverpod
bool currentEditorExpand(Ref ref) {
  final editorExpands = ref.watch(
    settingsStateProvider.select((s) => s.value?.expands),
  );
  return editorExpands ?? true;
}

@riverpod
bool currentDisableClipboard(Ref ref) {
  final disableClipboard = ref.watch(
    settingsStateProvider.select((s) => s.value?.disableClipboard),
  );
  return disableClipboard ?? false;
}

@riverpod
double currentEditorPadding(Ref ref) {
  final editorPadding = ref.watch(
    settingsStateProvider.select((s) => s.value?.padding),
  );
  return editorPadding ?? 0.0;
}
