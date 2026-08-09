import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// Animated circular progress with a sweep-gradient stroke and a glowing head.
///
/// Used for the daily goal on Home. The value animates implicitly, so pushing
/// a new progress number after a review produces a smooth fill without the
/// caller managing a controller.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 168,
    this.stroke = 14,
    this.colors,
    this.center,
  });

  /// 0..1, clamped.
  final double value;
  final double size;
  final double stroke;
  final List<Color>? colors;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = colors ?? [c.accent, c.accentAlt, c.accent];
    final target = value.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: target),
        duration: context.reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => CustomPaint(
          painter: _RingPainter(
            value: v,
            stroke: stroke,
            colors: ramp,
            track: c.glassStroke,
          ),
          child: Center(child: center),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.stroke,
    required this.colors,
    required this.track,
  });

  final double value;
  final double stroke;
  final List<Color> colors;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -math.pi / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );

    if (value <= 0) return;

    // A sweep needs at least two stops; a single-colour ramp is doubled.
    final ramp = colors.length >= 2 ? colors : [colors.first, colors.first];

    final sweep = 2 * math.pi * value;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      // Stops must be supplied explicitly: Gradient.sweep only accepts a null
      // stops list when there are exactly two colours, and the ramps used here
      // are three-stop so the arc closes on the colour it started from.
      ..shader = ui.Gradient.sweep(
        center,
        ramp,
        [
          for (var i = 0; i < ramp.length; i++) i / (ramp.length - 1),
        ],
        TileMode.clamp,
        start,
        start + 2 * math.pi,
      );

    // Bloom pass first, crisp stroke on top: reads as light rather than a
    // drop shadow.
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = ramp.first.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawArc(rect, start, sweep, false, arc);

    // Head dot.
    final headAngle = start + sweep;
    final head = center + Offset(math.cos(headAngle), math.sin(headAngle)) * radius;
    canvas.drawCircle(head, stroke * 0.34, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.stroke != stroke || old.track != track;
}

/// Thin gradient progress bar used at the top of a review session.
class LinearProgress extends StatelessWidget {
  const LinearProgress({
    super.key,
    required this.value,
    this.colors,
    this.height = 8,
  });

  final double value;
  final List<Color>? colors;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = colors ?? [c.accent, c.accentAlt];

    return Semantics(
      value: '${(value.clamp(0.0, 1.0) * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(LL.rPill),
        child: Container(
          height: height,
          color: c.glassStroke,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
              duration: context.reduceMotion ? Duration.zero : LL.slow,
              curve: LL.enter,
              builder: (context, v, _) => FractionallySizedBox(
                widthFactor: v == 0 ? 0.0001 : v,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: ramp),
                    borderRadius: BorderRadius.circular(LL.rPill),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
