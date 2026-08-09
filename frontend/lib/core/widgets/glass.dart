import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// Frosted surface used for every card in the app.
///
/// In dark mode it is a genuine backdrop blur over the aurora; in light mode
/// the fill is near-opaque so text keeps its 4.5:1 contrast rather than
/// fighting the background — the two themes are tuned separately on purpose.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(LL.s20),
    this.radius = LL.rLg,
    this.blur = 24,
    this.borderColor,
    this.gradient,
    this.glow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final Color? borderColor;

  /// Optional accent wash layered on top of the frost.
  final Gradient? gradient;

  /// Colour of the soft outer glow. Null means no glow.
  final Color? glow;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final border = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: border,
        boxShadow: [
          if (glow != null)
            BoxShadow(
              color: glow!.withValues(alpha: c.isDark ? 0.28 : 0.20),
              blurRadius: 36,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: c.isDark ? 0.34 : 0.07),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: border,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.glassFill,
              gradient: gradient,
              borderRadius: border,
              border: Border.all(color: borderColor ?? c.glassStroke, width: 1),
            ),
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
