import 'dart:math' as math;

import 'package:learning_app/data/models/card_item.dart';

/// Builds the wrong options for a multiple-choice question.
///
/// A plain shuffle of random cards produces distractors a learner can
/// eliminate by pattern-matching topic, length or register rather than by
/// actually knowing the grammar point being tested — "un QCM à la Duolingo".
/// This generator instead:
///
///  1. Prefers distractors drawn from *other cards that teach the same
///     [CardItem.focus]* — the one grammar point the course itself already
///     tags on every card. Two cards sharing a focus are, by construction,
///     testing the same confusion (the same tense, the same particle, the
///     same gender rule), so picking among them is close to hand-authoring
///     grammatically-plausible wrong answers without needing any new content.
///  2. Among same-focus candidates (and, if there are not enough, among the
///     wider pool used as fallback), ranks by surface similarity to the
///     correct answer — similar length and a shared prefix — so a wrong
///     option cannot be eliminated by skimming rather than reading.
///  3. Chooses randomly *within* that shortlist rather than always the same
///     top-N, so replaying the same card produces different wrong options
///     from run to run while staying reproducible for a given [random] seed.
///
/// Falls back to the widest available pool only when a course does not have
/// enough same-focus material for a given card (e.g. a lone card introducing
/// a one-off focus) — still random, but no longer the only strategy.
List<String> generateDistractors({
  required CardItem card,
  required List<CardItem> pool,
  required math.Random random,
  int count = 3,
}) {
  final correct = card.native;

  // Every other card's meaning, deduplicated, indexed by whether it shares
  // this card's grammar focus.
  final sameFocus = <String>{};
  final other = <String>{};
  for (final candidate in pool) {
    if (candidate.id == card.id) continue;
    final meaning = candidate.native;
    if (meaning == correct) continue;
    if (candidate.focus == card.focus) {
      sameFocus.add(meaning);
    } else {
      other.add(meaning);
    }
  }

  // Prefer the same-focus pool; only reach into the general pool to top it
  // up when the course does not have enough same-focus material.
  final ranked = _rankBySimilarity(sameFocus.toList(), correct);
  if (ranked.length < count) {
    ranked.addAll(_rankBySimilarity(other.toList(), correct));
  }

  // Shortlist the closest matches (more than we need), then pick randomly
  // within it. The shortlist keeps distractors plausible; the random pick
  // within it is what makes the same card show different wrong answers on
  // different attempts.
  final shortlistSize = math.min(ranked.length, math.max(count * 3, count));
  final shortlist = ranked.take(shortlistSize).toList()..shuffle(random);

  return shortlist.take(count).toList();
}

/// Sorts [candidates] by closeness to [target]: a shared starting character
/// and a similar length are cheap, language-agnostic stand-ins for "looks
/// like it could be the answer at a glance" (works the same for Latin,
/// Cyrillic or CJK scripts, unlike a Levenshtein edit distance which
/// penalises CJK strings that are already only a few characters long).
List<String> _rankBySimilarity(List<String> candidates, String target) {
  final targetLen = target.length;
  final firstChar = target.isEmpty ? '' : target[0].toLowerCase();

  int score(String candidate) {
    var s = 0;
    if (candidate.isNotEmpty && candidate[0].toLowerCase() == firstChar) {
      s += 3;
    }
    final lengthDiff = (candidate.length - targetLen).abs();
    s -= lengthDiff;
    return s;
  }

  final scored = [...candidates];
  scored.sort((a, b) => score(b).compareTo(score(a)));
  return scored;
}
