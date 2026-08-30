import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/data/srs/memory_forecast.dart';
import 'package:learning_app/features/memory/memory_curve.dart';
import 'package:provider/provider.dart';

/// "Ta mémoire" — the scheduler's model, made legible.
///
/// Streaks measure attendance. This measures the thing the learner actually
/// cares about: how much of what they have learned is still there, and what
/// it costs to keep it.
class MemoryCard extends StatefulWidget {
  const MemoryCard({super.key});

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  // Created eagerly here rather than via a lazy `late final` initializer: a
  // lazy initializer that build() never reads would otherwise run for the
  // first time inside dispose() when the widget is torn down before ever
  // being laid out, which crashes trying to look up an ancestor on an
  // already-deactivated element.
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    // The curve draws itself in once; with reduced motion it simply appears.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.reduceMotion) {
        _controller.value = 1;
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final progress = controller.progress;
    if (progress == null) return const SizedBox.shrink();

    final forecast = MemoryForecast(controller.scheduler);
    final now = DateTime.now();
    final tracked =
        progress.states.values.where((s) => s.stability > 0).length;

    if (tracked < 3) {
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TA MÉMOIRE', style: context.type.labelSmall),
            const SizedBox(height: LL.s12),
            Text(
              'Encore un peu de patience : il faut quelques révisions avant '
              'que le modèle puisse dire quoi que ce soit d\'honnête sur ta '
              'mémoire.',
              style: context.type.bodyMedium,
            ),
          ],
        ),
      );
    }

    final days = forecast.project(progress.states, now, days: 30);
    final retention = forecast.currentRetention(progress.states, now);
    final bought = forecast.daysBoughtByReviewing(progress.states, now);
    final fading = forecast.fading(progress.states, now, limit: 3);

    // The first day the average crosses under the threshold, if it does.
    final crossing = days.firstWhere(
      (d) => d.averageRetention < MemoryForecast.riskThreshold,
      orElse: () => days.last,
    );
    final crosses =
        crossing.averageRetention < MemoryForecast.riskThreshold;

    return GlassCard(
      glow: c.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('TA MÉMOIRE', style: context.type.labelSmall),
              const Spacer(),
              Text('$tracked cartes suivies', style: context.type.labelSmall),
            ],
          ),
          const SizedBox(height: LL.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(retention * 100).round()}%',
                style: context.type.displayMedium?.copyWith(color: c.accent),
              ),
              const SizedBox(width: LL.s8),
              Padding(
                padding: const EdgeInsets.only(bottom: LL.s8),
                child: Text('de rétention aujourd\'hui',
                    style: context.type.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: LL.s16),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => MemoryCurve(
              days: days,
              progress: Curves.easeOutCubic.transform(_controller.value),
            ),
          ),
          const SizedBox(height: LL.s12),
          Text(
            crosses
                ? 'Si tu ne révises rien, tu passes sous la barre des 50 % '
                    'dans ${crossing.dayOffset} jour'
                    '${crossing.dayOffset > 1 ? 's' : ''}.'
                : 'Même sans rien réviser, tu restes au-dessus de 50 % sur '
                    'les 30 prochains jours. C\'est du solide.',
            style: context.type.bodyMedium,
          ),
          if (bought > 0) ...[
            const SizedBox(height: LL.s12),
            Container(
              padding: const EdgeInsets.all(LL.s12),
              decoration: BoxDecoration(
                color: c.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(LL.rSm),
                border: Border.all(color: c.success.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up_rounded, size: 18, color: c.success),
                  const SizedBox(width: LL.s8),
                  Expanded(
                    child: Text(
                      crosses
                          ? 'La séance d\'aujourd\'hui repousse cette échéance '
                              'de $bought jour${bought > 1 ? 's' : ''}.'
                          : 'La séance d\'aujourd\'hui ajoute encore $bought '
                              'jour${bought > 1 ? 's' : ''} de marge.',
                      style: context.type.bodyMedium
                          ?.copyWith(color: c.success),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (fading.isNotEmpty) ...[
            const SizedBox(height: LL.s20),
            Text('CE QUI S\'EFFACE', style: context.type.labelSmall),
            const SizedBox(height: LL.s8),
            for (final card in fading)
              Padding(
                padding: const EdgeInsets.only(bottom: LL.s8),
                child: _FadingRow(
                  card: card,
                  label: controller.course
                          ?.allCards
                          .where((item) => item.id == card.cardId)
                          .map((item) => item.target)
                          .firstOrNull ??
                      card.cardId,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _FadingRow extends StatelessWidget {
  const _FadingRow({required this.card, required this.label});

  final FadingCard card;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final value = card.retention.clamp(0.0, 1.0);
    final tint = value < 0.5
        ? c.danger
        : value < 0.75
            ? c.warning
            : c.success;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.type.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: LL.s4),
              ClipRRect(
                borderRadius: BorderRadius.circular(LL.rPill),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                  backgroundColor: c.glassStroke,
                  valueColor: AlwaysStoppedAnimation(tint),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: LL.s12),
        SizedBox(
          width: 42,
          child: Text(
            '${(value * 100).round()}%',
            textAlign: TextAlign.right,
            style: context.type.labelMedium?.copyWith(color: tint),
          ),
        ),
      ],
    );
  }
}
