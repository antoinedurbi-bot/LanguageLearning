import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// Theme construction — the "Mimi" identity's three-font system: Fredoka
/// carries display/headline/button roles (rounded, warm, not childish),
/// Nunito Sans carries body copy, Space Mono carries tags/stats/mono data
/// (set directly on the widgets that need it, e.g. streak counters).
class AppTheme {
  static ThemeData get dark => _build(LLColors.dark, Brightness.dark);
  static ThemeData get light => _build(LLColors.light, Brightness.light);

  /// Display face: rounded and warm, for headlines and buttons.
  static const _display = 'Fredoka';

  /// Body face: neutral, high legibility at small sizes.
  static const _body = 'NunitoSans';

  /// Tags/stats/mono data face — exposed for direct use, e.g. `LL.mono`.
  static const mono = 'SpaceMono';

  static TextTheme _textTheme(LLColors c) {
    const display = TextStyle(fontFamily: _display);
    const body = TextStyle(fontFamily: _body);

    // Type scale: 12 / 14 / 16 / 18 / 22 / 28 / 36 / 46.
    return TextTheme(
      displayLarge: display.copyWith(
        fontSize: 46,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.4,
        color: c.textPrimary,
      ),
      displayMedium: display.copyWith(
        fontSize: 36,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: c.textPrimary,
      ),
      headlineMedium: display.copyWith(
        fontSize: 28,
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: c.textPrimary,
      ),
      headlineSmall: display.copyWith(
        fontSize: 22,
        height: 1.24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: c.textPrimary,
      ),
      titleMedium: display.copyWith(
        fontSize: 18,
        height: 1.32,
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
      ),
      titleSmall: body.copyWith(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: c.textPrimary,
      ),
      bodyLarge: body.copyWith(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: c.textSecondary,
      ),
      bodyMedium: body.copyWith(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: c.textSecondary,
      ),
      labelLarge: body.copyWith(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: c.textPrimary,
      ),
      labelMedium: body.copyWith(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: c.textSecondary,
      ),
      labelSmall: body.copyWith(
        fontSize: 12,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: c.textTertiary,
      ),
    );
  }

  static ThemeData _build(LLColors c, Brightness brightness) {
    final text = _textTheme(c);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      splashFactory: InkSparkle.splashFactory,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.accent,
        onPrimary: c.onAccent,
        secondary: c.accentAlt,
        onSecondary: c.onAccent,
        error: c.danger,
        onError: c.onAccent,
        surface: c.surface,
        onSurface: c.textPrimary,
        surfaceContainerHighest: c.surfaceRaised,
        outline: c.glassStroke,
      ),
      textTheme: text,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.headlineSmall,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      iconTheme: IconThemeData(color: c.textSecondary, size: 24),
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        elevation: 0,
        color: c.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LL.rMd),
          side: BorderSide(color: c.glassStroke, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          minimumSize: const Size(64, 52),
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LL.rSm + 4),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accent,
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          minimumSize: const Size(64, 52),
          side: BorderSide(color: c.glassStroke),
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LL.rSm + 4),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.isDark ? c.surface : c.surface,
        // 56px tall: comfortably above the 44pt touch minimum.
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LL.s16,
          vertical: LL.s16,
        ),
        labelStyle: text.bodyMedium,
        floatingLabelStyle: TextStyle(color: c.accent),
        hintStyle: text.bodyMedium?.copyWith(color: c.textTertiary),
        helperStyle: text.labelSmall?.copyWith(letterSpacing: 0.1),
        errorStyle: text.labelMedium?.copyWith(color: c.danger),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          borderSide: BorderSide(color: c.glassStroke, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          borderSide: BorderSide(color: c.glassStroke, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          borderSide: BorderSide(color: c.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          borderSide: BorderSide(color: c.danger, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.surfaceRaised,
        contentTextStyle: text.bodyMedium?.copyWith(color: c.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LL.rSm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LL.rLg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: c.scrim,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(LL.rLg)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.glassStroke,
        circularTrackColor: c.glassStroke,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(color: c.glassStroke),
        ),
        textStyle: text.labelMedium,
      ),
    );
  }
}
