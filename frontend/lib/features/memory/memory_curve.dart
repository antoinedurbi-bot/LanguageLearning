import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/data/srs/memory_forecast.dart';

/// The forgetting curve, drawn from the learner's own cards.
///
/// This is the one chart in the app that is not decoration: it is the model
/// the scheduler has been using all along, finally shown to the person it
/// describes. The shape matters — power-law decay is steep then long-tailed,
/// and seeing that is what makes the timing of reviews make sense.
class MemoryCurve extends StatelessWidget {
  const MemoryCurve({
    super.key,
    required this.days,
    required this.progress,
  });

  final List<ForecastDay> days;

  /// Draw-in animation, 0..1. Pass 1 to render the finished curve.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return SizedBox(
      height: 168,
      width: double.infinity,
      child: CustomPaint(
        painter: _CurvePainter(
          days: days,
          progress: progress,
          line: c.accent,
          fillTop: c.accent.withValues(alpha: 0.32),
          fillBottom: c.accent.withValues(alpha: 0.0),
          grid: c.glassStroke,
          danger: c.danger,
          label: c.textTertiary,
          labelStyle: context.type.labelSmall ?? const TextStyle(fontSize: 11),
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  _CurvePainter({
    required this.days,
    required this.progress,
    required this.line,
    required this.fillTop,
    required this.fillBottom,
    required this.grid,
    required this.danger,
    required this.label,
    required this.labelStyle,
  });

  final List<ForecastDay> days;
  final double progress;
  final Color line;
  final Color fillTop;
  final Color fillBottom;
  final Color grid;
  final Color danger;
  final Color label;
  final TextStyle labelStyle;

  static const double _leftPad = 34;
  static const double _bottomPad = 22;
  static const double _topPad = 8;

  @override
  void paint(Canvas canvas, Size size) {
    if (days.length < 2) return;

    final chartWidth = size.width - _leftPad;
    final chartHeight = size.height - _bottomPad - _topPad;
    if (chartWidth <= 0 || chartHeight <= 0) return;

    Offset pointAt(int index) {
      final x = _leftPad + chartWidth * (index / (days.length - 1));
      final y = _topPad +
          chartHeight * (1 - days[index].averageRetention.clamp(0.0, 1.0));
      return Offset(x, y);
    }

    // Horizontal guides at 100 / 50 / 0 %.
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final value in [1.0, MemoryForecast.riskThreshold, 0.0]) {
      final y = _topPad + chartHeight * (1 - value);
      final isThreshold = value == MemoryForecast.riskThreshold;
      if (isThreshold) {
        _dashedLine(
          canvas,
          Offset(_leftPad, y),
          Offset(size.width, y),
          Paint()
            ..color = danger.withValues(alpha: 0.45)
            ..strokeWidth = 1,
        );
      } else {
        canvas.drawLine(Offset(_leftPad, y), Offset(size.width, y), gridPaint);
      }
      _text(canvas, '${(value * 100).round()}%', Offset(0, y - 7),
          isThreshold ? danger.withValues(alpha: 0.8) : label);
    }

    // The visible portion of the curve, for the draw-in animation.
    final shown = (days.length * progress.clamp(0.0, 1.0)).ceil().clamp(2, days.length);

    final path = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
    for (var i = 1; i < shown; i++) {
      // Smooth with a midpoint quadratic: the curve is monotone, so this
      // cannot introduce the overshoot a Catmull-Rom spline would.
      final previous = pointAt(i - 1);
      final current = pointAt(i);
      final mid = Offset(
        (previous.dx + current.dx) / 2,
        (previous.dy + current.dy) / 2,
      );
      path.quadraticBezierTo(previous.dx, previous.dy, mid.dx, mid.dy);
    }
    final lastShown = pointAt(shown - 1);
    path.lineTo(lastShown.dx, lastShown.dy);

    final fill = Path.from(path)
      ..lineTo(lastShown.dx, _topPad + chartHeight)
      ..lineTo(_leftPad, _topPad + chartHeight)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, _topPad),
          Offset(0, _topPad + chartHeight),
          [fillTop, fillBottom],
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Today's dot, the anchor for reading the whole chart.
    final today = pointAt(0);
    canvas.drawCircle(today, 5, Paint()..color = line);
    canvas.drawCircle(
      today,
      5,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    _text(canvas, 'auj.', Offset(_leftPad - 6, size.height - 16), label);
    _text(
      canvas,
      '+${days.last.dayOffset} j',
      Offset(size.width - 30, size.height - 16),
      label,
    );
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dash = 5.0;
    const gap = 4.0;
    var x = from.dx;
    while (x < to.dx) {
      canvas.drawLine(
        Offset(x, from.dy),
        Offset(math.min(x + dash, to.dx), to.dy),
        paint,
      );
      x += dash + gap;
    }
  }

  void _text(Canvas canvas, String value, Offset at, Color color) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: labelStyle.copyWith(color: color)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _CurvePainter old) =>
      old.progress != progress || old.days != days || old.line != line;
}
