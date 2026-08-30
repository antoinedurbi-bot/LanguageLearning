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
import 'package:learning_app/data/srs/dictation.dart';
import 'package:learning_app/data/srs/session.dart';
import 'package:learning_app/services/sound_service.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Listen and type it back.
///
/// Every other exercise in the app lets a learner see the target sentence at
/// some point before answering — recognition shows it outright, "listen"
/// mode reveals it after picking a meaning. That reading crutch is exactly
/// what lets a weak ear pass unnoticed: multiple choice can be solved by
/// ruling out options, never by actually resolving the sounds into words.
/// Dictation removes the crutch entirely. The sentence is never shown until
/// after an answer is typed, so the only route to a right answer is hearing
/// the sentence correctly and knowing how it is written — the classic pairing
/// for cementing sound-to-orthography mapping.
///
/// Consequence-free like the fluency sprint: nothing here is written back to
/// the scheduler. Getting a dictation wrong is not evidence the card was
/// forgotten, it may just mean the ear needs another pass, so grading it
/// would corrupt the memory model on a different signal than the one it
/// expects.
class DictationScreen extends StatefulWidget {
  const DictationScreen({super.key, this.rounds = 8});

  final int rounds;

  @override
  State<DictationScreen> createState() => _DictationScreenState();
}

enum _Phase { ready, running, done }

class _DictationScreenState extends State<DictationScreen> {
  static const _checker = AnswerChecker();

  final _controller = TextEditingController();
  final _focus = FocusNode();

  _Phase _phase = _Phase.ready;
  List<CardItem> _queue = const [];
  int _index = 0;
  int _correct = 0;
  bool _revealed = false;
  DictationVerdict? _verdict;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  CardItem? get _card => _index < _queue.length ? _queue[_index] : null;

  void _start() {
    final controller = context.read<LearningController>();
    final course = controller.course;
    final progress = controller.progress;
    if (course == null || progress == null) return;

    final pool = DictationPool(controller.scheduler)
        .select(course.allCards, progress.states, DateTime.now(),
            limit: widget.rounds);

    setState(() {
      _queue = pool;
      _index = 0;
      _correct = 0;
      _phase = _Phase.running;
    });
    _prepareRound();
  }

