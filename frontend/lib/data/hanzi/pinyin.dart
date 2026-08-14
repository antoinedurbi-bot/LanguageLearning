import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// A single-syllable word used as a tone-perception item.
class ToneExample {
  const ToneExample({
    required this.word,
    required this.pinyin,
    required this.syllable,
    required this.tone,
    required this.definition,
    required this.level,
  });

  final String word;
  final String pinyin;

  /// The syllable with its tone mark removed, e.g. `ma` for `mā`.
  final String syllable;

  /// 1-4. Neutral-tone syllables are not used as perception items because
  /// their pitch depends entirely on what precedes them.
  final int tone;
  final String definition;
  final int level;

  static ToneExample fromJson(Map<String, dynamic> json) => ToneExample(
        word: json['w'] as String? ?? '',
        pinyin: json['p'] as String? ?? '',
        syllable: json['s'] as String? ?? '',
        tone: (json['t'] as num?)?.toInt() ?? 0,
        definition: json['d'] as String? ?? '',
        level: (json['l'] as num?)?.toInt() ?? 0,
      );
}

/// A two-syllable word illustrating one tone combination.
class TonePairExample {
  const TonePairExample({
    required this.word,
    required this.pinyin,
    required this.definition,
    required this.first,
    required this.second,
  });

  final String word;
  final String pinyin;
  final String definition;
  final int first;

  /// 0 for a neutral second syllable.
  final int second;

  String get label => '$first-$second';
}

/// Everything the pinyin and tone trainers need.
class PinyinData {
  const PinyinData({
    required this.toneExamples,
    required this.tonePairs,
    required this.chart,
  });

  final List<ToneExample> toneExamples;

  /// Keyed by `"first-second"`, e.g. `"3-3"`.
  final Map<String, List<TonePairExample>> tonePairs;

  /// initial -> final -> the tones that syllable actually occurs with.
  /// An empty-string initial means a syllable with no initial consonant.
  final Map<String, Map<String, List<int>>> chart;

  List<ToneExample> examplesForTone(int tone) => [
        for (final e in toneExamples)
          if (e.tone == tone) e
      ];

  /// Initials in the order a pinyin chart conventionally lists them:
  /// by place of articulation, not alphabetically.
  static const initialOrder = [
    'b',
    'p',
    'm',
    'f',
    'd',
    't',
    'n',
    'l',
    'g',
    'k',
    'h',
    'j',
    'q',
    'x',
    'zh',
    'ch',
    'sh',
    'r',
    'z',
    'c',
    's',
    'y',
    'w',
    '',
  ];

  /// The 20 tone pairs, in a stable order.
  static List<String> get pairOrder => [
        for (var first = 1; first <= 4; first++)
          for (final second in [1, 2, 3, 4, 0]) '$first-$second',
      ];

  static PinyinData fromJson(Map<String, dynamic> json) {
    final pairs = <String, List<TonePairExample>>{};
    final rawPairs = json['tonePairs'] as Map<String, dynamic>? ?? {};
    rawPairs.forEach((key, value) {
      final tones = key.split('-');
      final first = int.tryParse(tones.first) ?? 0;
      final second = int.tryParse(tones.last) ?? 0;
      pairs[key] = [
        for (final entry in (value as List))
          TonePairExample(
            word: (entry as Map)['w'] as String? ?? '',
            pinyin: entry['p'] as String? ?? '',
            definition: entry['d'] as String? ?? '',
            first: first,
            second: second,
          ),
      ];
    });

    final chart = <String, Map<String, List<int>>>{};
    final rawChart = json['chart'] as Map<String, dynamic>? ?? {};
    rawChart.forEach((initial, finals) {
      chart[initial] = {
        for (final entry in (finals as Map).entries)
          entry.key.toString(): [
            for (final tone in (entry.value as List)) (tone as num).toInt(),
          ],
      };
    });

    return PinyinData(
      toneExamples: [
        for (final entry in (json['toneExamples'] as List? ?? const []))
          ToneExample.fromJson(Map<String, dynamic>.from(entry as Map)),
      ],
      tonePairs: pairs,
      chart: chart,
    );
  }
}

class PinyinRepository {
  PinyinRepository({this.assetBundleLoader});

  final Future<String> Function(String key)? assetBundleLoader;

  PinyinData? _cached;

  Future<PinyinData> load() async {
    final cached = _cached;
    if (cached != null) return cached;

    final raw = await (assetBundleLoader?.call('assets/data/pinyin.json') ??
        rootBundle.loadString('assets/data/pinyin.json'));
    final data = PinyinData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    _cached = data;
    return data;
  }
}

/// Places a tone mark on a plain syllable.
///
/// The rule is fixed and worth getting right, because a chart that renders
/// `guo` + 2nd tone as `guó` teaches the spelling convention for free, while
/// one that writes `gúo` teaches a mistake: the mark goes on `a`, `e` or `o`
/// when one is present, otherwise on the last vowel of the syllable.
class SyllableToneMark {
  const SyllableToneMark._();

  static const _marks = <String, List<String>>{
    'a': ['ā', 'á', 'ǎ', 'à'],
    'e': ['ē', 'é', 'ě', 'è'],
    'i': ['ī', 'í', 'ǐ', 'ì'],
    'o': ['ō', 'ó', 'ǒ', 'ò'],
    'u': ['ū', 'ú', 'ǔ', 'ù'],
    // `v` is how ü is typed on a keyboard without the umlaut.
    'v': ['ǖ', 'ǘ', 'ǚ', 'ǜ'],
    'ü': ['ǖ', 'ǘ', 'ǚ', 'ǜ'],
  };

  /// Returns [syllable] with the mark for [tone] (1-4). Tone 0 is neutral and
  /// carries no mark.
  static String apply(String syllable, int tone) {
    if (tone < 1 || tone > 4 || syllable.isEmpty) return syllable;

    var target = -1;
    for (final vowel in ['a', 'e', 'o']) {
      final index = syllable.indexOf(vowel);
      if (index >= 0) {
        target = index;
        break;
      }
    }
    if (target < 0) {
      for (var i = syllable.length - 1; i >= 0; i--) {
        if (_marks.containsKey(syllable[i])) {
          target = i;
          break;
        }
      }
    }
    if (target < 0) return syllable;

    return syllable.replaceRange(
      target,
      target + 1,
      _marks[syllable[target]]![tone - 1],
    );
  }
}

/// How a tone is described and drawn. Shared by the trainer and the grammar
/// lessons so a tone always looks the same everywhere in the app.
class ToneInfo {
  const ToneInfo({
    required this.number,
    required this.name,
    required this.contour,
    required this.mark,
  });

  final int number;
  final String name;
  final String contour;

  /// The diacritic as it appears on `a`.
  final String mark;

  static const all = [
    ToneInfo(
      number: 1,
      name: '1er ton',
      contour: 'haut et plat',
      mark: 'ā',
    ),
    ToneInfo(
      number: 2,
      name: '2e ton',
      contour: 'montant',
      mark: 'á',
    ),
    ToneInfo(
      number: 3,
      name: '3e ton',
      contour: 'descend puis remonte',
      mark: 'ǎ',
    ),
    ToneInfo(
      number: 4,
      name: '4e ton',
      contour: 'descendant, sec',
      mark: 'à',
    ),
    ToneInfo(
      number: 0,
      name: 'ton neutre',
      contour: 'court et sans hauteur propre',
      mark: 'a',
    ),
  ];

  static ToneInfo of(int number) =>
      all.firstWhere((t) => t.number == number, orElse: () => all.last);
}
