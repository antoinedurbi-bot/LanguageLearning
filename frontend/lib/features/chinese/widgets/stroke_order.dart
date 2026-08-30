import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/data/hanzi/svg_path.dart';

/// The 田字格 practice grid: the frame Chinese children learn to write in.
/// The dashed cross marks the centre lines that a well-proportioned
/// character is balanced around.
class HanziGridPainter extends CustomPainter {
  const HanziGridPainter({required this.line, required this.guide});

  final Color line;
  final Color guide;

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = line;
    canvas.drawRect(Offset.zero & size, border);

    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = guide;

    void dashed(Offset from, Offset to) {
      const dashLength = 7.0;
      const gap = 6.0;
      final total = (to - from).distance;
      final direction = (to - from) / total;
      var travelled = 0.0;
      while (travelled < total) {
        final end = math.min(travelled + dashLength, total);
        canvas.drawLine(
          from + direction * travelled,
          from + direction * end,
          dash,
        );
        travelled = end + gap;
      }
    }

    dashed(Offset(size.width / 2, 0), Offset(size.width / 2, size.height));
    dashed(Offset(0, size.height / 2), Offset(size.width, size.height / 2));
  }

  @override
  bool shouldRepaint(HanziGridPainter oldDelegate) =>
      oldDelegate.line != line || oldDelegate.guide != guide;
}

/// Paints a character's strokes, optionally partially.
///
/// Ink is revealed the way it is actually written: the stroke's outline is
/// used as a clip, and a thick line is drawn along the stroke's median up to
/// the current progress. That produces a brush travelling down the spine of
/// the stroke rather than the whole shape fading in, which is what makes the
/// direction of the stroke legible.
class StrokePainter extends CustomPainter {
  const StrokePainter({
    required this.hanzi,
    required this.completed,
    required this.activeProgress,
    required this.inkColor,
    required this.hintColor,
    this.showHint = true,
    this.activeColor,
  });

  /// Strokes fully drawn.
  final int completed;

  /// 0..1 progress of the stroke at index [completed].
  final double activeProgress;

  final Hanzi hanzi;
  final Color inkColor;

  /// Colour of the not-yet-written strokes shown faintly underneath.
  final Color hintColor;
  final bool showHint;
  final Color? activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (!hanzi.hasStrokeData) return;
    final side = size.shortestSide;

    // Faint outline of everything still to come.
    if (showHint) {
      final hint = Paint()..color = hintColor;
      for (var i = completed; i < hanzi.strokes.length; i++) {
        canvas.drawPath(HanziPath.parse(hanzi.strokes[i], side), hint);
      }
    }

    final ink = Paint()..color = inkColor;
    for (var i = 0; i < completed && i < hanzi.strokes.length; i++) {
      canvas.drawPath(HanziPath.parse(hanzi.strokes[i], side), ink);
    }

    if (completed >= hanzi.strokes.length || activeProgress <= 0) return;

    // Partial stroke: clip to its outline, then sweep along the median.
    final outline = HanziPath.parse(hanzi.strokes[completed], side);
    final median = HanziPath.median(hanzi.medians[completed], side);

    canvas.save();
    canvas.clipPath(outline);
    for (final metric in median.computeMetrics()) {
      final revealed = metric.extractPath(0, metric.length * activeProgress);
      canvas.drawPath(
        revealed,
        Paint()
          ..color = activeColor ?? inkColor
          ..style = PaintingStyle.stroke
          // Wider than any stroke is thick, so the clip alone decides the
          // shape and the sweep only decides how far along it has got.
          ..strokeWidth = side * 0.22
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) =>
      oldDelegate.completed != completed ||
      oldDelegate.activeProgress != activeProgress ||
      oldDelegate.hanzi.character != hanzi.character ||
      oldDelegate.inkColor != inkColor ||
      oldDelegate.showHint != showHint;
}

/// Plays a character's strokes in writing order, on a loop or once.
class StrokeOrderAnimation extends StatefulWidget {
  const StrokeOrderAnimation({
    super.key,
    required this.hanzi,
    this.size = 220,
    this.loop = true,
    this.showGrid = true,
    this.strokeDuration = const Duration(milliseconds: 620),
    this.pauseBetweenStrokes = const Duration(milliseconds: 130),
  });

  final Hanzi hanzi;
  final double size;
  final bool loop;
  final bool showGrid;
  final Duration strokeDuration;
  final Duration pauseBetweenStrokes;

  @override
  State<StrokeOrderAnimation> createState() => StrokeOrderAnimationState();
}

class StrokeOrderAnimationState extends State<StrokeOrderAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.strokeDuration,
  );

  int _completed = 0;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // With reduced motion the character is shown finished rather than drawn:
    // an animation the user asked not to see should not be the only way to
    // learn the content.
    if (context.reduceMotion) {
      _controller.stop();
      setState(() {
        _completed = widget.hanzi.strokes.length;
        _running = false;
      });
    } else if (!_running) {
      restart();
    }
  }

  @override
  void didUpdateWidget(covariant StrokeOrderAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hanzi.character != widget.hanzi.character) {
      if (context.reduceMotion) {
        setState(() => _completed = widget.hanzi.strokes.length);
      } else {
        restart();
      }
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;

    final next = _completed + 1;
    if (next < widget.hanzi.strokes.length) {
      setState(() => _completed = next);
      Future<void>.delayed(widget.pauseBetweenStrokes, () {
        if (mounted && _running) _controller.forward(from: 0);
      });
      return;
    }

    setState(() {
      _completed = next;
      _running = false;
    });
    if (widget.loop) {
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (mounted && widget.loop) restart();
      });
    }
  }

  /// Replays from the first stroke.
  void restart() {
    if (!mounted) return;
    setState(() {
      _completed = 0;
      _running = true;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Semantics(
      label: 'Ordre des traits de ${widget.hanzi.character}, '
          '${widget.hanzi.strokeCount} traits',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            if (widget.showGrid)
              Positioned.fill(
                child: CustomPaint(
                  painter: HanziGridPainter(
                    line: c.glassStroke,
                    guide: c.divider,
                  ),
                ),
              ),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  painter: StrokePainter(
                    hanzi: widget.hanzi,
                    completed: _completed,
                    activeProgress: _running ? _controller.value : 0,
                    inkColor: c.textPrimary,
                    hintColor: c.glassStroke,
                    activeColor: c.accent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
