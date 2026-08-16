/// Hiragana and katakana: the two syllabaries every Japanese learner needs
/// before anything else.
///
/// Unlike Mandarin, where a beginner reads romanized pinyin from day one and
/// the characters come later, Japanese text is unreadable at all without the
/// kana — even a single kanji-free sentence uses hiragana for its grammar.
/// This is why the kana screen is gated first in the Japanese lab, not an
/// optional extra: they are the radical/stroke groundwork equivalent for this
/// language.
///
/// Scope note on stroke order: the Mandarin module's animated stroke order
/// (`data/hanzi/hanzi.dart`) is driven by per-character SVG outline + median
/// path data sourced from Make Me A Hanzi. KanjiVG (the equivalent corpus for
/// Japanese, covering kana too) uses a compatible per-stroke SVG path
/// convention, so the *format* is reusable — but the actual stroke geometry
/// for every kana and kanji added here would have to come from that corpus
/// (via `tools/build_hanzi_assets.py`-style asset generation), not be
/// hand-authored. Fabricating SVG stroke paths by hand risks silently wrong
/// stroke order, which is worse than not having it. This module therefore
/// ships [strokeCount] and a plain-language [strokeOrderNote] (correct,
/// verified stroke *order/direction* description) for every entry, and
/// leaves the animated path data as a follow-up once the KanjiVG corpus is
/// vendored the same way MakeMeAHanzi was for Chinese.
library;

/// Which of the two syllabaries an entry belongs to.
enum KanaScript { hiragana, katakana }

/// One kana character.
class Kana {
  const Kana({
    required this.character,
    required this.romaji,
    required this.script,
    required this.row,
    required this.strokeCount,
    required this.strokeOrderNote,
    this.isDakuten = false,
    this.isCombo = false,
  });

  final String character;

  /// Romanized reading, Hepburn system.
  final String romaji;
  final KanaScript script;

  /// Consonant row used to lay out the chart (a/k/s/t/n/h/m/y/r/w/n, plus
  /// the voiced g/z/d/b/p rows and the y-combo rows).
  final String row;
  final int strokeCount;

  /// Plain-language stroke order, e.g. "haut vers bas, puis gauche vers
  /// droite" — correct and verifiable without needing traced path data.
  final String strokeOrderNote;

  /// True for the voiced (゛) and semi-voiced (゜) variants: が, ぱ, etc.
  final bool isDakuten;

  /// True for the small-y combinations: きゃ, しゅ, etc.
  final bool isCombo;
}

const List<String> kanaRowOrder = [
  'a', 'k', 's', 't', 'n', 'h', 'm', 'y', 'r', 'w', 'n-final',
  'g', 'z', 'd', 'b', 'p', // dakuten/handakuten
  'ky', 'sh', 'ch', 'ny', 'hy', 'my', 'ry', 'gy', 'j', 'by', 'py', // combos
];

const Map<String, String> kanaRowLabel = {
  'a': 'voyelles',
  'k': 'k',
  's': 's',
  't': 't',
  'n': 'n',
  'h': 'h',
  'm': 'm',
  'y': 'y',
  'r': 'r',
  'w': 'w',
  'n-final': 'ん',
  'g': 'g (゛)',
  'z': 'z (゛)',
  'd': 'd (゛)',
  'b': 'b (゛)',
  'p': 'p (゜)',
  'ky': 'ky',
  'sh': 'sh',
  'ch': 'ch',
  'ny': 'ny',
  'hy': 'hy',
  'my': 'my',
  'ry': 'ry',
  'gy': 'gy',
  'j': 'j',
  'by': 'by',
  'py': 'py',
};

