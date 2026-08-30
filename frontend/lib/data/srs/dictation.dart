import 'dart:math' as math;

import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/srs/memory_forecast.dart';
import 'package:learning_app/data/srs/scheduler.dart';

/// Material selection for the dictation drill.
///
/// Dictation trains listening-to-orthography mapping: hear the sentence, type
/// what was heard, nothing on screen to read first. That only works on
/// material the learner has actually met before — dictating a sentence never
/// seen is a guessing game, not a listening exercise — so selection borrows
/// the scheduler's own memory estimate rather than picking blindly from the
/// course. Unlike the fluency sprint, the bar is deliberately lower than
/// "essentially certain": dictation is itself a review, and struggling to
/// catch a half-remembered sentence by ear is exactly where the exercise
/// earns its keep.
class DictationPool {
  const DictationPool(this.scheduler);

  final Scheduler scheduler;

  /// A card must be recalled at least this reliably to be dictated. Below
  /// this the learner has nothing to retrieve yet, and typing becomes a
  /// spelling guess rather than a listening test.
  static const double minRetention = 0.5;

  /// Cards worth dictating, shuffled so the order cannot be memorised.
  List<CardItem> select(
    List<CardItem> cards,
    Map<String, MemoryState> states,
    DateTime now, {
    int limit = 10,
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

  /// Below this, a round would be over almost as soon as it started.
  static const int minimumPool = 5;

  bool isReady(
    List<CardItem> cards,
    Map<String, MemoryState> states,
    DateTime now,
  ) =>
      select(cards, states, now, limit: minimumPool).length >= minimumPool;
}

/// Outcome of one dictated sentence, used to render feedback without
/// re-deriving it from the raw similarity score at every call site.
enum DictationVerdict {
  /// Matches after normalisation — accents, case and punctuation ignored,
  /// exactly like every other typed answer in the app.
  correct,

  /// Close enough that the mishearing was minor — a wrong accent, a missed
  /// double letter — worth telling apart from a genuine miss.
  close,

  /// Different enough that the sentence was not really caught.
  miss,
}

DictationVerdict gradeDictation(double similarity) {
  if (similarity >= 1) return DictationVerdict.correct;
  if (similarity >= 0.8) return DictationVerdict.close;
  return DictationVerdict.miss;
}
