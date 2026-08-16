import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Which radicals the learner has marked as mastered.
///
/// Local-only, like the saved-items collection: this is a self-assessment, not a
/// scheduled review, so there is no scoring pipeline it needs to feed and no
/// conflict story worth building yet.
class RadicalProgressRepository {
  static const _key = 'radical_progress_v1';

  Future<Set<String>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return {};

      final decoded = jsonDecode(raw);
      if (decoded is! List) return {};
      return {for (final entry in decoded) entry.toString()};
    } catch (_) {
      return {};
    }
  }

  Future<void> save(Set<String> mastered) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(mastered.toList()));
  }
}
