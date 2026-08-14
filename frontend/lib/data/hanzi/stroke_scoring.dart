import 'dart:math' as math;
import 'dart:ui' show Offset;

/// Verdict on one attempted stroke.
class StrokeAttempt {
  const StrokeAttempt({
    required this.accepted,
    required this.meanDeviation,
    required this.reversed,
    required this.tooShort,
  });

  final bool accepted;

  /// Average distance between the drawn line and the model stroke, as a
  /// fraction of the writing box. 0 is a perfect trace.
  final double meanDeviation;

  /// The shape matched but was drawn end-to-start. Rejected on purpose:
  /// stroke direction is part of what is being learned, and a character
  /// written with the right shapes in the wrong directions still reads as
  /// wrong to a native eye and breaks handwriting recognition.
  final bool reversed;

  /// The gesture was too small to be a stroke — usually a stray tap.
  final bool tooShort;
}

/// Compares a hand-drawn stroke against the model stroke's median.
///
/// Both lines are resampled to the same number of evenly spaced points and
/// compared pairwise. That makes the score independent of how fast or how
/// jerkily the learner drew, which raw point-by-point comparison is not.
class StrokeScorer {
  const StrokeScorer({
    this.samples = 16,
    this.tolerance = 0.19,
    this.minimumLengthFraction = 0.06,
  });

  /// Points each line is resampled to before comparing.
  final int samples;

  /// Maximum mean deviation, as a fraction of the box, still accepted.
  /// Tuned to accept a wobbly but recognisable trace while rejecting a
  /// stroke drawn in the wrong place or the wrong shape.
  final double tolerance;

  /// Gestures shorter than this fraction of the box are treated as taps.
  final double minimumLengthFraction;

  StrokeAttempt score({
    required List<Offset> drawn,
    required List<Offset> model,
    required double boxSize,
  }) {
    if (drawn.length < 2 || model.length < 2 || boxSize <= 0) {
      return const StrokeAttempt(
        accepted: false,
        meanDeviation: double.infinity,
        reversed: false,
        tooShort: true,
      );
    }

    final drawnLength = _length(drawn);
    final modelLength = _length(model);

    // A dot stroke (丶) is legitimately tiny, so the threshold is relative to
    // the model stroke as well as to the box.
    final minimum = math.min(
      boxSize * minimumLengthFraction,
      modelLength * 0.45,
    );
    if (drawnLength < minimum) {
      return const StrokeAttempt(
        accepted: false,
        meanDeviation: double.infinity,
        reversed: false,
        tooShort: true,
      );
    }

    final a = _resample(drawn, samples);
    final b = _resample(model, samples);

    final forward = _meanDistance(a, b) / boxSize;
    final backward = _meanDistance(a.reversed.toList(), b) / boxSize;

    final reversed = backward < forward && backward <= tolerance;
    final deviation = math.min(forward, backward);

    return StrokeAttempt(
      accepted: forward <= tolerance && !reversed,
      meanDeviation: deviation,
      reversed: reversed,
      tooShort: false,
    );
  }

  double _meanDistance(List<Offset> a, List<Offset> b) {
    var total = 0.0;
    for (var i = 0; i < a.length; i++) {
      total += (a[i] - b[i]).distance;
    }
    return total / a.length;
  }

  static double _length(List<Offset> points) {
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += (points[i] - points[i - 1]).distance;
    }
    return total;
  }

  /// Redistributes [points] into [count] points spaced evenly along the line.
  static List<Offset> _resample(List<Offset> points, int count) {
    final total = _length(points);
    if (total == 0) return List<Offset>.filled(count, points.first);

    final step = total / (count - 1);
    final result = <Offset>[points.first];

    var segment = 1;
    var travelledInSegment = 0.0;

    for (var i = 1; i < count - 1; i++) {
      var remaining = step;
      while (segment < points.length) {
        final from = points[segment - 1];
        final to = points[segment];
        final segmentLength = (to - from).distance;
        final available = segmentLength - travelledInSegment;

        if (available >= remaining) {
          travelledInSegment += remaining;
          final t =
              segmentLength == 0 ? 0.0 : travelledInSegment / segmentLength;
          result.add(Offset.lerp(from, to, t)!);
          break;
        }

        remaining -= available;
        travelledInSegment = 0;
        segment++;
      }
      if (segment >= points.length) result.add(points.last);
    }

    result.add(points.last);
    return result;
  }
}
