/// A "language island".
///
/// The technique is Boris Shekhtman's: rather than hoping fluency emerges
/// everywhere at once, you prepare a handful of short monologues on subjects
/// that always come up — who you are, what you do, why you are learning the
/// language — and rehearse them until they come out without effort. The effect
/// is disproportionate: the first two minutes of most conversations are the
/// same two minutes, so a learner with three solid islands sounds far more
/// fluent than their grammar would predict, and buys the calm to handle the
/// unscripted part.
///
/// The app supplies the scaffold and the useful chunks; the content has to be
/// the learner's own, or it is a script rather than an island.
class Island {
  const Island({
    required this.id,
    required this.title,
    required this.situation,
    required this.why,
    required this.prompts,
    required this.chunks,
  });

  final String id;
  final String title;

  /// When this island gets used, in one line.
  final String situation;

  /// Why it is worth preparing this one specifically.
  final String why;

  /// The questions that shape the monologue, in the order they should be
  /// answered. Answering all of them yields roughly 30-60 seconds of speech.
  final List<IslandPrompt> prompts;

  /// Ready-made fragments in the target language the learner can lift
  /// directly. Not a full script: enough to remove the blank-page problem.
  final List<IslandChunk> chunks;
}

class IslandPrompt {
  const IslandPrompt({
    required this.id,
    required this.question,
    required this.hint,
  });

  final String id;

  /// Asked in French, because the learner is composing, not translating.
  final String question;

  /// A nudge about what makes a good answer here.
  final String hint;
}

class IslandChunk {
  const IslandChunk({
    required this.target,
    required this.native,
    this.romanization,
  });

  final String target;
  final String native;
  final String? romanization;
}
