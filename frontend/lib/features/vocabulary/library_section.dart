import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/page_transitions.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/content/frames.dart';
import 'package:learning_app/data/content/islands.dart';
import 'package:learning_app/data/content/stories.dart';
import 'package:learning_app/data/content/vocabularies.dart';
import 'package:learning_app/data/models/entitlement.dart';
import 'package:learning_app/features/chat/chat_screen.dart';
import 'package:learning_app/features/forge/sentence_forge_screen.dart';
import 'package:learning_app/features/premium/premium_screen.dart';
import 'package:learning_app/features/reading/story_list_screen.dart';
import 'package:learning_app/features/vocabulary/collection_screen.dart';
import 'package:learning_app/features/vocabulary/islands_screen.dart';
import 'package:learning_app/features/vocabulary/phrases_screen.dart';
import 'package:learning_app/features/vocabulary/vocabulary_screen.dart';
import 'package:provider/provider.dart';

/// Entry points to the reference material: vocabulary, key phrases, language
/// islands, and whatever the learner has saved.
///
/// These live in the workshop tab rather than the navigation bar because they
/// are consulted, not practised on a schedule — and because the bar is already
/// full on Chinese.
///
/// Free keeps vocabulary, key phrases and the saved collection: a genuinely
/// useful daily driver. Reading, the sentence workshop, islands and the AI
/// tutor are premium — the material that took the most work to build, and
/// the reason to upgrade beyond "it works".
class LibrarySection extends StatelessWidget {
  const LibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final course = controller.course;
    final code = controller.language?.code;
    if (course == null || code == null) return const SizedBox.shrink();

    final pack = vocabularyFor(code);
    final islands = islandsFor(code);
    final texts = storiesFor(code);
    final sentenceFrames = framesFor(code);
    final savedCount = controller.collection?.items.length ?? 0;
    final premium = controller.isPremium;

    void gated(PremiumPerk perk, VoidCallback openFeature) {
      if (premium) {
        openFeature();
      } else {
        openPaywall(context, reason: perk);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TA BIBLIOTHÈQUE', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text(
          'Le matériel de référence, consultable à tout moment. Chaque élément '
          'y est cliquable et s\'explique.',
          style: context.type.bodyMedium,
        ),
        const SizedBox(height: LL.s16),
        _Tile(
          icon: Icons.smart_toy_rounded,
          tint: LL.teal,
          title: 'Tuteur IA',
          subtitle: 'Discute librement, il corrige au fil de la conversation',
          locked: !premium,
          onPressed: () => gated(
            PremiumPerk.aiChat,
            () => Navigator.of(context).push(
              SharedAxisRoute<void>(
                builder: (_) => ChatScreen(
                  languageName: controller.language!.name,
                  languageCode: code,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        // Reading comes first among the reference tiles on purpose: it is the
        // only activity here where everything else the learner has studied
        // has to work together at real speed.
        if (texts.isNotEmpty) ...[
          _Tile(
            icon: Icons.auto_stories_rounded,
            tint: LL.marigold,
            title: 'Lectures',
            subtitle:
                '${texts.length} textes, chaque mot cliquable pour son sens',
            locked: !premium,
            onPressed: () => gated(
              PremiumPerk.reading,
              () => Navigator.of(context).push(
                SharedAxisRoute<void>(
                  builder: (_) => StoryListScreen(
                    stories: texts,
                    languageCode: code,
                    ttsLocale: course.ttsLocale,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: LL.s12),
        ],
        if (pack != null) ...[
          _Tile(
            icon: Icons.menu_book_rounded,
            tint: c.accent,
            title: 'Vocabulaire',
            subtitle: '${pack.allEntries.length} mots, par thème',
            onPressed: () => Navigator.of(context).push(
              SharedAxisRoute<void>(
                builder: (_) => VocabularyScreen(
                  pack: pack,
                  ttsLocale: course.ttsLocale,
                ),
              ),
            ),
          ),
          const SizedBox(height: LL.s12),
          _Tile(
            icon: Icons.forum_rounded,
            tint: c.accentAlt,
            title: 'Phrases clés',
            subtitle: '${pack.phrases.length} phrases à connaître par cœur',
            onPressed: () => Navigator.of(context).push(
              SharedAxisRoute<void>(
                builder: (_) => PhrasesScreen(
                  pack: pack,
                  ttsLocale: course.ttsLocale,
                ),
              ),
            ),
          ),
          const SizedBox(height: LL.s12),
        ],
        if (sentenceFrames.isNotEmpty) ...[
          _Tile(
            icon: Icons.auto_fix_high_rounded,
            tint: LL.tealBright,
            title: 'Atelier de phrases',
            subtitle: '${sentenceFrames.length} structures, '
                '${sentenceFrames.fold<int>(0, (s, f) => s + f.combinations)} '
                'phrases possibles',
            locked: !premium,
            onPressed: () => gated(
              PremiumPerk.sentenceForge,
              () => Navigator.of(context).push(
                SharedAxisRoute<void>(
                  builder: (_) => SentenceForgeScreen(
                    frames: sentenceFrames,
                    languageCode: code,
                    ttsLocale: course.ttsLocale,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: LL.s12),
        ],
        if (islands.isNotEmpty) ...[
          _Tile(
            icon: Icons.hub_rounded,
            tint: c.success,
            title: 'Îles linguistiques',
            subtitle: 'Tes réponses toutes prêtes aux questions inévitables',
            locked: !premium,
            onPressed: () => gated(
              PremiumPerk.islands,
              () => Navigator.of(context).push(
                SharedAxisRoute<void>(
                  builder: (_) => IslandsScreen(
                    islands: islands,
                    languageCode: code,
                    ttsLocale: course.ttsLocale,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: LL.s12),
        ],
        _Tile(
          icon: Icons.bookmark_rounded,
          tint: LL.coral,
          title: 'Ma collection',
          subtitle: savedCount == 0
              ? 'Rien d\'enregistré pour l\'instant'
              : '$savedCount élément${savedCount > 1 ? 's' : ''} gardé'
                  '${savedCount > 1 ? 's' : ''}',
          onPressed: () => Navigator.of(context).push(
            SharedAxisRoute<void>(
              builder: (_) => CollectionScreen(
                languageCode: code,
                ttsLocale: course.ttsLocale,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.locked = false,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: locked
          ? '$title, Premium requis. $subtitle'
          : '$title. $subtitle',
      child: GlassCard(
        padding: const EdgeInsets.all(LL.s16),
        radius: LL.rMd,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(LL.rSm),
              ),
              child: Icon(icon, color: tint, size: 22),
            ),
            const SizedBox(width: LL.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.type.titleSmall),
                  const SizedBox(height: LL.s2),
                  Text(
                    subtitle,
                    style: context.type.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (locked)
              const LLChip(label: 'Premium', icon: Icons.lock_rounded, color: LL.marigold)
            else
              Icon(Icons.chevron_right_rounded, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}
