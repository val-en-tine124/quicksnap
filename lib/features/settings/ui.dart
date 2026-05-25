import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:quicksnap/features/settings/providers.dart';
import 'package:quicksnap/features/widgets.dart';

class SettingsUI extends StatelessWidget {
  const SettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuickSnap Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _SectionHeader('Appearance'),
        ListTile(
          title: const Text('App Theme'),
          subtitle: const Text('Choose the theme of the app'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const _ThemeSettingsDialog(),
            );
          },
        ),
        const _SectionHeader('Editor'),
        Consumer(
          builder: (context, ref, _) {
            final autoFocus = ref.watch(currentAutoFocusProvider);
            return SwitchListTile(
              title: const Text('Auto Focus'),
              subtitle: const Text('Toggle the text editor cursor focus'),
              value: autoFocus,
              onChanged: (value) => ref
                  .read(settingsStateProvider.notifier)
                  .changeAutoFocus(value),
            );
          },
        ),
        Consumer(
          builder: (context, ref, _) {
            final editorExpand = ref.watch(currentEditorExpandProvider);
            return SwitchListTile(
              title: const Text('Editor Expand'),
              subtitle: const Text('Toggle the text editor expansion'),
              value: editorExpand,
              onChanged: (value) => ref
                  .read(settingsStateProvider.notifier)
                  .changeEditorExpand(value),
            );
          },
        ),

        ListTile(
          title: const Text('Editor padding'),
          subtitle: const Text(
            'Choose padding/spacing between the editor and your text',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const _PaddingSettingDialog(),
            );
          },
        ),
        const _SectionHeader('Styling'),
        Consumer(
          builder: (context, ref, _) {
            final colorValue = ref.watch(currentUserColorProvider);
            return ColorButtonTray(
              colors: UserColorEnum.values,
              value: colorValue,
              onTap: (color) =>
                  ref.read(settingsStateProvider.notifier).changeColor(color),
            );
          },
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _PaddingSettingDialog extends ConsumerWidget {
  const _PaddingSettingDialog();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorPadding = ref.watch(currentEditorPaddingProvider);
    return AlertDialog.adaptive(
      title: const Text('Select padding size'),
      content: Slider(
        value: editorPadding,
        onChanged: (value) =>
            ref.read(settingsStateProvider.notifier).changeEditorPadding(value),
        min: 0,
        max: 50,
        divisions: 10,
        label: editorPadding.round().toString(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _ThemeSettingsDialog extends ConsumerWidget {
  const _ThemeSettingsDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(currentThemeProvider);

    return AlertDialog(
      title: const Text('Choose Theme'),

      content: RadioGroup<ThemeMode>(
        groupValue: themeState,
        child: const Column(
          mainAxisSize: .min,
          children: [
            RadioListTile<ThemeMode>(value: .system, title: Text('System')),
            RadioListTile<ThemeMode>(value: .light, title: Text('Light')),
            RadioListTile<ThemeMode>(value: .dark, title: Text('Dark')),
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
