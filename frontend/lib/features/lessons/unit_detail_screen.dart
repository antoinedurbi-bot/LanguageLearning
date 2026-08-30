import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/page_transitions.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';
import 'package:learning_app/features/lessons/grammar_lesson_screen.dart';
import 'package:learning_app/features/session/session_screen.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Everything in one unit, browsable before or instead of a session.
///
/// Reading the sentences with their meaning visible is the "comprehensible
/// input" half of the method: recall practice consolidates what is already
/// understood, but understanding has to come first.
class UnitDetailScreen extends StatelessWidget {
  const UnitDetailScreen({super.key, required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final language = controller.language;
    final course = controller.course;
    final ramp =
        language?.gradient ?? [context.ll.accent, context.ll.accentAlt];

    return Scaffold(
      body: ColoredBox(
        color: context.ll.background,
        child: SafeArea(
          child: Column(
            children: [
              _Header(unit: unit),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s24),
                  children: [
                    if (unit.grammarLesson != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s16),
                        child: Reveal(
                          child: _GrammarEntry(
                            lesson: unit.grammarLesson!,
                            colors: ramp,
                            onTap: () => Navigator.of(context).push(
                              SharedAxisRoute<void>(
                                builder: (_) => GrammarLessonScreen(
                                  unit: unit,
                                  lesson: unit.grammarLesson!,
                                  ttsLocale: course?.ttsLocale ?? 'en-US',
                                  colors: ramp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    for (var i = 0; i < unit.cards.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s12),
                        child: Reveal(
                          index: i + 1,
                          child: _SentenceCard(
                            card: unit.cards[i],
                            locale: course?.ttsLocale ?? 'en-US',
                            colors: ramp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  LL.s20,
                  LL.s16,
                  LL.s20,
                  LL.s16 + MediaQuery.viewPaddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: context.ll.background.withValues(alpha: 0.92),
                  border: Border(top: BorderSide(color: context.ll.divider)),
                ),
                child: GradientButton(
                  label: 'Travailler cette unité',
                  icon: Icons.play_arrow_rounded,
                  colors: ramp,
                  onPressed: () {
                    final items = controller.buildUnitSession(unit);
                    if (items.isEmpty) return;
                    Navigator.of(context).push(
                      SharedAxisRoute<void>(
                        builder: (_) => SessionScreen(items: items),
                      ),
                    );
                  },
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
  const _Header({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                Text(unit.title, style: context.type.headlineSmall),
                Text(unit.subtitle, style: context.type.labelMedium),
              ],
            ),
          ),
          LLChip(label: unit.level, filled: true, color: context.ll.accent),
        ],
      ),
    );
  }
}

/// Entry point into the unit's grammar lesson, shown above the sentence list.
///
/// It comes first on purpose: understanding the rule before drilling the
/// sentences that use it is what makes the drill mean something, rather than
/// training pattern-matching without compréhension.
class _GrammarEntry extends StatelessWidget {
  const _GrammarEntry({
    required this.lesson,
    required this.colors,
    required this.onTap,
  });

  final GrammarLesson lesson;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Pressable(
      onPressed: onTap,
      semanticLabel: 'Lecon de grammaire : ${lesson.title}',
      child: GlassCard(
        glow: colors.first,
        gradient: LinearGradient(
          colors: [
            colors.first.withValues(alpha: c.isDark ? 0.22 : 0.12),
            colors.last.withValues(alpha: c.isDark ? 0.08 : 0.05),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(LL.rSm + 4),
              ),
              child: Icon(Icons.school_rounded,
                  color: LLColors.readableOn(colors.first), size: 24),
            ),
            const SizedBox(width: LL.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.longForm != null ? 'Chapitre complet' : 'Grammaire',
                    style: context.type.labelSmall,
                  ),
                  const SizedBox(height: LL.s2),
                  Text(lesson.title, style: context.type.titleMedium),
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

class _SentenceCard extends StatefulWidget {
  const _SentenceCard({
    required this.card,
    required this.locale,
    required this.colors,
  });

  final CardItem card;
  final String locale;
  final List<Color> colors;

  @override
  State<_SentenceCard> createState() => _SentenceCardState();
}

class _SentenceCardState extends State<_SentenceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final card = widget.card;

    return GlassCard(
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
                    SelectableText(card.target, style: context.type.titleSmall),
                    if (card.romanization != null) ...[
                      const SizedBox(height: LL.s2),
                      Text(
                        card.romanization!,
                        style: context.type.labelMedium
                            ?.copyWith(color: c.accentAlt),
                      ),
                    ],
                    const SizedBox(height: LL.s4),
                    Text(card.native, style: context.type.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: LL.s12),
              Pressable(
                onPressed: () {
                  if (!context.read<LearningController>().soundEnabled) return;
                  context.read<TtsService>().speak(card.target, widget.locale);
                },
                semanticLabel: 'Ecouter',
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: c.accentAlt.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.volume_up_rounded,
                      size: 20, color: c.accentAlt),
                ),
              ),
            ],
          ),
          const SizedBox(height: LL.s12),
          Pressable(
            haptic: false,
            onPressed: () => setState(() => _expanded = !_expanded),
            semanticLabel: _expanded ? 'Masquer le detail' : 'Voir le detail',
            child: Row(
              children: [
                Text(
                  _expanded ? 'Masquer' : 'Detail',
                  style: context.type.labelMedium?.copyWith(color: c.accent),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: c.accent,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: LL.s12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MOT A MOT', style: context.type.labelSmall),
                  const SizedBox(height: LL.s4),
                  Text(card.gloss, style: context.type.bodyMedium),
                  const SizedBox(height: LL.s12),
                  Text('A RETENIR', style: context.type.labelSmall),
                  const SizedBox(height: LL.s4),
                  Text(
                    card.focus,
                    style: context.type.bodyMedium?.copyWith(
                      color: c.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: LL.medium,
            sizeCurve: LL.enter,
          ),
        ],
      ),
    );
  }
}
