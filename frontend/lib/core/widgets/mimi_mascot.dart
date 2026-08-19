import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Mimi's expressive states. Each maps to a distinct hand-vector drawing —
/// see [MimiPainter].
enum MimiState {
  /// Default resting pose.
  idle,

  /// Shown next to an active streak.
  streakProud,

  /// Shown on a session/lesson completion, a milestone, a strong score.
  celebrating,

  /// Shown after a missed answer — never scolding, always warm.
  encouraging,
}

/// Mimi the toucan — the app's mascot.
///
/// Deliberately not a fox or an owl (the two most over-used mascot species):
/// a toucan gives the character a distinctive silhouette (the oversized
/// beak) that reads instantly even at small sizes, and a natural home for
/// the marigold accent colour.
///
/// Drawn as a flat, thick-outlined "sticker" via [CustomPainter] rather than
/// as a raster asset, so she stays crisp at any size and costs nothing to
/// ship. The public API (`MimiMascot(state: ...)`) is intentionally the only
/// surface other widgets touch — a future `.riv` file could replace the
/// painter behind this same widget without any call site changing.
class MimiMascot extends StatelessWidget {
  const MimiMascot({super.key, this.state = MimiState.idle, this.size = 96});

  final MimiState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: MimiPainter(state)),
    );

    // A soft bounce/scale on state change rather than a snap cut. Keyed on
    // state so flutter_animate replays the entrance whenever it changes.
    var animated = child
        .animate(key: ValueKey(state))
        .scaleXY(
          begin: 0.82,
          end: 1.0,
          duration: 420.ms,
          curve: Curves.elasticOut,
        );

    if (state == MimiState.celebrating) {
      animated = animated.then(delay: 80.ms).moveY(
            begin: 0,
            end: -10,
            duration: 260.ms,
            curve: Curves.easeOutCubic,
          ).then().moveY(
            begin: -10,
            end: 0,
            duration: 260.ms,
            curve: Curves.bounceOut,
          );
    }

    return animated;
  }
}

/// Vector-drawn toucan matching the mockup's proportions: an ellipse body
/// ~60% width, a circular head ~40% width overlapping it, a beak on the
/// right, a small eye, and thin curved leg/wing strokes. Flat fills, no
/// gradients — a thick (~3px-equivalent) outline throughout.
class MimiPainter extends CustomPainter {
  const MimiPainter(this.state);

  final MimiState state;

  static const _bodyGreen = Color(0xFF1C3A12);
  static const _bellyGreen = Color(0xFF2E5A1E);
  static const _beakMarigold = Color(0xFFF2A63D);
  static const _beakTip = Color(0xFF241F16);
  static const _eyeCream = Color(0xFFFBF3E3);
  static const _blush = Color(0xFFE85D3F);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _beakTip;

    final center = Offset(w * 0.46, h * 0.6);

    // --- Legs (drawn first, so the body overlaps their tops) ---
    final legPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round
      ..color = _beakTip;
    canvas.drawLine(
      Offset(w * 0.38, h * 0.86),
      Offset(w * 0.34, h * 0.97),
      legPaint,
    );
    canvas.drawLine(
      Offset(w * 0.52, h * 0.86),
      Offset(w * 0.56, h * 0.97),
      legPaint,
    );

