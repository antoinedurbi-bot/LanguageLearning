import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/pinyin.dart';
import 'package:learning_app/features/chinese/widgets/tone_contour.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Ear training for tones.
///
/// This is the single highest-value drill in a Mandarin app and the one most
/// courses skip: learners who only ever *read* pinyin build a private,
/// toneless version of every word and then cannot understand speech. Two
/// modes, in the order the difficulty actually rises:
///
/// * **isolated** — one syllable, name the tone. Builds the basic category.
/// * **pairs** — two syllables, name both. This is where tones are genuinely
///   hard: a 2nd tone after a 4th sounds nothing like a 2nd tone in isolation,
///   and connected speech is made of pairs, not isolated syllables.
class ToneTrainerScreen extends StatefulWidget {
  const ToneTrainerScreen({super.key, required this.data});

  final PinyinData data;

  @override
  State<ToneTrainerScreen> createState() => _ToneTrainerScreenState();
}

enum _Mode { isolated, pairs }

class _ToneTrainerScreenState extends State<ToneTrainerScreen> {
  final _random = math.Random();

  _Mode _mode = _Mode.isolated;

  ToneExample? _single;
  TonePairExample? _pair;

  int? _answerFirst;
  int? _answerSecond;
  bool _revealed = false;

  int _asked = 0;
  int _correct = 0;
  int _shake = 0;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    setState(() {
      _revealed = false;
      _answerFirst = null;
      _answerSecond = null;

      if (_mode == _Mode.isolated) {
        final pool = widget.data.toneExamples;
        _single = pool.isEmpty ? null : pool[_random.nextInt(pool.length)];
      } else {
        final keys = widget.data.tonePairs.keys.toList();
        if (keys.isEmpty) {
          _pair = null;
        } else {
          final bucket =
              widget.data.tonePairs[keys[_random.nextInt(keys.length)]]!;
          _pair = bucket[_random.nextInt(bucket.length)];
        }
      }
    });
    // The item must be heard before it can be answered — that is the whole
    // point of the exercise.
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  void _speak({bool slow = false}) {
    final controller = context.read<LearningController>();
    if (!controller.soundEnabled) return;
    final text = _mode == _Mode.isolated ? _single?.word : _pair?.word;
    if (text == null) return;
    context.read<TtsService>().speak(text, 'zh-CN', slow: slow);
  }

  bool get _canValidate => _mode == _Mode.isolated
      ? _answerFirst != null
      : _answerFirst != null && _answerSecond != null;

  void _validate() {
    if (_revealed || !_canValidate) return;

    final bool right;
    if (_mode == _Mode.isolated) {
      right = _answerFirst == _single?.tone;
    } else {
      right = _answerFirst == _pair?.first && _answerSecond == _pair?.second;
    }

    setState(() {
      _revealed = true;
      _asked++;
      if (right) {
        _correct++;
      } else {
        _shake++;
      }
    });
    right ? HapticFeedback.mediumImpact() : HapticFeedback.heavyImpact();
    _speak(slow: true);
  }

