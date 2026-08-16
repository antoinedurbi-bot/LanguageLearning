import 'package:flutter/material.dart';

/// Design tokens for LinguaLab.
///
/// Everything visual is derived from here: no raw hex values live in widgets.
/// The palette is dark-first (the product is used at night, on the couch) with
/// a light variant tuned separately rather than inverted.
class LL {
  LL._();

  // ---------------------------------------------------------------- spacing
  // 4pt rhythm. Section spacing tiers: 16 / 24 / 32 / 48.
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;

  // ----------------------------------------------------------------- radii
  static const double rSm = 12;
  static const double rMd = 20;
  static const double rLg = 28;
  static const double rXl = 36;
  static const double rPill = 999;

  // --------------------------------------------------------------- motion
  // Micro-interactions 150-300ms; exits ~65% of enter duration.
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration exit = Duration(milliseconds: 170);
  static const Curve enter = Curves.easeOutCubic;
  static const Curve leave = Curves.easeInCubic;
  static const Curve spring = Curves.easeOutBack;

  /// Per-item entrance delay for staggered lists.
  static const Duration stagger = Duration(milliseconds: 45);

  // ---------------------------------------------------------------- brand
  // Accent ramp shared by both themes; these are the "aurora" hues.
  static const Color violet = Color(0xFF7C5CFF);
  static const Color indigo = Color(0xFF4A7BFF);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color mint = Color(0xFF2FE0A6);
  static const Color amber = Color(0xFFFFB020);
  static const Color rose = Color(0xFFFF6B8A);

  /// Accent per language code, so each language owns a recognisable colour.
  static const Map<String, List<Color>> languageGradient = {
    'en': [Color(0xFF4A7BFF), Color(0xFF22D3EE)],
    'es': [Color(0xFFFFB020), Color(0xFFFF6B8A)],
    'zh': [Color(0xFFFF6B8A), Color(0xFF7C5CFF)],
    'tr': [Color(0xFF2FE0A6), Color(0xFF22D3EE)],
    'ja': [Color(0xFFFF5C7A), Color(0xFFFFC15C)],
  };

  static List<Color> gradientFor(String code) =>
      languageGradient[code] ?? const [violet, cyan];
}

/// Semantic colours resolved per theme. Widgets read these through
/// `Theme.of(context).extension<LLColors>()!` (see `context.ll`).
@immutable
class LLColors extends ThemeExtension<LLColors> {
  const LLColors({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceRaised,
    required this.glassFill,
    required this.glassStroke,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.divider,
    required this.accent,
    required this.accentAlt,
    required this.success,
    required this.warning,
    required this.danger,
    required this.onAccent,
    required this.scrim,
    required this.auroraA,
    required this.auroraB,
    required this.auroraC,
    required this.isDark,
  });

  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceRaised;
  final Color glassFill;
  final Color glassStroke;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;
  final Color accent;
  final Color accentAlt;
  final Color success;
  final Color warning;
  final Color danger;
  final Color onAccent;
  final Color scrim;
  final Color auroraA;
  final Color auroraB;
  final Color auroraC;
  final bool isDark;

  /// Dark theme. Text contrast: primary #F2F4FF on #070A14 ~ 17:1,
  /// secondary #A9B2CC ~ 8:1, tertiary #7A839E ~ 4.6:1.
  static const dark = LLColors(
    background: Color(0xFF070A14),
    backgroundAlt: Color(0xFF0C1020),
    surface: Color(0xFF12172A),
    surfaceRaised: Color(0xFF1A2039),
    glassFill: Color(0x14FFFFFF),
    glassStroke: Color(0x1FFFFFFF),
    textPrimary: Color(0xFFF2F4FF),
    textSecondary: Color(0xFFA9B2CC),
    textTertiary: Color(0xFF7A839E),
    divider: Color(0x1FFFFFFF),
    accent: LL.violet,
    accentAlt: LL.cyan,
    success: Color(0xFF2FE0A6),
    warning: Color(0xFFFFB020),
    danger: Color(0xFFFF6B8A),
    onAccent: Color(0xFF080B18),
    scrim: Color(0x99000000),
    auroraA: Color(0xFF7C5CFF),
    auroraB: Color(0xFF22D3EE),
    auroraC: Color(0xFFFF6B8A),
    isDark: true,
  );

  /// Light theme. Deliberately warm-paper rather than pure white, with
  /// darker accent variants so contrast stays >= 4.5:1 on light surfaces.
  static const light = LLColors(
    background: Color(0xFFF6F5FB),
    backgroundAlt: Color(0xFFEFEEF8),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    glassFill: Color(0xCCFFFFFF),
    glassStroke: Color(0x14101433),
    textPrimary: Color(0xFF10142B),
    textSecondary: Color(0xFF4A5170),
    textTertiary: Color(0xFF6C7391),
    divider: Color(0x1A101433),
    accent: Color(0xFF5B3DE0),
    accentAlt: Color(0xFF0E93AD),
    success: Color(0xFF0F8F68),
    warning: Color(0xFF9A6100),
    danger: Color(0xFFD1345B),
    onAccent: Color(0xFFFFFFFF),
    scrim: Color(0x80101433),
    auroraA: Color(0xFF9F8BFF),
    auroraB: Color(0xFF7BE0F5),
    auroraC: Color(0xFFFFB3C4),
    isDark: false,
  );

  @override
  LLColors copyWith({
    Color? background,
    Color? backgroundAlt,
    Color? surface,
    Color? surfaceRaised,
    Color? glassFill,
    Color? glassStroke,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? divider,
    Color? accent,
    Color? accentAlt,
    Color? success,
    Color? warning,
    Color? danger,
    Color? onAccent,
    Color? scrim,
    Color? auroraA,
    Color? auroraB,
    Color? auroraC,
    bool? isDark,
  }) {
    return LLColors(
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      glassFill: glassFill ?? this.glassFill,
      glassStroke: glassStroke ?? this.glassStroke,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
      accent: accent ?? this.accent,
      accentAlt: accentAlt ?? this.accentAlt,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      onAccent: onAccent ?? this.onAccent,
      scrim: scrim ?? this.scrim,
      auroraA: auroraA ?? this.auroraA,
      auroraB: auroraB ?? this.auroraB,
      auroraC: auroraC ?? this.auroraC,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  LLColors lerp(ThemeExtension<LLColors>? other, double t) {
    if (other is! LLColors) return this;
    return LLColors(
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassStroke: Color.lerp(glassStroke, other.glassStroke, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentAlt: Color.lerp(accentAlt, other.accentAlt, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      auroraA: Color.lerp(auroraA, other.auroraA, t)!,
      auroraB: Color.lerp(auroraB, other.auroraB, t)!,
      auroraC: Color.lerp(auroraC, other.auroraC, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension LLContext on BuildContext {
  LLColors get ll => Theme.of(this).extension<LLColors>() ?? LLColors.dark;
  TextTheme get type => Theme.of(this).textTheme;

  /// True when the user asked the OS to reduce motion. Every animated widget
  /// in the app checks this and falls back to an instant, readable state.
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}
