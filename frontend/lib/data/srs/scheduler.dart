import 'dart:math' as math;

/// How well the learner recalled a card. Mirrors the four-button grading used
/// by FSRS/Anki, because the grade has to carry more information than a
/// boolean for the stability update to mean anything.
enum Grade {
  /// Failed to recall. Resets stability to a short lapse interval.
  again(1),

  /// Recalled, but slowly and with effort.
  hard(2),

  /// Recalled correctly.
  good(3),

  /// Recalled instantly; the interval was too short.
  easy(4);

  const Grade(this.value);
  final int value;
}

/// Memory state for a single card, following the three-component model that
/// FSRS is built on: stability, difficulty and retrievability.
///
/// - **Stability (S)** is the number of days for recall probability to decay
///   from 100% to 90%.
/// - **Difficulty (D)**, on 1..10, is how resistant this item is to gaining
///   stability. It uses mean reversion, which is what keeps a few early
///   lapses from condemning a card to "ease hell" the way SM-2's ease factor
///   does.
/// - **Retrievability (R)** is derived, not stored: it falls out of stability
///   and the days elapsed since the last review.
class MemoryState {
  const MemoryState({
    required this.stability,
    required this.difficulty,
    required this.due,
    required this.lastReview,
    required this.reps,
    required this.lapses,
  });

  final double stability;
  final double difficulty;
  final DateTime due;
  final DateTime? lastReview;
  final int reps;
  final int lapses;

  /// A card that has never been reviewed. Due immediately.
  factory MemoryState.fresh(DateTime now) => MemoryState(
        stability: 0,
        difficulty: 0,
        due: now,
        lastReview: null,
        reps: 0,
        lapses: 0,
      );

  bool get isNew => reps == 0;

  Map<String, dynamic> toJson() => {
        'stability': stability,
        'difficulty': difficulty,
        'due': due.toIso8601String(),
        'lastReview': lastReview?.toIso8601String(),
        'reps': reps,
        'lapses': lapses,
      };

  static MemoryState fromJson(Map<String, dynamic> json, DateTime fallback) {
    DateTime parse(Object? value, DateTime or) =>
        value is String ? (DateTime.tryParse(value) ?? or) : or;

    double number(Object? value) => value is num ? value.toDouble() : 0;
    int count(Object? value) => value is num ? value.toInt() : 0;

    return MemoryState(
      stability: number(json['stability']),
      difficulty: number(json['difficulty']),
      due: parse(json['due'], fallback),
      lastReview:
          json['lastReview'] == null ? null : parse(json['lastReview'], fallback),
      reps: count(json['reps']),
      lapses: count(json['lapses']),
    );
  }
}

/// An FSRS-inspired scheduler.
///
/// This is a compact reimplementation of the FSRS-4.5 update rules with the
/// published default weights. It is not a trained-per-user model — there is no
/// review history corpus here to optimise against — but it keeps the parts
/// that produce FSRS's advantage over SM-2: a power-law forgetting curve, a
/// stability increase that depends on how *due* the card was when reviewed,
/// and mean-reverting difficulty.
class Scheduler {
  const Scheduler({this.requestedRetention = 0.9});

  /// Target probability of recall at review time. 0.9 is the standard
  /// trade-off between workload and retention.
  final double requestedRetention;

  /// FSRS-4.5 default weights.
  static const List<double> _w = [
    0.4872, 1.4003, 3.7145, 13.8206, // initial stability per grade
    5.1618, 1.2298, 0.8975, 0.031, // difficulty terms
    1.6474, 0.1367, 1.0461, // stability growth
    2.1072, 0.0793, 0.3246, 1.587, // lapse terms
    0.2272, 2.8755, // easy bonus / hard penalty
  ];

  static const double _decay = -0.5;
  static double get _factor => math.pow(0.9, 1 / _decay) - 1;

  /// Probability the learner still recalls the card after [elapsedDays].
  ///
  /// Power-law forgetting: R = (1 + f * t / S) ^ decay.
  double retrievability(double stability, double elapsedDays) {
    if (stability <= 0) return 0;
    return math.pow(1 + _factor * elapsedDays / stability, _decay).toDouble();
  }

  /// Days until recall probability falls to [requestedRetention].
  int intervalFor(double stability) {
    if (stability <= 0) return 0;
    final raw = (stability / _factor) *
        (math.pow(requestedRetention, 1 / _decay) - 1);
    return raw.round().clamp(1, 3650);
  }