  void _setMode(_Mode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      _asked = 0;
      _correct = 0;
    });
    _next();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, c.auroraC],
        intensity: 0.55,
        child: SafeArea(
          child: Column(
            children: [
              _Header(asked: _asked, correct: _correct),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LL.s20),
                child: SegmentedButton<_Mode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: _Mode.isolated,
                      label: Text('Une syllabe'),
                    ),
                    ButtonSegment(
                      value: _Mode.pairs,
                      label: Text('Deux syllabes'),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (value) => _setMode(value.first),
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(LL.s20, LL.s20, LL.s20, LL.s24),
                  children: [
                    Shake(trigger: _shake, child: _buildPrompt()),
                    const SizedBox(height: LL.s20),
                    if (_mode == _Mode.isolated)
                      _ToneChoices(
                        label: 'Quel ton ?',
                        selected: _answerFirst,
                        correct: _revealed ? _single?.tone : null,
                        includeNeutral: false,
                        onSelect: _revealed
                            ? null
                            : (tone) => setState(() => _answerFirst = tone),
                      )
                    else ...[
                      _ToneChoices(
                        label: '1re syllabe',
                        selected: _answerFirst,
                        correct: _revealed ? _pair?.first : null,
                        includeNeutral: false,
                        onSelect: _revealed
                            ? null
                            : (tone) => setState(() => _answerFirst = tone),
                      ),
                      const SizedBox(height: LL.s16),
                      _ToneChoices(
                        label: '2e syllabe',
                        selected: _answerSecond,
                        correct: _revealed ? _pair?.second : null,
                        includeNeutral: true,
                        onSelect: _revealed
                            ? null
                            : (tone) => setState(() => _answerSecond = tone),
                      ),
                    ],
                    if (_revealed) ...[
                      const SizedBox(height: LL.s20),
                      Reveal(
                          child: _Answer(
                              single: _single, pair: _pair, mode: _mode)),
                    ],
                  ],
                ),
              ),
              Container(
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
                  label: _revealed ? 'Suivant' : 'Verifier',
                  icon: _revealed ? Icons.arrow_forward_rounded : null,
                  colors: ramp,
                  onPressed:
                      _revealed ? _next : (_canValidate ? _validate : null),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt() {
    final c = context.ll;
    final hasItem = _mode == _Mode.isolated ? _single != null : _pair != null;
    if (!hasItem) {
      return GlassCard(
        child: Text('Aucun élément disponible.', style: context.type.bodyLarge),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(LL.s24),
      child: Column(
        children: [
          Text(
            _mode == _Mode.isolated
                ? 'ÉCOUTE ET IDENTIFIE LE TON'
                : 'ÉCOUTE ET IDENTIFIE LES DEUX TONS',
            style: context.type.labelSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LL.s20),
          // The written form stays hidden until the answer: with the tone
          // mark visible there is nothing left to hear.
          if (_revealed)
            Column(
              children: [
                Text(
                  _mode == _Mode.isolated ? _single!.word : _pair!.word,
                  style: context.type.displayMedium,
                ),
                const SizedBox(height: LL.s4),
                Text(
                  _mode == _Mode.isolated ? _single!.pinyin : _pair!.pinyin,
                  style: context.type.titleMedium?.copyWith(color: c.accentAlt),
                ),
              ],
            )
          else
            Icon(Icons.hearing_rounded, size: 56, color: c.textTertiary),
          const SizedBox(height: LL.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PlayButton(
                icon: Icons.volume_up_rounded,
                label: 'Écouter',
                onPressed: () => _speak(),
              ),
              const SizedBox(width: LL.s12),
              _PlayButton(
                icon: Icons.slow_motion_video_rounded,
                label: 'Lentement',
                onPressed: () => _speak(slow: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Pressable(
      onPressed: onPressed,
      semanticLabel: label,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: LL.s16),
        decoration: BoxDecoration(
          color: c.accentAlt.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(LL.rPill),
          border: Border.all(color: c.accentAlt.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: c.accentAlt),
            const SizedBox(width: LL.s8),
            Text(
              label,
              style: context.type.labelMedium?.copyWith(color: c.accentAlt),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToneChoices extends StatelessWidget {
  const _ToneChoices({
    required this.label,
    required this.selected,
    required this.correct,
    required this.includeNeutral,
    required this.onSelect,
  });

  final String label;
  final int? selected;

  /// Non-null once the answer is revealed.
  final int? correct;
  final bool includeNeutral;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    final tones = [1, 2, 3, 4, if (includeNeutral) 0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: context.type.labelSmall),
        const SizedBox(height: LL.s8),
        Row(
          children: [
            for (final tone in tones)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: tone == tones.last ? 0 : LL.s8,
                  ),
                  child: _ToneButton(
                    tone: tone,
                    selected: selected == tone,
                    correct: correct,
                    onTap: onSelect == null ? null : () => onSelect!(tone),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ToneButton extends StatelessWidget {
  const _ToneButton({
    required this.tone,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  final int tone;
  final bool selected;
  final int? correct;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final revealed = correct != null;
    final isAnswer = revealed && correct == tone;
    final isWrongPick = revealed && selected && correct != tone;

    final tint = isAnswer
        ? c.success
        : isWrongPick
            ? c.danger
            : selected
                ? c.accent
                : c.textTertiary;

    return Semantics(
      selected: selected,
      child: Pressable(
        onPressed: onTap,
        disabledOpacity: 1,
        semanticLabel: ToneInfo.of(tone).name,
        child: AnimatedContainer(
          duration: LL.fast,
          height: 78,
          decoration: BoxDecoration(
            color: (isAnswer || isWrongPick || selected)
                ? tint.withValues(alpha: 0.16)
                : c.glassFill,
            borderRadius: BorderRadius.circular(LL.rSm + 4),
            border: Border.all(
              color:
                  (isAnswer || isWrongPick || selected) ? tint : c.glassStroke,
              width: (isAnswer || isWrongPick || selected) ? 1.6 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 34,
                height: 20,
                child: CustomPaint(
                  painter: ToneContourPainter(tone: tone, color: tint),
                ),
              ),
              const SizedBox(height: LL.s4),
              Text(
                tone == 0 ? 'neutre' : '$tone',
                style: context.type.labelMedium?.copyWith(color: tint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Answer extends StatelessWidget {
  const _Answer({required this.single, required this.pair, required this.mode});

  final ToneExample? single;
  final TonePairExample? pair;
  final _Mode mode;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final definition =
        mode == _Mode.isolated ? single?.definition : pair?.definition;
    final tones = mode == _Mode.isolated
        ? [single?.tone ?? 0]
        : [pair?.first ?? 0, pair?.second ?? 0];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final tone in tones)
            Padding(
              padding: const EdgeInsets.only(bottom: LL.s8),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 20,
                    child: CustomPaint(
                      painter: ToneContourPainter(tone: tone, color: c.accent),
                    ),
                  ),
                  const SizedBox(width: LL.s12),
                  Expanded(
                    child: Text(
                      '${ToneInfo.of(tone).name} — ${ToneInfo.of(tone).contour}',
                      style: context.type.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          if (definition != null && definition.isNotEmpty) ...[
            const SizedBox(height: LL.s8),
            Divider(color: c.divider),
            const SizedBox(height: LL.s8),
            Text('SENS (EN ANGLAIS)', style: context.type.labelSmall),
            const SizedBox(height: LL.s4),
            Text(definition, style: context.type.bodyMedium),
          ],
          if (mode == _Mode.pairs && pair?.first == 3 && pair?.second == 3) ...[
            const SizedBox(height: LL.s12),
            Container(
              padding: const EdgeInsets.all(LL.s12),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(LL.rSm),
                border: Border.all(color: c.warning.withValues(alpha: 0.4)),
              ),
              child: Text(
                'Attention : deux 3es tons de suite se prononcent 2e + 3e. '
                'Tu entends donc "${pair!.pinyin}" avec un ton montant sur la '
                'première syllabe, même si elle s\'ecrit au 3e ton.',
                style: context.type.bodyMedium?.copyWith(color: c.warning),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.asked, required this.correct});

  final int asked;
  final int correct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
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
                Text('OREILLE', style: context.type.labelSmall),
                Text('Entrainement aux tons',
                    style: context.type.headlineSmall),
              ],
            ),
          ),
          if (asked > 0)
            Text(
              '$correct/$asked',
              style: context.type.titleMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}
