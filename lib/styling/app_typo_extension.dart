import 'package:flutter/material.dart';

class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  const AppTypographyExtension({
    required this.displayLarge,
    required this.headingCard,
    required this.bodyEmphasized,
    required this.caption,
    required this.overline,
    required this.codeBlock,
  });

  final TextStyle displayLarge;
  final TextStyle headingCard;
  final TextStyle bodyEmphasized;
  final TextStyle caption;
  final TextStyle overline;
  final TextStyle codeBlock;

  @override
  AppTypographyExtension copyWith({
    TextStyle? displayLarge,
    TextStyle? headingCard,
    TextStyle? bodyEmphasized,
    TextStyle? caption,
    TextStyle? overline,
    TextStyle? codeBlock,
  }) {
    return AppTypographyExtension(
      displayLarge: displayLarge ?? this.displayLarge,
      headingCard: headingCard ?? this.headingCard,
      bodyEmphasized: bodyEmphasized ?? this.bodyEmphasized,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      codeBlock: codeBlock ?? this.codeBlock,
    );
  }

  @override
  AppTypographyExtension lerp(AppTypographyExtension? other, double t) {
    if (other is! AppTypographyExtension) return this;
    return AppTypographyExtension(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      headingCard: TextStyle.lerp(headingCard, other.headingCard, t)!,
      bodyEmphasized: TextStyle.lerp(bodyEmphasized, other.bodyEmphasized, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
      codeBlock: TextStyle.lerp(codeBlock, other.codeBlock, t)!,
    );
  }
}
