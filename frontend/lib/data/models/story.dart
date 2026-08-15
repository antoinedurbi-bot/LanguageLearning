/// Graded reading: the strand the app was missing.
///
/// Deliberate study (flashcards, grammar drills) is only one of the four
/// strands a language course needs. The others are meaning-focused input,
/// meaning-focused output and fluency development. This file covers the first
/// one: texts short enough to finish, easy enough to follow, and annotated
/// densely enough that the learner never has to leave the page to understand a
/// word — the condition Krashen calls comprehensible input.
///
/// Authoring format
/// ----------------
/// A line is written as plain text with the taught items in brackets:
///
///     'Ayer [fui|je suis alle] al [mercado|marche] con mi [hermana|soeur].'
///
/// A third field carries a romanization, which non-Latin scripts need:
///
///     '[我|je|wo3][去了|suis alle|qu4le]'
///
/// Everything outside brackets is still tappable: the token falls back to the
/// language's shared lexicon of function words, and failing that the sheet
/// shows the translation of the whole line rather than inventing a gloss.
library;

/// One tappable unit of a story.
class StoryToken {
  const StoryToken({
    required this.text,
    this.gloss,
    this.romanization,
    this.note,
    this.isWord = true,
    this.taught = false,
  });

  /// The surface form, exactly as it appears in the text.
  final String text;

  /// French meaning. Null when nothing reliable is known — never a guess.
  final String? gloss;

  final String? romanization;

  /// A grammar remark worth making at this exact point in the text.
  final String? note;

  /// False for punctuation and whitespace, which are rendered but not tappable.
  final bool isWord;

  /// True when the author bracketed this chunk, i.e. it is a teaching point
  /// rather than a word the shared lexicon happened to cover. Only these get a
  /// visual marker, so the page stays a text rather than a highlighted mess.
  final bool taught;

  bool get hasGloss => gloss != null && gloss!.trim().isNotEmpty;
}

/// One line of a story: a sentence, or one speaker's turn in a dialogue.
class StoryLine {
  const StoryLine({
    required this.tokens,
    required this.native,
    this.speaker,
    this.romanization,
    this.note,
  });

  final List<StoryToken> tokens;

  /// Full-line French translation, revealed on demand rather than shown by
  /// default: reading with the translation always visible trains the eye to
  /// skip the target language entirely.
  final String native;

  /// Speaker name for dialogues, null for narration.
  final String? speaker;

  /// Whole-line romanization, for scripts where per-token syllables are not
  /// enough to read the sentence aloud.
  final String? romanization;

  /// An optional remark about the line as a whole.
  final String? note;

  /// The line as it reads in the target language.
  String get text => tokens.map((t) => t.text).join();

  /// Parses the authoring format described at the top of this file.
  ///
  /// [lexicon] supplies glosses for words left unbracketed, so that common
  /// function words are annotated once per language instead of once per line.
  static StoryLine parse(
    String source, {
    required String native,
    String? speaker,
    String? romanization,
    String? note,
    Map<String, String> lexicon = const {},
  }) {
    return StoryLine(
      tokens: tokenize(source, lexicon: lexicon),
      native: native,
      speaker: speaker,
      romanization: romanization,
      note: note,
    );
  }

  /// Splits a source line into tokens, resolving brackets and the lexicon.
  static List<StoryToken> tokenize(
    String source, {
    Map<String, String> lexicon = const {},
  }) {
    final tokens = <StoryToken>[];
    final buffer = StringBuffer();

    void flushPlain() {
      if (buffer.isEmpty) return;
      tokens.addAll(_splitPlain(buffer.toString(), lexicon));
      buffer.clear();
    }

    var i = 0;
    while (i < source.length) {
      final char = source[i];
      if (char == '[') {
        final close = source.indexOf(']', i);
        if (close == -1) {
          // Unbalanced bracket: treat the rest as plain text rather than
          // dropping content the reader is supposed to see.
          buffer.write(source.substring(i));
          break;
        }
        flushPlain();
        final parts = source.substring(i + 1, close).split('|');
        final surface = parts.isNotEmpty ? parts[0] : '';
        if (surface.isNotEmpty) {
          tokens.add(StoryToken(
            text: surface,
            taught: true,
            gloss: parts.length > 1 && parts[1].trim().isNotEmpty
                ? parts[1].trim()
                : null,
            romanization: parts.length > 2 && parts[2].trim().isNotEmpty
                ? parts[2].trim()
                : null,
            note: parts.length > 3 && parts[3].trim().isNotEmpty
                ? parts[3].trim()
                : null,
          ));
        }
        i = close + 1;
        continue;
      }
      buffer.write(char);
      i++;
    }
    flushPlain();
    return tokens;
  }

