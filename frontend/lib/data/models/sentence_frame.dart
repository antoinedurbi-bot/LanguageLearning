/// Sentence building by substitution.
///
/// Letting a beginner assemble words freely produces sentences that are wrong
/// in ways they cannot detect, and being corrected on your own invention is
/// discouraging in a way that teaches nothing. A frame inverts that: the
/// grammar is fixed and correct, and the learner chooses the meaning. Every
/// sentence that comes out is one a native speaker would say.
///
/// This is the substitution table of the lexical approach — the same device
/// language teachers have used on blackboards for a century, which happens to
/// work far better on a screen where the sentence can rebuild itself as you
/// choose.
library;

/// One choice available in a slot.
class SlotOption {
  const SlotOption({
    required this.target,
    required this.native,
    this.romanization,
    this.note,
  });

  /// The fragment in the language being learned, already inflected.
  ///
  /// Inflection is baked in on purpose: Turkish suffix harmony and Chinese
  /// measure words cannot be composed generically, and a frame that produced
  /// "otel'e" instead of "otele" would be teaching an error.
  final String target;

  final String native;
  final String? romanization;

  /// Why this option is worth knowing, when it is not obvious.
  final String? note;
}

sealed class FramePart {
  const FramePart();
}

/// Fixed text: the part of the sentence the learner is not choosing.
class FrameText extends FramePart {
  const FrameText(this.text, {this.romanization});

  final String text;
  final String? romanization;
}

/// A blank to be filled.
class FrameSlot extends FramePart {
  const FrameSlot({
    required this.id,
    required this.label,
    required this.options,
  });

  final String id;

  /// What goes here, in French: "un objet", "un moment", "une action".
  final String label;

  final List<SlotOption> options;
}

class SentenceFrame {
  const SentenceFrame({
    required this.id,
    required this.languageCode,
    required this.label,
    required this.why,
    required this.parts,
    required this.nativePattern,
    this.grammarNote,
  });

  final String id;
  final String languageCode;

  /// What this frame lets you do, in French.
  final String label;

  /// When you would reach for it.
  final String why;

  final List<FramePart> parts;

  /// The French sentence, with `{slotId}` where each choice goes.
  final String nativePattern;

  /// The structural point the frame teaches, if there is one.
  final String? grammarNote;

  List<FrameSlot> get slots =>
      [for (final part in parts) if (part is FrameSlot) part];

  /// How many different sentences this frame can produce.
  ///
  /// Shown to the learner, because the number is the argument: one structure
  /// is not one sentence, it is a few hundred.
  int get combinations {
    var total = 1;
    for (final slot in slots) {
      total *= slot.options.length;
    }
    return total;
  }

  /// The sentence as it currently stands, with unfilled slots left blank.
  ///
  /// [chosen] maps slot id to the index picked in that slot.
  String render(Map<String, int> chosen, {String blank = '…'}) {
    final buffer = StringBuffer();
    for (final part in parts) {
      switch (part) {
        case FrameText(:final text):
          buffer.write(text);
        case FrameSlot(:final id, :final options):
          final index = chosen[id];
          buffer.write(
            index == null || index < 0 || index >= options.length
                ? blank
                : options[index].target,
          );
      }
    }
    return buffer.toString();
  }

  /// The romanized sentence, or null when the language does not need one.
  String? renderRomanization(Map<String, int> chosen, {String blank = '…'}) {
    final hasAny = parts.any((p) =>
        (p is FrameText && p.romanization != null) ||
        (p is FrameSlot && p.options.any((o) => o.romanization != null)));
    if (!hasAny) return null;

    final pieces = <String>[];
    for (final part in parts) {
      switch (part) {
        case FrameText(:final romanization, :final text):
          final value = romanization ?? text;
          if (value.trim().isNotEmpty) pieces.add(value.trim());
        case FrameSlot(:final id, :final options):
          final index = chosen[id];
          if (index == null || index < 0 || index >= options.length) {
            pieces.add(blank);
          } else {
            final option = options[index];
            pieces.add(option.romanization ?? option.target);
          }
      }
    }
    return pieces.where((p) => p.isNotEmpty).join(' ');
  }

  /// The French rendering of the current sentence.
  String renderNative(Map<String, int> chosen, {String blank = '…'}) {
    var result = nativePattern;
    for (final slot in slots) {
      final index = chosen[slot.id];
      final value = index == null || index < 0 || index >= slot.options.length
          ? blank
          : slot.options[index].native;
      result = result.replaceAll('{${slot.id}}', value);
    }
    return result;
  }

  bool isComplete(Map<String, int> chosen) =>
      slots.every((slot) => chosen[slot.id] != null);
}
