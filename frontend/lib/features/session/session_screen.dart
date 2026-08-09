import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/session.dart';
import 'package:learning_app/features/session/exercises.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// A review session: a queue of items, answered one at a time.
class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key, this.items});

  /// Explicit queue, used by "practise this unit". Null builds the scheduled
  /// session from what is actually due.
  final List<SessionItem>? items;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final _checker = const AnswerChecker();
  final _builder = const SessionBuilder();
  final _answerController = TextEditingController();
  final _answerFocus = FocusNode();
  final _random = math.Random();

  late List<SessionItem> _queue;
  int _index = 0;

  // Per-item answer state.
  String? _selectedChoice;
  List<String> _bank = [];
  List<String> _chosen = [];
  bool _revealed = false;
  bool _wasCorrect = false;
  int _shakeTrigger = 0;

  // Session totals.
  int _correct = 0;
  int _answered = 0;
  bool _finished = false;

  List<String> _choices = [];
  int _clozeIndex = 0;

  @override
  void initState() {
    super.initState();
    final controller = context.read<LearningController>();
    _queue = widget.items ?? controller.buildSession();
    if (_queue.isEmpty) {
      _finished = true;
    } else {
      _prepareItem();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocus.dispose();
    super.dispose();
  }

  SessionItem get _item => _queue[_index];

  void _prepareItem() {
    final controller = context.read<LearningController>();
    final course = controller.course;
    final item = _queue[_index];

    _selectedChoice = null;
    _revealed = false;
    _wasCorrect = false;
    _answerController.clear();

    if (course != null) {
      _choices = _builder.choicesFor(
        course: course,
        card: item.card,
        random: _random,
      );
    }

    // Word bank: the real chunks plus a couple of near-miss decoys.
    final decoys = item.card.distractors.take(2).toList();
    _bank = [...item.card.tokens, ...decoys]..shuffle(_random);
    _chosen = [];

    // Cloze removes one chunk; prefer a content chunk over punctuation.
    final candidates = [
      for (var i = 0; i < item.card.tokens.length; i++)
        if (item.card.tokens[i].trim().length > 1) i,
    ];
    _clozeIndex =
        candidates.isEmpty ? 0 : candidates[_random.nextInt(candidates.length)];

    // Typing exercises should be ready to type into.
    if (item.mode == ExerciseMode.produce || item.mode == ExerciseMode.cloze) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _answerFocus.requestFocus();
      });
    }

    if (item.mode == ExerciseMode.listen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
    }
  }

  void _speak({bool slow = false}) {
    final controller = context.read<LearningController>();
    if (!controller.soundEnabled) return;
    final course = controller.course;
    if (course == null) return;
    context
        .read<TtsService>()
        .speak(_item.card.target, course.ttsLocale, slow: slow);
  }

  String get _clozeExpected => _item.card.tokens[_clozeIndex];

  String get _clozePrompt {
    final tokens = [..._item.card.tokens];
    tokens[_clozeIndex] = '_____';
    return _join(tokens);
  }

  /// CJK text is written without spaces between words, so re-joining the
  /// tokens must not insert any.
  String _join(List<String> tokens) {
    final code = context.read<LearningController>().language?.code;
    if (code == 'zh') return tokens.join();
    return tokens
        .join(' ')
        .replaceAll(RegExp(r'\s+([,.!?;:])'), r'$1')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool _evaluate() {
    final card = _item.card;
    return switch (_item.mode) {
      ExerciseMode.recognize ||
      ExerciseMode.listen =>
        _selectedChoice == card.native,
      ExerciseMode.build => _checker.isCorrect(_join(_chosen), card.target),
      ExerciseMode.cloze =>
        _checker.isCorrect(_answerController.text, _clozeExpected),
      ExerciseMode.produce =>
        _checker.isCorrect(_answerController.text, card.target),
    };
  }

  bool get _canSubmit {
    if (_revealed) return true;
    return switch (_item.mode) {
      ExerciseMode.recognize || ExerciseMode.listen => _selectedChoice != null,
      ExerciseMode.build => _chosen.isNotEmpty,
      ExerciseMode.cloze ||
      ExerciseMode.produce =>
        _answerController.text.trim().isNotEmpty,
    };
  }

  void _submit() {
    if (_revealed || !_canSubmit) return;

    final correct = _evaluate();
    setState(() {
      _revealed = true;
      _wasCorrect = correct;
      _answered += 1;
      if (correct) {
        _correct += 1;
      } else {
        _shakeTrigger += 1;
      }
    });

    correct ? HapticFeedback.mediumImpact() : HapticFeedback.heavyImpact();
    _answerFocus.unfocus();

    // Hearing the sentence right after answering is the moment it sticks.
    _speak();
  }

  Future<void> _grade(Grade grade) async {
    final controller = context.read<LearningController>();
    await controller.grade(_item.card, grade);
    if (!mounted) return;

    if (_index + 1 >= _queue.length) {
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _index += 1;
      _prepareItem();
    });
  }

  /// Grading after a wrong answer is not a choice — a failed card is a lapse.
  Future<void> _continueAfterWrong() => _grade(Grade.again);

  Future<bool> _confirmExit() async {
    if (_finished || _answered == 0) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la session ?'),
        content: Text(
          'Les $_answered carte${_answered > 1 ? 's' : ''} deja repondue'
          '${_answered > 1 ? 's' : ''} sont enregistrees. Le reste de la file '
          'restera en attente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Quitter',
              style: TextStyle(color: context.ll.danger),
            ),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final ramp = controller.language?.gradient ??
        [context.ll.accent, context.ll.accentAlt];

    if (_finished) {
      return _SummaryScreen(
        answered: _answered,
        correct: _correct,
        colors: ramp,
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: AuroraBackground(
          colors: [ramp.first, ramp.last, context.ll.auroraC],
          // Calmer than the dashboard: the sentence is what should hold
          // attention during a review, not the background.
          intensity: 0.55,
          child: SafeArea(
            child: Column(
              children: [
                _SessionHeader(
                  progress: _index / _queue.length,
                  position: _index + 1,
                  total: _queue.length,
                  colors: ramp,
                  onClose: () async {
                    if (await _confirmExit() && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                        LL.s20, LL.s20, LL.s20, LL.s32),
                    children: [
                      Shake(
                        trigger: _shakeTrigger,
                        child: _buildExerciseBody(),
                      ),
                      if (_revealed) ...[
                        const SizedBox(height: LL.s20),
                        Reveal(
                          child: ExplanationPanel(
                            card: _item.card,
                            correct: _wasCorrect,
                            onSpeak: () => _speak(slow: true),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _Footer(
                  revealed: _revealed,
                  wasCorrect: _wasCorrect,
                  canSubmit: _canSubmit,
                  colors: ramp,
                  item: _item,
                  scheduler: controller.scheduler,
                  onSubmit: _submit,
                  onGrade: _grade,
                  onContinue: _continueAfterWrong,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseBody() {
    final item = _item;
    final card = item.card;

    switch (item.mode) {
      case ExerciseMode.recognize:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.isNew) ...[
              _NewCardBanner(focus: card.focus),
              const SizedBox(height: LL.s12),
            ],
            PromptCard(
              instruction: 'Que signifie cette phrase ?',
              text: card.target,
              romanization: card.romanization,
              large: true,
              onSpeak: _speak,
            ),
            const SizedBox(height: LL.s20),
            ChoiceExercise(
              options: _choices,
              correct: card.native,
              selected: _selectedChoice,
              revealed: _revealed,
              onSelect: (value) => setState(() => _selectedChoice = value),
            ),
          ],
        );

      case ExerciseMode.listen:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(
              instruction: 'Ecoute et choisis le sens',
              text: card.target,
              obscured: !_revealed,
              onSpeak: () => _speak(slow: true),
            ),
            const SizedBox(height: LL.s20),
            ChoiceExercise(
              options: _choices,
              correct: card.native,
              selected: _selectedChoice,
              revealed: _revealed,
              onSelect: (value) => setState(() => _selectedChoice = value),
            ),
          ],
        );

      case ExerciseMode.build:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(
              instruction: 'Reconstruis la phrase',
              text: card.native,
              large: true,
            ),
            const SizedBox(height: LL.s20),
            BuildExercise(
              bank: _bank,
              chosen: _chosen,
              revealed: _revealed,
              onPick: (i) => setState(() {
                _chosen.add(_bank[i]);
                _bank.removeAt(i);
              }),
              onUnpick: (i) => setState(() {
                _bank.add(_chosen[i]);
                _chosen.removeAt(i);
              }),
            ),
          ],
        );

      case ExerciseMode.cloze:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(
              instruction: 'Complete le mot manquant',
              text: _clozePrompt,
              large: true,
              onSpeak: _speak,
            ),
            const SizedBox(height: LL.s12),
            Text(card.native, style: context.type.bodyLarge),
            const SizedBox(height: LL.s20),
            TypeExercise(
              controller: _answerController,
              focusNode: _answerFocus,
              revealed: _revealed,
              onSubmit: _submit,
              hint: 'Le mot qui manque',
              helper: 'Les accents et la ponctuation ne sont pas comptes.',
            ),
          ],
        );

      case ExerciseMode.produce:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PromptCard(
              instruction: 'Traduis cette phrase',
              text: card.native,
              large: true,
            ),
            const SizedBox(height: LL.s20),
            TypeExercise(
              controller: _answerController,
              focusNode: _answerFocus,
              revealed: _revealed,
              onSubmit: _submit,
              hint: 'Ecris la phrase complete',
              helper: 'Les accents et la ponctuation ne sont pas comptes.',
            ),
          ],
        );
    }
  }
}

class _NewCardBanner extends StatelessWidget {
  const _NewCardBanner({required this.focus});

  final String focus;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Container(
      padding: const EdgeInsets.all(LL.s12),
      decoration: BoxDecoration(
        color: c.accentAlt.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(LL.rSm),
        border: Border.all(color: c.accentAlt.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, size: 18, color: c.accentAlt),
          const SizedBox(width: LL.s8),
          Expanded(
            child: Text(
              'Nouvelle phrase - $focus',
              style: context.type.labelMedium?.copyWith(color: c.accentAlt),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.progress,
    required this.position,
    required this.total,
    required this.colors,
    required this.onClose,
  });

  final double progress;
  final int position;
  final int total;
  final List<Color> colors;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s12, LL.s8, LL.s20, LL.s8),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Quitter la session',
          ),
          Expanded(child: LinearProgress(value: progress, colors: colors)),
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

/// The action bar. Before answering it holds one button; after a correct
/// answer it holds the self-grading buttons with their real intervals, so the
/// learner can see what each choice costs.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.revealed,
    required this.wasCorrect,
    required this.canSubmit,
    required this.colors,
    required this.item,
    required this.scheduler,
    required this.onSubmit,
    required this.onGrade,
    required this.onContinue,
  });

  final bool revealed;
  final bool wasCorrect;
  final bool canSubmit;
  final List<Color> colors;
  final SessionItem item;
  final Scheduler scheduler;
  final VoidCallback onSubmit;
  final ValueChanged<Grade> onGrade;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final now = DateTime.now();

    return Container(
      padding: EdgeInsets.fromLTRB(
        LL.s20,
        LL.s16,
        LL.s20,
        LL.s16 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: !revealed
          ? GradientButton(
              label: 'Verifier',
              colors: colors,
              onPressed: canSubmit ? onSubmit : null,
            )
          : !wasCorrect
              ? GradientButton(
                  label: 'Continuer',
                  icon: Icons.arrow_forward_rounded,
                  colors: colors,
                  onPressed: onContinue,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'C\'etait comment ?',
                      style: context.type.labelMedium,
                    ),
                    const SizedBox(height: LL.s12),
                    Row(
                      children: [
                        for (final grade in [
                          Grade.hard,
                          Grade.good,
                          Grade.easy,
                        ])
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: grade == Grade.easy ? 0 : LL.s8,
                              ),
                              child: _GradeButton(
                                grade: grade,
                                interval: scheduler.previewInterval(
                                  item.state,
                                  grade,
                                  now,
                                ),
                                onPressed: () => onGrade(grade),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton({
    required this.grade,
    required this.interval,
    required this.onPressed,
  });

  final Grade grade;
  final String interval;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final (label, tint) = switch (grade) {
      Grade.again => ('A revoir', c.danger),
      Grade.hard => ('Difficile', c.warning),
      Grade.good => ('Correct', c.accent),
      Grade.easy => ('Facile', c.success),
    };

    return Pressable(
      onPressed: onPressed,
      semanticLabel: '$label, revient dans $interval',
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: tint.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          border: Border.all(color: tint.withValues(alpha: 0.45)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: context.type.labelMedium?.copyWith(
                color: tint,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: LL.s2),
            Text(interval, style: context.type.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _SummaryScreen extends StatelessWidget {
  const _SummaryScreen({
    required this.answered,
    required this.correct,
    required this.colors,
  });

  final int answered;
  final int correct;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final rate = answered == 0 ? 0.0 : correct / answered;

    // Retention far above target means the intervals are too short and time
    // is being wasted; far below means cards are being introduced too fast.
    final String verdict;
    if (answered == 0) {
      verdict = 'Rien n\'etait du. La file se remplira toute seule.';
    } else if (rate >= 0.95) {
      verdict = 'Tres haut. Ces cartes pourraient espacer davantage : '
          'note-les "Facile" quand elles reviennent sans effort.';
    } else if (rate >= 0.8) {
      verdict = 'Exactement la zone visee. Autour de 90 % de reussite, '
          'chaque revision compte au maximum.';
    } else {
      verdict = 'En dessous de la cible. Rien d\'anormal : les cartes ratees '
          'reviennent vite, et c\'est la qu\'elles s\'ancrent.';
    }

    return Scaffold(
      body: AuroraBackground(
        colors: [colors.first, colors.last, c.auroraC],
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(LL.s24),
                    children: [
                      Reveal(
                        child: Center(
                          child: ProgressRing(
                            value: rate,
                            colors: [colors.first, colors.last, colors.first],
                            center: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${(rate * 100).round()}%',
                                  style: context.type.displayMedium,
                                ),
                                Text('de reussite',
                                    style: context.type.labelMedium),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: LL.s32),
                      Reveal(
                        index: 1,
                        child: Text(
                          answered == 0 ? 'Rien a reviser' : 'Session terminee',
                          textAlign: TextAlign.center,
                          style: context.type.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: LL.s12),
                      Reveal(
                        index: 2,
                        child: Text(
                          '$correct / $answered',
                          textAlign: TextAlign.center,
                          style: context.type.titleMedium?.copyWith(
                            color: c.accent,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      const SizedBox(height: LL.s16),
                      Reveal(
                        index: 3,
                        child: Text(
                          verdict,
                          textAlign: TextAlign.center,
                          style: context.type.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: LL.s32),
                      Reveal(
                        index: 4,
                        child: GradientButton(
                          label: 'Terminer',
                          colors: colors,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Celebration(play: answered > 0 && rate >= 0.7, colors: colors),
          ],
        ),
      ),
    );
  }
}
