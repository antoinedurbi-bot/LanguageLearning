import 'dart:convert';
import 'dart:ui' show Offset;

import 'package:flutter/services.dart' show rootBundle;

/// A single character, with everything needed to display and to write it.
class Hanzi {
  const Hanzi({
    required this.character,
    required this.pinyin,
    required this.definition,
    required this.radical,
    required this.decomposition,
    required this.strokeCount,
    required this.hskLevel,
    required this.strokes,
    required this.medians,
  });

  final String character;

  /// Readings, most common first. A character can have several (多音字).
  final List<String> pinyin;

  /// English gloss from the upstream dictionary. Shown labelled as such —
  /// the app is in French, and pretending otherwise would be misleading.
  final String definition;

  /// The radical (部首): the component under which the character is
  /// traditionally indexed, and usually the one carrying its meaning class.
  final String radical;

  /// Ideographic description sequence, e.g. `⿰亻尔` for 你 — the leading
  /// character says *how* the parts are arranged, the rest are the parts.
  final String decomposition;

  final int strokeCount;

  /// 1 or 2 for the bundled HSK bands, 0 when the character is only used by
  /// the course and is not itself in HSK 1-2.
  final int hskLevel;

  /// Outline of each stroke, in writing order, as SVG path data.
  final List<String> strokes;

  /// Spine of each stroke, in writing order. Used both to animate the ink
  /// and to score a learner's finger tracing.
  final List<List<Offset>> medians;

  bool get hasStrokeData =>
      strokes.isNotEmpty && strokes.length == medians.length;

  /// The arrangement symbol at the head of [decomposition], if any.
  String? get structure {
    if (decomposition.isEmpty) return null;
    final head = decomposition[0];
    return _structureNames.containsKey(head) ? head : null;
  }

  /// Human-readable description of how the parts are laid out.
  String? get structureLabel => _structureNames[structure];

  /// The component characters, with the arrangement symbols and the
  /// placeholder `？` (used upstream for parts with no Unicode point)
  /// removed.
  List<String> get components => [
        for (final ch in decomposition.split(''))
          if (!_structureNames.containsKey(ch) && ch != '？') ch,
      ];

  static const _structureNames = <String, String>{
    '⿰': 'gauche-droite',
    '⿱': 'haut-bas',
    '⿲': 'trois colonnes',
    '⿳': 'trois etages',
    '⿴': 'encadre',
    '⿵': 'entoure par le haut',
    '⿶': 'entoure par le bas',
    '⿷': 'entoure par la gauche',
    '⿸': 'coin haut-gauche',
    '⿹': 'coin haut-droit',
    '⿺': 'coin bas-gauche',
    '⿻': 'superpose',
  };

  static Hanzi fromJson(String character, Map<String, dynamic> json) {
    return Hanzi(
      character: character,
      pinyin: [
        for (final p in (json['p'] as List? ?? const [])) p.toString(),
      ],
      definition: json['d'] as String? ?? '',
      radical: json['r'] as String? ?? '',
      decomposition: json['c'] as String? ?? '',
      strokeCount: (json['n'] as num?)?.toInt() ?? 0,
      hskLevel: (json['h'] as num?)?.toInt() ?? 0,
      strokes: [
        for (final s in (json['s'] as List? ?? const [])) s.toString(),
      ],
      medians: [
        for (final stroke in (json['m'] as List? ?? const []))
          [
            for (final point in (stroke as List))
              Offset(
                ((point as List)[0] as num).toDouble(),
                (point[1] as num).toDouble(),
              ),
          ],
      ],
    );
  }
}

/// An HSK vocabulary entry (a word, which may be one or several characters).
class HskWord {
  const HskWord({
    required this.word,
    required this.pinyin,
    required this.definition,
    required this.level,
    required this.frequency,
  });

  final String word;
  final String pinyin;

  /// English gloss, as with [Hanzi.definition].
  final String definition;
  final int level;

  /// Corpus frequency rank; lower is more common.
  final int frequency;

  static HskWord fromJson(Map<String, dynamic> json) => HskWord(
        word: json['w'] as String? ?? '',
        pinyin: json['p'] as String? ?? '',
        definition: json['d'] as String? ?? '',
        level: (json['l'] as num?)?.toInt() ?? 0,
        frequency: (json['f'] as num?)?.toInt() ?? 0,
      );
}

