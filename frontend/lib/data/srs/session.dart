import 'dart:math' as math;

import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/data/srs/scheduler.dart';

/// How a card is presented in a given review.
///
/// The mode escalates as the card's memory stability grows. Recognising a
/// meaning is far easier than producing the sentence from scratch, so asking
/// for production too early just manufactures failure, and asking for
/// recognition forever never builds the ability to speak. The ladder below
/// moves each card from recognition to production as it consolidates.
enum ExerciseMode {
  /// See the target sentence, choose its meaning. Introduces the card.
  recognize,

  /// Hear the sentence, choose its meaning. Trains the ear separately from
  /// the eye, which is the gap most reading-heavy learners end up with.
  listen,

  /// Rebuild the target sentence from a bank of chunks. Production with
  /// support: the learner supplies the order, not the spelling.
  build,

  /// Fill the one removed chunk. Targets the card's grammatical focus.
  cloze,

  /// Type the whole sentence from the French prompt. Free production.
  produce,
}

/// One item queued in a session.
class SessionItem {
  SessionItem({
    required this.card,
    required this.mode,
    required this.state,
    this.isNew = false,
  });

  final CardItem card;
  final ExerciseMode mode;
  final MemoryState state;
  final bool isNew;
}

/// Builds the study queue.
class SessionBuilder {
  const SessionBuilder({this.scheduler = const Scheduler()});

  final Scheduler scheduler;

  /// Cards whose due date has passed.
  List<CardItem> dueCards(Course course, LanguageProgress progress, DateTime now) {
    final due = <CardItem>[];
    for (final card in course.allCards) {
      final state = progress.states[card.id];
      if (state != null && !state.due.isAfter(now)) due.add(card);
    }
    // Most-overdue first: those are closest to being forgotten outright.
    due.sort((a, b) =>
        progress.states[a.id]!.due.compareTo(progress.states[b.id]!.due));
    return due;
  }

  /// Cards never studied, in curriculum order.
  List<CardItem> newCards(Course course, LanguageProgress progress) => [
        for (final card in course.allCards)
          if (!progress.states.containsKey(card.id)) card,
      ];

  /// Assembles a session.
  ///
  /// Reviews are always served before new material — letting new cards crowd
  /// out due ones is how a review backlog snowballs. New cards are then capped
  /// per session so the queue tomorrow stays survivable.
  List<SessionItem> build({
    required Course course,
    required LanguageProgress progress,
    required DateTime now,
    int maxItems = 20,
    int maxNew = 6,
    int? seed,
  }) {
    final random = math.Random(seed ?? now.millisecondsSinceEpoch);
    final items = <SessionItem>[];

    for (final card in dueCards(course, progress, now)) {
      if (items.length >= maxItems) break;
      final state = progress.states[card.id]!;
      items.add(SessionItem(
        card: card,
        mode: _modeFor(state, card, random),
        state: state,
      ));
    }

    final freshBudget = math.min(maxNew, maxItems - items.length);
    for (final card in newCards(course, progress).take(freshBudget)) {
      items.add(SessionItem(
        card: card,
        mode: ExerciseMode.recognize,
        state: MemoryState.fresh(now),
        isNew: true,
      ));
    }

    // Interleave rather than blocking by type. Mixing item kinds within a
    // session produces worse practice performance but better long-term
    // retention than practising one kind at a time.
    items.shuffle(random);
    return items;
  }

  /// Picks a presentation mode from the card's consolidation level.
  ExerciseMode _modeFor(MemoryState state, CardItem card, math.Random random) {
    final canBuild = card.tokens.length >= 3;

    if (state.stability < 2) {
      return canBuild ? ExerciseMode.build : ExerciseMode.recognize;
    }
    if (state.stability < 10) {
      return random.nextBool()
          ? ExerciseMode.listen
          : (canBuild ? ExerciseMode.build : ExerciseMode.recognize);
    }
    if (state.stability < 30) {
      return random.nextBool() ? ExerciseMode.cloze : ExerciseMode.listen;
    }
    // Well-consolidated: demand free production.
    return random.nextInt(3) == 0 ? ExerciseMode.cloze : ExerciseMode.produce;
  }

  /// Multiple-choice options for a recognition or listening item: the correct
  /// meaning plus meanings drawn from other cards in the same unit, which are
  /// thematically close enough to require actually knowing the answer.
  List<String> choicesFor({
    required Course course,
    required CardItem card,
    required math.Random random,
    int count = 4,
  }) {
    final unit = course.unitOf(card.id);
    final pool = <String>[
      for (final other in (unit?.cards ?? course.allCards))
        if (other.id != card.id) other.native,
    ];

    if (pool.length < count - 1) {
      pool.addAll([
        for (final other in course.allCards)
          if (other.id != card.id && !pool.contains(other.native)) other.native,
      ]);
    }

    pool.shuffle(random);
    final options = <String>[card.native, ...pool.take(count - 1)];
    options.shuffle(random);
    return options;
  }
}

/// Compares a typed answer against the expected sentence.
///
/// Accent marks, punctuation, capitalisation and doubled spaces are ignored:
/// a learner who typed the right sentence without the accent knew the answer,
/// and marking that wrong teaches nothing except distrust of the app. Tone
/// marks in pinyin are the one thing not stripped — they are part of the word.
class AnswerChecker {
  const AnswerChecker();

  String normalize(String input) {
    var text = input.toLowerCase().trim();
    const accents = {
      'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
      'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', 'ı': 'i',
      'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
      'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
      'ñ': 'n', 'ç': 'c', 'ş': 's', 'ğ': 'g',
    };
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(accents[char] ?? char);
    }
    text = buffer.toString();

    // Strip punctuation, keeping letters, digits, CJK and spaces.
    text = text.replaceAll(RegExp(r'''[.,!?;:¿¡"'’“”()\[\]-]'''), ' ');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool isCorrect(String answer, String expected) =>
      normalize(answer) == normalize(expected);

  /// 0..1 similarity, used to tell "almost right" from "not close".
  double similarity(String answer, String expected) {
    final a = normalize(answer);
    final b = normalize(expected);
    if (a.isEmpty || b.isEmpty) return 0;
    if (a == b) return 1;

    final distance = _levenshtein(a, b);
    return (1 - distance / math.max(a.length, b.length)).clamp(0.0, 1.0);
  }

  int _levenshtein(String a, String b) {
    var previous = List<int>.generate(b.length + 1, (i) => i);
    var current = List<int>.filled(b.length + 1, 0);

    for (var i = 0; i < a.length; i++) {
      current[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
        current[j + 1] = math.min(
          math.min(current[j] + 1, previous[j + 1] + 1),
          previous[j] + cost,
        );
      }
      final swap = previous;
      previous = current;
      current = swap;
    }
    return previous[b.length];
  }
}
