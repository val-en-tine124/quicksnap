import 'package:flutter/material.dart';
import 'package:quicksnap/styling/theme_extension.dart';

class AppThemeData {
  const AppThemeData._();

  static ThemeData light() {
    const ext = AppColorsExtension.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: ext.brandPrimary,
        secondary: ext.brandSecondary,
        surface: ext.surface,
        onSurface: ext.onSurface,
        error: ext.danger,
      ),
      textTheme: _buildTextTheme(),
      cardTheme: CardThemeData(
        elevation: 0,
        color: ext.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: ext.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      listTileTheme: _buildListTileTheme(ext),
      extensions: [AppColorsExtension.light],
    );
  }

  static ThemeData dark() {
    const ext = AppColorsExtension.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: ext.brandPrimary,
        secondary: ext.brandSecondary,
        surface: ext.surface,
        onSurface: ext.onSurface,
        error: ext.danger,
      ),
      textTheme: _buildTextTheme(),
      listTileTheme: _buildListTileTheme(ext),
    );
  }

  static ListTileThemeData _buildListTileTheme(AppColorsExtension ext) {
    return ListTileThemeData(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ext.onSurface.withValues(alpha: 0.08)),
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
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    );
  }
}