/// Loads and caches the bundled Chinese data.
///
/// Both assets are a couple of megabytes of JSON, so they are decoded once,
/// lazily, on first use — a learner who never opens the Chinese section never
/// pays for them.
class HanziRepository {
  HanziRepository({this.assetBundleLoader});

  /// Injection point for tests, which supply fixtures instead of the real
  /// (large) bundled assets.
  final Future<String> Function(String key)? assetBundleLoader;

  Map<String, Hanzi>? _characters;
  List<HskWord>? _words;

  Future<String> _load(String key) =>
      assetBundleLoader?.call(key) ?? rootBundle.loadString(key);

  Future<Map<String, Hanzi>> characters() async {
    final cached = _characters;
    if (cached != null) return cached;

    final raw = await _load('assets/data/hanzi.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final entries = decoded['characters'] as Map<String, dynamic>;

    final result = <String, Hanzi>{
      for (final entry in entries.entries)
        entry.key: Hanzi.fromJson(
          entry.key,
          Map<String, dynamic>.from(entry.value as Map),
        ),
    };
    _characters = result;
    return result;
  }

  Future<List<HskWord>> words() async {
    final cached = _words;
    if (cached != null) return cached;

    final raw = await _load('assets/data/hsk_words.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final result = [
      for (final word in (decoded['words'] as List))
        HskWord.fromJson(Map<String, dynamic>.from(word as Map)),
    ];
    _words = result;
    return result;
  }

  Future<Hanzi?> character(String ch) async => (await characters())[ch];

  /// Characters of a word that have stroke data, in order.
  Future<List<Hanzi>> charactersOf(String word) async {
    final all = await characters();
    return [
      for (final ch in word.split(''))
        if (all[ch] != null) all[ch]!,
    ];
  }

  /// Searches characters and words by character, pinyin or gloss.
  ///
  /// Pinyin is matched with tone marks stripped, so typing "ni hao" or
  /// "nihao" finds 你好 without the learner having to produce diacritics on
  /// a French keyboard.
  Future<HanziSearchResults> search(String query, {int limit = 40}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const HanziSearchResults(characters: [], words: []);
    }

    final needle = stripTones(trimmed.toLowerCase());
    final all = await characters();
    final vocabulary = await words();

    final matchedChars = <Hanzi>[];
    for (final hanzi in all.values) {
      if (hanzi.character == trimmed ||
          trimmed.contains(hanzi.character) ||
          hanzi.pinyin
              .any((p) => stripTones(p.toLowerCase()).startsWith(needle)) ||
          hanzi.definition.toLowerCase().contains(needle)) {
        matchedChars.add(hanzi);
      }
      if (matchedChars.length >= limit) break;
    }

    final matchedWords = <HskWord>[];
    for (final word in vocabulary) {
      if (word.word.contains(trimmed) ||
          stripTones(word.pinyin.toLowerCase())
              .replaceAll(' ', '')
              .startsWith(needle.replaceAll(' ', '')) ||
          word.definition.toLowerCase().contains(needle)) {
        matchedWords.add(word);
      }
      if (matchedWords.length >= limit) break;
    }

    return HanziSearchResults(characters: matchedChars, words: matchedWords);
  }

  /// Removes pinyin tone diacritics, so `nǐ` and `ni` compare equal.
  static String stripTones(String input) {
    const table = {
      'ā': 'a',
      'á': 'a',
      'ǎ': 'a',
      'à': 'a',
      'ē': 'e',
      'é': 'e',
      'ě': 'e',
      'è': 'e',
      'ī': 'i',
      'í': 'i',
      'ǐ': 'i',
      'ì': 'i',
      'ō': 'o',
      'ó': 'o',
      'ǒ': 'o',
      'ò': 'o',
      'ū': 'u',
      'ú': 'u',
      'ǔ': 'u',
      'ù': 'u',
      'ǖ': 'v',
      'ǘ': 'v',
      'ǚ': 'v',
      'ǜ': 'v',
      'ü': 'v',
      'ń': 'n',
      'ň': 'n',
      'ǹ': 'n',
    };
    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      buffer.write(table[ch] ?? ch);
    }
    return buffer.toString();
  }
}

class HanziSearchResults {
  const HanziSearchResults({required this.characters, required this.words});

  final List<Hanzi> characters;
  final List<HskWord> words;

  bool get isEmpty => characters.isEmpty && words.isEmpty;
}
