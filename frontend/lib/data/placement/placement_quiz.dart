import 'dart:math' as math;

import 'package:learning_app/data/models/card_item.dart';

/// One placement question: recognise the meaning of a sentence drawn from a
/// real unit of the course.
///
/// Questions are not invented content — each one *is* the first card of a
/// unit spread across the curriculum, so a right answer means "I already
/// know material at this level" in a very literal sense, and the difficulty
/// ramp is exactly the difficulty ramp the course itself uses.
class PlacementQuestion {
  const PlacementQuestion({
    required this.unitIndex,
    required this.card,
    required this.options,
    required this.correctIndex,
  });

  /// Index of the unit this question's card was drawn from.
  final int unitIndex;
  final CardItem card;

  /// Four possible French meanings, one of them correct.
  final List<String> options;
  final int correctIndex;
}

/// The learner's answers, scored against the questions.
class PlacementResult {
  const PlacementResult({
    required this.recommendedUnitIndex,
    required this.correctCount,
    required this.totalCount,
  });

  /// Unit the learner is invited to start from. Always a valid index into
  /// `course.units` — never a suggestion to skip the whole course.
  final int recommendedUnitIndex;
  final int correctCount;
  final int totalCount;
}

/// Builds and scores a short placement quiz from a course's own content.
///
/// Adaptive in feel rather than in mechanism: instead of branching on each
/// answer mid-quiz (which would need a much bigger content budget to give
/// every branch real material), it samples fixed checkpoints spread across
/// the whole course and finds how far into that ramp the learner's
/// knowledge actually reaches. That is enough to tell "already knows the
/// basics" from "starting from zero" without pretending to more precision
/// than an 8-12 question quiz can honestly deliver.
class PlacementQuizBuilder {
  const PlacementQuizBuilder();

  /// Builds up to [questionCount] questions, one per sampled unit, evenly
  /// spread across the course and always including the very first unit.
  List<PlacementQuestion> build(
    List<Unit> units, {
    int questionCount = 10,
    int? seed,
  }) {
    if (units.isEmpty) return const [];
    final random = math.Random(seed);

    final unitCount = units.length;
    final sampleCount = math.min(questionCount, unitCount);
    final unitIndices = <int>{};
    for (var i = 0; i < sampleCount; i++) {
      // Evenly spread indices 0..unitCount-1 across sampleCount picks.
      final index = (i * unitCount / sampleCount).floor();
      unitIndices.add(index.clamp(0, unitCount - 1));
    }

    final sorted = unitIndices.toList()..sort();
    final questions = <PlacementQuestion>[];
    for (final unitIndex in sorted) {
      final unit = units[unitIndex];
      if (unit.cards.isEmpty) continue;
      final card = unit.cards.first;

      final distractorPool = <String>[
        for (final other in units)
          for (final otherCard in other.cards)
            if (otherCard.id != card.id) otherCard.native,
      ]..shuffle(random);

      final wrong = <String>{};
      for (final candidate in distractorPool) {
        if (wrong.length >= 3) break;
        if (candidate != card.native) wrong.add(candidate);
      }

      final options = [card.native, ...wrong]..shuffle(random);
      questions.add(PlacementQuestion(
        unitIndex: unitIndex,
        card: card,
        options: options,
        correctIndex: options.indexOf(card.native),
      ));
    }
    return questions;
  }

  /// Scores answered questions (in the order they were asked) and
  /// recommends a starting unit.
  ///
  /// Walks the questions from the easiest (lowest unit index) forward. The
  /// recommendation advances past every unit answered correctly; two
  /// consecutive wrong answers are read as "the ceiling of what this learner
  /// already knows" and stop the scan, so one lucky guess or one careless
  /// slip does not swing the recommendation on its own.
  PlacementResult score(
    List<PlacementQuestion> questions,
    List<int?> answers,
    int unitCount,
  ) {
    assert(answers.length == questions.length);
    var recommended = 0;
    var correct = 0;
    var consecutiveWrong = 0;

    for (var i = 0; i < questions.length; i++) {
      final isCorrect = answers[i] != null &&
          answers[i] == questions[i].correctIndex;
      if (isCorrect) {
        correct++;
        recommended = questions[i].unitIndex + 1;
        consecutiveWrong = 0;
      } else {
        consecutiveWrong++;
        if (consecutiveWrong >= 2) break;
      }
    }

    final clamped = unitCount == 0
        ? 0
        : recommended.clamp(0, unitCount - 1);

    return PlacementResult(
      recommendedUnitIndex: clamped,
      correctCount: correct,
      totalCount: questions.length,
    );
  }
}
