import 'package:flutter/material.dart';

/// Draws a tone as its pitch contour.
///
/// A learner who has never heard Mandarin cannot tell ā, á, ǎ and à apart
/// from the diacritic alone — the mark means nothing until the pitch shape
/// does. Drawing the contour makes the four tones visually distinct at a
/// glance, and gives the neutral tone a shape of its own instead of leaving
/// it as "the one with no mark".
class ToneContourPainter extends CustomPainter {
  const ToneContourPainter({required this.tone, required this.color});

  /// 1-4, or 0 for the neutral tone.
  final int tone;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final path = Path();

    switch (tone) {
      case 1:
        path
          ..moveTo(0, h * 0.15)
          ..lineTo(w, h * 0.15);
      case 2:
        path
          ..moveTo(0, h * 0.8)
          ..lineTo(w, h * 0.1);
      case 3:
        path
          ..moveTo(0, h * 0.35)
          ..quadraticBezierTo(w * 0.5, h * 1.1, w, h * 0.2);
      case 4:
        path
          ..moveTo(0, h * 0.1)
          ..lineTo(w, h * 0.9);
      default:
        // Neutral: a short mark at mid height, with no direction.
        canvas.drawCircle(
          Offset(w / 2, h / 2),
          2.6,
          Paint()..color = color,
        );
        return;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ToneContourPainter oldDelegate) =>
      oldDelegate.tone != tone || oldDelegate.color != color;
}

/// A tone contour at a fixed small size, for inline use next to text.
class ToneContour extends StatelessWidget {
  const ToneContour({
    super.key,
    required this.tone,
    required this.color,
    this.width = 32,
    this.height = 18,
  });

  final int tone;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: ToneContourPainter(tone: tone, color: color),
      ),
    );
  }
}
