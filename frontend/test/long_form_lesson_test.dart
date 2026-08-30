import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/courses.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';

/// Content validation for the "chapter-like" long-form treatment added to a
/// handful of foundational units — mirrors the conventions in
/// `session_test.dart`'s "grammar lessons" group and `story_test.dart`.
void main() {
  group('long-form lessons', () {
    /// Every unit in [courses] that carries a [LongFormContent], in
    /// (languageCode, unitId, content) form.
    List<(String, String, LongFormContent)> allLongForm() {
      final found = <(String, String, LongFormContent)>[];
      for (final code in courses.keys) {
        for (final unit in courses[code]!.units) {
          final longForm = unit.grammarLesson?.longForm;
          if (longForm != null) found.add((code, unit.id, longForm));
        }
      }
      return found;
    }

    test('at least one foundational unit per language has long-form content',
        () {
      final byLanguage = <String, int>{};
      for (final (code, _, _) in allLongForm()) {
        byLanguage[code] = (byLanguage[code] ?? 0) + 1;
      }
      for (final code in ['en', 'es', 'zh', 'ja']) {
        expect(byLanguage[code], isNotNull,
            reason: '$code has no long-form lesson yet');
        expect(byLanguage[code], greaterThanOrEqualTo(1));
      }
    });

    test('referenced unit ids actually exist in their course', () {
      for (final code in courses.keys) {
        final ids = courses[code]!.units.map((u) => u.id).toSet();
        for (final unit in courses[code]!.units) {
          final longForm = unit.grammarLesson?.longForm;
          if (longForm == null) continue;
          expect(ids, contains(unit.id),
              reason: 'sanity: $code ${unit.id} should be in its own course');
          expect(longForm.dialogue, isNotEmpty);
        }
      }
    });

    test('narrative has 2 to 4 non-empty paragraphs of real prose', () {
      for (final (code, id, longForm) in allLongForm()) {
        expect(longForm.narrative.length, inInclusiveRange(2, 4),
            reason: '$code $id narrative paragraph count');
        for (final paragraph in longForm.narrative) {
          expect(paragraph.trim(), isNotEmpty,
              reason: '$code $id has an empty narrative paragraph');
          expect(paragraph.trim().length, greaterThan(80),
              reason:
                  '$code $id narrative paragraph reads as a stub, not prose');
        }
      }
    });

    test('dialogue has 3 to 6 lines, each with a French translation', () {
      for (final (code, id, longForm) in allLongForm()) {
        expect(longForm.dialogue.length, inInclusiveRange(3, 6),
            reason: '$code $id dialogue line count');
        for (final line in longForm.dialogue) {
          expect(line.native.trim(), isNotEmpty,
              reason: '$code $id has a dialogue line with no translation');
          expect(line.tokens, isNotEmpty,
              reason: '$code $id has a dialogue line with no tokens');
        }
      }
    });

    test('every dialogue line has at least one glossed (taught) token', () {
      for (final (code, id, longForm) in allLongForm()) {
        for (final line in longForm.dialogue) {
          final taughtWithGloss =
              line.tokens.where((t) => t.taught && t.hasGloss);
          expect(taughtWithGloss, isNotEmpty,
              reason:
                  '$code $id: dialogue line "${line.text}" has no glossed token');
        }
      }
    });

    test('walkthroughs have 2 to 3 examples, each broken into parts', () {
      for (final (code, id, longForm) in allLongForm()) {
        expect(longForm.walkthroughs.length, inInclusiveRange(2, 3),
            reason: '$code $id walkthrough count');
        for (final example in longForm.walkthroughs) {
          expect(example.target.trim(), isNotEmpty);
          expect(example.native.trim(), isNotEmpty);
          expect(example.parts, isNotEmpty,
              reason:
                  '$code $id: "${example.target}" has no piece-by-piece breakdown');
          for (final part in example.parts) {
            expect(part.chunk.trim(), isNotEmpty);
            expect(part.explanation.trim(), isNotEmpty);
            expect(part.explanation.trim().length, greaterThan(10),
                reason:
                    '$code $id: "${part.chunk}" explanation reads as a stub');
          }
        }
      }
    });

    test('a walkthrough explanation is a grammatical note, not a translation',
        () {
      for (final (code, id, longForm) in allLongForm()) {
        for (final example in longForm.walkthroughs) {
          for (final part in example.parts) {
            expect(
              part.explanation.trim().toLowerCase(),
              isNot(equals(part.chunk.trim().toLowerCase())),
              reason: '$code $id: "${part.chunk}" explanation just repeats '
                  'the chunk',
            );
          }
        }
      }
    });

    test('long-form lessons still carry the standard grammar blocks', () {
      // The long-form layer is additive: the rule/table/mistake blocks that
      // already exist for these units must not have been dropped.
      for (final (code, id, _) in allLongForm()) {
        final unit = courses[code]!.units.firstWhere((u) => u.id == id);
        expect(unit.grammarLesson!.blocks, isNotEmpty,
            reason: '$code $id lost its standard blocks');
      }
    });
  });
}
