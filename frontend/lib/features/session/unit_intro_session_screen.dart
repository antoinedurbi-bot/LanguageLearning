import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/session.dart';
import 'package:learning_app/features/session/exercises.dart';
import 'package:learning_app/features/session/session_screen.dart';
import 'package:learning_app/services/sound_service.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// First-encounter walk through a unit's brand-new cards.
///
/// A learner meeting a grammar point for the first time is not ready for a
/// flat, mode-scrambled review queue the moment they finish reading the
/// lesson — that is what turned this app into "disconnected flashcards" in
/// the first place. This screen ramps up in three phases instead:
///
/// 1. **Découverte** (guided) — each sentence shown with its translation,
///    pronunciation and grammar focus up front. No quiz: pure exposure,
///    continuing what the grammar lesson already explained.
/// 2. **Reconnaissance** — the same cards as a multiple-choice check: did
///    the learner notice the pattern, without demanding full recall yet.
/// 3. **Production** — the same cards as free-text translation: genuine
///    unprompted recall.
///
/// Only phase 3 reports back to the FSRS scheduler (via
/// [LearningController.grade]) — that is the moment a card actually leaves
/// "new" and enters the ordinary spaced-repetition pool, exactly once, on
/// completion. Phases 1 and 2 never touch [LearningController.grade], so
/// re-entering this screen (e.g. after backing out mid-way) cannot double
/// count a review. Once every card has been through this ramp, it is
/// indistinguishable from any other reviewed card: the FSRS scheduler and
/// ongoing review queue are untouched by this screen.
class UnitIntroSessionScreen extends StatefulWidget {
  const UnitIntroSessionScreen({
    super.key,
    required this.cards,
    this.onDone,
  });

  /// The unit's unstudied cards, in curriculum order. Must be non-empty —
  /// callers check [LearningController.newCardsInUnit] first.
  final List<CardItem> cards;

  /// Invoked once, right before the final summary is shown (after every
  /// card has been graded) — lets the caller chain into the unit's ordinary
  /// review queue for its already-studied cards.
  final VoidCallback? onDone;

  @override
  State<UnitIntroSessionScreen> createState() =>
      _UnitIntroSessionScreenState();
}

class _UnitIntroSessionScreenState extends State<UnitIntroSessionScreen> {
  static const _phases = SessionPhase.values;

  final _checker = const AnswerChecker();
  final _builder = const SessionBuilder();
  final _answerController = TextEditingController();
  final _answerFocus = FocusNode();
  final _random = math.Random();

  int _phaseIndex = 0;
  int _cardIndex = 0;
  int _correct = 0;
  int _answered = 0;
  bool _finished = false;

  // Per-card answer state (recognition/production phases only).
  String? _selectedChoice;
  bool _revealed = false;
  bool _wasCorrect = false;
  int _shakeTrigger = 0;
  List<String> _choices = [];

  SessionPhase get _phase => _phases[_phaseIndex];
  CardItem get _card => widget.cards[_cardIndex];

  @override
  void initState() {
    super.initState();
    _prepareCard();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocus.dispose();
    super.dispose();
  }

