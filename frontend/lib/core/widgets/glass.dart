import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// The card used everywhere in the app.
///
/// Kept the `GlassCard` name for API compatibility with every screen that
/// already builds on it, but the Mimi identity replaced the frosted-blur
/// treatment with a flat, solid surface and a thick 2px border — no
/// translucency, no backdrop blur. Pass [tint] for a saturated color-blocked
/// tile (coral/marigold/sage/teal, as in the stat tiles on Home); leave it
/// null for the plain cream/near-black card most content sits on.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(LL.s20),
    this.radius = LL.rLg,
    this.blur = 24, // retained for API compat; unused in the flat treatment.
    this.borderColor,
    this.gradient,
    this.glow,
    this.tint,
    this.onTint,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final Color? borderColor;

  /// Optional wash painted on the flat fill.
  final Gradient? gradient;

  /// Kept for API compatibility. In the Mimi system a small coloured drop
  /// shadow reads as "physical" rather than a soft glow, so this only tints
  /// the border when set and no explicit [tint] is given.
  final Color? glow;

  /// A saturated color-blocked background (coral/teal/marigold/sage). When
  /// set, text/icon colours default to [onTint] (or white/ink by contrast).
  final Color? tint;

  /// Foreground colour to use on a [tint] fill. Defaults to white, which
  /// reads well on every Mimi accent.
  final Color? onTint;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final border = BorderRadius.circular(radius);
    final fill = tint ?? c.surface;
    final strokeColor = tint != null
        ? Colors.transparent
        : (borderColor ?? glow?.withValues(alpha: 0.5) ?? c.glassStroke);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: border,
        boxShadow: [
          BoxShadow(
            color: c.isDark
                ? Colors.black.withValues(alpha: 0.4)
                : LL.ink.withValues(alpha: 0.08),
            blurRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          gradient: gradient,
          borderRadius: border,
          border: Border.all(color: strokeColor, width: 2),
        ),
        child: DefaultTextStyle.merge(
          style: tint != null ? TextStyle(color: onTint ?? Colors.white) : null,
          child: IconTheme.merge(
            data: IconThemeData(color: tint != null ? (onTint ?? Colors.white) : null),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// Small uppercase chip used for levels, tags and counts.
class LLChip extends StatelessWidget {
  const LLChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.filled = false,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final tint = color ?? c.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: icon == null ? LL.s12 : LL.s8 + 2,
        vertical: LL.s4 + 2,
      ),
      decoration: BoxDecoration(
        color: filled
            ? tint.withValues(alpha: 0.16)
            : c.glassFill.withValues(alpha: c.isDark ? 0.5 : 0.9),
        borderRadius: BorderRadius.circular(LL.rPill),
        border: Border.all(
          color: filled ? tint.withValues(alpha: 0.35) : c.glassStroke,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: tint),
            const SizedBox(width: LL.s4 + 2),
          ],
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: context.type.labelSmall?.copyWith(
                color: tint,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