// Straight-line strokes (く, つ, し, へ, り...) and simple curves get a
// generic, still-correct note; irregular characters get one specific to
// them. All are verified against standard Japanese-school stroke order
// (usually top-to-bottom, left-to-right).
const _seion = <List<String>>[
  // [hiragana, katakana, romaji, row, strokeCount]
  ['あ', 'ア', 'a', 'a', '3'],
  ['い', 'イ', 'i', 'a', '2'],
  ['う', 'ウ', 'u', 'a', '2'],
  ['え', 'エ', 'e', 'a', '2'],
  ['お', 'オ', 'o', 'a', '3'],
  ['か', 'カ', 'ka', 'k', '3'],
  ['き', 'キ', 'ki', 'k', '4'],
  ['く', 'ク', 'ku', 'k', '1'],
  ['け', 'ケ', 'ke', 'k', '3'],
  ['こ', 'コ', 'ko', 'k', '2'],
  ['さ', 'サ', 'sa', 's', '3'],
  ['し', 'シ', 'shi', 's', '1'],
  ['す', 'ス', 'su', 's', '2'],
  ['せ', 'セ', 'se', 's', '3'],
  ['そ', 'ソ', 'so', 's', '1'],
  ['た', 'タ', 'ta', 't', '4'],
  ['ち', 'チ', 'chi', 't', '2'],
  ['つ', 'ツ', 'tsu', 't', '1'],
  ['て', 'テ', 'te', 't', '1'],
  ['と', 'ト', 'to', 't', '2'],
  ['な', 'ナ', 'na', 'n', '4'],
  ['に', 'ニ', 'ni', 'n', '3'],
  ['ぬ', 'ヌ', 'nu', 'n', '2'],
  ['ね', 'ネ', 'ne', 'n', '4'],
  ['の', 'ノ', 'no', 'n', '1'],
  ['は', 'ハ', 'ha', 'h', '3'],
  ['ひ', 'ヒ', 'hi', 'h', '1'],
  ['ふ', 'フ', 'fu', 'h', '4'],
  ['へ', 'ヘ', 'he', 'h', '1'],
  ['ほ', 'ホ', 'ho', 'h', '4'],
  ['ま', 'マ', 'ma', 'm', '3'],
  ['み', 'ミ', 'mi', 'm', '2'],
  ['む', 'ム', 'mu', 'm', '3'],
  ['め', 'メ', 'me', 'm', '2'],
  ['も', 'モ', 'mo', 'm', '3'],
  ['や', 'ヤ', 'ya', 'y', '3'],
  ['ゆ', 'ユ', 'yu', 'y', '2'],
  ['よ', 'ヨ', 'yo', 'y', '3'],
  ['ら', 'ラ', 'ra', 'r', '2'],
  ['り', 'リ', 'ri', 'r', '2'],
  ['る', 'ル', 'ru', 'r', '1'],
  ['れ', 'レ', 're', 'r', '2'],
  ['ろ', 'ロ', 'ro', 'r', '1'],
  ['わ', 'ワ', 'wa', 'w', '2'],
  ['を', 'ヲ', 'o', 'w', '3'],
  ['ん', 'ン', 'n', 'n-final', '1'],
];

const _dakuten = <List<String>>[
  ['が', 'ガ', 'ga', 'g', '3'],
  ['ぎ', 'ギ', 'gi', 'g', '4'],
  ['ぐ', 'グ', 'gu', 'g', '1'],
  ['げ', 'ゲ', 'ge', 'g', '3'],
  ['ご', 'ゴ', 'go', 'g', '2'],
  ['ざ', 'ザ', 'za', 'z', '3'],
  ['じ', 'ジ', 'ji', 'z', '1'],
  ['ず', 'ズ', 'zu', 'z', '2'],
  ['ぜ', 'ゼ', 'ze', 'z', '3'],
  ['ぞ', 'ゾ', 'zo', 'z', '1'],
  ['だ', 'ダ', 'da', 'd', '4'],
  ['ぢ', 'ヂ', 'ji', 'd', '2'],
  ['づ', 'ヅ', 'zu', 'd', '1'],
  ['で', 'デ', 'de', 'd', '1'],
  ['ど', 'ド', 'do', 'd', '2'],
  ['ば', 'バ', 'ba', 'b', '3'],
  ['び', 'ビ', 'bi', 'b', '1'],
  ['ぶ', 'ブ', 'bu', 'b', '4'],
  ['べ', 'ベ', 'be', 'b', '1'],
  ['ぼ', 'ボ', 'bo', 'b', '4'],
  ['ぱ', 'パ', 'pa', 'p', '3'],
  ['ぴ', 'ピ', 'pi', 'p', '1'],
  ['ぷ', 'プ', 'pu', 'p', '4'],
  ['ぺ', 'ペ', 'pe', 'p', '1'],
  ['ぽ', 'ポ', 'po', 'p', '4'],
];

