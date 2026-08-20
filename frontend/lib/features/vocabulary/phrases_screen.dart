import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/vocabulary.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/features/vocabulary/explanation_sheet.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Phrases worth knowing as whole blocks.
///
/// Ordered by what actually keeps a conversation alive: the repair phrases
/// come first, before politeness and before survival vocabulary. A learner who
/// can say "sorry, could you repeat that?" keeps talking; one who cannot
/// stops, however many words they know.
class PhrasesScreen extends StatelessWidget {
  const PhrasesScreen({
    super.key,
    required this.pack,
    required this.ttsLocale,
  });

  final VocabularyPack pack;
  final String ttsLocale;

  static const _categoryTitles = {
    'réparation': 'Reparer la conversation',
    'politesse': 'Politesse',
    'survie': 'Survie',
  };

  static const _categoryNotes = {
    'réparation': 'Les plus importantes de toutes. Elles te permettent de '
        'continuer quand tu n\'as pas compris, au lieu de t\'arrêter.',
    'politesse': 'Ce qui fait la différence entre "compréhensible" et '
        '"agréable a écouter".',
    'survie': 'Ce dont tu as besoin dans la rue, au guichet, au restaurant.',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(pack.languageCode);
    final categories = pack.phraseCategories;

    return Scaffold(
      body: ColoredBox(
        color: c.background,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Retour',
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PHRASES CLÉS',
                              style: context.type.labelSmall
                                  ?.copyWith(color: ramp.first)),
                          Text('A connaître par coeur',
                              style: context.type.headlineSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                      LL.s20, LL.s8, LL.s20, LL.s32),
                  children: [
                    for (var i = 0; i < categories.length; i++) ...[
                      Reveal(
                        index: i,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _categoryTitles[categories[i]] ?? categories[i],
                              style: context.type.titleMedium,
                            ),
                            const SizedBox(height: LL.s4),
                            Text(
                              _categoryNotes[categories[i]] ?? '',
                              style: context.type.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: LL.s12),
                      for (final phrase in pack.phrases
                          .where((p) => p.category == categories[i]))
                        Padding(
                          padding: const EdgeInsets.only(bottom: LL.s12),
                          child: _PhraseCard(
                            phrase: phrase,
                            ttsLocale: ttsLocale,
                          ),
                        ),
                      const SizedBox(height: LL.s24),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({required this.phrase, required this.ttsLocale});

  final KeyPhrase phrase;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final saved = controller.isSaved(phrase.id);

    return Pressable(
      onPressed: () => ExplanationSheet.show(
        context,
        id: phrase.id,
        kind: SavedKind.phrase,
        target: phrase.target,
        native: phrase.native,
        explanation: phrase.whenToUse,
        romanization: phrase.romanization,
        literal: phrase.literal,
      ),
      semanticLabel: '${phrase.target}. ${phrase.native}',
      child: GlassCard(
        padding: const EdgeInsets.all(LL.s16),
        radius: LL.rMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(phrase.target,
                          style: context.type.titleSmall),
                      if (phrase.romanization != null) ...[
                        const SizedBox(height: LL.s2),
                        Text(
                          phrase.romanization!,
                          style: context.type.labelMedium
                              ?.copyWith(color: c.accentAlt),
                        ),
                      ],
                      const SizedBox(height: LL.s4),
                      Text(phrase.native, style: context.type.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: LL.s8),
                Column(
                  children: [
                    Pressable(
                      onPressed: () {
                        if (!controller.soundEnabled) return;
                        context
                            .read<TtsService>()
                            .speak(phrase.target, ttsLocale);
                      },
                      semanticLabel: 'Écouter',
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c.accentAlt.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.volume_up_rounded,
                            size: 18, color: c.accentAlt),
                      ),
                    ),
                    if (saved) ...[
                      const SizedBox(height: LL.s4),
                      Icon(Icons.bookmark_rounded, size: 14, color: c.success),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: LL.s12),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: c.textTertiary),
                const SizedBox(width: LL.s4 + 2),
                Expanded(
                  child: Text(
                    phrase.whenToUse,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.type.labelSmall
                        ?.copyWith(color: c.textTertiary, letterSpacing: 0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
