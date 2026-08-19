import 'package:flutter/material.dart';

/// Design tokens for LinguaLab — the "Mimi" identity.
///
/// Warm, saturated, sticker-flat color-blocking with a toucan mascot, chunky
/// hand-drawn-feeling shapes and "physical" pressed buttons — chosen over the
/// earlier dark/glass system because it reads as inviting rather than as a
/// generic AI dashboard. Both a light "paper" mode and a warm dark mode are
/// first-class; nothing here is a naive invert of the other.
///
/// Everything visual is derived from here: no raw hex values live in widgets.
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
  // Chunkier than the previous system: Mimi's shapes read as thick and
  // hand-drawn rather than as sharp corporate rounding.
  static const double rSm = 14;
  static const double rMd = 22;
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
  // Mimi palette — light-mode reference values, per the approved mockups.
  // Coral: primary action/CTA. Teal: secondary/mascot card. Marigold: reward
  // / celebration. Sage: mastery/success.
  static const Color coral = Color(0xFFE85D3F);
  static const Color coralDark = Color(0xFFC8482E);
  static const Color teal = Color(0xFF1C6B63);
  static const Color tealDark = Color(0xFF134E48);
  static const Color marigold = Color(0xFFF2A63D);
  static const Color marigoldDark = Color(0xFFC97F1F);
  static const Color sage = Color(0xFF8FAE6B);
  static const Color sageDark = Color(0xFF6B8A49);
  static const Color cream = Color(0xFFFBF3E3);
  static const Color creamAlt = Color(0xFFF4EAD2);
  static const Color ink = Color(0xFF241F16);

  // Dark-mode accent variants — same hues, brightened for contrast on a
  // warm near-black ground rather than dimmed.
  static const Color coralBright = Color(0xFFFF7A57);
  static const Color tealBright = Color(0xFF3FA69A);
  static const Color marigoldBright = Color(0xFFFFC266);
  static const Color sageBright = Color(0xFFA9CC80);

  /// The four confetti accents, used for celebration bursts.
  static const List<Color> confettiColors = [coral, teal, marigold, sage];

  // ------------------------------------------------------- legacy aliases
  // The previous "aurora" palette's names, kept pointing at the closest
  // Mimi colour so screens not yet redesigned in this pass keep compiling
  // and inherit the new identity's hues rather than breaking outright.
  // Follow-up passes should migrate call sites to the names above and
  // remove these.
  static const Color violet = teal;
  static const Color indigo = tealDark;
  static const Color cyan = tealBright;
  static const Color mint = sage;
  static const Color amber = marigold;
  static const Color rose = coral;

  /// Accent per language code, so each language owns a recognisable colour —
  /// pulled from the same warm family rather than the old cool "aurora" ramp.
  static const Map<String, List<Color>> languageGradient = {
    'en': [teal, Color(0xFF2F8A80)],
    'es': [marigold, coral],
    'zh': [coral, Color(0xFFD1462E)],
    'tr': [sage, teal],
    'ja': [coral, marigold],
  };

  static List<Color> gradientFor(String code) =>
      languageGradient[code] ?? const [coral, marigold];
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

  /// Paper / page background.
  final Color background;
  final Color backgroundAlt;

  /// Card surfaces — flat, not translucent, in the Mimi system.
  final Color surface;
  final Color surfaceRaised;

  /// Kept for API compatibility with the previous glass system: a handful of
  /// widgets still read `glassFill`/`glassStroke` for a soft fill or hairline
  /// border. In Mimi these resolve to a flat tint and a solid ~2px border
  /// colour rather than a translucent blur.
  final Color glassFill;
  final Color glassStroke;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;

  /// Primary action colour — coral.
  final Color accent;

  /// Secondary colour — teal.
  final Color accentAlt;

  /// Mastery / success — sage.
  final Color success;

  /// Reward / celebration — marigold.
  final Color warning;

  final Color danger;
  final Color onAccent;
  final Color scrim;

  /// Retained for the language-gradient accent triples used by a few
  /// screens; no longer paints an aurora field by default.
  final Color auroraA;
  final Color auroraB;
  final Color auroraC;
  final bool isDark;

  /// Light "paper" theme — the Mimi mockup's reference palette, used as-is.
  static const light = LLColors(
    background: LL.cream,
    backgroundAlt: LL.creamAlt,
    surface: Colors.white,
    surfaceRaised: Colors.white,
    glassFill: LL.creamAlt,
    glassStroke: Color(0x1F241F16), // ink @ 12%
    textPrimary: LL.ink,
    textSecondary: Color(0xB3241F16), // ink @ 70%
    textTertiary: Color(0x80241F16), // ink @ 50%
    divider: Color(0x1F241F16),
    accent: LL.coral,
    accentAlt: LL.teal,
    success: LL.sage,
    warning: LL.marigold,
    danger: Color(0xFFC8482E),
    onAccent: Colors.white,
    scrim: Color(0x80241F16),
    auroraA: LL.coral,
    auroraB: LL.teal,
    auroraC: LL.marigold,
    isDark: false,
  );

  /// Dark theme — cream becomes a warm near-black, ink becomes warm cream
  /// text, and the four accents brighten to stay legible. Not an invert:
  /// each value was picked separately for contrast on the dark ground.
  static const dark = LLColors(
    background: Color(0xFF1C1812),
    backgroundAlt: Color(0xFF241E16),
    surface: Color(0xFF2A231A),
    surfaceRaised: Color(0xFF332A1F),
    glassFill: Color(0xFF2A231A),
    glassStroke: Color(0x24FBF3E3), // cream @ 14%
    textPrimary: Color(0xFFF7EFDD),
    textSecondary: Color(0xFFC9BFA9),
    textTertiary: Color(0xFF988E78),
    divider: Color(0x1FFBF3E3),
    accent: LL.coralBright,
    accentAlt: LL.tealBright,
    success: LL.sageBright,
    warning: LL.marigoldBright,
    danger: Color(0xFFFF7A57),
    onAccent: Color(0xFF1C1812),
    scrim: Color(0xB3000000),
    auroraA: LL.coralBright,
    auroraB: LL.tealBright,
    auroraC: LL.marigoldBright,
    isDark: true,
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

  /// Darker shade of a colour, used for the "physical" button drop-shadow
  /// (mimics `box-shadow: 0 6px 0 <darker-shade>`) — a flat colour offset,
  /// not a blurred grey shadow.
  static Color pressedShadeOf(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withLightness((hsl.lightness - 0.16).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + 0.06).clamp(0.0, 1.0))
        .toColor();
  }
}

extension LLContext on BuildContext {
  LLColors get ll => Theme.of(this).extension<LLColors>() ?? LLColors.light;
  TextTheme get type => Theme.of(this).textTheme;

  /// True when the user asked the OS to reduce motion. Every animated widget
  /// in the app checks this and falls back to an instant, readable state.
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}
