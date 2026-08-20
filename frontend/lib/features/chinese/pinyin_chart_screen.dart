import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/pinyin.dart';
import 'package:learning_app/features/chinese/widgets/tone_contour.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// The pinyin syllable chart.
///
/// Mandarin has a closed inventory of a few hundred syllables — far smaller
/// than a French speaker expects. Seeing that the whole language is built from
/// a finite grid, and being able to hear any cell, turns pronunciation from an
/// open-ended worry into a list that can be worked through.
///
/// Only combinations that actually occur in the vocabulary are shown: an
/// exhaustive theoretical grid would be mostly empty cells.
class PinyinChartScreen extends StatefulWidget {
  const PinyinChartScreen({super.key, required this.data});

  final PinyinData data;

  @override
  State<PinyinChartScreen> createState() => _PinyinChartScreenState();
}

class _PinyinChartScreenState extends State<PinyinChartScreen> {
  String? _selectedInitial;

  @override
  Widget build(BuildContext context) {
    final initials = [
      for (final initial in PinyinData.initialOrder)
        if (widget.data.chart.containsKey(initial)) initial,
    ];
    final active = _selectedInitial ??
        (initials.contains('b')
            ? 'b'
            : (initials.isEmpty ? null : initials.first));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                        Text('PRONONCIATION', style: context.type.labelSmall),
                        Text('Table des syllabes',
                            style: context.type.headlineSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
                children: [
                  GlassCard(
                    child: Text(
                      'Le mandarin n\'utilise qu\'environ 400 syllabes '
                      'différentes. Choisis une initiale, puis touche une '
                      'syllabe pour l\'entendre dans chacun de ses tons.',
                      style: context.type.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: LL.s16),
                  Text('INITIALE', style: context.type.labelSmall),
                  const SizedBox(height: LL.s8),
                  Wrap(
                    spacing: LL.s8,
                    runSpacing: LL.s8,
                    children: [
                      for (final initial in initials)
                        _InitialChip(
                          label: initial.isEmpty ? '(aucune)' : initial,
                          selected: initial == active,
                          onTap: () =>
                              setState(() => _selectedInitial = initial),
                        ),
                    ],
                  ),
                  const SizedBox(height: LL.s24),
                  if (active != null) ...[
                    Text(
                      active.isEmpty
                          ? 'SYLLABES SANS INITIALE'
                          : 'SYLLABES EN « $active »',
                      style: context.type.labelSmall,
                    ),
                    const SizedBox(height: LL.s12),
                    _FinalsGrid(
                      initial: active,
                      finals: widget.data.chart[active] ?? const {},
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialChip extends StatelessWidget {
  const _InitialChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Semantics(
      selected: selected,
      child: Pressable(
        onPressed: onTap,
        semanticLabel: 'Initiale $label',
        child: AnimatedContainer(
          duration: LL.fast,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 44),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: LL.s12),
          decoration: BoxDecoration(
            color: selected ? c.accent.withValues(alpha: 0.18) : c.glassFill,
            borderRadius: BorderRadius.circular(LL.rSm),
            border: Border.all(color: selected ? c.accent : c.glassStroke),
          ),
          child: Text(
            label,
            style: context.type.titleSmall?.copyWith(
              color: selected ? c.accent : c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FinalsGrid extends StatelessWidget {
  const _FinalsGrid({required this.initial, required this.finals});

  final String initial;
  final Map<String, List<int>> finals;

  @override
  Widget build(BuildContext context) {
    final keys = finals.keys.toList()..sort();
    if (keys.isEmpty) {
      return Text('Aucune syllabe.', style: context.type.bodyMedium);
    }

    return Wrap(
      spacing: LL.s8,
      runSpacing: LL.s8,
      children: [
        for (final finalPart in keys)
          _SyllableTile(
            syllable: '$initial$finalPart',
            tones: finals[finalPart]!,
          ),
      ],
    );
  }
}

/// One syllable, with a dot per tone it occurs in. Tapping plays it.
class _SyllableTile extends StatelessWidget {
  const _SyllableTile({required this.syllable, required this.tones});

  final String syllable;
  final List<int> tones;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: () => _showTones(context),
      semanticLabel: 'Syllabe $syllable',
      child: Container(
        constraints: const BoxConstraints(minWidth: 74, minHeight: 56),
        padding: const EdgeInsets.symmetric(
          horizontal: LL.s12,
          vertical: LL.s8,
        ),
        decoration: BoxDecoration(
          color: c.glassFill,
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(color: c.glassStroke),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(syllable, style: context.type.titleSmall),
            const SizedBox(height: LL.s4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final tone in tones)
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: ToneContour(
                      tone: tone,
                      color: c.accentAlt,
                      width: 12,
                      height: 9,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTones(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final c = sheetContext.ll;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(LL.s20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(syllable, style: sheetContext.type.displayMedium),
                const SizedBox(height: LL.s4),
                Text(
                  'Cette syllabe existe dans ${tones.length} ton'
                  '${tones.length > 1 ? 's' : ''}.',
                  style: sheetContext.type.bodyMedium,
                ),
                const SizedBox(height: LL.s20),
                for (final tone in tones)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LL.s12),
                    child: Pressable(
                      onPressed: () {
                        if (!sheetContext
                            .read<LearningController>()
                            .soundEnabled) {
                          return;
                        }
                        sheetContext.read<TtsService>().speak(
                              SyllableToneMark.apply(syllable, tone),
                              'zh-CN',
                              slow: true,
                            );
                      },
                      semanticLabel:
                          '${SyllableToneMark.apply(syllable, tone)}, ${ToneInfo.of(tone).name}',
                      child: Container(
                        padding: const EdgeInsets.all(LL.s12),
                        decoration: BoxDecoration(
                          color: c.glassFill,
                          borderRadius: BorderRadius.circular(LL.rSm),
                          border: Border.all(color: c.glassStroke),
                        ),
                        child: Row(
                          children: [
                            ToneContour(tone: tone, color: c.accent),
                            const SizedBox(width: LL.s16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SyllableToneMark.apply(syllable, tone),
                                    style: sheetContext.type.titleMedium,
                                  ),
                                  Text(
                                    '${ToneInfo.of(tone).name} — '
                                    '${ToneInfo.of(tone).contour}',
                                    style: sheetContext.type.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.volume_up_rounded, color: c.accentAlt),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
