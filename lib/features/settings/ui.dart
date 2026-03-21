import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizmos_settings_screen/gizmos_settings_screen.dart';
import 'package:quicksnap/features/settings/providers.dart';

class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuickSnap Settings", style: TextStyle(fontWeight: .bold)),
      ),
      body: _SettingsBody(),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  _SettingsBody();
  // Select the default skin to use
  final SettingsSkinDelegate skinDelegate = !Platform.isIOS
      ? MaterialSettingsSkin()
      : CupertinoSettingsSkin();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool autoFocus = ref.watch(currentAutoFocusProvider);
    return SettingsSkin(
      delegate: skinDelegate,
      child: SettingsScreen(
        sections: [
          SettingsSection(
            header: "Appearance",
            cells: [
              DetailsSettingsCell(
                title: "App Theme",
                subtitle: "Choose the theme of the app",
                value: "",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return _ThemeSettingsDialog();
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            header: "Editor",
            cells: [
              SwitchSettingsCell(
                title: "Auto Focus",
                subtitle: "Toggle the text editor cursor focus",
                value: autoFocus,
                onChanged: (value) => ref
                    .read(settingsStateProvider.notifier)
                    .changeAutoFocus(value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeSettingsDialog extends ConsumerWidget {
  const _ThemeSettingsDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeState = ref.watch(currentThemeProvider);

    return AlertDialog(
      title: Text("Choose Theme"),

      content: RadioGroup<ThemeMode>(
        groupValue: themeState,
        child: Column(
          mainAxisSize: .min,
          children: [
            RadioListTile<ThemeMode>(value: .system, title: Text("System")),
            RadioListTile<ThemeMode>(value: .light, title: Text("Light")),
            RadioListTile<ThemeMode>(value: .dark, title: Text("Dark")),
          ],
        ),
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsStateProvider.notifier).changeTheme(value);
          }
        },
      ),
    );
  }
}
