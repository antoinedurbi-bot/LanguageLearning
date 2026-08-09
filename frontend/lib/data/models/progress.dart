import 'package:learning_app/data/srs/scheduler.dart';

/// One learner's state for one language.
class LanguageProgress {
  LanguageProgress({
    required this.languageCode,
    Map<String, MemoryState>? states,
    this.streak = 0,
    this.bestStreak = 0,
    this.lastStudyDay,
    this.dailyGoal = 20,
    Map<String, int>? reviewsPerDay,
    this.totalReviews = 0,
    this.correctReviews = 0,
  })  : states = states ?? {},
        reviewsPerDay = reviewsPerDay ?? {};

  final String languageCode;

  /// Card id -> memory state. Cards absent from this map have never been seen.
  final Map<String, MemoryState> states;

  int streak;
  int bestStreak;

  /// Local calendar day of the last completed review, as yyyy-MM-dd.
  String? lastStudyDay;

  /// Number of cards the learner aims to review each day.
  int dailyGoal;

  /// yyyy-MM-dd -> reviews completed. Drives the activity heatmap.
  final Map<String, int> reviewsPerDay;

  int totalReviews;
  int correctReviews;

  double get accuracy =>
      totalReviews == 0 ? 0 : correctReviews / totalReviews;

  int get reviewsToday => reviewsPerDay[dayKey(DateTime.now())] ?? 0;

  int get learnedCount =>
      states.values.where((s) => s.stability >= 21).length;

  int get seenCount => states.length;

  static String dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// Records a completed review and rolls the streak forward.
  ///
  /// The streak advances only on the first review of a new day, and resets
  /// only when a full day was missed — so studying twice on Tuesday does not
  /// count as two days, and studying Monday then Tuesday keeps the chain.
  void registerReview({required bool correct, required DateTime now}) {
    final today = dayKey(now);
    if (lastStudyDay != today) {
      final yesterday = dayKey(now.subtract(const Duration(days: 1)));
      streak = lastStudyDay == yesterday ? streak + 1 : 1;
      if (streak > bestStreak) bestStreak = streak;
      lastStudyDay = today;
    }
    reviewsPerDay[today] = (reviewsPerDay[today] ?? 0) + 1;
    totalReviews += 1;
    if (correct) correctReviews += 1;
  }

  /// Drops heatmap entries older than a year so the stored blob stays small.
  void prune(DateTime now) {
    final cutoff = now.subtract(const Duration(days: 366));
    reviewsPerDay.removeWhere((key, _) {
      final date = DateTime.tryParse(key);
      return date == null || date.isBefore(cutoff);
    });
  }

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'states': {for (final e in states.entries) e.key: e.value.toJson()},
        'streak': streak,
        'bestStreak': bestStreak,
        'lastStudyDay': lastStudyDay,
        'dailyGoal': dailyGoal,
        'reviewsPerDay': reviewsPerDay,
        'totalReviews': totalReviews,
        'correctReviews': correctReviews,
      };

  static LanguageProgress fromJson(Map<String, dynamic> json, DateTime now) {
    final rawStates = json['states'];
    final states = <String, MemoryState>{};
    if (rawStates is Map) {
      rawStates.forEach((key, value) {
        if (value is Map) {
          states[key.toString()] =
              MemoryState.fromJson(Map<String, dynamic>.from(value), now);
        }
      });
    }

    final rawDays = json['reviewsPerDay'];
    final days = <String, int>{};
    if (rawDays is Map) {
      rawDays.forEach((key, value) {
        final count = value is num ? value.toInt() : null;
        if (count != null) days[key.toString()] = count;
      });
    }

    return LanguageProgress(
      languageCode: json['languageCode'] as String? ?? 'en',
      states: states,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      lastStudyDay: json['lastStudyDay'] as String?,
      dailyGoal: (json['dailyGoal'] as num?)?.toInt() ?? 20,
      reviewsPerDay: days,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      correctReviews: (json['correctReviews'] as num?)?.toInt() ?? 0,
    );
  }
}
