import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:quicksnap/styling/theme_data.dart';
import 'package:quicksnap/features/settings/hive_registrar.g.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'features/editor/ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import './features/settings/providers.dart';
// import 'db.dart';
// import 'home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initDb();               // ← creates encrypted Isar instance
//   runApp(const ProviderScope(child: QuickSnapApp()));
// }

// class QuickSnapApp extends StatelessWidget {
//   const QuickSnapApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'QuickSnap',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
//       darkTheme: ThemeData.dark(useMaterial3: true),
//       home: const HomeScreen(),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  final box = await Hive.openBox<QuickSnapSettings>('QuickSnapSettings');

  runApp(
    ProviderScope(
      overrides: [settingsInHiveProvider.overrideWithValue(box)],
      child: const QuickSnapApp(),
    ),
  );
}

class QuickSnapApp extends ConsumerWidget {
  const QuickSnapApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref){
    final themeMode = ref.watch(currentThemeProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.light(context,ref) ,
      darkTheme: AppThemeData.dark(context,ref),
      themeMode:themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],

      home: EditorScaffold(),
    );
  }
}
