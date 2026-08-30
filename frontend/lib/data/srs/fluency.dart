import 'dart:math' as math;

import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/srs/memory_forecast.dart';
import 'package:learning_app/data/srs/scheduler.dart';

/// Material selection for fluency work.
///
/// Fluency development is the strand where nothing new is learned. Its whole
/// point is getting faster with language already known — Nation's condition is
/// that the material be *easy*, so that the only thing under pressure is
/// retrieval speed. That makes the selection rule the opposite of the
/// scheduler's: take what is best remembered, not what is closest to being
/// forgotten.
class FluencyPool {
  const FluencyPool(this.scheduler);

  final Scheduler scheduler;

  /// A card must be recalled at least this reliably to be worth sprinting on.
  static const double minRetention = 0.8;

  /// Cards the learner knows well enough to be pushed for speed.
  ///
  /// Returns them shuffled, strongest-first order being pointless here: the
  /// drill is about volume, and a predictable order lets the learner memorise
  /// the sequence instead of the language.
  List<CardItem> select(
    List<CardItem> cards,
    Map<String, MemoryState> states,
    DateTime now, {
    int limit = 40,
    int? seed,
  }) {
    final forecast = MemoryForecast(scheduler);
    final eligible = <CardItem>[];

    for (final card in cards) {
      final state = states[card.id];
      if (state == null || state.stability <= 0) continue;
      if (forecast.retentionAt(state, now, 0) < minRetention) continue;
      eligible.add(card);
    }

    eligible.shuffle(math.Random(seed));
    return eligible.take(limit).toList();
  }

  /// Whether there is enough known material for the drill to mean anything.
  ///
  /// Below this, a sprint would just be a slow reading test, and the score
  /// would say nothing about fluency.
  static const int minimumPool = 8;

  bool isReady(
    List<CardItem> cards,
    Map<String, MemoryState> states,
    DateTime now,
  ) =>
      select(cards, states, now, limit: minimumPool).length >= minimumPool;
}
