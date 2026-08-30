import 'package:flutter/painting.dart';

/// Minimal SVG path parser for the bundled stroke outlines.
///
/// The Make Me a Hanzi glyph data uses only five absolute commands — M, L, Q,
/// C and Z — so a full SVG parser (and the dependency it would bring) is not
/// warranted. Anything outside that set is ignored rather than throwing: a
/// malformed stroke should cost one stroke of ink, not crash the screen the
/// learner is looking at.
///
/// The glyph coordinate space is y-up in a 1024 box with the baseline offset
/// that upstream applies at render time, so every point is mapped through
/// `x' = x`, `y' = 900 - y` and then scaled to the requested size. That
/// transform is part of the data contract and is asserted by the tests.
class HanziPath {
  const HanziPath._();

  /// Side of the upstream coordinate box.
  static const double viewBox = 1024;

  /// Vertical offset applied when flipping the y-up data to y-down.
  static const double yFlipOrigin = 900;

  /// Maps a single glyph-space point into a [size]x[size] canvas.
  static Offset point(double x, double y, double size) {
    final scale = size / viewBox;
    return Offset(x * scale, (yFlipOrigin - y) * scale);
  }

  /// Parses an SVG path string into a [Path] already mapped to [size].
  static Path parse(String d, double size) {
    final path = Path();
    final tokens = _tokenize(d);

    var index = 0;
    double startX = 0, startY = 0;
    double currentX = 0, currentY = 0;

    Offset mapped(double x, double y) => point(x, y, size);

    while (index < tokens.length) {
      final token = tokens[index];
      if (token is! String) {
        // Numbers with no command in front of them are meaningless here.
        index++;
        continue;
      }
      index++;

      switch (token) {
        case 'M':
          if (index + 1 >= tokens.length) break;
          currentX = tokens[index++] as double;
          currentY = tokens[index++] as double;
          startX = currentX;
          startY = currentY;
          final p = mapped(currentX, currentY);
          path.moveTo(p.dx, p.dy);

          // Repeated coordinate pairs after an M are implicit line-tos.
          while (index + 1 < tokens.length && tokens[index] is double) {
            currentX = tokens[index++] as double;
            currentY = tokens[index++] as double;
            final next = mapped(currentX, currentY);
            path.lineTo(next.dx, next.dy);
          }

        case 'L':
          while (index + 1 < tokens.length && tokens[index] is double) {
            currentX = tokens[index++] as double;
            currentY = tokens[index++] as double;
            final p = mapped(currentX, currentY);
            path.lineTo(p.dx, p.dy);
          }

        case 'Q':
          while (index + 3 < tokens.length && tokens[index] is double) {
            final cx = tokens[index++] as double;
            final cy = tokens[index++] as double;
            currentX = tokens[index++] as double;
            currentY = tokens[index++] as double;
            final control = mapped(cx, cy);
            final end = mapped(currentX, currentY);
            path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
          }

        case 'C':
          while (index + 5 < tokens.length && tokens[index] is double) {
            final c1x = tokens[index++] as double;
            final c1y = tokens[index++] as double;
            final c2x = tokens[index++] as double;
            final c2y = tokens[index++] as double;
            currentX = tokens[index++] as double;
            currentY = tokens[index++] as double;
            final c1 = mapped(c1x, c1y);
            final c2 = mapped(c2x, c2y);
            final end = mapped(currentX, currentY);
            path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
          }

        case 'Z':
        case 'z':
          path.close();
          currentX = startX;
          currentY = startY;

        default:
          // Unsupported command: skip its arguments so parsing stays in sync.
          while (index < tokens.length && tokens[index] is double) {
            index++;
          }
      }
    }

    return path;
  }

  /// Builds a polyline [Path] from a median (the spine of a stroke).
  static Path median(List<Offset> points, double size) {
    final path = Path();
    if (points.isEmpty) return path;
    final first = point(points.first.dx, points.first.dy, size);
    path.moveTo(first.dx, first.dy);
    for (final raw in points.skip(1)) {
      final p = point(raw.dx, raw.dy, size);
      path.lineTo(p.dx, p.dy);
    }
    return path;
  }

  /// Splits a path string into command letters and numbers.
  static List<Object> _tokenize(String d) {
    final tokens = <Object>[];
    final buffer = StringBuffer();

    void flush() {
      if (buffer.isEmpty) return;
      final value = double.tryParse(buffer.toString());
      if (value != null) tokens.add(value);
      buffer.clear();
    }

    for (var i = 0; i < d.length; i++) {
      final ch = d[i];
      final code = ch.codeUnitAt(0);
      final isDigit = code >= 0x30 && code <= 0x39;

      if (isDigit || ch == '.') {
        buffer.write(ch);
      } else if (ch == '-') {
        // A minus starts a new number unless it follows an exponent marker.
        final previous = buffer.isEmpty ? '' : buffer.toString();
        if (previous.isNotEmpty &&
            !previous.endsWith('e') &&
            !previous.endsWith('E')) {
          flush();
        }
        buffer.write(ch);
      } else if (ch == ' ' || ch == ',' || ch == '\n' || ch == '\t') {
        flush();
      } else {
        flush();
        tokens.add(ch);
      }
    }
    flush();
    return tokens;
  }
}
