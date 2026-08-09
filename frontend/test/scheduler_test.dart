import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/srs/scheduler.dart';

void main() {
  const scheduler = Scheduler();
  final now = DateTime(2026, 1, 1, 9);

  group('first review', () {
    test('a failed new card comes back within the same session', () {
      final state = scheduler.review(MemoryState.fresh(now), Grade.again, now);

      expect(state.reps, 1);
      expect(state.lapses, 1);
      expect(state.due.difference(now).inMinutes, lessThan(60));
    });

    test('grading higher on a new card schedules it further out', () {
      final fresh = MemoryState.fresh(now);
      final hard = scheduler.review(fresh, Grade.hard, now);
      final good = scheduler.review(fresh, Grade.good, now);
      final easy = scheduler.review(fresh, Grade.easy, now);

      expect(hard.stability, lessThan(good.stability));
      expect(good.stability, lessThan(easy.stability));
      expect(hard.due.isBefore(good.due), isTrue);
      expect(good.due.isBefore(easy.due), isTrue);
    });
  });

  group('retrievability', () {
    test('decays from 1 toward 0 as time passes', () {
      expect(scheduler.retrievability(10, 0), closeTo(1.0, 1e-9));

      final afterAWeek = scheduler.retrievability(10, 7);
      final afterAYear = scheduler.retrievability(10, 365);

      expect(afterAWeek, lessThan(1.0));
      expect(afterAYear, lessThan(afterAWeek));
      expect(afterAYear, greaterThan(0));
    });

    test('is ~0.9 after exactly one stability period, by definition', () {
      expect(scheduler.retrievability(30, 30), closeTo(0.9, 0.01));
    });

    test('an unseen card has no retrievability', () {
      expect(scheduler.retrievability(0, 1), 0);
    });
  });

  group('interval', () {
    test('grows with stability', () {
      expect(scheduler.intervalFor(1), lessThan(scheduler.intervalFor(10)));
      expect(scheduler.intervalFor(10), lessThan(scheduler.intervalFor(100)));
    });

    test('targets the requested retention', () {
      // At 90% retention the interval should be close to the stability.
      expect(scheduler.intervalFor(30), closeTo(30, 2));

      // Demanding higher retention must shorten the interval.
      const strict = Scheduler(requestedRetention: 0.97);
      expect(strict.intervalFor(30), lessThan(scheduler.intervalFor(30)));
    });
  });

  group('review of a seen card', () {
    test('recall grows stability, and reviewing later grows it more', () {
      final learned = scheduler.review(MemoryState.fresh(now), Grade.good, now);

      final early = scheduler.review(
        learned,
        Grade.good,
        now.add(const Duration(days: 1)),
      );
      final onTime = scheduler.review(
        learned,
        Grade.good,
        now.add(Duration(days: scheduler.intervalFor(learned.stability))),
      );

      expect(early.stability, greaterThan(learned.stability));
      // The spacing effect: waiting until the card is nearly forgotten buys
      // more stability than an early review.
      expect(onTime.stability, greaterThan(early.stability));
    });

    test('a lapse cuts stability and counts as a lapse', () {
      var state = scheduler.review(MemoryState.fresh(now), Grade.easy, now);
      final before = state.stability;

      state = scheduler.review(
        state,
        Grade.again,
        now.add(const Duration(days: 30)),
      );

      expect(state.stability, lessThan(before));
      expect(state.lapses, 1);
      expect(state.reps, 2);
    });

    test('difficulty reverts toward baseline instead of staying damaged', () {
      // This is the property SM-2 lacks: a few early failures must not
      // condemn a card to permanently short intervals ("ease hell").
      var state = scheduler.review(MemoryState.fresh(now), Grade.again, now);
      var time = now;
      for (var i = 0; i < 3; i++) {
        time = time.add(const Duration(days: 1));
        state = scheduler.review(state, Grade.again, time);
      }
      final damaged = state.difficulty;

      for (var i = 0; i < 8; i++) {
        time = time.add(const Duration(days: 3));
        state = scheduler.review(state, Grade.easy, time);
      }

      expect(state.difficulty, lessThan(damaged));
      expect(state.stability, greaterThan(1));
    });

    test('difficulty always stays inside 1..10', () {
      var state = MemoryState.fresh(now);
      var time = now;
      for (var i = 0; i < 40; i++) {
        time = time.add(const Duration(days: 2));
        state = scheduler.review(state, Grade.again, time);
        expect(state.difficulty, inInclusiveRange(1.0, 10.0));
      }
      for (var i = 0; i < 40; i++) {
        time = time.add(const Duration(days: 2));
        state = scheduler.review(state, Grade.easy, time);
        expect(state.difficulty, inInclusiveRange(1.0, 10.0));
      }
    });
  });

  group('serialisation', () {
    test('survives a round trip', () {
      final state = scheduler.review(MemoryState.fresh(now), Grade.good, now);
      final restored = MemoryState.fromJson(state.toJson(), now);

      expect(restored.stability, closeTo(state.stability, 1e-9));
      expect(restored.difficulty, closeTo(state.difficulty, 1e-9));
      expect(restored.due, state.due);
      expect(restored.lastReview, state.lastReview);
      expect(restored.reps, state.reps);
      expect(restored.lapses, state.lapses);
    });

    test('falls back cleanly on malformed data', () {
      final restored = MemoryState.fromJson(
        {'stability': 'nonsense', 'due': 'not-a-date'},
        now,
      );

      expect(restored.stability, 0);
      expect(restored.due, now);
      expect(restored.isNew, isTrue);
    });
  });

  group('interval preview', () {
    test('reads as minutes for a lapse and days for a success', () {
      final state = MemoryState.fresh(now);

      expect(scheduler.previewInterval(state, Grade.again, now), contains('min'));
      expect(scheduler.previewInterval(state, Grade.easy, now), contains('j'));
    });
  });
}
