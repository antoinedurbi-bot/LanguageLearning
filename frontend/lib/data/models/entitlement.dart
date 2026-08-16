/// What premium actually unlocks, in one place.
///
/// Free stays a genuinely complete daily driver — one language, the full SRS
/// loop, grammar, vocabulary, key phrases and the memory dashboard. Premium
/// is what makes the app the best version of itself: every language at once,
/// AI-backed correction and tutoring, the reading library, language islands,
/// the sentence workshop, the fluency sprint, and pronunciation practice.
/// Keeping this list in one file means the paywall screen and every gate in
/// the app describe the same thing.
enum PremiumPerk {
  languages,
  aiCorrection,
  aiChat,
  reading,
  islands,
  sentenceForge,
  fluencySprint,
  pronunciation;

  String get label => switch (this) {
        PremiumPerk.languages => 'Les 4 langues, sans limite',
        PremiumPerk.aiCorrection => 'Correction par IA, pas seulement exacte',
        PremiumPerk.aiChat => 'Tuteur IA en conversation libre',
        PremiumPerk.reading => 'Bibliothèque de lecture graduée',
        PremiumPerk.islands => 'Îles linguistiques',
        PremiumPerk.sentenceForge => 'Atelier de construction de phrases',
        PremiumPerk.fluencySprint => 'Sprint de fluidité',
        PremiumPerk.pronunciation => 'Pratique de prononciation (micro)',
      };

  String get detail => switch (this) {
        PremiumPerk.languages =>
          'Passe d\'une langue à l\'autre librement, sans perdre ta progression '
              'nulle part.',
        PremiumPerk.aiCorrection =>
          'Une IA juge le sens de ta réponse, pas seulement si elle est '
              'identique au mot près — accepte les paraphrases correctes.',
        PremiumPerk.aiChat =>
          'Discute librement dans la langue que tu apprends avec un tuteur '
              'qui corrige au fil de la conversation.',
        PremiumPerk.reading =>
          'Des textes entiers, chaque mot cliquable, avec questions de '
              'compréhension.',
        PremiumPerk.islands =>
          'Prépare tes réponses aux questions qu\'on te pose vraiment, et '
              'entraîne-toi à les redire.',
        PremiumPerk.sentenceForge =>
          'Construis des centaines de phrases justes par construction, '
              'jamais fausses.',
        PremiumPerk.fluencySprint =>
          'Soixante secondes pour automatiser ce que tu sais déjà.',
        PremiumPerk.pronunciation =>
          'Parle ta réponse au lieu de l\'écrire ; l\'app te dit si on te '
              'comprendrait.',
      };
}

/// Codes that unlock premium locally without going through a store purchase.
///
/// Deliberately simple and client-side: this is a friends-and-family unlock,
/// not a protection against determined bypass — anyone reading the compiled
/// app can find a string constant. That trade-off is accepted on purpose
/// rather than hidden, because pretending otherwise would be dishonest about
/// what this actually guards against.
class PromoCode {
  PromoCode._();

  static const _codes = {'ThomasLeBGetYarabe'};

  static bool isValid(String input) => _codes.contains(input.trim());
}
