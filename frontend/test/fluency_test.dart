import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/srs/fluency.dart';
import 'package:learning_app/data/srs/scheduler.dart';

CardItem _card(String id) => CardItem(
      id: id,
      target: 'target $id',
      native: 'natif $id',
      gloss: 'glose',
      tokens: const ['a'],
      distractors: const ['b'],
      focus: 'focus',
    );

MemoryState _state({
  required double stability,
  required DateTime lastReview,
}) =>
    MemoryState(
      stability: stability,
      difficulty: 5,
      due: lastReview.add(Duration(days: stability.round())),
      lastReview: lastReview,
      reps: 3,
      lapses: 0,
    );

void main() {
  const pool = FluencyPool(Scheduler());
  final now = DateTime.utc(2026, 6, 1, 12);

  test('only well-remembered cards make it into the drill', () {
    final cards = [_card('solide'), _card('fragile'), _card('neuf')];
    final states = {
      // Reviewed today with high stability: essentially certain.
      'solide': _state(stability: 30, lastReview: now),
      // Long overdue relative to its stability: barely remembered.
      'fragile': _state(
          stability: 1, lastReview: now.subtract(const Duration(days: 20))),
      // 'neuf' has never been reviewed at all.
    };

    final selected = pool.select(cards, states, now);
    expect(selected.map((c) => c.id), ['solide']);
  });

  test('a card never reviewed is excluded even if it is in the course', () {
    final cards = [_card('a')];
    expect(pool.select(cards, const {}, now), isEmpty);
  });

  test('selection is capped by the limit', () {
    final cards = [for (var i = 0; i < 50; i++) _card('$i')];
    final states = {
      for (var i = 0; i < 50; i++) '$i': _state(stability: 40, lastReview: now),
    };
    expect(pool.select(cards, states, now, limit: 12).length, 12);
  });

  test('the same seed gives the same order, a different one does not', () {
    final cards = [for (var i = 0; i < 20; i++) _card('$i')];
    final states = {
      for (var i = 0; i < 20; i++) '$i': _state(stability: 40, lastReview: now),
    };

    final a = pool.select(cards, states, now, seed: 1).map((c) => c.id).toList();
    final b = pool.select(cards, states, now, seed: 1).map((c) => c.id).toList();
    final other =
        pool.select(cards, states, now, seed: 2).map((c) => c.id).toList();

    expect(a, b);
    expect(a, isNot(other));
  });

  group('readiness', () {
    test('is false until there is enough known material', () {
      final cards = [for (var i = 0; i < 5; i++) _card('$i')];
      final states = {
        for (var i = 0; i < 5; i++) '$i': _state(stability: 40, lastReview: now),
      };
      expect(pool.isReady(cards, states, now), isFalse,
          reason: 'five known cards is not a fluency drill');
    });

    test('is true once the minimum is reached', () {
      final count = FluencyPool.minimumPool;
      final cards = [for (var i = 0; i < count; i++) _card('$i')];
      final states = {
        for (var i = 0; i < count; i++)
          '$i': _state(stability: 40, lastReview: now),
      };
      expect(pool.isReady(cards, states, now), isTrue);
    });

    test('ignores cards that are merely present but not learned', () {
      final cards = [for (var i = 0; i < 30; i++) _card('$i')];
      final states = {
        for (var i = 0; i < 30; i++)
          '$i': _state(
              stability: 0.5,
              lastReview: now.subtract(const Duration(days: 10))),
      };
      expect(pool.isReady(cards, states, now), isFalse);
    });
  });
}
