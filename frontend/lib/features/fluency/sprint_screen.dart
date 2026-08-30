import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/mimi_mascot.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/repository/progress_repository.dart';
import 'package:learning_app/data/srs/fluency.dart';
import 'package:learning_app/services/sound_service.dart';
import 'package:provider/provider.dart';

/// Sixty seconds of already-known sentences.
///
/// Nothing here is written back to the scheduler, and that is deliberate. The
/// drill is not a review: grading it would corrupt the memory model with
/// answers given under time pressure, and would turn the one activity in the
/// app that has no consequences into another thing to be anxious about.
class SprintScreen extends StatefulWidget {
  const SprintScreen({super.key, this.duration = const Duration(seconds: 60)});

  final Duration duration;

  @override
  State<SprintScreen> createState() => _SprintScreenState();
}

enum _Phase { ready, running, done }

class _SprintScreenState extends State<SprintScreen> {
  final _settings = SettingsRepository();

  _Phase _phase = _Phase.ready;
  List<CardItem> _pool = const [];
  int _index = 0;
  int _cleared = 0;
  int _passed = 0;
  int _best = 0;
  bool _newRecord = false;
  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.duration.inSeconds;
    _loadBest();
  }

  Future<void> _loadBest() async {
    final code = context.read<LearningController>().language?.code;
    if (code == null) return;
    final best = await _settings.sprintBest(code);
    if (!mounted) return;
    setState(() => _best = best);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    final controller = context.read<LearningController>();
    final course = controller.course;
    final progress = controller.progress;
    if (course == null || progress == null) return;

    final pool = FluencyPool(controller.scheduler)
        .select(course.allCards, progress.states, DateTime.now());

    setState(() {
      _pool = pool;
      _index = 0;
      _cleared = 0;
      _passed = 0;
      _newRecord = false;
      _secondsLeft = widget.duration.inSeconds;
      _phase = _Phase.running;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) _finish();
    });
  }

  Future<void> _finish() async {
    _timer?.cancel();
    HapticFeedback.mediumImpact();
    setState(() => _phase = _Phase.done);

    final controller = context.read<LearningController>();
    final code = controller.language?.code;
    if (code == null) return;
    if (_cleared > _best) {
      await _settings.setSprintBest(code, _cleared);
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      playSfx(context, SfxSound.celebration);
      setState(() {
        _best = _cleared;
        _newRecord = true;
      });
    }
  }

  void _answer({required bool knew}) {
    // Pressable already fires a light selection tick on tap; a stronger
    // pulse only for "compris" (knew) makes correct recall feel distinct
    // from a pass, without grading the deliberately consequence-free sprint.
    if (knew) {
      HapticFeedback.lightImpact();
      playSfx(context, SfxSound.correct);
    }
    setState(() {
      if (knew) {
        _cleared++;
      } else {
        _passed++;
      }
      _index++;
      // The pool loops rather than running out: the drill is bounded by the
      // clock, not by the material.
      if (_pool.isNotEmpty) _index %= _pool.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final language = controller.language;
    final course = controller.course;
    final progress = controller.progress;
    if (language == null || course == null || progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ramp = language.gradient;
    final ready = FluencyPool(controller.scheduler)
        .isReady(course.allCards, progress.states, DateTime.now());

    return Scaffold(
      body: ColoredBox(
        color: c.background,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Quitter',
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SPRINT', style: context.type.labelSmall),
                          Text(
                            _phase == _Phase.running
                                ? '$_secondsLeft s'
                                : 'Vitesse, pas apprentissage',
                            style: context.type.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    if (_phase == _Phase.running)
                      Text('$_cleared',
                          style: context.type.headlineSmall
                              ?.copyWith(color: c.success)),
                  ],
                ),
              ),
              Expanded(
                child: switch (_phase) {
                  _Phase.ready => _Intro(
                      colors: ramp,
                      best: _best,
                      ready: ready,
                      onStart: _start,
                    ),
                  _Phase.running => _Round(
                      card: _pool.isEmpty ? null : _pool[_index],
                      secondsLeft: _secondsLeft,
                      total: widget.duration.inSeconds,
                      colors: ramp,
                      onKnew: () => _answer(knew: true),
                      onPassed: () => _answer(knew: false),
                    ),
                  _Phase.done => _Result(
                      cleared: _cleared,
                      passed: _passed,
                      best: _best,
                      newRecord: _newRecord,
                      colors: ramp,
                      onAgain: _start,
                    ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({
    required this.colors,
    required this.best,
    required this.ready,
    required this.onStart,
  });

  final List<Color> colors;
  final int best;
  final bool ready;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
      children: [
        Reveal(
          child: Text('Soixante secondes', style: context.type.displaySmall),
        ),
        const SizedBox(height: LL.s16),
        Reveal(
          index: 1,
          child: Text(
            'Des phrases que tu connais déjà, le plus vite possible. Le but '
            'n\'est pas d\'apprendre : c\'est de raccourcir le délai entre '
            'voir une phrase et la comprendre. C\'est ce délai, et pas ton '
            'vocabulaire, qui t\'empêche de suivre une conversation réelle.',
            style: context.type.bodyLarge,
          ),
        ),
        const SizedBox(height: LL.s20),
        Reveal(
          index: 2,
          child: GlassCard(
            padding: const EdgeInsets.all(LL.s16),
            radius: LL.rMd,
            child: Row(
              children: [
                Icon(Icons.lock_open_rounded, size: 18, color: c.textTertiary),
                const SizedBox(width: LL.s12),
                Expanded(
                  child: Text(
                    'Rien de ce que tu fais ici n\'est enregistré dans tes '
                    'révisions. Aucune conséquence, aucune carte abîmée.',
                    style: context.type.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (best > 0) ...[
          const SizedBox(height: LL.s16),
          Reveal(
            index: 3,
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded,
                    size: 18, color: LL.marigold),
                const SizedBox(width: LL.s8),
                Text('Ton record : $best phrases',
                    style: context.type.bodyLarge?.copyWith(color: LL.marigold)),
              ],
            ),
          ),
        ],
        const SizedBox(height: LL.s32),
        if (ready)
          GradientButton(
            label: 'Lancer le chrono',
            icon: Icons.bolt_rounded,
            colors: colors,
            onPressed: onStart,
          )
        else
          GlassCard(
            borderColor: c.warning.withValues(alpha: 0.4),
            child: Row(
              children: [
                Icon(Icons.hourglass_empty_rounded, size: 18, color: c.warning),
                const SizedBox(width: LL.s12),
                Expanded(
                  child: Text(
                    'Il te faut au moins ${FluencyPool.minimumPool} phrases '
                    'bien sues pour que le sprint veuille dire quelque chose. '
                    'Continue tes révisions, reviens dans quelques jours.',
                    style: context.type.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Round extends StatelessWidget {
  const _Round({
    required this.card,
    required this.secondsLeft,
    required this.total,
    required this.colors,
    required this.onKnew,
    required this.onPassed,
  });

  final CardItem? card;
  final int secondsLeft;
  final int total;
  final List<Color> colors;
  final VoidCallback onKnew;
  final VoidCallback onPassed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final item = card;
    if (item == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MimiMascot(state: MimiState.encouraging, size: 72),
            const SizedBox(height: LL.s12),
            Text(
              'Plus rien à réviser pour ce sprint — reviens un peu plus tard.',
              textAlign: TextAlign.center,
              style: context.type.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s24),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(LL.rPill),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : secondsLeft / total,
              minHeight: 4,
              backgroundColor: c.glassStroke,
              valueColor: AlwaysStoppedAnimation(
                secondsLeft <= 10 ? c.danger : colors.first,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.target,
                    textAlign: TextAlign.center,
                    style: context.type.displaySmall,
                  ),
                  if (item.romanization != null) ...[
                    const SizedBox(height: LL.s8),
                    Text(
                      item.romanization!,
                      textAlign: TextAlign.center,
                      style: context.type.titleSmall
                          ?.copyWith(color: c.accentAlt),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _Button(
                  label: 'Pas encore',
                  icon: Icons.close_rounded,
                  tint: c.textSecondary,
                  onPressed: onPassed,
                ),
              ),
              const SizedBox(width: LL.s12),
              Expanded(
                flex: 2,
                child: _Button(
                  label: 'Compris',
                  icon: Icons.bolt_rounded,
                  tint: c.success,
                  filled: true,
                  onPressed: onKnew,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.icon,
    required this.tint,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final Color tint;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: label,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: filled ? tint.withValues(alpha: 0.2) : c.glassFill,
          borderRadius: BorderRadius.circular(LL.rSm + 6),
          border: Border.all(color: filled ? tint : c.glassStroke),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: tint),
            const SizedBox(width: LL.s8),
            Text(label,
                style: context.type.labelLarge?.copyWith(color: tint)),
          ],
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    required this.cleared,
    required this.passed,
    required this.best,
    required this.newRecord,
    required this.colors,
    required this.onAgain,
  });

  final int cleared;
  final int passed;
  final int best;
  final bool newRecord;
  final List<Color> colors;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final seen = cleared + passed;

    return Stack(
      children: [
        _body(context, c, seen),
        // Confetti sits above the result rather than wrapping a row: the
        // widget paints an overlay, it is not a container.
        if (newRecord)
          Positioned.fill(
            child: IgnorePointer(
              child: Celebration(play: true, colors: colors),
            ),
          ),
      ],
    );
  }

  Widget _body(BuildContext context, LLColors c, int seen) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s24, LL.s20, LL.s32),
      children: [
        Center(
          child: ProgressRing(
            value: seen == 0 ? 0 : cleared / seen,
            size: 168,
            stroke: 12,
            colors: [colors.first, colors.last, colors.first],
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$cleared', style: context.type.displayMedium),
                Text('phrases', style: context.type.labelSmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: LL.s24),
        if (newRecord)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_rounded, color: LL.marigold),
                const SizedBox(width: LL.s8),
                Text('Nouveau record',
                    style: context.type.titleMedium?.copyWith(color: LL.marigold)),
              ],
            ),
          )
        else
          Center(
            child: Text('Ton record : $best',
                style: context.type.bodyLarge?.copyWith(color: c.textSecondary)),
          ),
        const SizedBox(height: LL.s24),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CE QUE ÇA MESURE', style: context.type.labelSmall),
              const SizedBox(height: LL.s12),
              Text(
                'Pas ton niveau — ta vitesse d\'accès. Le même score la '
                'semaine prochaine sur les mêmes phrases voudrait dire que '
                'rien ne s\'est automatisé ; un score plus haut veut dire que '
                'tu as cessé de traduire dans ta tête.',
                style: context.type.bodyMedium,
              ),
              if (passed > 0) ...[
                const SizedBox(height: LL.s12),
                Text(
                  'Tu as laissé passer $passed phrase${passed > 1 ? 's' : ''}. '
                  'Normal : ce sont celles qui ne sont pas encore '
                  'automatiques.',
                  style: context.type.labelSmall
                      ?.copyWith(color: c.textTertiary, letterSpacing: 0.1),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: LL.s24),
        GradientButton(
          label: 'Encore',
          icon: Icons.refresh_rounded,
          colors: colors,
          onPressed: onAgain,
        ),
      ],
    );
  }
}
