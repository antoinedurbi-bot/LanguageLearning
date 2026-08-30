import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/courses.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/session.dart';

/// Tests for the three-phase first-encounter ramp (découverte ->
/// reconnaissance -> production) that a unit's brand-new cards walk through
/// before joining the ordinary FSRS-scheduled review pool. Mirrors the
/// conventions in session_test.dart.
void main() {
  const builder = SessionBuilder();
  const scheduler = Scheduler();
  final course = courses['en']!;
  final unit = course.units.first;
  final now = DateTime(2026, 3, 10, 8);

  group('new-vs-review routing', () {
    test('a brand new unit puts every card in newCardsInUnit', () {
      final progress = LanguageProgress(languageCode: 'en');
      final newCards = builder.newCardsInUnit(unit, progress);
      final studied = builder.studiedCardsInUnit(unit, progress);

      expect(newCards.length, unit.cards.length);
      expect(studied, isEmpty);
    });

    test('a card once reviewed moves from new to studied', () {
      final progress = LanguageProgress(languageCode: 'en');
      final firstCard = unit.cards.first;
      progress.states[firstCard.id] =
          scheduler.review(MemoryState.fresh(now), Grade.good, now);

      final newCards = builder.newCardsInUnit(unit, progress);
      final studied = builder.studiedCardsInUnit(unit, progress);

      expect(newCards, isNot(contains(firstCard)));
      expect(studied, contains(firstCard));
      expect(newCards.length + studied.length, unit.cards.length);
    });

    test('a fully studied unit has no first-encounter cards left', () {
      final progress = LanguageProgress(languageCode: 'en');
      for (final card in unit.cards) {
        progress.states[card.id] =
            scheduler.review(MemoryState.fresh(now), Grade.good, now);
      }

      final session = builder.buildFirstEncounter(unit, progress);
      expect(session.isEmpty, isTrue);
      expect(session.cards, isEmpty);
    });

    test('buildFirstEncounter only ever includes genuinely new cards', () {
      final progress = LanguageProgress(languageCode: 'en');
      // Study half the unit.
      final half = unit.cards.length ~/ 2;
      for (final card in unit.cards.take(half)) {
        progress.states[card.id] =
            scheduler.review(MemoryState.fresh(now), Grade.good, now);
      }

      final session = builder.buildFirstEncounter(unit, progress);
      expect(session.cards.length, unit.cards.length - half);
      for (final card in session.cards) {
        expect(progress.states.containsKey(card.id), isFalse);
      }
    });
  });

  group('phase item construction', () {
    test('every phase produces one item per card, in curriculum order', () {
      final progress = LanguageProgress(languageCode: 'en');
      final session = builder.buildFirstEncounter(unit, progress);
      expect(session.cards, isNotEmpty);

      for (final phase in SessionPhase.values) {
        final items = builder.phaseItems(session.cards, phase, now);
        expect(items.length, session.cards.length);
        for (var i = 0; i < items.length; i++) {
          expect(items[i].card.id, session.cards[i].id);
          expect(items[i].isNew, isTrue);
        }
      }
    });

    test('the production phase uses free-text production mode', () {
      final progress = LanguageProgress(languageCode: 'en');
      final session = builder.buildFirstEncounter(unit, progress);
      final items =
          builder.phaseItems(session.cards, SessionPhase.production, now);
      expect(items.every((i) => i.mode == ExerciseMode.produce), isTrue);
    });

    test('guided and recognition phases never demand free typing', () {
      final progress = LanguageProgress(languageCode: 'en');
      final session = builder.buildFirstEncounter(unit, progress);

      for (final phase in [SessionPhase.guided, SessionPhase.recognition]) {
        final items = builder.phaseItems(session.cards, phase, now);
        expect(items.every((i) => i.mode != ExerciseMode.produce), isTrue);
      }
    });

    test('phase labels are stable and in the guided/recognition/production'
        ' order', () {
      expect(SessionPhase.values, [
        SessionPhase.guided,
        SessionPhase.recognition,
        SessionPhase.production,
      ]);
      expect(SessionPhase.guided.label, 'Découverte');
      expect(SessionPhase.recognition.label, 'Reconnaissance');
      expect(SessionPhase.production.label, 'Production');
    });
  });

  group('completion feeds the FSRS scheduler', () {
    test('grading a first-encounter card after production enters it into '
        'the normal review pool, exactly like any other card', () {
      final progress = LanguageProgress(languageCode: 'en');
      final card = unit.cards.first;
      expect(progress.states.containsKey(card.id), isFalse);

      // Simulates what UnitIntroSessionScreen does at the end of the
      // production phase: grade once, from a fresh state, same call the
      // ordinary session screen makes.
      final fresh = progress.states[card.id] ?? MemoryState.fresh(now);
      progress.states[card.id] = scheduler.review(fresh, Grade.good, now);

      expect(progress.states.containsKey(card.id), isTrue);
      expect(builder.newCardsInUnit(unit, progress), isNot(contains(card)));
      expect(builder.dueCards(course, progress, now), isNot(contains(card)));
      // It now behaves exactly like a normal reviewed card: due once its
      // FSRS interval elapses, not before.
      final due = progress.states[card.id]!.due;
      expect(due.isAfter(now), isTrue);
    });

    test('cards are only graded once per completed ramp, never double '
        'counted', () {
      final progress = LanguageProgress(languageCode: 'en');
      final card = unit.cards.first;

      progress.states[card.id] =
          scheduler.review(MemoryState.fresh(now), Grade.good, now);
      final afterFirstGrade = progress.states[card.id]!;

      // Re-running the guided or recognition phase for an already-graded
      // card must never happen once it has left newCardsInUnit — this is
      // the invariant that keeps the first-encounter ramp from re-grading
      // a card the learner already produced correctly.
      expect(builder.newCardsInUnit(unit, progress), isNot(contains(card)));
      expect(progress.states[card.id], same(afterFirstGrade));
    });
  });
}
