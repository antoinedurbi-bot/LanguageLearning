/// A single vocabulary item.
///
/// Every entry carries a [note]. That is the point of this layer rather than a
/// nicety: a bare word/translation pair is exactly the kind of flashcard that
/// produces learners who "know" a word and still use it wrongly. The note says
/// the thing a dictionary line leaves out — which register it belongs to, what
/// it is *not* interchangeable with, what preposition it drags along.
class VocabEntry {
  const VocabEntry({
    required this.id,
    required this.target,
    required this.native,
    required this.pos,
    required this.example,
    required this.exampleNative,
    required this.note,
    this.romanization,
  });

  final String id;

  /// The word in the language being learned.
  final String target;

  /// Its French meaning.
  final String native;

  /// Part of speech, shown as a tag: nom, verbe, adjectif, expression...
  final String pos;

  /// The word used in a real sentence. A word met only in isolation has no
  /// context to be recalled from later.
  final String example;
  final String exampleNative;

  /// What a dictionary would not tell you. Always present.
  final String note;

  /// Pronunciation aid for non-Latin scripts.
  final String? romanization;
}

/// A themed group of vocabulary.
///
/// Themes rather than a frequency dump: a list ordered purely by corpus
/// frequency mixes "the", "want" and "government" on one screen, which is
/// efficient for a computer and useless for a person trying to hold a
/// conversation about one subject.
class VocabTheme {
  const VocabTheme({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.entries,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<VocabEntry> entries;
}

/// A phrase worth knowing whole.
///
/// These are deliberately not decomposed into vocabulary: they are used as
/// fixed blocks by native speakers, and trying to build them from their parts
/// is how learners produce grammatically valid sentences nobody says.
class KeyPhrase {
  const KeyPhrase({
    required this.id,
    required this.target,
    required this.native,
    required this.whenToUse,
    required this.category,
    this.romanization,
    this.literal,
  });

  final String id;
  final String target;
  final String native;

  /// The situation this phrase belongs to — the part that decides whether
  /// using it makes you sound fluent or strange.
  final String whenToUse;

  /// Grouping key, e.g. 'survie', 'politesse', 'reparation'.
  final String category;
  final String? romanization;

  /// Word-for-word rendering, when it differs enough from the meaning to be
  /// worth showing.
  final String? literal;
}

/// Everything in the vocabulary layer for one language.
class VocabularyPack {
  const VocabularyPack({
    required this.languageCode,
    required this.themes,
    required this.phrases,
  });

  final String languageCode;
  final List<VocabTheme> themes;
  final List<KeyPhrase> phrases;

  List<VocabEntry> get allEntries => [
        for (final theme in themes) ...theme.entries,
      ];

  VocabEntry? entryById(String id) {
    for (final theme in themes) {
      for (final entry in theme.entries) {
        if (entry.id == id) return entry;
      }
    }
    return null;
  }

  KeyPhrase? phraseById(String id) {
    for (final phrase in phrases) {
      if (phrase.id == id) return phrase;
    }
    return null;
  }

  /// Phrase categories, in the order they are worth learning: being unable to
  /// repair a conversation ends it faster than a small vocabulary does.
  List<String> get phraseCategories {
    final seen = <String>[];
    for (final phrase in phrases) {
      if (!seen.contains(phrase.category)) seen.add(phrase.category);
    }
    return seen;
  }
}
