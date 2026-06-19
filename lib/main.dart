import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:quicksnap/features/app_update/ui.dart';
import 'package:quicksnap/features/editor_save_on_exit/ui.dart';
import 'package:quicksnap/features/save_to_db/ui.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:quicksnap/features/settings/ui.dart';
import 'package:quicksnap/styling/theme_data.dart';

import '../features/hive_registrar.g.dart';
import './features/settings/providers.dart';
import 'features/editor/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('quicksnap_data');
  Hive.registerAdapters();

  final [settingsBox, _] = await Future.wait([
    Hive.openBox<QuickSnapSettings>('QuickSnapSettings'),
    Hive.openBox<UpdateChecker>('UpdateConfig'),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        settingsInHiveProvider.overrideWithValue(
          settingsBox as Box<QuickSnapSettings>,
        ),
      ],
      child: const QuickSnapApp(),
    ),
  );
}

class QuickSnapApp extends ConsumerWidget {
  const QuickSnapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(currentThemeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.light(context, ref),
      darkTheme: AppThemeData.dark(context, ref),
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],

      home: const UpdateChecker(
        child: SaveOnExit(
          editorScaffold: EditorScaffold(
            drawer: DBNotesDrawer(),
            settingsPage: SettingsPage(),
          ),
        ),
      ),
    );
  }
}
