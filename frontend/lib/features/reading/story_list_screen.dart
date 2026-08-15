import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/story.dart';
import 'package:learning_app/features/reading/story_screen.dart';

/// The reading list, ordered easiest first.
class StoryListScreen extends StatelessWidget {
  const StoryListScreen({
    super.key,
    required this.stories,
    required this.languageCode,
    required this.ttsLocale,
  });

  final List<Story> stories;
  final String languageCode;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(languageCode);

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, c.auroraC],
        intensity: 0.5,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Retour',
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LECTURES', style: context.type.labelSmall),
                          Text('Lire pour de vrai',
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
                    const Reveal(child: _Why()),
                    const SizedBox(height: LL.s24),
                    for (var i = 0; i < stories.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s12),
                        child: Reveal(
                          index: i + 1,
                          child: _StoryCard(
                            story: stories[i],
                            colors: ramp,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => StoryScreen(
                                  story: stories[i],
                                  ttsLocale: ttsLocale,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _Why extends StatelessWidget {
  const _Why();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Les cartes et les exercices te donnent des pièces détachées. La '
      'lecture est le seul endroit où elles fonctionnent ensemble, à vitesse '
      'réelle. Un texte par jour vaut mieux qu\'une heure de révisions.',
      style: context.type.bodyLarge,
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.story,
    required this.colors,
    required this.onPressed,
  });

  final Story story;
  final List<Color> colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: '${story.title}. ${story.titleNative}',
      child: GlassCard(
        glow: colors.first,
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
                      Text(story.title, style: context.type.titleMedium),
                      const SizedBox(height: LL.s2),
                      Text(story.titleNative,
                          style: context.type.bodyMedium),
                    ],
                  ),
                ),
                Icon(
                  story.isDialogue
                      ? Icons.forum_rounded
                      : Icons.menu_book_rounded,
                  color: c.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: LL.s12),
            Text(story.blurb, style: context.type.bodyMedium),
            const SizedBox(height: LL.s16),
            Row(
              children: [
                LLChip(label: story.level.label, color: c.accentAlt),
                const SizedBox(width: LL.s8),
                LLChip(
                  label: '${story.minutes} min',
                  icon: Icons.schedule_rounded,
                  color: c.textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
