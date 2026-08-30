import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What kind of thing was saved.
enum SavedKind { word, phrase, sentence }

/// An item the learner deliberately kept.
///
/// The saved text is stored, not just an id: a collection that breaks when the
/// content files are reorganised would silently lose the learner's own work,
/// which is the one thing in the app that cannot be regenerated.
class SavedItem {
  const SavedItem({
    required this.id,
    required this.kind,
    required this.target,
    required this.native,
    required this.savedAt,
    this.romanization,
    this.note,
  });

  final String id;
  final SavedKind kind;
  final String target;
  final String native;
  final DateTime savedAt;
  final String? romanization;
  final String? note;

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'target': target,
        'native': native,
        'savedAt': savedAt.toIso8601String(),
        'romanization': romanization,
        'note': note,
      };

  static SavedItem? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || id.isEmpty) return null;
    return SavedItem(
      id: id,
      kind: SavedKind.values.firstWhere(
        (k) => k.name == json['kind'],
        orElse: () => SavedKind.word,
      ),
      target: json['target'] as String? ?? '',
      native: json['native'] as String? ?? '',
      savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      romanization: json['romanization'] as String?,
      note: json['note'] as String?,
    );
  }
}

/// The learner's own material for one language: saved items, and the answers
/// they wrote for their language islands.
class LanguageCollection {
  LanguageCollection({
    required this.languageCode,
    Map<String, SavedItem>? saved,
    Map<String, String>? islandAnswers,
  })  : saved = saved ?? {},
        islandAnswers = islandAnswers ?? {};

  final String languageCode;

  /// Keyed by item id so saving twice is idempotent.
  final Map<String, SavedItem> saved;

  /// Keyed by `"islandId/promptId"`.
  final Map<String, String> islandAnswers;

  List<SavedItem> get items {
    final list = saved.values.toList();
    // Most recently saved first: the thing just kept is the thing most likely
    // to be looked at next.
    list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return list;
  }

  List<SavedItem> itemsOfKind(SavedKind kind) =>
      [for (final item in items) if (item.kind == kind) item];

  bool contains(String id) => saved.containsKey(id);

  String answerFor(String islandId, String promptId) =>
      islandAnswers['$islandId/$promptId'] ?? '';

  /// How many of an island's prompts have a non-empty answer.
  int answeredCount(String islandId, List<String> promptIds) {
    var count = 0;
    for (final promptId in promptIds) {
      if (answerFor(islandId, promptId).trim().isNotEmpty) count++;
    }
    return count;
  }

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'saved': {for (final e in saved.entries) e.key: e.value.toJson()},
        'islandAnswers': islandAnswers,
      };

  static LanguageCollection fromJson(Map<String, dynamic> json) {
    final saved = <String, SavedItem>{};
    final rawSaved = json['saved'];
    if (rawSaved is Map) {
      rawSaved.forEach((key, value) {
        if (value is Map) {
          final item = SavedItem.fromJson(Map<String, dynamic>.from(value));
          if (item != null) saved[key.toString()] = item;
        }
      });
    }

    final answers = <String, String>{};
    final rawAnswers = json['islandAnswers'];
    if (rawAnswers is Map) {
      rawAnswers.forEach((key, value) {
        if (value is String) answers[key.toString()] = value;
      });
    }

    return LanguageCollection(
      languageCode: json['languageCode'] as String? ?? 'en',
      saved: saved,
      islandAnswers: answers,
    );
  }
}

/// Stores the collection locally.
///
/// Deliberately local-only for now. Unlike review scheduling, this is content
/// the learner typed; syncing it needs a conflict story that does not exist
/// yet, and silently overwriting someone's own sentences would be worse than
/// not syncing at all.
class CollectionRepository {
  static const _prefix = 'collection_v1_';

  Future<LanguageCollection> load(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$languageCode');
      if (raw == null) return LanguageCollection(languageCode: languageCode);

      final decoded = jsonDecode(raw);
      if (decoded is! Map) return LanguageCollection(languageCode: languageCode);
      return LanguageCollection.fromJson(Map<String, dynamic>.from(decoded));
    } catch (error) {
      debugPrint('Collection unreadable, starting empty: $error');
      return LanguageCollection(languageCode: languageCode);
    }
  }

  Future<void> save(LanguageCollection collection) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix${collection.languageCode}',
      jsonEncode(collection.toJson()),
    );
  }

  Future<void> clear(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$languageCode');
  }
}
