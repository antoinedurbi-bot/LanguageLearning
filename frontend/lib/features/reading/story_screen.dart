import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/story.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/features/vocabulary/explanation_sheet.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// The reader.
///
/// Two rules drive every decision here. The translation stays hidden until
/// asked for, because a translation permanently on screen trains the eye to
/// skip the target language. And every single word is tappable, because the
/// thing that stops a beginner reading is not difficulty, it is the cost of
/// looking something up.
class StoryScreen extends StatefulWidget {
  const StoryScreen({
    super.key,
    required this.story,
    required this.ttsLocale,
  });

  final Story story;
  final String ttsLocale;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  /// Keys of tokens the reader looked up, as "line:token".
  final Set<String> _lookedUp = {};

  /// Lines whose translation is currently shown.
  final Set<int> _revealed = {};

  bool _showAllNative = false;
  bool _finished = false;

  void _openToken(int lineIndex, int tokenIndex, StoryToken token) {
    final line = widget.story.lines[lineIndex];
    setState(() => _lookedUp.add('$lineIndex:$tokenIndex'));

    ExplanationSheet.show(
      context,
      id: '${widget.story.id}-$lineIndex-$tokenIndex-${token.text}',
      kind: SavedKind.word,
      target: token.text,
      native: token.gloss ?? 'Sens non annoté pour ce mot',
      // When a word has no gloss of its own, the honest fallback is the
      // sentence it sits in — never an invented definition.
      explanation: token.note ??
          (token.hasGloss
              ? 'Dans cette phrase : « ${line.native} »'
              : 'Ce mot n\'a pas de fiche propre. La phrase entière veut '
                  'dire : « ${line.native} »'),
      romanization: token.romanization ?? line.romanization,
      example: line.text,
      exampleNative: line.native,
    );
  }

  void _speakLine(StoryLine line) {
    final controller = context.read<LearningController>();
    if (!controller.soundEnabled) return;
    context.read<TtsService>().speak(line.text, widget.ttsLocale);
  }

