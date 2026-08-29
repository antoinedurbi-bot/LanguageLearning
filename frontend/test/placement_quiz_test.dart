import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/placement/placement_quiz.dart';

Unit _unit(String id, List<String> nativeMeanings) => Unit(
      id: id,
      title: id,
      subtitle: id,
      level: 'A1',
      cards: [
        for (var i = 0; i < nativeMeanings.length; i++)
          CardItem(
            id: '$id-$i',
            target: '$id-target-$i',
            native: nativeMeanings[i],
            gloss: 'gloss',
            tokens: [id, 'target', i.toString()],
            distractors: const [],
            focus: 'focus',
          ),
      ],
    );

void main() {
  const builder = PlacementQuizBuilder();

  group('PlacementQuizBuilder.build', () {
    test('samples one question per spread-out unit, always including unit 0',
        () {
      final units = [
        for (var i = 0; i < 20; i++) _unit('u$i', ['meaning $i'])
      ];

      final questions = builder.build(units, questionCount: 10, seed: 1);

      expect(questions.length, 10);
      expect(questions.first.unitIndex, 0);
      // Strictly increasing unit indices: each question is a distinct,
      // harder checkpoint than the last.
      for (var i = 1; i < questions.length; i++) {
        expect(questions[i].unitIndex, greaterThan(questions[i - 1].unitIndex));
      }
    });

    test('each question offers exactly one correct option among four', () {
      final units = [
        for (var i = 0; i < 8; i++) _unit('u$i', ['meaning $i'])
      ];
      final questions = builder.build(units, questionCount: 8, seed: 2);

      for (final q in questions) {
        expect(q.options.length, lessThanOrEqualTo(4));
        expect(q.options[q.correctIndex], q.card.native);
        expect(q.options.toSet().length, q.options.length,
            reason: 'options must not repeat');
      }
    });

    test('never asks more questions than there are units', () {
      final units = [_unit('only', ['x']), _unit('second', ['y'])];
      final questions = builder.build(units, questionCount: 10);
      expect(questions.length, lessThanOrEqualTo(units.length));
    });

    test('an empty course yields no questions', () {
      expect(builder.build(const []), isEmpty);
    });
  });

  group('PlacementQuizBuilder.score', () {
    late List<Unit> units;
    late List<PlacementQuestion> questions;

    setUp(() {
      units = [for (var i = 0; i < 10; i++) _unit('u$i', ['meaning $i'])];
      questions = builder.build(units, questionCount: 10, seed: 3);
    });

    test('all correct recommends starting near the end of the course', () {
      final answers = [for (final q in questions) q.correctIndex];
      final result = builder.score(questions, answers, units.length);

      expect(result.correctCount, questions.length);
      expect(result.recommendedUnitIndex, units.length - 1);
    });

    test('all wrong recommends starting at unit 0', () {
      final answers = [
        for (final q in questions)
          (q.correctIndex + 1) % q.options.length,
      ];
      final result = builder.score(questions, answers, units.length);

      expect(result.correctCount, 0);
      expect(result.recommendedUnitIndex, 0);
    });

    test('stops advancing after two consecutive wrong answers', () {
      // Correct on the first three checkpoints, then wrong twice in a row —
      // the recommendation should freeze at the unit right after the third
      // correct answer, ignoring any later (unreliable) correct guesses.
      final answers = <int?>[];
      for (var i = 0; i < questions.length; i++) {
        if (i < 3) {
          answers.add(questions[i].correctIndex);
        } else if (i < 5) {
          answers.add((questions[i].correctIndex + 1) % questions[i].options.length);
        } else {
          answers.add(questions[i].correctIndex);
        }
      }

      final result = builder.score(questions, answers, units.length);
      expect(result.recommendedUnitIndex, questions[2].unitIndex + 1);
    });

    test('an unanswered question counts as wrong, not as a crash', () {
      final answers = <int?>[questions.first.correctIndex, null, null];
      final trimmed = questions.take(3).toList();
      final result = builder.score(trimmed, answers, units.length);
      expect(result.recommendedUnitIndex, trimmed.first.unitIndex + 1);
    });

    test('recommendation is always a valid unit index', () {
      final answers = [for (final q in questions) q.correctIndex];
      final result = builder.score(questions, answers, units.length);
      expect(result.recommendedUnitIndex, greaterThanOrEqualTo(0));
      expect(result.recommendedUnitIndex, lessThan(units.length));
    });
  });
}
