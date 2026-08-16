import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/courses.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';
import 'package:learning_app/data/srs/session.dart';

void main() {
  const builder = SessionBuilder();
  const checker = AnswerChecker();
  final course = courses['en']!;
  final now = DateTime(2026, 3, 10, 8);

  group('content integrity', () {
    test('every course has unique card ids and complete cards', () {
      for (final entry in courses.entries) {
        final ids = <String>{};
        for (final card in entry.value.allCards) {
          expect(ids.add(card.id), isTrue,
              reason: 'duplicate id ${card.id} in ${entry.key}');
          expect(card.target.trim(), isNotEmpty);
          expect(card.native.trim(), isNotEmpty);
          expect(card.focus.trim(), isNotEmpty);
          expect(card.tokens, isNotEmpty);
        }
      }
    });

    test('word-bank tokens rebuild the target sentence', () {
      for (final entry in courses.entries) {
        final joiner = (entry.key == 'zh' || entry.key == 'ja') ? '' : ' ';
        for (final card in entry.value.allCards) {
          final rebuilt = card.tokens.join(joiner);
          expect(
            checker.normalize(rebuilt),
            checker.normalize(card.target),
            reason: 'tokens do not rebuild ${card.id}',
          );
        }
      }
    });

    test('Mandarin cards all carry pinyin', () {
      for (final card in courses['zh']!.allCards) {
        expect(card.romanization, isNotNull, reason: card.id);
        expect(card.romanization!.trim(), isNotEmpty);
      }
    });

    test('unit ids are unique across a course', () {
      for (final entry in courses.entries) {
        final ids = entry.value.units.map((u) => u.id).toList();
        expect(ids.toSet().length, ids.length, reason: entry.key);
      }
    });
  });

  group('queue building', () {
    test('a brand new learner gets only new cards, capped', () {
      final progress = LanguageProgress(languageCode: 'en');
      final items = builder.build(
        course: course,
        progress: progress,
        now: now,
        seed: 1,
      );

      expect(items, isNotEmpty);
      expect(items.every((i) => i.isNew), isTrue);
      expect(items.length, lessThanOrEqualTo(6));
    });

    test('due reviews are served before new material', () {
      const scheduler = Scheduler();
      final progress = LanguageProgress(languageCode: 'en');

      // Make 10 cards overdue.
      for (final card in course.allCards.take(10)) {
        final state = scheduler.review(
          MemoryState.fresh(now.subtract(const Duration(days: 40))),
          Grade.good,
          now.subtract(const Duration(days: 40)),
        );
        progress.states[card.id] = state;
      }

      final items = builder.build(
        course: course,
        progress: progress,
        now: now,
        maxItems: 12,
        seed: 2,
      );

      final reviews = items.where((i) => !i.isNew).length;
      expect(reviews, 10);
      // The remaining slots go to new cards, never more than the cap.
      expect(items.length, lessThanOrEqualTo(12));
    });

    test('cards not yet due are not scheduled', () {
      const scheduler = Scheduler();
      final progress = LanguageProgress(languageCode: 'en');
      for (final card in course.allCards) {
        progress.states[card.id] =
            scheduler.review(MemoryState.fresh(now), Grade.easy, now);
      }

      final due = builder.dueCards(course, progress, now);
      expect(due, isEmpty);

      final items = builder.build(
        course: course,
        progress: progress,
        now: now,
        seed: 3,
      );
      expect(items, isEmpty);
    });

    test('the queue never exceeds maxItems', () {
      const scheduler = Scheduler();
      final progress = LanguageProgress(languageCode: 'en');
      final past = now.subtract(const Duration(days: 90));
      for (final card in course.allCards) {
        progress.states[card.id] =
            scheduler.review(MemoryState.fresh(past), Grade.good, past);
      }

      final items = builder.build(
        course: course,
        progress: progress,
        now: now,
        maxItems: 15,
        seed: 4,
      );
      expect(items.length, 15);
    });
  });

  group('multiple choice options', () {
    test('always include the right answer and no duplicates', () {
      final random = math.Random(9);
      for (final card in course.allCards) {
        final options = builder.choicesFor(
          course: course,
          card: card,
          random: random,
        );
        expect(options, contains(card.native));
        expect(options.length, 4);
        expect(options.toSet().length, 4,
            reason: 'duplicate option for ${card.id}');
      }
    });
  });

  group('answer checking', () {
    test('ignores accents, case and punctuation', () {
      expect(
          checker.isCorrect(
              'me gusta mucho este barrio', 'Me gusta mucho este barrio.'),
          isTrue);
      expect(checker.isCorrect('¿CUANTO CUESTA?', '¿Cuánto cuesta?'), isTrue);
      expect(
          checker.isCorrect(
              '  hola,   me llamo marco ', 'Hola, me llamo Marco.'),
          isTrue);
    });

    test('still rejects a genuinely different sentence', () {
      expect(checker.isCorrect('bonjour', 'Hola, me llamo Marco.'), isFalse);
      expect(checker.isCorrect('', 'Mucho gusto.'), isFalse);
    });

    test('similarity separates near-misses from unrelated answers', () {
      final near = checker.similarity(
          'I would like a coffe please', 'I would like a coffee, please.');
      final far = checker.similarity(
          'bonjour tout le monde', 'I would like a coffee, please.');

      expect(near, greaterThan(0.85));
      expect(far, lessThan(0.5));
      expect(checker.similarity('Mucho gusto', 'Mucho gusto.'), 1.0);
    });
  });

  group('progress bookkeeping', () {
    test('streak advances once per day, not once per review', () {
      final progress = LanguageProgress(languageCode: 'en');
      final day = DateTime(2026, 5, 4, 10);

      progress.registerReview(correct: true, now: day);
      progress.registerReview(
          correct: true, now: day.add(const Duration(hours: 2)));

      expect(progress.streak, 1);
      expect(progress.reviewsPerDay[LanguageProgress.dayKey(day)], 2);
      expect(progress.totalReviews, 2);
    });

    test('consecutive days extend the streak and set a record', () {
      final progress = LanguageProgress(languageCode: 'en');
      var day = DateTime(2026, 5, 4, 10);
      for (var i = 0; i < 5; i++) {
        progress.registerReview(correct: true, now: day);
        day = day.add(const Duration(days: 1));
      }

      expect(progress.streak, 5);
      expect(progress.bestStreak, 5);
    });

    test('a missed day resets the streak but keeps the record', () {
      final progress = LanguageProgress(languageCode: 'en');
      var day = DateTime(2026, 5, 4, 10);
      for (var i = 0; i < 3; i++) {
        progress.registerReview(correct: true, now: day);
        day = day.add(const Duration(days: 1));
      }

      progress.registerReview(
        correct: true,
        now: day.add(const Duration(days: 3)),
      );

      expect(progress.streak, 1);
      expect(progress.bestStreak, 3);
    });

    test('accuracy tracks only correct reviews', () {
      final progress = LanguageProgress(languageCode: 'en');
      final day = DateTime(2026, 5, 4, 10);
      progress.registerReview(correct: true, now: day);
      progress.registerReview(correct: false, now: day);
      progress.registerReview(correct: true, now: day);
      progress.registerReview(correct: true, now: day);

      expect(progress.accuracy, closeTo(0.75, 1e-9));
    });

    test('pruning drops history older than a year', () {
      final progress = LanguageProgress(languageCode: 'en');
      final now = DateTime(2026, 6, 1);
      progress.reviewsPerDay[
          LanguageProgress.dayKey(now.subtract(const Duration(days: 400)))] = 5;
      progress.reviewsPerDay[
          LanguageProgress.dayKey(now.subtract(const Duration(days: 10)))] = 7;

      progress.prune(now);

      expect(progress.reviewsPerDay.length, 1);
      expect(progress.reviewsPerDay.values.single, 7);
    });

    test('survives a JSON round trip', () {
      const scheduler = Scheduler();
      final progress = LanguageProgress(languageCode: 'es', dailyGoal: 30);
      progress.registerReview(correct: true, now: now);
      progress.states['es-1-1'] =
          scheduler.review(MemoryState.fresh(now), Grade.good, now);

      final restored = LanguageProgress.fromJson(progress.toJson(), now);

      expect(restored.languageCode, 'es');
      expect(restored.dailyGoal, 30);
      expect(restored.streak, progress.streak);
      expect(restored.totalReviews, progress.totalReviews);
      expect(restored.states.keys, contains('es-1-1'));
      expect(
        restored.states['es-1-1']!.stability,
        closeTo(progress.states['es-1-1']!.stability, 1e-9),
      );
    });
  });

  group('grammar lessons', () {
    test('every unit in EN, ES and ZH has a grammar lesson', () {
      for (final code in ['en', 'es', 'zh', 'ja']) {
        final course = courses[code]!;
        for (final unit in course.units) {
          expect(unit.grammarLesson, isNotNull,
              reason: '$code ${unit.id} has no grammar lesson');
          expect(unit.grammarLesson!.title.trim(), isNotEmpty);
          expect(unit.grammarLesson!.hook.trim(), isNotEmpty);
          expect(unit.grammarLesson!.blocks, isNotEmpty);
        }
      }
    });

    test('Turkish units have no grammar lesson yet, and that is fine', () {
      for (final unit in courses['tr']!.units) {
        expect(unit.grammarLesson, isNull);
      }
    });

    test('every tone entry uses a valid tone number', () {
      for (final unit in courses['zh']!.units) {
        final lesson = unit.grammarLesson;
        if (lesson == null) continue;
        for (final block in lesson.blocks) {
          if (block is ToneBlock) {
            for (final entry in block.entries) {
              expect(entry.tone, inInclusiveRange(0, 4));
              expect(entry.pinyin.trim(), isNotEmpty);
            }
          }
        }
      }
    });

    test('mistake blocks always pair a wrong form with a fix and a reason', () {
      for (final code in ['en', 'es', 'zh', 'ja']) {
        for (final unit in courses[code]!.units) {
          final lesson = unit.grammarLesson;
          if (lesson == null) continue;
          for (final block in lesson.blocks) {
            if (block is MistakeBlock) {
              expect(block.wrong.trim(), isNotEmpty);
              expect(block.right.trim(), isNotEmpty);
              expect(block.why.trim(), isNotEmpty);
              expect(block.wrong, isNot(equals(block.right)));
            }
          }
        }
      }
    });

    test('table blocks are rectangular (every row matches the header count)',
        () {
      for (final code in ['en', 'es', 'zh', 'ja']) {
        for (final unit in courses[code]!.units) {
          final lesson = unit.grammarLesson;
          if (lesson == null) continue;
          for (final block in lesson.blocks) {
            if (block is TableBlock) {
              for (final row in block.rows) {
                expect(row.length, block.headers.length,
                    reason: '${unit.id}: row/header length mismatch');
              }
            }
          }
        }
      }
    });
  });
}