  void _speakAll() {
    final controller = context.read<LearningController>();
    if (!controller.soundEnabled) return;
    context.read<TtsService>().speak(widget.story.plainText, widget.ttsLocale);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final story = widget.story;
    final ramp = LL.gradientFor(story.languageCode);

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, c.auroraC],
        intensity: 0.4,
        child: SafeArea(
          child: Column(
            children: [
              _Toolbar(
                story: story,
                showAllNative: _showAllNative,
                lookedUp: _lookedUp.length,
                onToggleNative: () => setState(() {
                  _showAllNative = !_showAllNative;
                  if (!_showAllNative) _revealed.clear();
                }),
                onSpeakAll: _speakAll,
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
                  children: [
                    Reveal(child: _Intro(story: story)),
                    const SizedBox(height: LL.s24),
                    for (var i = 0; i < story.lines.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s20),
                        child: _LineBlock(
                          line: story.lines[i],
                          lineIndex: i,
                          languageCode: story.languageCode,
                          lookedUp: _lookedUp,
                          showNative:
                              _showAllNative || _revealed.contains(i),
                          onToggleNative: () => setState(() {
                            if (_revealed.contains(i)) {
                              _revealed.remove(i);
                            } else {
                              _revealed.add(i);
                            }
                          }),
                          onTapToken: (tokenIndex, token) =>
                              _openToken(i, tokenIndex, token),
                          onSpeak: () => _speakLine(story.lines[i]),
                        ),
                      ),
                    const SizedBox(height: LL.s8),
                    if (!_finished)
                      GradientButton(
                        label: 'J\'ai fini de lire',
                        icon: Icons.check_rounded,
                        colors: ramp,
                        onPressed: () => setState(() => _finished = true),
                      )
                    else ...[
                      _Debrief(
                        story: story,
                        lookedUp: _lookedUp.length,
                      ),
                      if (story.questions.isNotEmpty) ...[
                        const SizedBox(height: LL.s24),
                        _Questions(story: story),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.story,
    required this.showAllNative,
    required this.lookedUp,
    required this.onToggleNative,
    required this.onSpeakAll,
  });

  final Story story;
  final bool showAllNative;
  final int lookedUp;
  final VoidCallback onToggleNative;
  final VoidCallback onSpeakAll;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s16, LL.s8),
      child: Row(
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
                Text('LECTURE', style: context.type.labelSmall),
                Text(
                  lookedUp == 0
                      ? story.titleNative
                      : '$lookedUp mot${lookedUp > 1 ? 's' : ''} consulté'
                          '${lookedUp > 1 ? 's' : ''}',
                  style: context.type.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onSpeakAll,
            icon: const Icon(Icons.headphones_rounded),
            tooltip: 'Écouter le texte entier',
          ),
          IconButton(
            onPressed: onToggleNative,
            isSelected: showAllNative,
            icon: const Icon(Icons.translate_rounded),
            color: showAllNative ? c.accent : null,
            tooltip: showAllNative
                ? 'Masquer les traductions'
                : 'Afficher toutes les traductions',
          ),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(story.title, style: context.type.displaySmall),
        const SizedBox(height: LL.s4),
        Text(story.titleNative, style: context.type.bodyLarge),
        const SizedBox(height: LL.s12),
        Row(
          children: [
            LLChip(label: story.level.label, color: c.accentAlt),
            const SizedBox(width: LL.s8),
            LLChip(
              label: '${story.minutes} min',
              icon: Icons.schedule_rounded,
              color: c.textTertiary,
            ),
            const SizedBox(width: LL.s8),
            LLChip(
              label: '${story.wordCount} mots',
              color: c.textTertiary,
            ),
          ],
        ),
        const SizedBox(height: LL.s16),
        GlassCard(
          padding: const EdgeInsets.all(LL.s16),
          radius: LL.rMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(story.blurb, style: context.type.bodyMedium),
              const SizedBox(height: LL.s12),
              Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 16, color: c.accent),
                  const SizedBox(width: LL.s8),
                  Expanded(
                    child: Text(
                      'Touche n\'importe quel mot pour son sens. Touche la '
                      'ligne pour la traduction.',
                      style: context.type.labelSmall
                          ?.copyWith(color: c.accent, letterSpacing: 0.1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One line: the target text, and its translation when asked for.
class _LineBlock extends StatelessWidget {
  const _LineBlock({
    required this.line,
    required this.lineIndex,
    required this.languageCode,
    required this.lookedUp,
    required this.showNative,
    required this.onToggleNative,
    required this.onTapToken,
    required this.onSpeak,
  });

  final StoryLine line;
  final int lineIndex;
  final String languageCode;
  final Set<String> lookedUp;
  final bool showNative;
  final VoidCallback onToggleNative;
  final void Function(int tokenIndex, StoryToken token) onTapToken;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (line.speaker != null) ...[
          Text(
            line.speaker!.toUpperCase(),
            style: context.type.labelSmall?.copyWith(color: c.accentAlt),
          ),
          const SizedBox(height: LL.s4),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TappableLine(
                line: line,
                lineIndex: lineIndex,
                languageCode: languageCode,
                lookedUp: lookedUp,
                onTapToken: onTapToken,
              ),
            ),
            const SizedBox(width: LL.s8),
            Pressable(
              onPressed: onSpeak,
              semanticLabel: 'Écouter cette ligne',
              child: Padding(
                padding: const EdgeInsets.all(LL.s4),
                child: Icon(Icons.volume_up_rounded,
                    size: 18, color: c.textTertiary),
              ),
            ),
          ],
        ),
        if (line.romanization != null && showNative) ...[
          const SizedBox(height: LL.s4),
          Text(
            line.romanization!,
            style: context.type.bodyMedium?.copyWith(color: c.accentAlt),
          ),
        ],
        const SizedBox(height: LL.s4),
        Pressable(
          onPressed: onToggleNative,
          semanticLabel: showNative
              ? 'Masquer la traduction'
              : 'Afficher la traduction',
          child: AnimatedSize(
            duration: LL.fast,
            alignment: Alignment.topLeft,
            curve: Curves.easeOutCubic,
            child: showNative
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: LL.s8, horizontal: LL.s12),
                    decoration: BoxDecoration(
                      color: c.glassFill,
                      borderRadius: BorderRadius.circular(LL.rSm),
                      border: Border(
                        left: BorderSide(color: c.accent, width: 2),
                      ),
                    ),
                    child: Text(line.native, style: context.type.bodyMedium),
                  )
                : Row(
                    children: [
                      Icon(Icons.subdirectory_arrow_right_rounded,
                          size: 14, color: c.textTertiary),
                      const SizedBox(width: LL.s4),
                      Text(
                        'traduction',
                        style: context.type.labelSmall?.copyWith(
                          color: c.textTertiary,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (line.note != null && showNative) ...[
          const SizedBox(height: LL.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  size: 14, color: c.warning),
              const SizedBox(width: LL.s8),
              Expanded(
                child: Text(
                  line.note!,
                  style: context.type.labelSmall
                      ?.copyWith(color: c.textSecondary, letterSpacing: 0.1),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// The target-language line, rendered as real flowing text.
///
/// A `Wrap` of buttons would have been simpler, but it breaks the line
/// rhythm and turns a text into a keypad. Real spans keep it reading like
/// prose while every word stays tappable.
class _TappableLine extends StatefulWidget {
  const _TappableLine({
    required this.line,
    required this.lineIndex,
    required this.languageCode,
    required this.lookedUp,
    required this.onTapToken,
  });

  final StoryLine line;
  final int lineIndex;
  final String languageCode;
  final Set<String> lookedUp;
  final void Function(int tokenIndex, StoryToken token) onTapToken;

  @override
  State<_TappableLine> createState() => _TappableLineState();
}

class _TappableLineState extends State<_TappableLine> {
  final _recognizers = <int, TapGestureRecognizer>{};

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.line.tokens.length; i++) {
      if (!widget.line.tokens[i].isWord) continue;
      final index = i;
      _recognizers[index] = TapGestureRecognizer()
        ..onTap = () =>
            widget.onTapToken(index, widget.line.tokens[index]);
    }
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    // Mandarin needs more room between lines: the glyphs are denser and the
    // reader is still segmenting words visually.
    final isCjk = widget.languageCode == 'zh' || widget.languageCode == 'ja';
    final base = (isCjk ? context.type.titleMedium : context.type.titleSmall)
        ?.copyWith(height: isCjk ? 2.0 : 1.85, letterSpacing: 0);

    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < widget.line.tokens.length; i++)
            _spanFor(i, widget.line.tokens[i], base, c),
        ],
      ),
      style: base,
    );
  }

  InlineSpan _spanFor(
    int index,
    StoryToken token,
    TextStyle? base,
    LLColors c,
  ) {
    if (!token.isWord) {
      return TextSpan(text: token.text, style: base);
    }

    final wasLookedUp =
        widget.lookedUp.contains('${widget.lineIndex}:$index');

    return TextSpan(
      text: token.text,
      recognizer: _recognizers[index],
      style: base?.copyWith(
        // A soft dotted underline marks the teaching points without turning
        // the page into a highlighted mess.
        decoration: token.taught ? TextDecoration.underline : null,
        decorationStyle: TextDecorationStyle.dotted,
        decorationColor: c.accent.withValues(alpha: 0.45),
        decorationThickness: 1.5,
        backgroundColor:
            wasLookedUp ? c.accent.withValues(alpha: 0.18) : null,
      ),
    );
  }
}

class _Debrief extends StatelessWidget {
  const _Debrief({required this.story, required this.lookedUp});

  final Story story;
  final int lookedUp;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ratio = story.wordCount == 0 ? 0.0 : lookedUp / story.wordCount;

    // Krashen's i+1: the useful zone is a text you mostly understand, with a
    // little friction. Both extremes are worth naming honestly.
    final verdict = ratio > 0.25
        ? 'Tu as consulté beaucoup de mots. Ce texte est au-dessus de ton '
            'niveau actuel — relis-le demain, ce sera plus facile que tu ne '
            'le crois.'
        : ratio < 0.03
            ? 'Presque aucune consultation : ce texte est trop facile pour '
                'toi. Passe au niveau au-dessus.'
            : 'C\'est exactement la bonne difficulté : compris dans '
                'l\'ensemble, avec un peu de friction. C\'est dans cette zone '
                'qu\'on progresse le plus vite.';

    return GlassCard(
      glow: c.success,
      borderColor: c.success.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, size: 20, color: c.success),
              const SizedBox(width: LL.s8),
              Text('Texte terminé',
                  style:
                      context.type.labelLarge?.copyWith(color: c.success)),
            ],
          ),
          const SizedBox(height: LL.s16),
          Text(verdict, style: context.type.bodyLarge),
          if (story.takeaway != null) ...[
            const SizedBox(height: LL.s16),
            Text('À RETENIR', style: context.type.labelSmall),
            const SizedBox(height: LL.s4),
            Text(story.takeaway!, style: context.type.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _Questions extends StatefulWidget {
  const _Questions({required this.story});

  final Story story;

  @override
  State<_Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<_Questions> {
  final Map<int, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final questions = widget.story.questions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AS-TU SUIVI ?', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text(
          'Questions en français : on vérifie que le sens est passé, pas que '
          'tu sais traduire.',
          style: context.type.bodyMedium,
        ),
        const SizedBox(height: LL.s16),
        for (var q = 0; q < questions.length; q++) ...[
          _QuestionCard(
            question: questions[q],
            chosen: _answers[q],
            onChoose: (index) => setState(() => _answers[q] = index),
          ),
          if (q < questions.length - 1) const SizedBox(height: LL.s16),
        ],
        if (_answers.length == questions.length) ...[
          const SizedBox(height: LL.s20),
          Builder(builder: (context) {
            var correct = 0;
            for (var q = 0; q < questions.length; q++) {
              if (_answers[q] == questions[q].answerIndex) correct++;
            }
            return Center(
              child: Text(
                '$correct / ${questions.length}',
                style: context.type.displaySmall?.copyWith(
                  color: correct == questions.length ? c.success : c.warning,
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.chosen,
    required this.onChoose,
  });

  final StoryQuestion question;
  final int? chosen;
  final void Function(int index) onChoose;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final answered = chosen != null;

    return GlassCard(
      padding: const EdgeInsets.all(LL.s16),
      radius: LL.rMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question.question, style: context.type.titleSmall),
          const SizedBox(height: LL.s12),
          for (var i = 0; i < question.options.length; i++) ...[
            _Option(
              label: question.options[i],
              state: !answered
                  ? _OptionState.idle
                  : i == question.answerIndex
                      ? _OptionState.correct
                      : i == chosen
                          ? _OptionState.wrong
                          : _OptionState.muted,
              onPressed: answered ? null : () => onChoose(i),
            ),
            if (i < question.options.length - 1)
              const SizedBox(height: LL.s8),
          ],
          if (answered && question.explanation != null) ...[
            const SizedBox(height: LL.s12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: c.textTertiary),
                const SizedBox(width: LL.s8),
                Expanded(
                  child: Text(
                    question.explanation!,
                    style: context.type.labelSmall?.copyWith(
                        color: c.textTertiary, letterSpacing: 0.1),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

enum _OptionState { idle, correct, wrong, muted }

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.state,
    required this.onPressed,
  });

  final String label;
  final _OptionState state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final (border, fill, icon) = switch (state) {
      _OptionState.idle => (c.glassStroke, c.glassFill, null),
      _OptionState.correct => (
          c.success,
          c.success.withValues(alpha: 0.16),
          Icons.check_rounded
        ),
      _OptionState.wrong => (
          c.danger,
          c.danger.withValues(alpha: 0.14),
          Icons.close_rounded
        ),
      _OptionState.muted => (c.glassStroke, Colors.transparent, null),
    };

    return Pressable(
      onPressed: onPressed,
      // Revealed options must stay readable: dimming the answer the learner
      // is trying to read defeats the purpose of showing it.
      disabledOpacity: 1,
      semanticLabel: label,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: LL.s16, vertical: LL.s12),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(LL.rSm + 4),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.type.bodyLarge)),
            if (icon != null) Icon(icon, size: 18, color: border),
          ],
        ),
      ),
    );
  }
}
