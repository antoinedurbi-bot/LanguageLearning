import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/kana/kana.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// The hiragana/katakana chart.
///
/// The two syllabaries are the prerequisite for reading anything in
/// Japanese at all — closer to the alphabet than to vocabulary. This screen
/// lets a learner work the grid row by row and hear every cell, the same
/// role the pinyin chart plays for Mandarin syllables.
class KanaChartScreen extends StatefulWidget {
  const KanaChartScreen({super.key});

  @override
  State<KanaChartScreen> createState() => _KanaChartScreenState();
}

class _KanaChartScreenState extends State<KanaChartScreen> {
  KanaScript _script = KanaScript.hiragana;
  bool _showDakuten = false;
  bool _showCombos = false;

  @override
  Widget build(BuildContext context) {
    final entries = allKana.where((k) {
      if (k.script != _script) return false;
      if (k.isCombo) return _showCombos;
      if (k.isDakuten) return _showDakuten;
      return true;
    }).toList();

    final rows = <String>[];
    for (final k in entries) {
      if (!rows.contains(k.row)) rows.add(k.row);
    }
    rows.sort((a, b) =>
        kanaRowOrder.indexOf(a).compareTo(kanaRowOrder.indexOf(b)));

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
                        Text('SYLLABAIRES', style: context.type.labelSmall),
                        Text('Hiragana et katakana',
                            style: context.type.headlineSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LL.s20),
              child: Row(
                children: [
                  Expanded(
                    child: _ScriptToggle(
                      script: _script,
                      onChanged: (s) => setState(() => _script = s),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: LL.s8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LL.s20),
              child: Wrap(
                spacing: LL.s8,
                children: [
                  FilterChip(
                    label: const Text('Sonores (゛゜)'),
                    selected: _showDakuten,
                    onSelected: (v) => setState(() => _showDakuten = v),
                  ),
                  FilterChip(
                    label: const Text('Combinaisons (ゃゅょ)'),
                    selected: _showCombos,
                    onSelected: (v) => setState(() => _showCombos = v),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    LL.s20, LL.s12, LL.s20, LL.s32),
                itemCount: rows.length,
                itemBuilder: (context, i) {
                  final row = rows[i];
                  final items =
                      entries.where((k) => k.row == row).toList();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: LL.s16),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(kanaRowLabel[row] ?? row,
                              style: context.type.labelMedium),
                          const SizedBox(height: LL.s8),
                          Wrap(
                            spacing: LL.s8,
                            runSpacing: LL.s8,
                            children: [
                              for (final k in items) _KanaTile(kana: k),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScriptToggle extends StatelessWidget {
  const _ScriptToggle({required this.script, required this.onChanged});

  final KanaScript script;
  final ValueChanged<KanaScript> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<KanaScript>(
      segments: const [
        ButtonSegment(value: KanaScript.hiragana, label: Text('ひらがな')),
        ButtonSegment(value: KanaScript.katakana, label: Text('カタカナ')),
      ],
      selected: {script},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _KanaTile extends StatelessWidget {
  const _KanaTile({required this.kana});

  final Kana kana;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Pressable(
      onPressed: () =>
          context.read<TtsService>().speak(kana.character, 'ja-JP'),
      semanticLabel: '${kana.character}, ${kana.romaji}',
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(LL.rMd),
          border: Border.all(color: c.glassStroke),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(kana.character, style: context.type.titleMedium),
            Text(kana.romaji, style: context.type.labelSmall),
          ],
        ),
      ),
    );
  }
}
