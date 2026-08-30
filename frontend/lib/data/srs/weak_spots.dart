import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/session.dart';

/// What kind of material a weak spot is, so the UI can label and route it.
enum WeakSpotKind { card, radical }

/// One thing the learner is weak on, ranked so the weakest material sorts
/// first.
class WeakSpotEntry {
  const WeakSpotEntry({
    required this.kind,
    required this.id,
    required this.label,
    required this.detail,
    required this.weakness,
    this.card,
  });

  final WeakSpotKind kind;
  final String id;

  /// Short label shown in the list (the sentence, or the radical glyph).
  final String label;

  /// Secondary line (the French meaning, or the radical's meaning/count).
  final String detail;

  /// 0..1, higher means weaker. For cards this is `1 - retrievability`; for
  /// radicals it is a flat value for "not yet marked mastered" since
  /// self-assessed mastery has no continuous score to rank within.
  final double weakness;

  /// Present only for [WeakSpotKind.card] entries, so the caller can build a
  /// review session directly from the ranked list.
  final CardItem? card;
}

/// Aggregates the learner's weakest material for one language into a single
/// ranked list, reusing the FSRS retrievability estimate that already drives
/// the daily queue rather than inventing a second notion of "weak".
///
/// This deliberately only surfaces what the app can actually measure:
/// - vocabulary/grammar cards, ranked by how likely the learner is to have
///   already forgotten them (low retrievability = weak), restricted to cards
///   they have actually studied at least once — an unseen card is not a
///   "weak spot", it is just unstarted material the normal queue will
///   introduce in due course;
/// - for Mandarin, radicals not yet marked mastered, since that mastery is
///   tracked independently of the FSRS states.
///
/// AI-correction mistake patterns are intentionally left out: nothing in
/// this codebase persists chat/correction history to aggregate from, and
/// building storage for that just to populate this screen would be
/// inventing a feature the task did not actually ask for.
class WeakSpotsAggregator {
  const WeakSpotsAggregator({this.scheduler = const Scheduler()});

  final Scheduler scheduler;

  /// Ranks studied cards by weakness (lowest retrievability first).
  List<WeakSpotEntry> rankCards(
    Course course,
    LanguageProgress progress,
    DateTime now,
  ) {
    final entries = <WeakSpotEntry>[];
    for (final card in course.allCards) {
      final state = progress.states[card.id];
      if (state == null || state.isNew) continue;

      final elapsedDays = state.lastReview == null
          ? 0.0
          : now.difference(state.lastReview!).inMinutes / (60 * 24);
      final r = scheduler.retrievability(state.stability, elapsedDays.clamp(0, double.infinity));

      entries.add(WeakSpotEntry(
        kind: WeakSpotKind.card,
        id: card.id,
        label: card.target,
        detail: card.native,
        weakness: 1 - r,
        card: card,
      ));
    }
    entries.sort((a, b) => b.weakness.compareTo(a.weakness));
    return entries;
  }

  /// Weak radicals: everything not yet self-marked mastered, most frequent
  /// (by character count) first — those pay off fastest once learned.
  List<WeakSpotEntry> rankRadicals(
    List<({String radical, String meaning, int characterCount})> radicals,
    Set<String> mastered,
  ) {
    final unmastered = [
      for (final r in radicals)
        if (!mastered.contains(r.radical)) r,
    ]..sort((a, b) => b.characterCount.compareTo(a.characterCount));

    return [
      for (final r in unmastered)
        WeakSpotEntry(
          kind: WeakSpotKind.radical,
          id: r.radical,
          label: r.radical,
          detail: '${r.meaning} · ${r.characterCount} caractères',
          weakness: 1.0,
        ),
    ];
  }

  /// Combined, ranked list: weak cards first (true recall risk), then
  /// unmastered radicals capped to a reasonable amount so the session stays
  /// focused rather than becoming "review literally everything".
  List<WeakSpotEntry> combine({
    required List<WeakSpotEntry> cardEntries,
    List<WeakSpotEntry> radicalEntries = const [],
    int maxCards = 20,
    int maxRadicals = 10,
  }) {
    return [
      ...cardEntries.take(maxCards),
      ...radicalEntries.take(maxRadicals),
    ];
  }

  /// Builds a drillable session straight from the weak card entries, reusing
  /// the same [SessionItem]/[ExerciseMode] machinery as the normal queue —
  /// weak material is practised with the same exercises, just re-prioritised.
  List<SessionItem> buildSession(
    List<WeakSpotEntry> entries,
    LanguageProgress progress,
    DateTime now, {
    int maxItems = 15,
  }) {
    final items = <SessionItem>[];
    for (final entry in entries) {
      if (items.length >= maxItems) break;
      final card = entry.card;
      if (card == null) continue;
      final state = progress.states[card.id];
      if (state == null) continue;
      items.add(SessionItem(
        card: card,
        mode: card.tokens.length >= 3
            ? ExerciseMode.build
            : ExerciseMode.recognize,
        state: state,
      ));
    }
    return items;
  }
}
