import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/mimi_mascot.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/radicals.dart';
import 'package:learning_app/data/repository/radical_progress_repository.dart';
import 'package:learning_app/data/srs/weak_spots.dart';
import 'package:learning_app/features/chinese/radical_explorer_screen.dart';
import 'package:learning_app/features/session/session_screen.dart';
import 'package:provider/provider.dart';

/// "Points faibles" — the learner's weakest material for the current
/// language, gathered into one place instead of scattered across the normal
/// due queue, the radical explorer and (for Mandarin) tone practice.
///
/// This aggregates, it does not replace: the daily queue in [HomeScreen]
/// still schedules reviews by due date as normal. This screen answers a
/// different question — "if I only have five minutes, what should I use
/// them on" — by ranking what is actually shaky right now.
class WeakSpotsScreen extends StatefulWidget {
  const WeakSpotsScreen({super.key});

  @override
  State<WeakSpotsScreen> createState() => _WeakSpotsScreenState();
}

class _WeakSpotsScreenState extends State<WeakSpotsScreen> {
  final _radicalRepository = RadicalRepository();
  final _radicalProgress = RadicalProgressRepository();

  List<Radical>? _radicals;
  Set<String> _masteredRadicals = {};

  @override
  void initState() {
    super.initState();
    final controller = context.read<LearningController>();
    if (controller.language?.code == 'zh') {
      _radicalRepository.radicals().then((value) {
        if (mounted) setState(() => _radicals = value);
      });
      _radicalProgress.load().then((value) {
        if (mounted) setState(() => _masteredRadicals = value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final isChinese = controller.language?.code == 'zh';

    final cardSpots = controller.weakCardSpots;
    final radicalSpots = !isChinese || _radicals == null
        ? const <WeakSpotEntry>[]
        : controller.weakSpots.rankRadicals(
            [
              for (final r in _radicals!)
                (
                  radical: r.radical,
                  meaning: r.meaning,
                  characterCount: r.characterCount,
                ),
            ],
            _masteredRadicals,
          );

    final combined = controller.weakSpots.combine(
      cardEntries: cardSpots,
      radicalEntries: radicalSpots,
    );

    return Scaffold(
      body: SafeArea(
        child: combined.isEmpty
            ? _EmptyState(hasStudiedNothing: cardSpots.isEmpty)
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                    LL.s20, LL.s16, LL.s20, LL.s32),
                children: [
                  Reveal(child: _Header(count: cardSpots.length)),
                  const SizedBox(height: LL.s20),
                  if (cardSpots.isNotEmpty)
                    Reveal(
                      index: 1,
                      child: GradientButton(
                        label: 'Réviser mes points faibles',
                        icon: Icons.gps_fixed_rounded,
                        onPressed: () {
                          final items = controller.buildWeakSpotSession();
                          if (items.isEmpty) return;
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => SessionScreen(items: items),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: LL.s24),
                  for (var i = 0; i < cardSpots.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LL.s12),
                      child: Reveal(
                        index: i + 2,
                        child: _CardSpotTile(entry: cardSpots[i]),
                      ),
                    ),
                  if (radicalSpots.isNotEmpty) ...[
                    const SizedBox(height: LL.s12),
                    Text('Radicaux à revoir', style: context.type.labelLarge),
                    const SizedBox(height: LL.s12),
                    Wrap(
                      spacing: LL.s8,
                      runSpacing: LL.s8,
                      children: [
                        for (final entry in radicalSpots.take(10))
                          Pressable(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => RadicalExplorerScreen(
                                  repository: _radicalRepository,
                                ),
                              ),
                            ),
                            child: LLChip(
                              label: '${entry.label} · ${entry.detail}',
                              color: LL.marigold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MimiMascot(state: MimiState.encouraging, size: 72),
        const SizedBox(width: LL.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Points faibles', style: context.type.displaySmall),
              const SizedBox(height: LL.s4),
              Text(
                count == 0
                    ? 'Rien de fragile pour l\'instant.'
                    : '$count carte${count > 1 ? 's' : ''} que tu risques '
                        'd\'avoir oubliées, classées de la plus fragile à la '
                        'moins fragile.',
                style: context.type.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardSpotTile extends StatelessWidget {
  const _CardSpotTile({required this.entry});

  final WeakSpotEntry entry;

  @override
  Widget build(BuildContext context) {
    final pct = (entry.weakness * 100).round();
    return GlassCard(
      padding: const EdgeInsets.all(LL.s16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label, style: context.type.bodyLarge),
                const SizedBox(height: LL.s4),
                Text(entry.detail, style: context.type.labelMedium),
              ],
            ),
          ),
          const SizedBox(width: LL.s12),
          LLChip(
            label: '$pct %',
            icon: Icons.trending_down_rounded,
            color: pct >= 50 ? LL.coral : LL.marigold,
            filled: true,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasStudiedNothing});

  final bool hasStudiedNothing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LL.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MimiMascot(state: MimiState.celebrating, size: 88),
            const SizedBox(height: LL.s16),
            Text(
              hasStudiedNothing
                  ? 'Rien à montrer pour l\'instant'
                  : 'Aucun point faible détecté',
              style: context.type.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LL.s8),
            Text(
              hasStudiedNothing
                  ? 'Cette liste se remplit une fois que tu as commencé à '
                      'réviser — reviens ici après quelques sessions.'
                  : 'Tout ce que tu as étudié est solide en ce moment. '
                      'Continue les révisions normales pour que ça dure.',
              textAlign: TextAlign.center,
              style: context.type.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
