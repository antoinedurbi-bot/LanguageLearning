import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/content/islands.dart';
import 'package:learning_app/data/content/stories.dart';
import 'package:learning_app/data/content/vocabularies.dart';
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
    final savedCount = controller.collection?.items.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TA BIBLIOTHEQUE', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text(
          'Le materiel de reference, consultable a tout moment. Chaque element '
          'y est cliquable et s\'explique.',
          style: context.type.bodyMedium,
        ),
        const SizedBox(height: LL.s16),
        // Reading comes first on purpose: it is the only activity here where
        // everything else the learner has studied has to work together at
        // real speed.
        if (texts.isNotEmpty) ...[
          _Tile(
            icon: Icons.auto_stories_rounded,
            tint: LL.amber,
            title: 'Lectures',
            subtitle:
                '${texts.length} textes, chaque mot cliquable pour son sens',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StoryListScreen(
                  stories: texts,
                  languageCode: code,
                  ttsLocale: course.ttsLocale,
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
            subtitle: '${pack.allEntries.length} mots, par theme',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
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
            title: 'Phrases cles',
            subtitle: '${pack.phrases.length} phrases a connaitre par coeur',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PhrasesScreen(
                  pack: pack,
                  ttsLocale: course.ttsLocale,
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
            title: 'Iles linguistiques',
            subtitle: 'Tes reponses toutes pretes aux questions inevitables',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => IslandsScreen(
                  islands: islands,
                  languageCode: code,
                  ttsLocale: course.ttsLocale,
                ),
              ),
            ),
          ),
          const SizedBox(height: LL.s12),
        ],
        _Tile(
          icon: Icons.bookmark_rounded,
          tint: LL.rose,
          title: 'Ma collection',
          subtitle: savedCount == 0
              ? 'Rien d\'enregistre pour l\'instant'
              : '$savedCount element${savedCount > 1 ? 's' : ''} garde'
                  '${savedCount > 1 ? 's' : ''}',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
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
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: '$title. $subtitle',
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
            Icon(Icons.chevron_right_rounded, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}
