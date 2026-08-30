import 'dart:math' as math;

import 'package:learning_app/data/srs/scheduler.dart';

/// One day of the projection.
class ForecastDay {
  const ForecastDay({
    required this.dayOffset,
    required this.averageRetention,
    required this.dueCount,
    required this.atRiskCount,
  });

  /// 0 = today.
  final int dayOffset;

  /// Mean probability of recall across every card, if nothing is reviewed.
  final double averageRetention;

  /// Cards whose scheduled review date has arrived by this day.
  final int dueCount;

  /// Cards that have fallen under 50% recall — the ones actually being lost.
  final int atRiskCount;
}

/// A single card's standing right now, for the "what is fading" list.
class FadingCard {
  const FadingCard({
    required this.cardId,
    required this.retention,
    required this.stability,
    required this.daysUntilRisk,
  });

  final String cardId;

  /// Probability of recall today, 0..1.
  final double retention;

  /// Days for recall to fall from 100% to 90%.
  final double stability;

  /// Days until recall drops below 50%. Negative when already past it.
  final int daysUntilRisk;
}

/// Turns the scheduler's memory model into something a learner can look at.
///
/// The app has been computing retrievability all along and showing none of it.
/// A learner who can see which words are slipping, and what a review actually
/// buys, is being told the truth about their own memory instead of a streak
/// counter — and that turns out to be far more motivating.
class MemoryForecast {
  const MemoryForecast(this.scheduler);

  final Scheduler scheduler;

  /// Recall probability is judged lost below this line.
  static const double riskThreshold = 0.5;

  double _elapsedDays(MemoryState state, DateTime now) {
    final last = state.lastReview;
    if (last == null) return 0;
    return math.max(now.difference(last).inMinutes / (60 * 24), 0);
  }

  /// Retention of one card [dayOffset] days from [now], assuming no review.
  double retentionAt(MemoryState state, DateTime now, int dayOffset) {
    if (state.stability <= 0) return 0;
    return scheduler.retrievability(
      state.stability,
      _elapsedDays(state, now) + dayOffset,
    );
  }

  /// Day-by-day projection over [days] days, assuming the learner stops now.
  ///
  /// Cards never reviewed are excluded: they have no memory state to decay,
  /// and counting them as 0% would make the curve say something false.
  List<ForecastDay> project(
    Map<String, MemoryState> states,
    DateTime now, {
    int days = 30,
  }) {
    final tracked = [
      for (final state in states.values)
        if (state.stability > 0) state,
    ];

    return [
      for (var d = 0; d <= days; d++)
        () {
          if (tracked.isEmpty) {
            return ForecastDay(
              dayOffset: d,
              averageRetention: 0,
              dueCount: 0,
              atRiskCount: 0,
            );
          }
          var sum = 0.0;
          var due = 0;
          var atRisk = 0;
          final horizon = now.add(Duration(days: d));
          for (final state in tracked) {
            final r = retentionAt(state, now, d);
            sum += r;
            if (!state.due.isAfter(horizon)) due++;
            if (r < riskThreshold) atRisk++;
          }
          return ForecastDay(
            dayOffset: d,
            averageRetention: sum / tracked.length,
            dueCount: due,
            atRiskCount: atRisk,
          );
        }(),
    ];
  }

  /// The cards closest to being lost, weakest first.
  List<FadingCard> fading(
    Map<String, MemoryState> states,
    DateTime now, {
    int limit = 8,
  }) {
    final cards = <FadingCard>[];
    for (final entry in states.entries) {
      final state = entry.value;
      if (state.stability <= 0) continue;
      cards.add(FadingCard(
        cardId: entry.key,
        retention: retentionAt(state, now, 0),
        stability: state.stability,
        daysUntilRisk: daysUntilRisk(state, now),
      ));
    }
    cards.sort((a, b) => a.retention.compareTo(b.retention));
    return cards.take(limit).toList();
  }

  /// Days until this card's recall falls below [riskThreshold].
  ///
  /// Solved directly from the power-law rather than stepped day by day, so it
  /// stays exact for very stable cards where a loop would be slow.
  int daysUntilRisk(MemoryState state, DateTime now) {
    if (state.stability <= 0) return 0;
    // R = (1 + f*t/S)^decay  →  t = S/f * (R^(1/decay) - 1)
    final factor = math.pow(0.9, 1 / -0.5) - 1;
    final total =
        (state.stability / factor) * (math.pow(riskThreshold, 1 / -0.5) - 1);
    return (total - _elapsedDays(state, now)).floor();
  }

  /// Mean recall probability across tracked cards right now.
  double currentRetention(Map<String, MemoryState> states, DateTime now) {
    final projection = project(states, now, days: 0);
    return projection.first.averageRetention;
  }

  /// How many days of retention a review session buys.
  ///
  /// Compares the day the average falls under the threshold with and without
  /// reviewing everything due today. This is the honest answer to "why should
  /// I bother today", and it is a number, not a guilt trip.
  int daysBoughtByReviewing(
    Map<String, MemoryState> states,
    DateTime now, {
    int horizon = 120,
  }) {
    final without = _daysUntilAverageDrops(states, now, horizon);

    // Reviewing a due card with a "good" grade is the realistic assumption.
    final after = <String, MemoryState>{};
    for (final entry in states.entries) {
      final state = entry.value;
      if (state.stability > 0 && !state.due.isAfter(now)) {
        after[entry.key] = scheduler.review(state, Grade.good, now);
      } else {
        after[entry.key] = state;
      }
    }
    final with_ = _daysUntilAverageDrops(after, now, horizon);
    return math.max(with_ - without, 0);
  }

  int _daysUntilAverageDrops(
    Map<String, MemoryState> states,
    DateTime now,
    int horizon,
  ) {
    final projection = project(states, now, days: horizon);
    for (final day in projection) {
      if (day.averageRetention < riskThreshold) return day.dayOffset;
    }
    return horizon;
  }
}
