import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Which chengyu the learner has marked as known. Local-only, mirroring the
/// radical progress store: a self-assessment, not a scheduled review.
class ChengyuProgressRepository {
  static const _key = 'chengyu_progress_v1';

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

  Future<void> save(Set<String> known) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(known.toList()));
  }
}
