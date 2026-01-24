import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/editor/ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

void main() {
  runApp(const ProviderScope(child: QuickSnapApp()));
}

class QuickSnapApp extends StatelessWidget {
  const QuickSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData.dark(useMaterial3: true),
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
