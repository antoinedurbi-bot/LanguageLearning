/// A grammar lesson attached to a [Unit].
///
/// The model is deliberately a sealed set of *blocks* rather than one fixed
/// template. English and Spanish lessons are built almost entirely from
/// [ExplanationBlock], [ExampleBlock], [MistakeBlock] and the occasional
/// [TableBlock] (verb conjugation, case endings). Mandarin needs none of that
/// shape forced on it — tone, character structure and measure words are not
/// "grammar rules with examples," they are their own kind of content, so they
/// get their own block types ([ToneBlock], [CharacterBreakdownBlock],
/// [MeasureWordBlock]) rather than being awkwardly squeezed into a table.
///
/// A lesson is a flat, ordered list of blocks: the rendering screen just
/// switches on the block type, so adding a new block kind for a future
/// language (e.g. a Turkish vowel-harmony block) never requires touching the
/// existing content.
class GrammarLesson {
  const GrammarLesson({
    required this.title,
    required this.hook,
    required this.blocks,
  });

  final String title;

  /// One sentence, shown at the top: why this lesson matters before the
  /// learner is asked to sit through it.
  final String hook;

  final List<GrammarBlock> blocks;
}

sealed class GrammarBlock {
  const GrammarBlock();
}

/// Prose explanation of a rule.
class ExplanationBlock extends GrammarBlock {
  const ExplanationBlock({required this.heading, required this.body});

  final String heading;
  final String body;
}

/// A short list of worked examples, each pairing the target sentence with a
/// literal or contrastive note — not just a translation, since the point is
/// usually to show the mechanism, not to re-teach vocabulary.
class ExampleBlock extends GrammarBlock {
  const ExampleBlock({this.heading, required this.examples});

  final String? heading;
  final List<GrammarExample> examples;
}

class GrammarExample {
  const GrammarExample({
    required this.target,
    required this.native,
    this.note,
    this.romanization,
  });

  final String target;
  final String native;

  /// What to notice in this specific example (a highlighted contrast, not a
  /// restatement of the translation).
  final String? note;
  final String? romanization;
}

/// Rows of structured data: conjugation, case endings, tone pairs — anything
/// better scanned than read.
class TableBlock extends GrammarBlock {
  const TableBlock({this.caption, required this.headers, required this.rows});

  final String? caption;
  final List<String> headers;
  final List<List<String>> rows;
}

/// A named error a learner at this level predictably makes, paired with the
/// fix and the reason — the reason is what prevents the same slip next time.
class MistakeBlock extends GrammarBlock {
  const MistakeBlock(
      {required this.wrong, required this.right, required this.why});

  final String wrong;
  final String right;
  final String why;
}

/// Mandarin tone pedagogy: pitch is part of the word, so a syllable is shown
/// with its tone number and a description of the pitch contour, not just a
/// diacritic that a Latin-alphabet reader will skim past.
class ToneBlock extends GrammarBlock {
  const ToneBlock({this.heading, required this.entries});

  final String? heading;
  final List<ToneExample> entries;
}

class ToneExample {
  const ToneExample({
    required this.syllable,
    required this.pinyin,
    required this.tone,
    required this.contour,
    required this.meaning,
  });

  final String syllable;
  final String pinyin;

  /// 1-4 for the four tones, 0 for the neutral tone.
  final int tone;

  /// Short description of the pitch movement, e.g. "haut et plat",
  /// "montant", "descend puis monte", "descendant".
  final String contour;
  final String meaning;
}

/// Decomposes a character into the radical that carries (usually) its
/// meaning category and the phonetic or remaining component, with a memory
/// hook — the actual technique fluent readers use to stop treating characters
/// as arbitrary shapes.
class CharacterBreakdownBlock extends GrammarBlock {
  const CharacterBreakdownBlock({this.heading, required this.entries});

  final String? heading;
  final List<CharacterBreakdown> entries;
}

class CharacterBreakdown {
  const CharacterBreakdown({
    required this.character,
    required this.pinyin,
    required this.meaning,
    required this.radical,
    required this.radicalMeaning,
    required this.mnemonic,
  });

  final String character;
  final String pinyin;
  final String meaning;

  /// The component carrying the meaning class, e.g. 氵 (water).
  final String radical;
  final String radicalMeaning;
  final String mnemonic;
}

/// Measure words (量词): Mandarin requires one between a number and almost
/// every noun, chosen by the noun's shape or category — there is no French
/// or English equivalent to lean on, so each entry teaches the word on its
/// own terms.
class MeasureWordBlock extends GrammarBlock {
  const MeasureWordBlock({this.heading, required this.entries});

  final String? heading;
  final List<MeasureWordEntry> entries;
}

class MeasureWordEntry {
  const MeasureWordEntry({
    required this.word,
    required this.pinyin,
    required this.usedFor,
    required this.example,
    required this.exampleNative,
  });

  final String word;
  final String pinyin;

  /// What category of noun takes this measure word.
  final String usedFor;
  final String example;
  final String exampleNative;
}
