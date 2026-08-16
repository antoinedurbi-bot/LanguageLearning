import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/illustration.dart';
import 'package:rive/rive.dart';

/// A fully interactive Rive animation, for the one moment in the app that
/// earns it.
///
/// Everywhere else uses the static OpenMoji SVGs: a real illustration set,
/// but not a full character sheet, and stretching it into fake motion
/// everywhere would look cheaper than standing still. This asset is the
/// rive-flutter package's own bundled example (MIT licensed, see
/// assets/rive/CREDITS.md) — one genuine animated asset used honestly, not a
/// mascot system this app doesn't actually have yet.
class RiveMoment extends StatelessWidget {
  const RiveMoment({
    super.key,
    this.size = 160,
    this.fallback = Illust.rocket,
  });

  final double size;

  /// Shown instead of the animation when Rive fails to load or when the
  /// user asked for reduced motion — never a blank box.
  final Illust fallback;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return Illustration(fallback, size: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: RiveAnimation.asset(
        'assets/rive/rocket.riv',
        fit: BoxFit.contain,
        // RiveAnimation shows `placeHolder` for as long as its artboard is
        // null, which is true both while loading and, silently, forever if
        // loading throws (a corrupt asset, an unsupported format on some
        // platform) — the package has no error callback. Using the static
        // illustration here means a load failure degrades to a still image
        // instead of a permanently blank box.
        placeHolder: Illustration(fallback, size: size),
      ),
    );
  }
}
