import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/features/chinese/widgets/stroke_order.dart';
import 'package:learning_app/features/chinese/widgets/writing_practice.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// A short writing session over the characters the course actually uses.
///
/// Characters are served simplest-first (by stroke count), which is the
/// closest thing to a difficulty order available without extra data, and
/// keeps the first session from opening on a twelve-stroke character.
class WritingSessionScreen extends StatefulWidget {
  const WritingSessionScreen({
    super.key,
    required this.repository,
    this.length = 8,
  });

  final HanziRepository repository;
  final int length;

  @override
  State<WritingSessionScreen> createState() => _WritingSessionScreenState();
}

class _WritingSessionScreenState extends State<WritingSessionScreen> {
  late Future<List<Hanzi>> _queue;

  int _index = 0;
  int _misses = 0;
  bool _finished = false;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _queue = _buildQueue();
  }

  Future<List<Hanzi>> _buildQueue() async {
    final all = await widget.repository.characters();
    final candidates = [
      for (final hanzi in all.values)
        if (hanzi.hskLevel == 1 && hanzi.hasStrokeData) hanzi,
    ]..sort((a, b) => a.strokeCount.compareTo(b.strokeCount));
    return candidates.take(widget.length).toList();
  }

  void _advance(List<Hanzi> queue, int misses) {
    setState(() {
      _misses += misses;
      if (_index + 1 >= queue.length) {
        _finished = true;
      } else {
        _index++;
        _showAnimation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, c.auroraC],
        intensity: 0.5,
        child: SafeArea(
          child: FutureBuilder<List<Hanzi>>(
            future: _queue,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final queue = snapshot.data!;
              if (queue.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(LL.s24),
                    child: Text(
                      'Aucun caractere disponible pour l\'ecriture.',
                      style: context.type.bodyLarge,
                    ),
                  ),
                );
              }

              if (_finished) {
                return _Summary(
                  total: queue.length,
                  misses: _misses,
                  colors: ramp,
                );
              }

              final hanzi = queue[_index];

              return Column(
                children: [
                  _Header(
                    position: _index + 1,
                    total: queue.length,
                    colors: ramp,
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                          LL.s20, LL.s8, LL.s20, LL.s24),
                      children: [
                        GlassCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hanzi.pinyin.isEmpty
                                          ? '—'
                                          : hanzi.pinyin.first,
                                      style: context.type.headlineSmall
                                          ?.copyWith(color: c.accentAlt),
                                    ),
                                    const SizedBox(height: LL.s4),
                                    Text(
                                      hanzi.definition.isEmpty
                                          ? 'Trace le caractere'
                                          : hanzi.definition,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.type.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Pressable(
                                onPressed: () {
                                  if (!context
                                      .read<LearningController>()
                                      .soundEnabled) {
                                    return;
                                  }
                                  context
                                      .read<TtsService>()
                                      .speak(hanzi.character, 'zh-CN');
                                },
                                semanticLabel: 'Ecouter',
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: c.accentAlt.withValues(alpha: 0.16),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.volume_up_rounded,
                                      size: 20, color: c.accentAlt),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: LL.s20),
                        Center(
                          child: _showAnimation
                              ? StrokeOrderAnimation(
                                  key: ValueKey('anim-${hanzi.character}'),
                                  hanzi: hanzi,
                                  size: 280,
                                )
                              : WritingPractice(
                                  key: ValueKey('write-${hanzi.character}'),
                                  hanzi: hanzi,
                                  size: 280,
                                  onCompleted: (misses) => Future<void>.delayed(
                                    const Duration(milliseconds: 700),
                                    () {
                                      if (mounted) _advance(queue, misses);
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(height: LL.s16),
                        Center(
                          child: TextButton.icon(
                            onPressed: () => setState(
                                () => _showAnimation = !_showAnimation),
                            icon: Icon(
                              _showAnimation
                                  ? Icons.edit_rounded
                                  : Icons.play_circle_outline_rounded,
                              size: 18,
                            ),
                            label: Text(
                              _showAnimation
                                  ? 'Revenir a l\'ecriture'
                                  : 'Montre-moi le modele',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.position,
    required this.total,
    required this.colors,
  });

  final int position;
  final int total;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s12, LL.s8, LL.s20, LL.s8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Quitter',
          ),
          Expanded(
            child: LinearProgress(
              value: total == 0 ? 0 : (position - 1) / total,
              colors: colors,
            ),
          ),
          const SizedBox(width: LL.s16),
          Text(
            '$position/$total',
            style: context.type.labelMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.total,
    required this.misses,
    required this.colors,
  });

  final int total;
  final int misses;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    // One miss per character is still a good session: writing from memory is
    // supposed to be hard, and the point is the attempt, not a clean score.
    final rate = total == 0 ? 0.0 : (total / (total + misses)).clamp(0.0, 1.0);

    return Stack(
      children: [
        Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(LL.s24),
            children: [
              Center(
                child: ProgressRing(
                  value: rate,
                  colors: [colors.first, colors.last, colors.first],
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$total', style: context.type.displayMedium),
                      Text('caracteres', style: context.type.labelMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: LL.s32),
              Text(
                'Session d\'ecriture terminee',
                textAlign: TextAlign.center,
                style: context.type.headlineMedium,
              ),
              const SizedBox(height: LL.s12),
              Text(
                misses == 0
                    ? 'Aucun trait rate. Impressionnant.'
                    : '$misses trait${misses > 1 ? 's' : ''} a reprendre — '
                        'c\'est normal : ecrire de memoire est bien plus dur '
                        'que reconnaitre.',
                textAlign: TextAlign.center,
                style: context.type.bodyMedium,
              ),
              const SizedBox(height: LL.s32),
              GradientButton(
                label: 'Terminer',
                colors: colors,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Celebration(play: misses <= total, colors: colors),
      ],
    );
  }
}
