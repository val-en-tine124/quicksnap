import 'package:flutter/material.dart';
import 'package:quicksnap/styling/app_typo_extension.dart';
import 'package:quicksnap/styling/color_tokens.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.brandPrimary,
    required this.brandPrimaryLight,
    required this.brandSecondary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
  });

  final Color brandPrimary;
  final Color brandPrimaryLight;
  final Color brandSecondary;
  final Color success;
  final Color warning;
  final Color danger;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;

  static const light = AppColorsExtension(
    brandPrimary: ColorTokens.blue600,
    brandPrimaryLight: ColorTokens.blue50,
    brandSecondary: ColorTokens.green500,
    success: ColorTokens.green500,
    warning: ColorTokens.yellow400,
    danger: ColorTokens.red500,
    surface: Color(0xFFFFFFFF),
    surfaceVariant: ColorTokens.grey50,
    onSurface: ColorTokens.grey900,
    onSurfaceVariant: Color(0xFF5F6368),
  );

  static const dark = AppColorsExtension(
    brandPrimary: Color(0xFF8AB4F8),
    brandPrimaryLight: Color(0xFF1C2B41),
    brandSecondary: Color(0xFF81C995),
    success: Color(0xFF81C995),
    warning: Color(0xFFFDD663),
    danger: Color(0xFFF28B82),
    surface: ColorTokens.grey900,
    surfaceVariant: Color(0xFF303134),
    onSurface: Color(0xFFE8EAED),
    onSurfaceVariant: Color(0xFF9AA0A6),
  );

  @override
  AppColorsExtension copyWith({
    Color? brandPrimary,
    Color? brandPrimaryLight,
    Color? brandSecondary,
    Color? success,
    Color? warning,
    Color? danger,
    Color? surface,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceVariant,
  }) {
    return AppColorsExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandPrimaryLight: brandPrimaryLight ?? this.brandPrimaryLight,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandPrimaryLight: Color.lerp(
        brandPrimaryLight,
        other.brandPrimaryLight,
        t,
      )!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;

  AppTypographyExtension get appTypo =>
      Theme.of(this).extension<AppTypographyExtension>()!;
}