  double _initialStability(Grade grade) =>
      math.max(_w[grade.value - 1], 0.1);

  double _initialDifficulty(Grade grade) =>
      (_w[4] - math.exp(_w[5] * (grade.value - 1)) + 1).clamp(1.0, 10.0);

  double _nextDifficulty(double difficulty, Grade grade) {
    final delta = -_w[6] * (grade.value - 3);
    final updated = difficulty + delta * ((10 - difficulty) / 9);
    // Mean reversion toward the difficulty of an "easy" first answer: this is
    // the mechanism that lets a card recover after early failures.
    final reverted =
        _w[7] * _initialDifficulty(Grade.easy) + (1 - _w[7]) * updated;
    return reverted.clamp(1.0, 10.0);
  }

  double _stabilityAfterRecall({
    required double stability,
    required double difficulty,
    required double retrievabilityNow,
    required Grade grade,
  }) {
    final hardPenalty = grade == Grade.hard ? _w[15] : 1.0;
    final easyBonus = grade == Grade.easy ? _w[16] : 1.0;

    // The (e^(w10 * (1-R)) - 1) term is the "spacing effect": reviewing a card
    // when it is nearly forgotten grows stability far more than reviewing one
    // that is still fresh.
    final growth = math.exp(_w[8]) *
        (11 - difficulty) *
        math.pow(stability, -_w[9]) *
        (math.exp(_w[10] * (1 - retrievabilityNow)) - 1) *
        hardPenalty *
        easyBonus;

    return (stability * (1 + growth)).clamp(0.1, 3650.0);
  }

  double _stabilityAfterLapse({
    required double stability,
    required double difficulty,
    required double retrievabilityNow,
  }) {
    final value = _w[11] *
        math.pow(difficulty, -_w[12]) *
        (math.pow(stability + 1, _w[13]) - 1) *
        math.exp(_w[14] * (1 - retrievabilityNow));
    return math.min(value.toDouble(), stability).clamp(0.1, 3650.0);
  }

  /// Applies a review and returns the updated memory state.
  MemoryState review(MemoryState state, Grade grade, DateTime now) {
    if (state.isNew) {
      final stability = _initialStability(grade);
      final difficulty = _initialDifficulty(grade);
      return MemoryState(
        stability: stability,
        difficulty: difficulty,
        // A failed first attempt comes back inside the same session rather
        // than tomorrow.
        due: grade == Grade.again
            ? now.add(const Duration(minutes: 5))
            : now.add(Duration(days: intervalFor(stability))),
        lastReview: now,
        reps: 1,
        lapses: grade == Grade.again ? 1 : 0,
      );
    }

    final elapsed = state.lastReview == null
        ? 0.0
        : now.difference(state.lastReview!).inMinutes / (60 * 24);
    final r = retrievability(state.stability, math.max(elapsed, 0));
    final difficulty = _nextDifficulty(state.difficulty, grade);

    final stability = grade == Grade.again
        ? _stabilityAfterLapse(
            stability: state.stability,
            difficulty: difficulty,
            retrievabilityNow: r,
          )
        : _stabilityAfterRecall(
            stability: state.stability,
            difficulty: difficulty,
            retrievabilityNow: r,
            grade: grade,
          );

    return MemoryState(
      stability: stability,
      difficulty: difficulty,
      due: grade == Grade.again
          ? now.add(const Duration(minutes: 5))
          : now.add(Duration(days: intervalFor(stability))),
      lastReview: now,
      reps: state.reps + 1,
      lapses: state.lapses + (grade == Grade.again ? 1 : 0),
    );
  }

  /// Human-readable preview of when a card returns for each grade, shown on
  /// the grading buttons so the learner understands the consequence of the
  /// choice they are about to make.
  String previewInterval(MemoryState state, Grade grade, DateTime now) {
    final next = review(state, grade, now);
    final minutes = next.due.difference(now).inMinutes;
    if (minutes < 60) return '${math.max(minutes, 1)} min';
    final days = next.due.difference(now).inHours / 24;
    if (days < 1) return '${next.due.difference(now).inHours} h';
    if (days < 30) return '${days.round()} j';
    if (days < 365) return '${(days / 30).round()} mois';
    return '${(days / 365).toStringAsFixed(1)} ans';
  }
}
