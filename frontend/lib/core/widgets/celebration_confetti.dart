import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// Wraps [child] with a confetti burst that can be triggered on demand for
/// meaningful moments — a streak milestone, a strong session score.
///
/// The burst uses the four Mimi accent colours. Kept as a thin wrapper
/// around the `confetti` package (rather than a hand-rolled particle system)
/// so a screen only needs to hold a [CelebrationConfettiController] and call
/// [CelebrationConfettiController.burst] wherever the "did they just do
/// something worth celebrating" check already lives.
class CelebrationConfetti extends StatefulWidget {
  const CelebrationConfetti({
    super.key,
    required this.controller,
    required this.child,
  });

  final CelebrationConfettiController controller;
  final Widget child;

  @override
  State<CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<CelebrationConfetti> {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    widget.controller._attach(_confetti);
  }

  @override
  void dispose() {
    widget.controller._detach();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        widget.child,
        IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 24,
              maxBlastForce: 18,
              minBlastForce: 8,
              emissionFrequency: 0.0,
              gravity: 0.3,
              shouldLoop: false,
              colors: LL.confettiColors,
            ),
          ),
        ),
      ],
    );
  }
}

/// Trigger for a [CelebrationConfetti] burst, held by the screen that owns
/// the "worth celebrating" moment (e.g. session-complete with a high score,
/// a streak milestone). Call [burst] any time after the widget attaches;
/// calls before attachment are silently dropped — a celebration animation
/// arriving one frame late isn't worth the plumbing to guarantee otherwise.
class CelebrationConfettiController {
  ConfettiController? _confetti;

  void _attach(ConfettiController confetti) => _confetti = confetti;
  void _detach() => _confetti = null;

  void burst() => _confetti?.play();
}
