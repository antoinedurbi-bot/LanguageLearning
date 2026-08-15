import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/data/hanzi/stroke_scoring.dart';
import 'package:learning_app/data/hanzi/svg_path.dart';
import 'package:learning_app/features/chinese/widgets/stroke_order.dart';

/// Trace-the-character practice.
///
/// The learner draws one stroke at a time on a 田字格 grid. Each attempt is
/// compared to the model stroke's median: close enough and in the right
/// direction, and it is accepted and redrawn as proper ink; otherwise it is
/// rejected and, after a few misses, the stroke is demonstrated.
///
/// Recall beats recognition here for the same reason it does elsewhere in the
/// app — being able to pick 你 out of four options is a much weaker memory
/// than being able to produce it — and stroke order is not decoration: it
/// determines proportion, and it is what handwriting input methods expect.
class WritingPractice extends StatefulWidget {
  const WritingPractice({
    super.key,
    required this.hanzi,
    this.size = 300,
    this.onCompleted,
  });

  final Hanzi hanzi;
  final double size;

  /// Called once the last stroke is accepted, with the number of misses.
  final void Function(int misses)? onCompleted;

  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  static const _scorer = StrokeScorer();

  /// Misses on the current stroke before the model is demonstrated.
  static const _missesBeforeHint = 2;

  final List<Offset> _current = [];

  int _completed = 0;
  int _missesOnStroke = 0;
  int _totalMisses = 0;
  int _shake = 0;
  bool _showStrokeHint = false;
  String? _message;
  bool _finished = false;

  @override
  void didUpdateWidget(covariant WritingPractice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hanzi.character != widget.hanzi.character) reset();
  }

  void reset() {
    setState(() {
      _current.clear();
      _completed = 0;
      _missesOnStroke = 0;
      _totalMisses = 0;
      _showStrokeHint = false;
      _message = null;
      _finished = false;
    });
  }

  /// Model median for the stroke being attempted, in canvas coordinates.
  List<Offset> get _expectedMedian => [
        for (final p in widget.hanzi.medians[_completed])
          HanziPath.point(p.dx, p.dy, widget.size),
      ];

  void _onPanEnd() {
    if (_finished || _current.length < 2) {
      setState(_current.clear);
      return;
    }

    final attempt = _scorer.score(
      drawn: List.of(_current),
      model: _expectedMedian,
      boxSize: widget.size,
    );

    if (attempt.accepted) {
      HapticFeedback.selectionClick();
      final next = _completed + 1;
      final done = next >= widget.hanzi.strokes.length;
      setState(() {
        _current.clear();
        _completed = next;
        _missesOnStroke = 0;
        _showStrokeHint = false;
        _message = null;
        _finished = done;
      });
      if (done) {
        HapticFeedback.mediumImpact();
        widget.onCompleted?.call(_totalMisses);
      }
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() {
      _current.clear();
      _missesOnStroke++;
      _totalMisses++;
      _shake++;
      _message = attempt.tooShort
          ? 'Trace plus long : suis tout le trait.'
          : attempt.reversed
              ? 'Bon trait, mais a l\'envers : le sens compte.'
              : 'Pas tout à fait : c\'est le trait n° ${_completed + 1}.';
      if (_missesOnStroke >= _missesBeforeHint) _showStrokeHint = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Shake(
          trigger: _shake,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: GestureDetector(
              onPanStart: (details) {
                if (_finished) return;
                setState(() {
                  _current
                    ..clear()
                    ..add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                if (_finished) return;
                setState(() => _current.add(details.localPosition));
              },
              onPanEnd: (_) => _onPanEnd(),
              child: Container(
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(LL.rMd),
                  border: Border.all(color: c.glassStroke),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(LL.rMd),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: HanziGridPainter(
                            line: Colors.transparent,
                            guide: c.divider,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StrokePainter(
                            hanzi: widget.hanzi,
                            completed: _completed,
                            activeProgress: 0,
                            inkColor: c.textPrimary,
                            hintColor: c.glassStroke,
                            // The rest of the character is only revealed once
                            // the learner has already failed it a couple of
                            // times: showing it from the start turns writing
                            // practice back into tracing.
                            showHint: false,
                          ),
                        ),
                      ),
                      if (_showStrokeHint && !_finished)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _StrokeHintPainter(
                              hanzi: widget.hanzi,
                              index: _completed,
                              color: c.accent.withValues(alpha: 0.32),
                            ),
                          ),
                        ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _InkPainter(
                            points: _current,
                            color: c.accent,
                            width: widget.size * 0.055,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s16),
        _StatusBar(
          completed: _completed,
          total: widget.hanzi.strokes.length,
          finished: _finished,
          misses: _totalMisses,
          message: _message,
          onReset: reset,
          onHint: () => setState(() => _showStrokeHint = true),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.completed,
    required this.total,
    required this.finished,
    required this.misses,
    required this.message,
    required this.onReset,
    required this.onHint,
  });

  final int completed;
  final int total;
  final bool finished;
  final int misses;
  final String? message;
  final VoidCallback onReset;
  final VoidCallback onHint;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < total; i++)
              Container(
                width: 18,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: i < completed ? c.success : c.glassStroke,
                  borderRadius: BorderRadius.circular(LL.rPill),
                ),
              ),
          ],
        ),
        const SizedBox(height: LL.s12),
        SizedBox(
          height: 44,
          child: Center(
            child: Text(
              finished
                  ? (misses == 0
                      ? 'Parfait, sans erreur.'
                      : 'Caractère terminé — $misses erreur'
                          '${misses > 1 ? 's' : ''}.')
                  : message ?? 'Trait $completed/$total — trace le suivant.',
              textAlign: TextAlign.center,
              style: context.type.bodyMedium?.copyWith(
                color: finished ? c.success : c.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Recommencer'),
            ),
            if (!finished) ...[
              const SizedBox(width: LL.s8),
              TextButton.icon(
                onPressed: onHint,
                icon: const Icon(Icons.help_outline_rounded, size: 18),
                label: const Text('Indice'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// The learner's in-progress finger trail.
class _InkPainter extends CustomPainter {
  const _InkPainter({
    required this.points,
    required this.color,
    required this.width,
  });

  final List<Offset> points;
  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_InkPainter old) => true;
}

/// Shows the shape of the stroke currently expected, plus an arrow head at
/// its start so the direction is unambiguous.
class _StrokeHintPainter extends CustomPainter {
  const _StrokeHintPainter({
    required this.hanzi,
    required this.index,
    required this.color,
  });

  final Hanzi hanzi;
  final int index;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (index >= hanzi.strokes.length) return;
    final side = size.shortestSide;

    canvas.drawPath(
      HanziPath.parse(hanzi.strokes[index], side),
      Paint()..color = color,
    );

    final median = hanzi.medians[index];
    if (median.isEmpty) return;
    final start = HanziPath.point(median.first.dx, median.first.dy, side);
    canvas.drawCircle(
      start,
      side * 0.035,
      Paint()..color = color.withValues(alpha: 1),
    );
  }

  @override
  bool shouldRepaint(_StrokeHintPainter old) =>
      old.index != index || old.hanzi.character != hanzi.character;
}
