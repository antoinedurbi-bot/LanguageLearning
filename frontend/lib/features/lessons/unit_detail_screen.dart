import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/card_item.dart';
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
    final ramp = language?.gradient ??
        [context.ll.accent, context.ll.accentAlt];

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, context.ll.auroraC],
        child: SafeArea(
          child: Column(
            children: [
              _Header(unit: unit),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                      LL.s20, LL.s8, LL.s20, LL.s24),
                  children: [
                    for (var i = 0; i < unit.cards.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s12),
                        child: Reveal(
                          index: i,
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
                  label: 'Travailler cette unite',
                  icon: Icons.play_arrow_rounded,
                  colors: ramp,
                  onPressed: () {
                    final items = controller.buildUnitSession(unit);
                    if (items.isEmpty) return;
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
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
                  context
                      .read<TtsService>()
                      .speak(card.target, widget.locale);
                },
                semanticLabel: 'Ecouter',
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: c.accentAlt.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.volume_up_rounded, size: 20, color: c.accentAlt),
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
