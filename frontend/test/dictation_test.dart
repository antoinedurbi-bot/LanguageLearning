import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/srs/dictation.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/session.dart';

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
  const pool = DictationPool(Scheduler());
  const checker = AnswerChecker();
  final now = DateTime.utc(2026, 6, 1, 12);

  group('dictation pool selection', () {
    test('only cards with some memory of them are dictated', () {
      final cards = [_card('connue'), _card('neuve')];
      final states = {
        'connue': _state(stability: 20, lastReview: now),
        // 'neuve' has never been reviewed.
      };

      final selected = pool.select(cards, states, now);
      expect(selected.map((c) => c.id), ['connue']);
    });

    test('a card barely remembered is excluded — dictation is a review, not '
        'a first exposure', () {
      final cards = [_card('fragile')];
      final states = {
        'fragile': _state(
            stability: 1, lastReview: now.subtract(const Duration(days: 30))),
      };
      expect(pool.select(cards, states, now), isEmpty);
    });

    test('selection is capped by the limit', () {
      final cards = [for (var i = 0; i < 30; i++) _card('$i')];
      final states = {
        for (var i = 0; i < 30; i++) '$i': _state(stability: 40, lastReview: now),
      };
      expect(pool.select(cards, states, now, limit: 8).length, 8);
    });

    test('a fixed seed reproduces the same order', () {
      final cards = [for (var i = 0; i < 15; i++) _card('$i')];
      final states = {
        for (var i = 0; i < 15; i++) '$i': _state(stability: 40, lastReview: now),
      };

      final a = pool.select(cards, states, now, seed: 7).map((c) => c.id).toList();
      final b = pool.select(cards, states, now, seed: 7).map((c) => c.id).toList();
      expect(a, b);
    });

    group('readiness', () {
      test('is false below the minimum pool', () {
        final cards = [for (var i = 0; i < 3; i++) _card('$i')];
        final states = {
          for (var i = 0; i < 3; i++) '$i': _state(stability: 40, lastReview: now),
        };
        expect(pool.isReady(cards, states, now), isFalse);
      });

      test('is true once the minimum is reached', () {
        final count = DictationPool.minimumPool;
        final cards = [for (var i = 0; i < count; i++) _card('$i')];
        final states = {
          for (var i = 0; i < count; i++)
            '$i': _state(stability: 40, lastReview: now),
        };
        expect(pool.isReady(cards, states, now), isTrue);
      });
    });
  });

  group('grading a dictated answer', () {
    test('an exact (normalised) match is correct', () {
      final similarity = checker.similarity(
        'me gusta mucho este barrio',
        'Me gusta mucho este barrio.',
      );
      expect(gradeDictation(similarity), DictationVerdict.correct);
    });

    test('a small slip is close, not a miss', () {
      final similarity = checker.similarity(
        'I would like a coffe please',
        'I would like a coffee, please.',
      );
      expect(similarity, greaterThanOrEqualTo(0.8));
      expect(gradeDictation(similarity), DictationVerdict.close);
    });

    test('an unrelated answer is a miss', () {
      final similarity =
          checker.similarity('bonjour tout le monde', 'I would like a coffee.');
      expect(gradeDictation(similarity), DictationVerdict.miss);
    });

    test('verdict thresholds are ordered and exhaustive', () {
      expect(gradeDictation(1.0), DictationVerdict.correct);
      expect(gradeDictation(0.99), DictationVerdict.close);
      expect(gradeDictation(0.8), DictationVerdict.close);
      expect(gradeDictation(0.79), DictationVerdict.miss);
      expect(gradeDictation(0.0), DictationVerdict.miss);
    });
  });
}
