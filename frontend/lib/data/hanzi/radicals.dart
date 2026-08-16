import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// A Kangxi radical (部首): the component every paper and digital Chinese
/// dictionary indexes characters under.
///
/// Radicals are worth teaching as their own mini-curriculum, separately from
/// the characters that contain them, for the same reason prefixes and
/// suffixes are worth teaching separately from the words that contain them:
/// once a learner recognises 氵 as "water" on sight, every character built on
/// it — 河, 海, 汉, 泳 — stops being an arbitrary shape and starts being a
/// shape with a clue in it.
class Radical {
  const Radical({
    required this.radical,
    required this.pinyin,
    required this.meaning,
    required this.strokeCount,
    required this.characterCount,
    required this.examples,
  });

  final String radical;
  final String pinyin;

  /// French gloss of what the radical originally depicts or suggests.
  final String meaning;

  /// Strokes in the radical's own written form.
  final int strokeCount;

  /// How many bundled characters use this radical — also its teaching
  /// priority: the radicals worth learning first are the ones that unlock
  /// the most characters.
  final int characterCount;

  /// Characters (from the app's own bundled set) that use this radical,
  /// easiest first. Never empty: a radical with no bundled examples was
  /// dropped when the asset was built.
  final List<String> examples;

  static Radical fromJson(Map<String, dynamic> json) => Radical(
        radical: json['r'] as String? ?? '',
        pinyin: json['p'] as String? ?? '',
        meaning: json['m'] as String? ?? '',
        strokeCount: (json['n'] as num?)?.toInt() ?? 0,
        characterCount: (json['count'] as num?)?.toInt() ?? 0,
        examples: [
          for (final ch in (json['examples'] as List? ?? const []))
            ch.toString(),
        ],
      );
}

/// Loads and caches the bundled radical curriculum.
class RadicalRepository {
  RadicalRepository({this.assetBundleLoader});

  /// Injection point for tests, which supply fixtures instead of the real
  /// bundled asset.
  final Future<String> Function(String key)? assetBundleLoader;

  List<Radical>? _cached;

  Future<String> _load(String key) =>
      assetBundleLoader?.call(key) ?? rootBundle.loadString(key);

  /// All radicals, in teaching order: the ones that unlock the most bundled
  /// characters come first.
  Future<List<Radical>> radicals() async {
    final cached = _cached;
    if (cached != null) return cached;

    final raw = await _load('assets/data/radicals.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final result = [
      for (final entry in (decoded['radicals'] as List))
        Radical.fromJson(Map<String, dynamic>.from(entry as Map)),
    ];
    _cached = result;
    return result;
  }
}