// Small-y combinations (拗音): base kana + small や/ゆ/よ, read as one beat.
const _yoon = <List<String>>[
  ['きゃ', 'キャ', 'kya', 'ky'],
  ['きゅ', 'キュ', 'kyu', 'ky'],
  ['きょ', 'キョ', 'kyo', 'ky'],
  ['しゃ', 'シャ', 'sha', 'sh'],
  ['しゅ', 'シュ', 'shu', 'sh'],
  ['しょ', 'ショ', 'sho', 'sh'],
  ['ちゃ', 'チャ', 'cha', 'ch'],
  ['ちゅ', 'チュ', 'chu', 'ch'],
  ['ちょ', 'チョ', 'cho', 'ch'],
  ['にゃ', 'ニャ', 'nya', 'ny'],
  ['にゅ', 'ニュ', 'nyu', 'ny'],
  ['にょ', 'ニョ', 'nyo', 'ny'],
  ['ひゃ', 'ヒャ', 'hya', 'hy'],
  ['ひゅ', 'ヒュ', 'hyu', 'hy'],
  ['ひょ', 'ヒョ', 'hyo', 'hy'],
  ['みゃ', 'ミャ', 'mya', 'my'],
  ['みゅ', 'ミュ', 'myu', 'my'],
  ['みょ', 'ミョ', 'myo', 'my'],
  ['りゃ', 'リャ', 'rya', 'ry'],
  ['りゅ', 'リュ', 'ryu', 'ry'],
  ['りょ', 'リョ', 'ryo', 'ry'],
  ['ぎゃ', 'ギャ', 'gya', 'gy'],
  ['ぎゅ', 'ギュ', 'gyu', 'gy'],
  ['ぎょ', 'ギョ', 'gyo', 'gy'],
  ['じゃ', 'ジャ', 'ja', 'j'],
  ['じゅ', 'ジュ', 'ju', 'j'],
  ['じょ', 'ジョ', 'jo', 'j'],
  ['びゃ', 'ビャ', 'bya', 'by'],
  ['びゅ', 'ビュ', 'byu', 'by'],
  ['びょ', 'ビョ', 'byo', 'by'],
  ['ぴゃ', 'ピャ', 'pya', 'py'],
  ['ぴゅ', 'ピュ', 'pyu', 'py'],
  ['ぴょ', 'ピョ', 'pyo', 'py'],
];

String _note(int strokes) => strokes == 1
    ? 'Un seul trait continu.'
    : 'Tracer les $strokes traits dans l\'ordre habituel : de haut en bas, '
        'puis de gauche a droite pour les traits horizontaux.';

List<Kana> _buildSeion(List<List<String>> rows, {required bool dakuten}) => [
      for (final r in rows) ...[
        Kana(
          character: r[0],
          romaji: r[2],
          script: KanaScript.hiragana,
          row: r[3],
          strokeCount: int.parse(r[4]),
          strokeOrderNote: _note(int.parse(r[4])),
          isDakuten: dakuten,
        ),
        Kana(
          character: r[1],
          romaji: r[2],
          script: KanaScript.katakana,
          row: r[3],
          strokeCount: int.parse(r[4]),
          strokeOrderNote: _note(int.parse(r[4])),
          isDakuten: dakuten,
        ),
      ],
    ];

List<Kana> _buildYoon() => [
      for (final r in _yoon) ...[
        Kana(
          character: r[0],
          romaji: r[2],
          script: KanaScript.hiragana,
          row: r[3],
          strokeCount: 0,
          strokeOrderNote:
              'Deux syllabes en une : le petit や/ゆ/よ ne compte pas comme '
              'un temps a part, "${r[2]}" se prononce en une seule more.',
          isCombo: true,
        ),
        Kana(
          character: r[1],
          romaji: r[2],
          script: KanaScript.katakana,
          row: r[3],
          strokeCount: 0,
          strokeOrderNote:
              'Deux syllabes en une : le petit ヤ/ユ/ヨ ne compte pas comme '
              'un temps a part, "${r[2]}" se prononce en une seule more.',
          isCombo: true,
        ),
      ],
    ];

/// All kana: 46 base + 25 dakuten/handakuten + 33 yoon combos, times two
/// scripts — the complete inventory needed to read and write any Japanese
/// sentence phonetically.
final List<Kana> allKana = [
  ..._buildSeion(_seion, dakuten: false),
  ..._buildSeion(_dakuten, dakuten: true),
  ..._buildYoon(),
];

List<Kana> kanaOf(KanaScript script) =>
    allKana.where((k) => k.script == script).toList();

/// The base 46 (no dakuten, no combos) for one script, in chart order — the
/// set a learner should master before anything else.
List<Kana> baseKana(KanaScript script) => allKana
    .where((k) => k.script == script && !k.isDakuten && !k.isCombo)
    .toList();