  void _prepareCard() {
    final controller = context.read<LearningController>();
    final course = controller.course;
    _selectedChoice = null;
    _revealed = false;
    _wasCorrect = false;
    _answerController.clear();

    if (course != null && _phase == SessionPhase.recognition) {
      _choices = _builder.choicesFor(
        course: course,
        card: _card,
        random: _random,
      );
    }

    if (_phase == SessionPhase.production) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _answerFocus.requestFocus();
      });
    }
  }

  void _speak({bool slow = false}) {
    final controller = context.read<LearningController>();
    if (!controller.soundEnabled) return;
    final course = controller.course;
    if (course == null) return;
    context.read<TtsService>().speak(_card.target, course.ttsLocale, slow: slow);
  }

  bool get _canSubmit {
    if (_phase == SessionPhase.guided) return true;
    if (_revealed) return true;
    return switch (_phase) {
      SessionPhase.recognition => _selectedChoice != null,
      SessionPhase.production => _answerController.text.trim().isNotEmpty,
      SessionPhase.guided => true,
    };
  }

  /// Guided cards have nothing to check — advancing is the only action.
  /// Recognition and production cards are checked and, only in production,
  /// fed to the FSRS scheduler.
  Future<void> _submit() async {
    if (!_canSubmit) return;

    if (_phase == SessionPhase.guided) {
      _advance();
      return;
    }

    if (!_revealed) {
      final correct = switch (_phase) {
        SessionPhase.recognition => _selectedChoice == _card.native,
        SessionPhase.production =>
          _checker.isCorrect(_answerController.text, _card.target),
        SessionPhase.guided => true,
      };
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
      playSfx(context, correct ? SfxSound.correct : SfxSound.incorrect);
      _answerFocus.unfocus();
      _speak();
      return;
    }

    if (_phase == SessionPhase.production) {
      // This is the single moment a first-encounter card reports to the
      // FSRS scheduler: production is genuine unprompted recall, so its
      // result is what the scheduler should learn from.
      final controller = context.read<LearningController>();
      await controller.grade(_card, _wasCorrect ? Grade.good : Grade.again);
    }
    _advance();
  }

  void _advance() {
    if (!mounted) return;
    if (_cardIndex + 1 < widget.cards.length) {
      setState(() {
        _cardIndex += 1;
        _prepareCard();
      });
      return;
    }

    if (_phaseIndex + 1 < _phases.length) {
      setState(() {
        _phaseIndex += 1;
        _cardIndex = 0;
        _prepareCard();
      });
      return;
    }

    widget.onDone?.call();
    setState(() => _finished = true);
  }

  Future<bool> _confirmExit() async {
    if (_finished || _answered == 0) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la découverte de l\'unité ?'),
        content: const Text(
          'Les cartes déjà validées en production sont enregistrées. Le '
          'reste de l\'unité restera à découvrir.',
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
    final ramp = controller.language?.gradient ??
        [context.ll.accent, context.ll.accentAlt];

    if (_finished) {
      return SessionSummaryScreen(
        answered: _answered,
        correct: _correct,
        colors: ramp,
      );
    }

    final totalSteps = _phases.length * widget.cards.length;
    final doneSteps = _phaseIndex * widget.cards.length + _cardIndex;

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
          intensity: 0.55,
          child: SafeArea(
            child: Column(
              children: [
                _PhaseHeader(
                  phase: _phase,
                  phaseIndex: _phaseIndex,
                  phaseCount: _phases.length,
                  progress: totalSteps == 0 ? 0 : doneSteps / totalSteps,
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
                      Shake(trigger: _shakeTrigger, child: _buildBody(ramp)),
                      if (_revealed && _phase != SessionPhase.guided) ...[
                        const SizedBox(height: LL.s20),
                        Reveal(
                          child: ExplanationPanel(
                            card: _card,
                            correct: _wasCorrect,
                            onSpeak: () => _speak(slow: true),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _PhaseFooter(
                  phase: _phase,
                  revealed: _revealed,
                  canSubmit: _canSubmit,
                  colors: ramp,
                  isLastCard: _cardIndex + 1 >= widget.cards.length &&
                      _phaseIndex + 1 >= _phases.length,
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<Color> ramp) {
    final card = _card;
    switch (_phase) {
      case SessionPhase.guided:
        return _GuidedCard(card: card, onSpeak: _speak, colors: ramp);

      case SessionPhase.recognition:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

      case SessionPhase.production:
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
              hint: 'Écris la phrase complète',
              helper: 'Les accents et la ponctuation ne sont pas comptés.',
            ),
          ],
        );
    }
  }
}

/// Guided phase: pure exposure, no quiz. The sentence, its translation and
/// pronunciation up front, with the card's grammar focus highlighted — the
/// same [CardItem.focus] the unit's grammar lesson already introduced.
class _GuidedCard extends StatelessWidget {
  const _GuidedCard({
    required this.card,
    required this.onSpeak,
    required this.colors,
  });

  final CardItem card;
  final VoidCallback onSpeak;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return GlassCard(
      padding: const EdgeInsets.all(LL.s24),
      glow: colors.first,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('NOUVELLE PHRASE', style: context.type.labelSmall),
              ),
              Pressable(
                onPressed: onSpeak,
                semanticLabel: 'Écouter la phrase',
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: c.accentAlt.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(color: c.accentAlt.withValues(alpha: 0.35)),
                  ),
                  child: Icon(Icons.volume_up_rounded, color: c.accentAlt, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: LL.s16),
          SelectableText(card.target, style: context.type.headlineMedium),
          if (card.romanization != null) ...[
            const SizedBox(height: LL.s8),
            Text(
              card.romanization!,
              style: context.type.bodyLarge
                  ?.copyWith(color: c.accentAlt, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: LL.s12),
          Text(card.native, style: context.type.titleMedium),
          const SizedBox(height: LL.s20),
          Divider(color: c.divider),
          const SizedBox(height: LL.s16),
          Text('MOT À MOT', style: context.type.labelSmall),
          const SizedBox(height: LL.s4),
          Text(card.gloss, style: context.type.bodyMedium),
          const SizedBox(height: LL.s16),
          Container(
            padding: const EdgeInsets.all(LL.s12),
            decoration: BoxDecoration(
              color: c.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(LL.rSm),
              border: Border.all(color: c.accent.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 18, color: c.accent),
                const SizedBox(width: LL.s8),
                Expanded(
                  child: Text(
                    card.focus,
                    style: context.type.bodyMedium
                        ?.copyWith(color: c.accent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Header showing which of the three phases is active — "Phase 2/3 :
/// Reconnaissance" — plus overall progress across the whole ramp, so the
/// structure is visible rather than implicit.
class _PhaseHeader extends StatelessWidget {
  const _PhaseHeader({
    required this.phase,
    required this.phaseIndex,
    required this.phaseCount,
    required this.progress,
    required this.colors,
    required this.onClose,
  });

  final SessionPhase phase;
  final int phaseIndex;
  final int phaseCount;
  final double progress;
  final List<Color> colors;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s12, LL.s8, LL.s20, LL.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Quitter',
              ),
              Expanded(
                child: Text(
                  'Phase ${phaseIndex + 1}/$phaseCount : ${phase.label}',
                  style: context.type.labelMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LL.s12),
            child: LinearProgress(value: progress, colors: colors),
          ),
        ],
      ),
    );
  }
}

class _PhaseFooter extends StatelessWidget {
  const _PhaseFooter({
    required this.phase,
    required this.revealed,
    required this.canSubmit,
    required this.colors,
    required this.isLastCard,
    required this.onSubmit,
  });

  final SessionPhase phase;
  final bool revealed;
  final bool canSubmit;
  final List<Color> colors;
  final bool isLastCard;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final String label;
    if (phase == SessionPhase.guided) {
      label = 'Suivant';
    } else if (!revealed) {
      label = 'Vérifier';
    } else {
      label = isLastCard ? 'Terminer' : 'Continuer';
    }

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
      child: GradientButton(
        label: label,
        icon: phase == SessionPhase.guided || revealed
            ? Icons.arrow_forward_rounded
            : null,
        colors: colors,
        onPressed: canSubmit ? onSubmit : null,
      ),
    );
  }
}
