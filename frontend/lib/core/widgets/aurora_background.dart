import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// A slow-drifting "aurora" field painted behind every screen.
///
/// Three large, heavily blurred radial blobs orbit on independent ellipses.
/// Because they are drawn with a MaskFilter blur rather than composited image
/// layers, the whole thing is a handful of draw calls and stays well inside
/// the 16ms frame budget.
///
/// The animation is purely atmospheric, so it is disabled entirely when the
/// user requests reduced motion — the blobs then render at their t=0 rest
/// position and the ticker never starts.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    required this.child,
    this.colors,
    this.intensity = 1.0,
  });

  final Widget child;

  /// Overrides the themed aurora hues — used to tint a screen with the
  /// currently selected language's gradient.
  final List<Color>? colors;

  /// 0 keeps the background flat; 1 is the default richness.
  final double intensity;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 32),
  );

  bool _running = false;

  void _syncTicker(bool reduceMotion) {
    if (reduceMotion && _running) {
      _controller.stop();
      _controller.value = 0;
      _running = false;
    } else if (!reduceMotion && !_running) {
      _controller.repeat();
      _running = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker(context.reduceMotion);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final palette = widget.colors ?? [c.auroraA, c.auroraB, c.auroraC];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.backgroundAlt, c.background],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _AuroraPainter(
                  t: _controller.value,
                  colors: palette,
                  intensity: widget.intensity,
                  dark: c.isDark,
                ),
              ),
            ),
          ),
          // A fine grain overlay: it hides the banding that large soft
          // gradients produce on 8-bit displays.
          const RepaintBoundary(child: _GrainOverlay()),
          widget.child,
        ],
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  const _AuroraPainter({
    required this.t,
    required this.colors,
    required this.intensity,
    required this.dark,
  });

  final double t;
  final List<Color> colors;
  final double intensity;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || intensity <= 0) return;

    final shortest = size.shortestSide;
    final blobRadius = shortest * 0.62;
    final blur = shortest * 0.35;

    // Each blob orbits a different centre at a different rate, so the field
    // never visibly loops even though the controller does.
    const orbits = <_Orbit>[
      _Orbit(Offset(0.18, 0.12), 0.26, 0.18, 1.0, 0.0),
      _Orbit(Offset(0.86, 0.30), 0.22, 0.24, -0.7, 0.35),
      _Orbit(Offset(0.45, 0.88), 0.30, 0.16, 0.55, 0.7),
    ];

    for (var i = 0; i < orbits.length; i++) {
      final orbit = orbits[i];
      final angle = (t * orbit.speed + orbit.phase) * 2 * math.pi;
      final center = Offset(
        (orbit.anchor.dx + math.cos(angle) * orbit.rx) * size.width,
        (orbit.anchor.dy + math.sin(angle) * orbit.ry) * size.height,
      );

      final color = colors[i % colors.length];
      final opacity = (dark ? 0.42 : 0.34) * intensity;

      final paint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          blobRadius,
          [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.45),
            color.withValues(alpha: 0),
          ],
          const [0.0, 0.55, 1.0],
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

      canvas.drawCircle(center, blobRadius, paint);
    }

    // Vignette: pulls attention to the centre and keeps text at the screen
    // edges comfortably above contrast minimums.
    final vignette = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height * 0.45),
        size.longestSide * 0.75,
        [
          const Color(0x00000000),
          Color.fromRGBO(0, 0, 0, dark ? 0.45 : 0.06),
        ],
        const [0.55, 1.0],
      );
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.t != t ||
      old.intensity != intensity ||
      old.dark != dark ||
      !listEquals(old.colors, colors);

  static bool listEquals(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _Orbit {
  const _Orbit(this.anchor, this.rx, this.ry, this.speed, this.phase);
  final Offset anchor;
  final double rx;
  final double ry;
  final double speed;
  final double phase;
}

/// Static, deterministic film grain. Painted once per size change.
class _GrainOverlay extends StatelessWidget {
  const _GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GrainPainter(opacity: context.ll.isDark ? 0.035 : 0.02),
        size: Size.infinite,
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  const _GrainPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    // Fixed seed: the grain must not shimmer between frames.
    final random = math.Random(7);
    final paint = Paint()..color = Colors.white.withValues(alpha: opacity);
    final count = (size.width * size.height / 900).clamp(0, 2600).toInt();
    final points = <Offset>[
      for (var i = 0; i < count; i++)
        Offset(random.nextDouble() * size.width, random.nextDouble() * size.height),
    ];
    canvas.drawPoints(ui.PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.opacity != opacity;
}
