import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/features/lessons/unit_detail_screen.dart';
import 'package:provider/provider.dart';

/// The curriculum, as a vertical path of units.
class UnitListScreen extends StatelessWidget {
  const UnitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final course = controller.course;
    final language = controller.language;

    if (course == null || language == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
      children: [
        const Reveal(child: _Header()),
        const SizedBox(height: LL.s24),
        for (var i = 0; i < course.units.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: LL.s16),
            child: Reveal(
              index: i + 1,
              child: _UnitCard(
                unit: course.units[i],
                position: i + 1,
                unlocked: controller.isUnitUnlocked(course, i),
                started: controller.startedInUnit(course.units[i]),
                mastered: controller.masteredInUnit(course.units[i]),
                colors: language.gradient,
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PARCOURS', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text('Les unités', style: context.type.displayMedium),
        const SizedBox(height: LL.s12),
        Text(
          'Chaque phrase n\'introduit qu\'une seule difficulté nouvelle. '
          'C\'est ce qui permet de comprendre sans traduire.',
          style: context.type.bodyLarge,
        ),
      ],
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.unit,
    required this.position,
    required this.unlocked,
    required this.started,
    required this.mastered,
    required this.colors,
  });

  final Unit unit;
  final int position;
  final bool unlocked;
  final int started;
  final int mastered;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final total = unit.cards.length;
    final ratio = total == 0 ? 0.0 : started / total;

    return Pressable(
      onPressed: unlocked
          ? () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UnitDetailScreen(unit: unit),
                ),
              )
          : null,
      semanticLabel: unlocked
          ? 'Unité $position, ${unit.title}, $started sur $total commencees'
          : 'Unité $position verrouillée, terminer l\'unité precedente',
      child: GlassCard(
        glow: unlocked ? colors.first : null,
        child: Row(
          children: [
            SizedBox(
              width: 62,
              height: 62,
              child: unlocked
                  ? ProgressRing(
                      value: ratio,
                      size: 62,
                      stroke: 5,
                      colors: [colors.first, colors.last, colors.first],
                      center: Text(
                        '$position',
                        style: context.type.titleMedium,
                      ),
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.glassFill,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.glassStroke),
                      ),
                      child: Icon(Icons.lock_rounded,
                          size: 22, color: c.textTertiary),
                    ),
            ),
            const SizedBox(width: LL.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          unit.title,
                          style: context.type.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: LL.s8),
                      LLChip(
                          label: unit.level, color: colors.first, filled: true),
                    ],
                  ),
                  const SizedBox(height: LL.s4),
                  Text(
                    unlocked
                        ? unit.subtitle
                        : 'Se debloque en avancant l\'unité precedente',
                    style: context.type.bodyMedium,
                  ),
                  if (unlocked) ...[
                    const SizedBox(height: LL.s8),
                    Row(
                      children: [
                        Icon(Icons.style_rounded,
                            size: 14, color: c.textTertiary),
                        const SizedBox(width: LL.s4 + 2),
                        Text('$started/$total vues',
                            style: context.type.labelSmall),
                        const SizedBox(width: LL.s12),
                        Icon(Icons.verified_rounded,
                            size: 14, color: c.success),
                        const SizedBox(width: LL.s4 + 2),
                        Text('$mastered acquises',
                            style: context.type.labelSmall),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (unlocked)
              Icon(Icons.chevron_right_rounded, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}
