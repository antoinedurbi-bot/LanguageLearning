import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/srs/session.dart';
import 'package:learning_app/features/fluency/sprint_screen.dart';
import 'package:learning_app/features/vocabulary/library_section.dart';
import 'package:learning_app/services/ai_service.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Free production practice, outside the scheduler.
///
/// The spaced-repetition queue decides what you review; this screen is where
/// you can push on demand. It draws a prompt from the course, takes a written
/// answer, and grades it — through the AI backend when it is reachable, and
/// locally otherwise, so the exercise never dead-ends on a network error.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _aiService = AiService();
  final _checker = const AnswerChecker();
  final _controller = TextEditingController();
  final _random = math.Random();

  CardItem? _card;
  String? _languageCode;
  bool _checking = false;
  AiFeedback? _feedback;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncPrompt(LearningController controller) {
    final code = controller.language?.code;
    if (code == _languageCode && _card != null) return;
    _languageCode = code;
    _card = _pick(controller);
    _controller.clear();
    _feedback = null;
  }

  CardItem? _pick(LearningController controller) {
    final course = controller.course;
    final progress = controller.progress;
    if (course == null) return null;

    // Prefer sentences already met: practising production of material never
    // seen is guessing, not practice.
    final seen = [
      for (final card in course.allCards)
        if (progress?.states.containsKey(card.id) ?? false) card,
    ];
    final pool = seen.isNotEmpty ? seen : course.allCards;
    if (pool.isEmpty) return null;
    return pool[_random.nextInt(pool.length)];
  }

  void _next() {
    final controller = context.read<LearningController>();
    setState(() {
      _card = _pick(controller);
      _controller.clear();
      _feedback = null;
    });
  }

  /// Local grading used when the API cannot be reached.
  AiFeedback _gradeLocally(CardItem card, String answer) {
    final correct = _checker.isCorrect(answer, card.target);
    if (correct) {
      return AiFeedback(
        isCorrect: true,
        feedback: 'Exact. ${card.focus}',
        fromServer: false,
      );
    }

    final similarity = _checker.similarity(answer, card.target);
    final message = similarity >= 0.8
        ? 'Très proche : il reste une petite différence.'
        : similarity >= 0.45
            ? 'L\'idée est la, mais la formulation s\'écarte du modèle.'
            : 'La phrase attendue est assez différente.';

    return AiFeedback(
      isCorrect: false,
      feedback: message,
      correctedAnswer: card.target,
      notes: [card.focus],
      fromServer: false,
    );
  }

  Future<void> _check() async {
    final card = _card;
    final code = _languageCode;
    if (card == null || code == null || _controller.text.trim().isEmpty) return;

    setState(() => _checking = true);
    AiFeedback result;
    try {
      result = await _aiService.checkAnswer(
        prompt: card.native,
        answer: _controller.text,
        targetLanguage: code,
        expectedAnswer: card.target,
      );
    } catch (_) {
      result = _gradeLocally(card, _controller.text);
    }

    if (!mounted) return;
    setState(() {
      _feedback = result;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    _syncPrompt(controller);

    final card = _card;
    final language = controller.language;
    if (card == null || language == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final ramp = language.gradient;
    final feedback = _feedback;

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
      children: [
        const Reveal(child: _Header()),
        const SizedBox(height: LL.s24),
        Reveal(
          index: 1,
          child: GlassCard(
            glow: ramp.first,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TRADUIS EN ${language.name.toUpperCase()}',
                    style: context.type.labelSmall),
                const SizedBox(height: LL.s12),
                Text(card.native, style: context.type.headlineSmall),
                const SizedBox(height: LL.s20),
                TextField(
                  controller: _controller,
                  minLines: 2,
                  maxLines: 5,
                  autocorrect: false,
                  enabled: feedback == null,
                  onSubmitted: (_) => _check(),
                  decoration: const InputDecoration(
                    labelText: 'Ta réponse',
                    helperText:
                        'Les accents et la ponctuation ne sont pas comptes.',
                    helperMaxLines: 2,
                  ),
                ),
                const SizedBox(height: LL.s16),
                if (feedback == null)
                  GradientButton(
                    label: 'Corriger',
                    colors: ramp,
                    loading: _checking,
                    onPressed: _checking ? null : _check,
                  )
                else
                  GradientButton(
                    label: 'Phrase suivante',
                    icon: Icons.refresh_rounded,
                    colors: ramp,
                    onPressed: _next,
                  ),
              ],
            ),
          ),
        ),
        if (feedback != null) ...[
          const SizedBox(height: LL.s16),
          Reveal(child: _FeedbackCard(feedback: feedback, card: card)),
        ],
        const SizedBox(height: LL.s16),
        Reveal(index: 2, child: _SprintCard(colors: ramp)),
        const SizedBox(height: LL.s16),
        const Reveal(index: 3, child: _ShadowingCard()),
        const SizedBox(height: LL.s32),
        const Reveal(index: 4, child: LibrarySection()),
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
        Text('ATELIER', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text('Production libre', style: context.type.displayMedium),
        const SizedBox(height: LL.s12),
        Text(
          'Reconnaître une phrase et savoir la produire sont deux compétences '
          'différentes. Celle-ci ne progresse qu\'en écrivant.',
          style: context.type.bodyLarge,
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback, required this.card});

  final AiFeedback feedback;
  final CardItem card;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final tint = feedback.isCorrect ? c.success : c.warning;

    return GlassCard(
      glow: tint,
      borderColor: tint.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                feedback.isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.lightbulb_rounded,
                color: tint,
                size: 20,
              ),
              const SizedBox(width: LL.s8),
              Text(
                feedback.isCorrect ? 'Correct' : 'A ajuster',
                style: context.type.labelLarge?.copyWith(color: tint),
              ),
              const Spacer(),
              if (!feedback.fromServer)
                Tooltip(
                  message: 'Correction locale : le service IA est injoignable',
                  child: LLChip(
                    label: 'hors ligne',
                    icon: Icons.cloud_off_rounded,
                    color: c.textTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: LL.s16),
          Text(feedback.feedback, style: context.type.bodyLarge),
          if (feedback.correctedAnswer != null) ...[
            const SizedBox(height: LL.s16),
            Text('PHRASE ATTENDUE', style: context.type.labelSmall),
            const SizedBox(height: LL.s4),
            SelectableText(
              feedback.correctedAnswer!,
              style: context.type.titleSmall,
            ),
            if (card.romanization != null) ...[
              const SizedBox(height: LL.s2),
              Text(
                card.romanization!,
                style: context.type.bodyMedium?.copyWith(color: c.accentAlt),
              ),
            ],
          ],
          if (feedback.notes.isNotEmpty) ...[
            const SizedBox(height: LL.s16),
            for (final note in feedback.notes)
              Padding(
                padding: const EdgeInsets.only(bottom: LL.s8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right_rounded,
                        size: 20, color: c.textTertiary),
                    Expanded(
                      child: Text(note, style: context.type.bodyMedium),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Entry point to the fluency drill.
///
/// It sits in the workshop rather than the daily flow because it is optional
/// by design: fluency work is the one strand that must never feel like a debt.
class _SprintCard extends StatelessWidget {
  const _SprintCard({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const SprintScreen()),
      ),
      semanticLabel: 'Sprint, soixante secondes de phrases connues',
      child: GlassCard(
        glow: colors.last,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt_rounded, size: 18, color: c.warning),
                const SizedBox(width: LL.s8),
                Text('Sprint', style: context.type.labelLarge),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: c.textTertiary),
              ],
            ),
            const SizedBox(height: LL.s12),
            Text(
              'Soixante secondes sur des phrases que tu connais déjà. On ne '
              'travaille pas la mémoire ici, mais la vitesse : le délai entre '
              'voir et comprendre. Rien n\'est enregistré.',
              style: context.type.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shadowing: repeating a sentence aloud immediately after hearing it. It is
/// the cheapest way to work on pronunciation and prosody without a partner,
/// and the app can drive it with the sentences already being learned.
class _ShadowingCard extends StatefulWidget {
  const _ShadowingCard();

  @override
  State<_ShadowingCard> createState() => _ShadowingCardState();
}

class _ShadowingCardState extends State<_ShadowingCard> {
  final _random = math.Random();
  CardItem? _card;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final course = controller.course;
    final c = context.ll;
    if (course == null) return const SizedBox.shrink();

    final card =
        _card ??= course.allCards[_random.nextInt(course.allCards.length)];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.record_voice_over_rounded,
                  size: 18, color: c.accentAlt),
              const SizedBox(width: LL.s8),
              Text('Shadowing', style: context.type.labelLarge),
            ],
          ),
          const SizedBox(height: LL.s12),
          Text(
            'Écoute la phrase, puis répète-la à voix haute en même temps que '
            'l\'audio. Trois fois de suite, sans lire.',
            style: context.type.bodyMedium,
          ),
          const SizedBox(height: LL.s16),
          SelectableText(card.target, style: context.type.titleMedium),
          if (card.romanization != null) ...[
            const SizedBox(height: LL.s2),
            Text(
              card.romanization!,
              style: context.type.bodyMedium?.copyWith(color: c.accentAlt),
            ),
          ],
          const SizedBox(height: LL.s16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (!controller.soundEnabled) return;
                    context
                        .read<TtsService>()
                        .speak(card.target, course.ttsLocale, slow: true);
                  },
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  label: const Text('Écouter'),
                ),
              ),
              const SizedBox(width: LL.s12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _card = course
                        .allCards[_random.nextInt(course.allCards.length)];
                  }),
                  icon: const Icon(Icons.shuffle_rounded, size: 20),
                  label: const Text('Autre'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
