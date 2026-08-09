/// A single thing to be learned.
///
/// The unit of study is a **sentence**, not an isolated word. This is the
/// central pedagogical choice in the app: isolated vocabulary gives you a word
/// you can recognise, whereas a sentence gives you the word plus its
/// collocations, its grammar and a context to retrieve it from. It is the
/// "sentence mining" approach polyglots use, with the sentences pre-mined and
/// ordered so that each one introduces roughly one new element over what came
/// before (Krashen's i+1).
class CardItem {
  const CardItem({
    required this.id,
    required this.target,
    required this.native,
    required this.gloss,
    this.romanization,
    required this.tokens,
    required this.distractors,
    required this.focus,
  });

  final String id;

  /// The sentence in the language being learned.
  final String target;

  /// The French meaning.
  final String native;

  /// Word-for-word gloss. Shown on demand, because seeing the literal
  /// structure of a sentence is what makes a foreign word order stop feeling
  /// arbitrary.
  final String gloss;

  /// Pronunciation aid for non-Latin scripts (pinyin for Mandarin).
  final String? romanization;

  /// The target sentence split into the chunks used to rebuild it in the
  /// word-bank exercise.
  final List<String> tokens;

  /// Plausible wrong chunks mixed into the word bank, and wrong options in
  /// multiple choice. They are near-misses on purpose: choosing between
  /// "por favor" and "para favor" forces attention where a random distractor
  /// would not.
  final List<String> distractors;

  /// The one new thing this card teaches, surfaced in the UI so practice
  /// never feels like an undifferentiated pile.
  final String focus;
}

/// A themed group of cards, unlocked in order.
class Unit {
  const Unit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.cards,
  });

  final String id;
  final String title;
  final String subtitle;

  /// CEFR band.
  final String level;
  final List<CardItem> cards;
}

/// Everything available for one language.
class Course {
  const Course({
    required this.languageCode,
    required this.ttsLocale,
    required this.units,
  });

  final String languageCode;

  /// BCP-47 tag handed to the platform speech engine.
  final String ttsLocale;
  final List<Unit> units;

  List<CardItem> get allCards => [for (final u in units) ...u.cards];

  Unit? unitOf(String cardId) {
    for (final unit in units) {
      if (unit.cards.any((c) => c.id == cardId)) return unit;
    }
    return null;
  }
}
