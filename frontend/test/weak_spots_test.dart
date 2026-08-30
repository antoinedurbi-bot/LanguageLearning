import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/weak_spots.dart';

CardItem _card(String id, {String native = 'meaning'}) => CardItem(
      id: id,
      target: 'target $id',
      native: native,
      gloss: 'gloss',
      tokens: ['target', id],
      distractors: const [],
      focus: 'focus',
    );

Course _course(List<Unit> units) =>
    Course(languageCode: 'en', ttsLocale: 'en-US', units: units);

Unit _unit(String id, List<CardItem> cards) => Unit(
      id: id,
      title: id,
      subtitle: id,
      level: 'A1',
      cards: cards,
    );

void main() {
  const aggregator = WeakSpotsAggregator();
  final now = DateTime(2026, 1, 1);

  group('rankCards', () {
    test('never surfaces a card the learner has never studied', () {
      final course = _course([_unit('u1', [_card('a'), _card('b')])]);
      final progress = LanguageProgress(languageCode: 'en');
      // Neither card has an entry in progress.states.

      final ranked = aggregator.rankCards(course, progress, now);
      expect(ranked, isEmpty);
    });

    test('ranks the least retrievable card first', () {
      final course = _course([
        _unit('u1', [_card('fresh'), _card('stale')]),
      ]);
      final tenDaysAgo = now.subtract(const Duration(days: 10));
      final progress = LanguageProgress(languageCode: 'en', states: {
        // High stability, reviewed 10 days ago: still very retrievable.
        'fresh': MemoryState(
          stability: 200,
          difficulty: 5,
          due: now,
          lastReview: tenDaysAgo,
          reps: 3,
          lapses: 0,
        ),
        // Low stability, reviewed 10 days ago: mostly forgotten by now.
        'stale': MemoryState(
          stability: 2,
          difficulty: 5,
          due: now,
          lastReview: tenDaysAgo,
          reps: 3,
          lapses: 1,
        ),
      });

      final ranked = aggregator.rankCards(course, progress, now);
      expect(ranked.first.id, 'stale');
      expect(ranked.first.weakness, greaterThan(ranked.last.weakness));
    });

    test('a brand new (never-reviewed) state is excluded even if present',
        () {
      final course = _course([_unit('u1', [_card('a')])]);
      final progress = LanguageProgress(languageCode: 'en', states: {
        'a': MemoryState.fresh(now),
      });

      expect(aggregator.rankCards(course, progress, now), isEmpty);
    });
  });

  group('rankRadicals', () {
    test('drops mastered radicals and orders the rest by character count',
        () {
      final radicals = [
        (radical: '氵', meaning: 'water', characterCount: 40),
        (radical: '木', meaning: 'tree', characterCount: 25),
        (radical: '人', meaning: 'person', characterCount: 60),
      ];

      final ranked = aggregator.rankRadicals(radicals, {'人'});

      expect(ranked.map((e) => e.id), ['氵', '木']);
      expect(ranked.first.id, '氵'); // higher character count than 木
    });
  });

  group('combine', () {
    test('caps each list independently and preserves card-first ordering',
        () {
      final cards = [
        for (var i = 0; i < 5; i++)
          WeakSpotEntry(
            kind: WeakSpotKind.card,
            id: 'c$i',
            label: 'l$i',
            detail: 'd$i',
            weakness: 1 - i * 0.1,
          ),
      ];
      final radicals = [
        for (var i = 0; i < 5; i++)
          WeakSpotEntry(
            kind: WeakSpotKind.radical,
            id: 'r$i',
            label: 'l$i',
            detail: 'd$i',
            weakness: 1,
          ),
      ];

      final combined = aggregator.combine(
        cardEntries: cards,
        radicalEntries: radicals,
        maxCards: 3,
        maxRadicals: 2,
      );

      expect(combined.length, 5);
      expect(combined.take(3).every((e) => e.kind == WeakSpotKind.card), isTrue);
      expect(combined.skip(3).every((e) => e.kind == WeakSpotKind.radical), isTrue);
    });
  });

  group('buildSession', () {
    test('builds a session item only for entries with a live progress state',
        () {
      final weak = WeakSpotEntry(
        kind: WeakSpotKind.card,
        id: 'a',
        label: 'l',
        detail: 'd',
        weakness: 0.9,
        card: _card('a'),
      );
      final progress = LanguageProgress(languageCode: 'en', states: {
        'a': MemoryState(
          stability: 5,
          difficulty: 5,
          due: now,
          lastReview: now,
          reps: 1,
          lapses: 0,
        ),
      });

      final items = aggregator.buildSession([weak], progress, now);
      expect(items.length, 1);
      expect(items.first.card.id, 'a');
    });
  });
}
