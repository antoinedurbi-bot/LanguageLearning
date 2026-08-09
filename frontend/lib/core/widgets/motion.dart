import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// Fade + rise entrance, optionally staggered by list index.
///
/// Motion here signals "this content just arrived"; with reduced motion on,
/// the child is rendered immediately at its final position.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 18,
    this.duration = LL.slow,
  });

  final Widget child;
  final int index;
  final double offset;
  final Duration duration;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (context.reduceMotion) {
      _controller.value = 1;
      return;
    }
    Future<void>.delayed(LL.stagger * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: LL.enter);
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) => Opacity(
        opacity: curved.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * widget.offset),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Gentle continuous float, used on the hero mark during onboarding.
class Floating extends StatefulWidget {
  const Floating({
    super.key,
    required this.child,
    this.amplitude = 6,
    this.period = const Duration(seconds: 5),
  });

  final Widget child;
  final double amplitude;
  final Duration period;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.period);

  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = context.reduceMotion;
    if (reduce && _running) {
      _controller.stop();
      _controller.value = 0;
      _running = false;
    } else if (!reduce && !_running) {
      _controller.repeat(reverse: true);
      _running = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, (curved.value - 0.5) * 2 * widget.amplitude),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Shake used to reject a wrong answer. Short and damped, and always paired
/// with text — never the only signal that something was incorrect.
class Shake extends StatefulWidget {
  const Shake({super.key, required this.child, required this.trigger});

  final Widget child;

  /// Incrementing this value replays the shake.
  final int trigger;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  @override
  void didUpdateWidget(covariant Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger && !context.reduceMotion) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // Damped sine: three swings of decreasing amplitude.
        final dx = (1 - t) * 10 * math.sin(t * 3 * 2 * math.pi);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}

/// One-shot particle burst for session completion.
///
/// Particles are simple physics dots (velocity + gravity + drag) drawn on a
/// single canvas — cheap enough to run alongside the aurora.
class Celebration extends StatefulWidget {
  const Celebration({super.key, required this.play, this.colors});

  final bool play;
  final List<Color>? colors;

  @override
  State<Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<Celebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  final _random = math.Random(11);
  late List<_Particle> _particles = _spawn();

  List<_Particle> _spawn() => List.generate(64, (_) {
        final angle = -math.pi / 2 + (_random.nextDouble() - 0.5) * math.pi * 1.1;
        final speed = 0.55 + _random.nextDouble() * 0.85;
        return _Particle(
          origin: Offset(0.5 + (_random.nextDouble() - 0.5) * 0.35, 0.55),
          velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
          size: 3 + _random.nextDouble() * 5,
          spin: (_random.nextDouble() - 0.5) * 8,
          colorIndex: _random.nextInt(4),
        );
      });

  @override
  void didUpdateWidget(covariant Celebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play && !context.reduceMotion) {
      _particles = _spawn();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final palette =
        widget.colors ?? [c.accent, c.accentAlt, c.success, c.warning];

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(
              t: _controller.value,
              particles: _particles,
              colors: palette,
            ),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.origin,
    required this.velocity,
    required this.size,
    required this.spin,
    required this.colorIndex,
  });

  final Offset origin;
  final Offset velocity;
  final double size;
  final double spin;
  final int colorIndex;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.t,
    required this.particles,
    required this.colors,
  });

  final double t;
  final List<_Particle> particles;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0 || t >= 1 || size.isEmpty) return;

    const gravity = 1.15;
    final fade = t < 0.7 ? 1.0 : 1 - ((t - 0.7) / 0.3);

    for (final p in particles) {
      final drag = 1 - 0.35 * t;
      final dx = p.velocity.dx * t * drag;
      final dy = p.velocity.dy * t + gravity * t * t * 0.5;

      final position = Offset(
        (p.origin.dx + dx) * size.width,
        (p.origin.dy + dy) * size.height,
      );
      if (position.dy > size.height + 20) continue;

      final color = colors[p.colorIndex % colors.length];
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(p.spin * t);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 1.6,
          ),
          const Radius.circular(1.5),
        ),
        Paint()..color = color.withValues(alpha: fade.clamp(0.0, 1.0)),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