  /// Breaks unbracketed text into words and separators.
  ///
  /// Runs of letters (in any script) become tappable words; everything else —
  /// spaces, punctuation — is emitted as-is so the line renders unchanged.
  static List<StoryToken> _splitPlain(
    String text,
    Map<String, String> lexicon,
  ) {
    final tokens = <StoryToken>[];
    final matches = _wordPattern.allMatches(text);
    var cursor = 0;

    for (final match in matches) {
      if (match.start > cursor) {
        tokens.add(StoryToken(
          text: text.substring(cursor, match.start),
          isWord: false,
        ));
      }
      final word = match.group(0)!;
      tokens.add(StoryToken(
        text: word,
        gloss: lexicon[word.toLowerCase()],
      ));
      cursor = match.end;
    }
    if (cursor < text.length) {
      tokens.add(StoryToken(text: text.substring(cursor), isWord: false));
    }
    return tokens;
  }

  // Letters and apostrophes, so "l'ami" and "don't" stay single words.
  static final _wordPattern = RegExp(r"[\p{L}\p{M}]+(?:['’][\p{L}]+)*",
      unicode: true);
}

/// A comprehension check, asked in French about a text in the target language.
///
/// Asked in French on purpose: the point is to verify that the *meaning* got
/// through, not to add a second language puzzle on top of the first.
class StoryQuestion {
  const StoryQuestion({
    required this.question,
    required this.options,
    required this.answerIndex,
    this.explanation,
  });

  final String question;
  final List<String> options;
  final int answerIndex;

  /// Where in the text the answer was, said plainly.
  final String? explanation;

  String get answer => options[answerIndex];
}

/// Difficulty, expressed as what the reader is expected to already handle.
enum StoryLevel {
  /// Present tense, concrete vocabulary, short sentences.
  first('Premiers pas'),

  /// Past and future, opinions, longer sentences.
  building('En construction'),

  /// Idiom, register shifts, implied meaning.
  confident('A l\'aise');

  const StoryLevel(this.label);
  final String label;
}

class Story {
  const Story({
    required this.id,
    required this.languageCode,
    required this.title,
    required this.titleNative,
    required this.blurb,
    required this.level,
    required this.lines,
    this.questions = const [],
    this.takeaway,
  });

  final String id;
  final String languageCode;

  /// Title in the target language.
  final String title;

  /// Title in French.
  final String titleNative;

  /// Why this text is worth reading — what it will teach.
  final String blurb;

  final StoryLevel level;
  final List<StoryLine> lines;
  final List<StoryQuestion> questions;

  /// The one thing to remember afterwards.
  final String? takeaway;

  bool get isDialogue => lines.any((line) => line.speaker != null);

  /// Every distinct speaker, in order of first appearance.
  List<String> get speakers {
    final seen = <String>[];
    for (final line in lines) {
      final speaker = line.speaker;
      if (speaker != null && !seen.contains(speaker)) seen.add(speaker);
    }
    return seen;
  }

  /// Word count, used to promise the reader a realistic reading time.
  int get wordCount {
    var count = 0;
    for (final line in lines) {
      for (final token in line.tokens) {
        if (token.isWord) count++;
      }
    }
    return count;
  }

  /// Rounded-up minutes at a beginner's pace of roughly 60 words a minute.
  int get minutes => (wordCount / 60).ceil().clamp(1, 99);

  /// The whole text, for read-aloud.
  String get plainText => lines.map((line) => line.text).join(' ');
}
