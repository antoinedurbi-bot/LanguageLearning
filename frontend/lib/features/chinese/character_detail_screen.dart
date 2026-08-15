import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/features/chinese/widgets/stroke_order.dart';
import 'package:learning_app/features/chinese/widgets/writing_practice.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Everything about one character: how it sounds, what it is made of, how it
/// is written, and a place to write it.
class CharacterDetailScreen extends StatefulWidget {
  const CharacterDetailScreen({
    super.key,
    required this.hanzi,
    required this.repository,
  });

  final Hanzi hanzi;
  final HanziRepository repository;

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  bool _writing = false;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');
    final hanzi = widget.hanzi;

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, c.auroraC],
        intensity: 0.5,
        child: SafeArea(
          child: Column(
            children: [
              _Header(hanzi: hanzi),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
                  children: [
                    Reveal(child: _HeroCard(hanzi: hanzi, ramp: ramp)),
                    const SizedBox(height: LL.s16),
                    Reveal(
                      index: 1,
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _writing
                                        ? 'Écris le caractère'
                                        : 'Ordre des traits',
                                    style: context.type.titleMedium,
                                  ),
                                ),
                                Pressable(
                                  onPressed: () =>
                                      setState(() => _writing = !_writing),
                                  semanticLabel: _writing
                                      ? 'Revoir l\'animation'
                                      : 'S\'entraîner a écrire',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: LL.s12,
                                      vertical: LL.s8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: c.accent.withValues(alpha: 0.16),
                                      borderRadius:
                                          BorderRadius.circular(LL.rPill),
                                      border: Border.all(
                                        color: c.accent.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _writing
                                              ? Icons
                                                  .play_circle_outline_rounded
                                              : Icons.edit_rounded,
                                          size: 16,
                                          color: c.accent,
                                        ),
                                        const SizedBox(width: LL.s4 + 2),
                                        Text(
                                          _writing ? 'Animation' : 'Écrire',
                                          style: context.type.labelMedium
                                              ?.copyWith(color: c.accent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: LL.s16),
                            Center(
                              child: _writing
                                  ? WritingPractice(
                                      key: ValueKey('write-${hanzi.character}'),
                                      hanzi: hanzi,
                                      size: 280,
                                    )
                                  : StrokeOrderAnimation(
                                      key: ValueKey('anim-${hanzi.character}'),
                                      hanzi: hanzi,
                                      size: 240,
                                    ),
                            ),
                            if (!_writing) ...[
                              const SizedBox(height: LL.s16),
                              Text(
                                '${hanzi.strokeCount} traits. L\'ordre n\'est pas '
                                'decoratif : il decide des proportions, et c\'est '
                                'lui qu\'attendent les claviers à reconnaissance '
                                'd\'écriture.',
                                style: context.type.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: LL.s16),
                    Reveal(index: 2, child: _CompositionCard(hanzi: hanzi)),
                    const SizedBox(height: LL.s16),
                    Reveal(
                      index: 3,
                      child: _WordsCard(
                        hanzi: hanzi,
                        repository: widget.repository,
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

class _Header extends StatelessWidget {
  const _Header({required this.hanzi});

  final Hanzi hanzi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Retour',
          ),
          Expanded(
            child: Text(hanzi.character, style: context.type.headlineSmall),
          ),
          if (hanzi.hskLevel > 0)
            LLChip(
              label: 'HSK ${hanzi.hskLevel}',
              filled: true,
              color: context.ll.accent,
            ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.hanzi, required this.ramp});

  final Hanzi hanzi;
  final List<Color> ramp;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return GlassCard(
      glow: ramp.first,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            hanzi.character,
            style: context.type.displayLarge?.copyWith(fontSize: 76),
          ),
          const SizedBox(width: LL.s20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hanzi.pinyin.isEmpty ? '—' : hanzi.pinyin.join(' / '),
                  style:
                      context.type.headlineSmall?.copyWith(color: c.accentAlt),
                ),
                if (hanzi.pinyin.length > 1) ...[
                  const SizedBox(height: LL.s2),
                  Text(
                    'Caractère à plusieurs lectures',
                    style: context.type.labelSmall,
                  ),
                ],
                const SizedBox(height: LL.s8),
                if (hanzi.definition.isNotEmpty) ...[
                  Text('SENS (EN ANGLAIS)', style: context.type.labelSmall),
                  const SizedBox(height: LL.s2),
                  Text(hanzi.definition, style: context.type.bodyMedium),
                ],
              ],
            ),
          ),
          Pressable(
            onPressed: () {
              if (!context.read<LearningController>().soundEnabled) return;
              context.read<TtsService>().speak(hanzi.character, 'zh-CN');
            },
            semanticLabel: 'Écouter ${hanzi.character}',
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: c.accentAlt.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(color: c.accentAlt.withValues(alpha: 0.35)),
              ),
              child:
                  Icon(Icons.volume_up_rounded, color: c.accentAlt, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

/// Radical, structure and components — the three things that turn a
/// character from an arbitrary shape into something with parts.
class _CompositionCard extends StatelessWidget {
  const _CompositionCard({required this.hanzi});

  final Hanzi hanzi;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Composition', style: context.type.titleMedium),
          const SizedBox(height: LL.s12),
          Wrap(
            spacing: LL.s8,
            runSpacing: LL.s8,
            children: [
              LLChip(
                label: '${hanzi.strokeCount} traits',
                icon: Icons.brush_rounded,
                color: c.textSecondary,
              ),
              if (hanzi.radical.isNotEmpty)
                LLChip(
                  label: 'Cle ${hanzi.radical}',
                  icon: Icons.key_rounded,
                  color: c.accent,
                  filled: true,
                ),
              if (hanzi.structureLabel != null)
                LLChip(
                  label: hanzi.structureLabel!,
                  icon: Icons.dashboard_rounded,
                  color: c.accentAlt,
                  filled: true,
                ),
            ],
          ),
          if (hanzi.components.isNotEmpty) ...[
            const SizedBox(height: LL.s16),
            Text('ÉLÉMENTS', style: context.type.labelSmall),
            const SizedBox(height: LL.s8),
            Row(
              children: [
                for (final part in hanzi.components)
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: LL.s8),
                    decoration: BoxDecoration(
                      color: c.glassFill,
                      borderRadius: BorderRadius.circular(LL.rSm),
                      border: Border.all(color: c.glassStroke),
                    ),
                    child: Text(part, style: context.type.headlineSmall),
                  ),
              ],
            ),
            const SizedBox(height: LL.s12),
            Text(
              'Reconnaître les éléments est ce qui permet de retenir des '
              'centaines de caractères sans les apprendre un par un : la cle '
              'donne souvent la categorie de sens, l\'autre élément souvent '
              'le son.',
              style: context.type.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// HSK words that use this character, so it is never learned in isolation.
class _WordsCard extends StatelessWidget {
  const _WordsCard({required this.hanzi, required this.repository});

  final Hanzi hanzi;
  final HanziRepository repository;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return FutureBuilder<List<HskWord>>(
      future: repository.words(),
      builder: (context, snapshot) {
        final all = snapshot.data;
        if (all == null) {
          return GlassCard(
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: LL.s12),
                Text('Chargement du vocabulaire...',
                    style: context.type.bodyMedium),
              ],
            ),
          );
        }

        final matches = [
          for (final word in all)
            if (word.word.contains(hanzi.character) && word.word.length > 1)
              word,
        ]..sort((a, b) => a.level.compareTo(b.level));

        if (matches.isEmpty) {
          return GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mots contenant ${hanzi.character}',
                    style: context.type.titleMedium),
                const SizedBox(height: LL.s8),
                Text(
                  'Aucun mot de HSK 1-2 ne combine ce caractère avec un autre.',
                  style: context.type.bodyMedium,
                ),
              ],
            ),
          );
        }

        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mots contenant ${hanzi.character}',
                  style: context.type.titleMedium),
              const SizedBox(height: LL.s4),
              Text('${matches.length} dans HSK 1-2',
                  style: context.type.labelSmall),
              const SizedBox(height: LL.s12),
              for (final word in matches.take(12))
                Padding(
                  padding: const EdgeInsets.only(bottom: LL.s12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 64,
                        child: Text(word.word, style: context.type.titleSmall),
                      ),
                      const SizedBox(width: LL.s8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word.pinyin,
                              style: context.type.labelMedium
                                  ?.copyWith(color: c.accentAlt),
                            ),
                            Text(
                              word.definition,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.type.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      LLChip(label: 'HSK ${word.level}', color: c.textTertiary),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
