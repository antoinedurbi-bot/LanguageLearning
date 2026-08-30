import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// A screen backdrop — the Mimi identity's flat cream/warm-dark ground.
///
/// Historically this painted a slow-drifting, heavily blurred "aurora" field
/// (three glowing orbiting blobs plus a film-grain overlay) left over from
/// the previous dark-glassmorphism system. The Mimi identity reads as flat,
/// sticker-like colour-blocking rather than glow, so this now paints the
/// plain themed background — with an optional thin flat colour band at the
/// top when [colors] is given, standing in for the old per-language tint
/// without any blur. The `AuroraBackground` name and API (`colors`,
/// `intensity`) are kept so every screen already built on it keeps
/// compiling unchanged.
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({
    super.key,
    required this.child,
    this.colors,
    this.intensity = 1.0,
  });

  final Widget child;

  /// When given, tints a flat band at the top of the screen with the first
  /// colour — a quiet nod to the language's accent rather than a glow.
  final List<Color>? colors;

  /// 0 removes the tint band entirely; 1 is the default strength.
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final tint = colors?.first;

    return DecoratedBox(
      decoration: BoxDecoration(color: c.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (tint != null && intensity > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 220,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: (c.isDark ? 0.16 : 0.10) * intensity),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