  void _prepareRound() {
    _controller.clear();
    _revealed = false;
    _verdict = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
      _speak();
    });
  }

  void _speak({bool slow = false}) {
    final controller = context.read<LearningController>();
    final course = controller.course;
    final card = _card;
    if (!controller.soundEnabled || course == null || card == null) return;
    context.read<TtsService>().speak(card.target, course.ttsLocale, slow: slow);
  }

  void _submit() {
    final card = _card;
    if (card == null || _revealed || _controller.text.trim().isEmpty) return;

    final similarity = _checker.similarity(_controller.text, card.target);
    final verdict = gradeDictation(similarity);
    setState(() {
      _revealed = true;
      _verdict = verdict;
      if (verdict == DictationVerdict.correct) _correct++;
    });

    verdict == DictationVerdict.correct
        ? HapticFeedback.mediumImpact()
        : HapticFeedback.heavyImpact();
    playSfx(
      context,
      verdict == DictationVerdict.correct
          ? SfxSound.correct
          : SfxSound.incorrect,
    );
    // Hearing the correct sentence right after seeing it written is the pass
    // that actually fixes the sound-to-spelling link.
    _speak();
  }

  void _next() {
    if (_index + 1 >= _queue.length) {
      setState(() => _phase = _Phase.done);
      return;
    }
    setState(() => _index += 1);
    _prepareRound();
  }

  Future<bool> _confirmExit() async {
    if (_phase != _Phase.running || _index == 0) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la dictée ?'),
        content: const Text(
          'Rien n\'est enregistré dans tes révisions ; tu peux relancer un '
          'nouveau tour à tout moment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Quitter', style: TextStyle(color: context.ll.danger)),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final language = controller.language;
    final course = controller.course;
    final progress = controller.progress;
    if (language == null || course == null || progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ramp = language.gradient;
    final ready = DictationPool(controller.scheduler)
        .isReady(course.allCards, progress.states, DateTime.now());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: ColoredBox(
          color: context.ll.background,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (await _confirmExit() && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.close_rounded),
                        tooltip: 'Quitter',
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DICTÉE', style: context.type.labelSmall),
                            Text(
                              _phase == _Phase.running
                                  ? '${_index + 1}/${_queue.length}'
                                  : 'Écoute, puis écris',
                              style: context.type.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (_phase) {
                    _Phase.ready => _Intro(
                        colors: ramp,
                        ready: ready,
                        onStart: _start,
                      ),
                    _Phase.running => _Round(
                        card: _card,
                        controller: _controller,
                        focus: _focus,
                        revealed: _revealed,
                        verdict: _verdict,
                        colors: ramp,
                        onReplay: () => _speak(slow: true),
                        onSubmit: _submit,
                        onNext: _next,
                      ),
                    _Phase.done => _Result(
                        correct: _correct,
                        total: _queue.length,
                        colors: ramp,
                        onAgain: _start,
                      ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.colors, required this.ready, required this.onStart});

  final List<Color> colors;
  final bool ready;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
      children: [
        Reveal(child: Text('La dictée', style: context.type.displaySmall)),
        const SizedBox(height: LL.s16),
        Reveal(
          index: 1,
          child: Text(
            'Une phrase que tu connais, jouée à voix haute. Écris-la sans '
            'jamais la voir écrite avant d\'avoir répondu. C\'est le seul '
            'exercice de l\'app qui entraîne l\'oreille sans laisser la '
            'lecture faire le travail à sa place.',
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
                    'révisions — c\'est une dictée, pas un jugement.',
                    style: context.type.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: LL.s32),
        if (ready)
          GradientButton(
            label: 'Commencer',
            icon: Icons.headphones_rounded,
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
                    'Il te faut au moins ${DictationPool.minimumPool} phrases '
                    'déjà rencontrées pour que la dictée ait un sens. '
                    'Continue tes révisions, reviens un peu plus tard.',
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
    required this.controller,
    required this.focus,
    required this.revealed,
    required this.verdict,
    required this.colors,
    required this.onReplay,
    required this.onSubmit,
    required this.onNext,
  });

  final CardItem? card;
  final TextEditingController controller;
  final FocusNode focus;
  final bool revealed;
  final DictationVerdict? verdict;
  final List<Color> colors;
  final VoidCallback onReplay;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final item = card;
    if (item == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(LL.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ÉCOUTE ET ÉCRIS', style: context.type.labelSmall),
              const SizedBox(height: LL.s20),
              Center(
                child: Pressable(
                  onPressed: onReplay,
                  semanticLabel: 'Réécouter la phrase',
                  child: Container(
                    width: 76,
                    height: 76,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.first.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.first, width: 2),
                    ),
                    child: Icon(Icons.volume_up_rounded,
                        size: 34, color: colors.first),
                  ),
                ),
              ),
              const SizedBox(height: LL.s24),
              TextField(
                controller: controller,
                focusNode: focus,
                enabled: !revealed,
                autocorrect: false,
                enableSuggestions: false,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSubmit(),
                style: context.type.titleSmall,
                decoration: const InputDecoration(
                  labelText: 'Ce que tu as entendu',
                  helperText:
                      'Les accents et la ponctuation ne sont pas comptes.',
                  helperMaxLines: 2,
                ),
              ),
            ],
          ),
        ),
        if (revealed) ...[
          const SizedBox(height: LL.s16),
          Reveal(child: _Feedback(card: item, verdict: verdict!)),
        ],
        const SizedBox(height: LL.s20),
        GradientButton(
          label: revealed ? 'Suivant' : 'Vérifier',
          icon: revealed ? Icons.arrow_forward_rounded : null,
          colors: colors,
          onPressed: revealed
              ? onNext
              : (controller.text.trim().isEmpty ? null : onSubmit),
        ),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.card, required this.verdict});

  final CardItem card;
  final DictationVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final (tint, label, mimi) = switch (verdict) {
      DictationVerdict.correct => (
          c.success,
          'Entendu et écrit juste',
          MimiState.celebrating,
        ),
      DictationVerdict.close => (
          c.warning,
          'Presque — regarde la différence',
          MimiState.encouraging,
        ),
      DictationVerdict.miss => (
          c.danger,
          'Pas tout à fait ça',
          MimiState.encouraging,
        ),
    };

    return GlassCard(
      glow: tint,
      borderColor: tint.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MimiMascot(state: mimi, size: 40),
              const SizedBox(width: LL.s12),
              Text(label, style: context.type.labelLarge?.copyWith(color: tint)),
            ],
          ),
          const SizedBox(height: LL.s16),
          Text('PHRASE ENTENDUE', style: context.type.labelSmall),
          const SizedBox(height: LL.s4),
          SelectableText(card.target, style: context.type.titleMedium),
          if (card.romanization != null) ...[
            const SizedBox(height: LL.s2),
            Text(
              card.romanization!,
              style: context.type.bodyMedium?.copyWith(color: c.accentAlt),
            ),
          ],
          const SizedBox(height: LL.s8),
          Text(card.native, style: context.type.bodyLarge),
        ],
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    required this.correct,
    required this.total,
    required this.colors,
    required this.onAgain,
  });

  final int correct;
  final int total;
  final List<Color> colors;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    final rate = total == 0 ? 0.0 : correct / total;

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s24, LL.s20, LL.s32),
      children: [
        Center(
          child: ProgressRing(
            value: rate,
            size: 168,
            stroke: 12,
            colors: [colors.first, colors.last, colors.first],
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${(rate * 100).round()}%',
                    style: context.type.displayMedium),
                Text('bien entendues', style: context.type.labelSmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: LL.s24),
        Center(
          child: Text('$correct / $total', style: context.type.titleMedium),
        ),
        const SizedBox(height: LL.s24),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CE QUE ÇA MESURE', style: context.type.labelSmall),
              const SizedBox(height: LL.s12),
              Text(
                'Ta capacité à reconnaître ces phrases à l\'oreille, sans '
                'jamais les lire. Un score bas ici et haut en lecture veut '
                'dire une seule chose : c\'est l\'oreille qu\'il faut '
                'travailler, pas le vocabulaire.',
                style: context.type.bodyMedium,
              ),
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
