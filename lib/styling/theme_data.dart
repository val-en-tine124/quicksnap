import 'package:flutter/material.dart';
import 'package:quicksnap/features/settings/models.dart';
import 'package:quicksnap/features/settings/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemeData {
  const AppThemeData._();

  static ThemeData light(BuildContext context, WidgetRef ref) {
    final seedColor = ref.watch(currentUserColorProvider).toMaterialColor();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      textTheme: _buildTextTheme(),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(),
        ),
      ),
      listTileTheme: _buildListTileTheme(),
    );
  }

  static ThemeData dark(BuildContext context, WidgetRef ref) {
    final seedColor = ref.watch(currentUserColorProvider).toMaterialColor();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: .dark,
      ),
      textTheme: _buildTextTheme(),
      listTileTheme: _buildListTileTheme(),
    );
  }

  static ListTileThemeData _buildListTileTheme() {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        side: BorderSide(style: .none),
        borderRadius: BorderRadiusGeometry.circular(30),
      ),
      contentPadding: const .all(2.0),
      titleAlignment: .top,
      minLeadingWidth: 0.0,

      minVerticalPadding: 17.0,
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontFamily: "ReThink-Sans",
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        fontFamily: "CodePro",
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
