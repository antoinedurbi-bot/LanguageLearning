import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// The names available in `assets/illustrations/`.
///
/// Kept as an enum rather than raw strings so a typo fails at compile time
/// instead of showing a blank box in production. See CREDITS.md in that
/// directory for the license (OpenMoji, CC BY-SA 4.0).
enum Illust {
  owl,
  book,
  openBook,
  speech,
  fire,
  trophy,
  medal,
  party,
  confetti,
  rocket,
  sparkles,
  moon,
  sun,
  magnifier,
  target,
  check,
  hourglass,
  brain,
  world,
  key;

  String get _file => switch (this) {
        Illust.owl => 'owl',
        Illust.book => 'book',
        Illust.openBook => 'open_book',
        Illust.speech => 'speech',
        Illust.fire => 'fire',
        Illust.trophy => 'trophy',
        Illust.medal => 'medal',
        Illust.party => 'party',
        Illust.confetti => 'confetti',
        Illust.rocket => 'rocket',
        Illust.sparkles => 'sparkles',
        Illust.moon => 'moon',
        Illust.sun => 'sun',
        Illust.magnifier => 'magnifier',
        Illust.target => 'target',
        Illust.check => 'check',
        Illust.hourglass => 'hourglass',
        Illust.brain => 'brain',
        Illust.world => 'world',
        Illust.key => 'key',
      };

  String get asset => 'assets/illustrations/$_file.svg';
}

/// One full-colour OpenMoji illustration, on an optional soft gradient halo.
///
/// The source art is already colourful and finished — it is not tinted, only
/// staged. The halo is what ties it to the app's own palette: a plain SVG
/// dropped on a screen reads as a sticker, but the same art sitting inside a
/// glowing gradient disc reads as part of the design system.
class Illustration extends StatelessWidget {
  const Illustration(
    this.illust, {
    super.key,
    this.size = 96,
    this.haloColors,
    this.haloOpacity = 0.22,
  });

  final Illust illust;
  final double size;

  /// Gradient for the halo behind the art. Null draws no halo — used when the
  /// illustration already sits inside a coloured surface.
  final List<Color>? haloColors;
  final double haloOpacity;

  @override
  Widget build(BuildContext context) {
    final svg = SvgPicture.asset(
      illust.asset,
      width: size * 0.62,
      height: size * 0.62,
      semanticsLabel: illust.name,
    );

    final colors = haloColors;
    if (colors == null) return svg;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors.first.withValues(alpha: haloOpacity),
            colors.last.withValues(alpha: haloOpacity * 0.4),
            Colors.transparent,
          ],
        ),
      ),
      child: svg,
    );
  }
}

/// The owl on a gentle up-and-down float, used wherever the app needs a
/// recurring "presence" rather than a static icon — the closest thing this
/// app has to a mascot.
class FloatingOwl extends StatefulWidget {
  const FloatingOwl({super.key, this.size = 96, this.haloColors});

  final double size;
  final List<Color>? haloColors;

  @override
  State<FloatingOwl> createState() => _FloatingOwlState();
}

class _FloatingOwlState extends State<FloatingOwl>
    with SingleTickerProviderStateMixin {
  // Created eagerly in initState rather than via a lazy `late final`
  // initializer: a lazy initializer that has never been read by build() would
  // otherwise run for the first time inside dispose() when a widget is torn
  // down before ever being laid out (e.g. an off-screen list item), which
  // tries to look up an ancestor on an already-deactivated element.
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    // Started post-frame, and only when motion is not reduced: starting a
    // repeating animation unconditionally here would run forever even for
    // users who asked for reduced motion, and would hang any test driven by
    // pumpAndSettle, which waits for animations to finish.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || context.reduceMotion) return;
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return Illustration(Illust.owl,
          size: widget.size, haloColors: widget.haloColors);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(offset: Offset(0, -6 * t), child: child);
      },
      child: Illustration(Illust.owl,
          size: widget.size, haloColors: widget.haloColors),
    );
  }
}
