import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/srs/memory_forecast.dart';
import 'package:learning_app/data/srs/scheduler.dart';

MemoryState _state({
  required double stability,
  required DateTime lastReview,
  required DateTime due,
  double difficulty = 5,
}) =>
    MemoryState(
      stability: stability,
      difficulty: difficulty,
      due: due,
      lastReview: lastReview,
      reps: 3,
      lapses: 0,
    );

void main() {
  const forecast = MemoryForecast(Scheduler());
  final now = DateTime.utc(2026, 6, 1, 12);

  group('projection', () {
    test('retention only ever falls when nothing is reviewed', () {
      final states = {
        'a': _state(
            stability: 10,
            lastReview: now.subtract(const Duration(days: 2)),
            due: now.add(const Duration(days: 5))),
        'b': _state(
            stability: 3,
            lastReview: now.subtract(const Duration(days: 1)),
            due: now),
      };

      final days = forecast.project(states, now, days: 30);
      expect(days.length, 31);
      for (var i = 1; i < days.length; i++) {
        expect(days[i].averageRetention,
            lessThanOrEqualTo(days[i - 1].averageRetention + 1e-9),
            reason: 'memory cannot improve on its own at day ${days[i].dayOffset}');
      }
    });

    test('a card reviewed just now sits near full retention', () {
      final states = {
        'a': _state(
            stability: 10, lastReview: now, due: now.add(const Duration(days: 9)))
      };
      expect(forecast.currentRetention(states, now), closeTo(1.0, 0.01));
    });

    test('cards never reviewed are excluded rather than counted as zero', () {
      final states = {
        'fresh': MemoryState.fresh(now),
        'known': _state(
            stability: 20, lastReview: now, due: now.add(const Duration(days: 18))),
      };
      // If the fresh card counted, the average would be about 0.5.
      expect(forecast.currentRetention(states, now), greaterThan(0.9));
    });

    test('an empty collection projects zero without throwing', () {
      final days = forecast.project(const {}, now, days: 5);
      expect(days.length, 6);
      expect(days.first.averageRetention, 0);
      expect(days.first.dueCount, 0);
    });

    test('due counts accumulate as the horizon moves out', () {
      final states = {
        'today': _state(stability: 5, lastReview: now, due: now),
        'later': _state(
            stability: 5,
            lastReview: now,
            due: now.add(const Duration(days: 10))),
      };
      final days = forecast.project(states, now, days: 20);
      expect(days[0].dueCount, 1);
      expect(days[10].dueCount, 2);
      expect(days[20].dueCount, 2);
    });
  });

  group('fading list', () {
    test('is ordered weakest first and skips unseen cards', () {
      final states = {
        'strong': _state(
            stability: 60,
            lastReview: now.subtract(const Duration(days: 1)),
            due: now.add(const Duration(days: 50))),
        'weak': _state(
            stability: 2,
            lastReview: now.subtract(const Duration(days: 6)),
            due: now.subtract(const Duration(days: 3))),
        'unseen': MemoryState.fresh(now),
      };

      final fading = forecast.fading(states, now);
      expect(fading.map((c) => c.cardId), ['weak', 'strong']);
      expect(fading.first.retention, lessThan(fading.last.retention));
    });

    test('honours the limit', () {
      final states = {
        for (var i = 0; i < 20; i++)
          '$i': _state(
              stability: 5 + i.toDouble(),
              lastReview: now.subtract(const Duration(days: 3)),
              due: now),
      };
      expect(forecast.fading(states, now, limit: 5).length, 5);
    });
  });

  group('days until risk', () {
    test('matches the day the projection actually crosses the threshold', () {
      final state = _state(stability: 12, lastReview: now, due: now);
      final predicted = forecast.daysUntilRisk(state, now);

      expect(forecast.retentionAt(state, now, predicted),
          greaterThanOrEqualTo(MemoryForecast.riskThreshold));
      expect(forecast.retentionAt(state, now, predicted + 1),
          lessThan(MemoryForecast.riskThreshold));
    });

    test('goes negative for a card already lost', () {
      final state = _state(
          stability: 1,
          lastReview: now.subtract(const Duration(days: 90)),
          due: now.subtract(const Duration(days: 89)));
      expect(forecast.daysUntilRisk(state, now), lessThan(0));
    });
  });

  group('what a review buys', () {
    test('reviewing due cards pushes the drop-off further out', () {
      final states = {
        for (var i = 0; i < 6; i++)
          '$i': _state(
              stability: 4,
              lastReview: now.subtract(const Duration(days: 8)),
              due: now.subtract(const Duration(days: 4))),
      };
      expect(forecast.daysBoughtByReviewing(states, now), greaterThan(0));
    });

    test('is zero when nothing is due', () {
      final states = {
        'a': _state(
            stability: 30,
            lastReview: now,
            due: now.add(const Duration(days: 27))),
      };
      expect(forecast.daysBoughtByReviewing(states, now), 0);
    });

    test('never returns a negative number', () {
      final states = {
        'a': _state(stability: 0.4, lastReview: now, due: now),
      };
      expect(forecast.daysBoughtByReviewing(states, now),
          greaterThanOrEqualTo(0));
    });
  });
}