    // --- Body: ellipse, ~60% width ---
    final bodyRect = Rect.fromCenter(
      center: center,
      width: w * 0.62,
      height: h * 0.58,
    );
    final tilt = switch (state) {
      MimiState.streakProud => -0.06,
      MimiState.celebrating => -0.10,
      MimiState.encouraging => 0.05,
      MimiState.idle => 0.0,
    };

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tilt);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawOval(bodyRect, Paint()..color = _bodyGreen);
    // Belly wash — a flat lighter shape, not a gradient.
    final bellyRect = Rect.fromCenter(
      center: center + Offset(0, h * 0.05),
      width: w * 0.34,
      height: h * 0.34,
    );
    canvas.drawOval(bellyRect, Paint()..color = _bellyGreen);
    canvas.drawOval(bodyRect, outline);

    // Wing stroke — a single curved line, sticker-style.
    final wingPath = Path()
      ..moveTo(w * 0.30, h * 0.5)
      ..quadraticBezierTo(w * 0.22, h * 0.62, w * 0.30, h * 0.78);
    canvas.drawPath(
      wingPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round
        ..color = _beakTip.withValues(alpha: 0.7),
    );
    canvas.restore();

    // --- Head: circle, ~40% width, overlapping the body's top ---
    final headCenter = Offset(w * 0.42, h * 0.36);
    final headRadius = w * 0.22;
    canvas.drawCircle(headCenter, headRadius, Paint()..color = _bodyGreen);
    canvas.drawCircle(headCenter, headRadius, outline);

    // Blush — celebration/streak only, flat colour circle.
    if (state == MimiState.streakProud || state == MimiState.celebrating) {
      canvas.drawCircle(
        headCenter + Offset(-headRadius * 0.35, headRadius * 0.35),
        headRadius * 0.16,
        Paint()..color = _blush.withValues(alpha: 0.55),
      );
    }

    // --- Beak: quadrilateral on the right of the head ---
    final beakBase = headCenter + Offset(headRadius * 0.75, -headRadius * 0.1);
    final beakDroop = switch (state) {
      MimiState.encouraging => headRadius * 0.25,
      _ => 0.0,
    };
    final beakTip = Offset(
      w * 0.92,
      headCenter.dy + headRadius * 0.05 + beakDroop,
    );
    final beakPath = Path()
      ..moveTo(beakBase.dx, beakBase.dy - headRadius * 0.32)
      ..lineTo(beakTip.dx, beakTip.dy - headRadius * 0.1)
      ..lineTo(beakTip.dx, beakTip.dy + headRadius * 0.14)
      ..lineTo(beakBase.dx, beakBase.dy + headRadius * 0.34)
      ..close();
    canvas.drawPath(beakPath, Paint()..color = _beakMarigold);
    canvas.drawPath(beakPath, outline);
    // Beak ridge line.
    canvas.drawLine(
      Offset(beakBase.dx + headRadius * 0.1, beakBase.dy),
      Offset(beakTip.dx - headRadius * 0.05, beakTip.dy + headRadius * 0.02),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.018
        ..color = _beakTip.withValues(alpha: 0.35),
    );

    // --- Eye ---
    final eyeCenter = headCenter + Offset(headRadius * 0.05, -headRadius * 0.12);
    final eyeSquint = state == MimiState.celebrating;
    if (eyeSquint) {
      final squintPath = Path()
        ..moveTo(eyeCenter.dx - headRadius * 0.16, eyeCenter.dy)
        ..quadraticBezierTo(
          eyeCenter.dx,
          eyeCenter.dy - headRadius * 0.2,
          eyeCenter.dx + headRadius * 0.16,
          eyeCenter.dy,
        );
      canvas.drawPath(
        squintPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.03
          ..strokeCap = StrokeCap.round
          ..color = _beakTip,
      );
    } else {
      canvas.drawCircle(eyeCenter, headRadius * 0.2, Paint()..color = _beakTip);
      canvas.drawCircle(
        eyeCenter + Offset(-headRadius * 0.06, -headRadius * 0.06),
        headRadius * 0.07,
        Paint()..color = _eyeCream,
      );
    }

    // --- Brow, to carry the encouraging / proud expressions ---
    if (state == MimiState.encouraging) {
      final browPath = Path()
        ..moveTo(eyeCenter.dx - headRadius * 0.22, eyeCenter.dy - headRadius * 0.3)
        ..lineTo(eyeCenter.dx + headRadius * 0.05, eyeCenter.dy - headRadius * 0.38);
      canvas.drawPath(
        browPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.022
          ..strokeCap = StrokeCap.round
          ..color = _beakTip.withValues(alpha: 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MimiPainter oldDelegate) =>
      oldDelegate.state != state;
}
