import 'package:shared_preferences/shared_preferences.dart';

/// Whether the placement quiz has already been shown (completed or
/// deliberately skipped) for a given language.
///
/// Local-only and per-language, same shape as [RadicalProgressRepository]:
/// this is a one-time onboarding flag, not learning data that needs to sync
/// or survive a progress reset.
class PlacementRepository {
  static const _seenPrefix = 'placement_seen_v1_';
  static const _recommendedPrefix = 'placement_recommended_v1_';

  Future<bool> hasSeen(String languageCode) async =>
      (await SharedPreferences.getInstance())
          .getBool('$_seenPrefix$languageCode') ??
      false;

  /// Marks the quiz as shown, optionally recording the recommended unit
  /// index (null when the learner skipped rather than completed it).
  Future<void> markSeen(String languageCode, {int? recommendedUnit}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_seenPrefix$languageCode', true);
    if (recommendedUnit != null) {
      await prefs.setInt(
          '$_recommendedPrefix$languageCode', recommendedUnit);
    }
  }

  Future<int?> recommendedUnit(String languageCode) async =>
      (await SharedPreferences.getInstance())
          .getInt('$_recommendedPrefix$languageCode');
}
