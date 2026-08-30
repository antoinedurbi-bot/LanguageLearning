/// A chéngyǔ (成语): a four-character idiom, almost always tracing back to a
/// specific fable, historical episode or classical text.
///
/// These are kept as a distinct pack rather than folded into [VocabularyPack]
/// because they do not behave like vocabulary: a chengyu is not learned by
/// knowing its four characters (a learner who already reads all four of
/// 守株待兔 still has no idea what it means without the story), and using one
/// correctly is as much about knowing when it lands as about the words
/// themselves — which is why every entry here carries both the story and a
/// usage note.
class Chengyu {
  const Chengyu({
    required this.id,
    required this.characters,
    required this.pinyin,
    required this.literal,
    required this.meaning,
    required this.story,
    required this.usage,
    required this.example,
    required this.exampleNative,
  });

  final String id;

  /// The four characters, e.g. `守株待兔`.
  final String characters;
  final String pinyin;

  /// Word-for-word rendering of the four characters — often nonsensical on
  /// its own, which is exactly the point: it shows why the story is needed.
  final String literal;

  /// What the idiom actually means, in French.
  final String meaning;

  /// The fable or episode the idiom comes from, briefly. This is what turns
  /// four characters from a string to memorise into a story to remember.
  final String story;

  /// When and how it lands in conversation — register, and what it is not
  /// interchangeable with.
  final String usage;

  final String example;
  final String exampleNative;
}
