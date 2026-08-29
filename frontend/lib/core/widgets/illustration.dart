import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
