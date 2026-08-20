import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/radicals.dart';
import 'package:learning_app/data/repository/radical_progress_repository.dart';

/// The radical mini-curriculum: browse the ~160 Kangxi radicals that the
/// app's own characters actually use, and drill recognising them.
///
/// Radicals are taught here as their own subject rather than left implicit in
/// the character dictionary, because that is how they earn their keep: a
/// learner who explicitly knows 氵 means "water" reads 河, 海, 汉 and 泳 as
/// four variations on a theme instead of four unrelated shapes to memorise
/// from scratch.
class RadicalExplorerScreen extends StatefulWidget {
  const RadicalExplorerScreen({super.key, required this.repository});

  final RadicalRepository repository;

  @override
  State<RadicalExplorerScreen> createState() => _RadicalExplorerScreenState();
}

class _RadicalExplorerScreenState extends State<RadicalExplorerScreen> {
  final _progress = RadicalProgressRepository();

  late Future<List<Radical>> _radicals;
  Set<String> _mastered = {};

  @override
  void initState() {
    super.initState();
    _radicals = widget.repository.radicals();
    _progress.load().then((value) {
      if (mounted) setState(() => _mastered = value);
    });
  }

  Future<void> _toggleMastered(String radical) async {
    setState(() {
      _mastered = {..._mastered};
      if (!_mastered.remove(radical)) _mastered.add(radical);
    });
    await _progress.save(_mastered);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Radical>>(
          future: _radicals,
          builder: (context, snapshot) {
            final radicals = snapshot.data;
            if (radicals == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
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
                            Text('CHINOIS', style: context.type.labelSmall),
                            Text('Clés (部首)',
                                style: context.type.headlineSmall),
                          ],
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: radicals.isEmpty
                            ? null
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => RadicalQuizScreen(
                                      radicals: radicals,
                                    ),
                                  ),
                                ),
                        icon: const Icon(Icons.quiz_rounded, size: 18),
                        label: const Text('Quiz'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LL.s20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_mastered.length} / ${radicals.length} maitrisees. '
                      'Triees par nombre de caracteres debloques.',
                      style: context.type.labelMedium
                          ?.copyWith(color: c.textTertiary),
                    ),
                  ),
                ),
                const SizedBox(height: LL.s8),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        LL.s20, LL.s8, LL.s20, LL.s32 + 64),
                    itemCount: radicals.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: LL.s12),
                    itemBuilder: (context, index) {
                      final radical = radicals[index];
                      return Reveal(
                        index: index.clamp(0, 12),
                        child: _RadicalRow(
                          radical: radical,
                          mastered: _mastered.contains(radical.radical),
                          colors: ramp,
                          onToggle: () => _toggleMastered(radical.radical),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RadicalRow extends StatelessWidget {
  const _RadicalRow({
    required this.radical,
    required this.mastered,
    required this.colors,
    required this.onToggle,
  });

  final Radical radical;
  final bool mastered;
  final List<Color> colors;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onToggle,
      semanticLabel:
          '${radical.radical}, $mastered maitrise, ${radical.meaning}',
      child: GlassCard(
        padding: const EdgeInsets.all(LL.s16),
        glow: mastered ? colors.first : null,
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(LL.rSm + 4),
              ),
              child: Text(
                radical.radical,
                style: const TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
            const SizedBox(width: LL.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${radical.pinyin} · ${radical.meaning}',
                      style: context.type.titleMedium),
                  const SizedBox(height: LL.s2),
                  Text(
                    '${radical.strokeCount} traits · '
                    '${radical.characterCount} caracteres · '
                    '${radical.examples.take(5).join(' ')}',
                    style: context.type.labelMedium
                        ?.copyWith(color: c.textTertiary),
                  ),
                ],
              ),
            ),
            Icon(
              mastered
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: mastered ? colors.first : c.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Multiple-choice drill: given a radical, pick its meaning among four.
///
/// Recognition, not recall, is the right bar here — the point of the
/// curriculum is that the learner notices a familiar shape while reading a
/// character they have never met, not that they can spell out its name
/// unprompted.
class RadicalQuizScreen extends StatefulWidget {
  const RadicalQuizScreen({super.key, required this.radicals});

  final List<Radical> radicals;

  @override
  State<RadicalQuizScreen> createState() => _RadicalQuizScreenState();
}

class _RadicalQuizScreenState extends State<RadicalQuizScreen> {
  final _random = Random();
  final _progress = RadicalProgressRepository();

  late List<Radical> _pool;
  int _index = 0;
  int _correct = 0;
  Radical? _picked;
  late List<Radical> _choices;

  @override
  void initState() {
    super.initState();
    _pool = [...widget.radicals]..shuffle(_random);
    _pool = _pool.take(min(15, _pool.length)).toList();
    _buildChoices();
  }

  void _buildChoices() {
    final answer = _pool[_index];
    final others = [...widget.radicals]
      ..remove(answer)
      ..shuffle(_random);
    _choices = [answer, ...others.take(3)]..shuffle(_random);
    _picked = null;
  }

  Future<void> _pick(Radical choice) async {
    if (_picked != null) return;
    final answer = _pool[_index];
    setState(() {
      _picked = choice;
      if (choice.radical == answer.radical) {
        _correct++;
        _markMastered(answer.radical);
      }
    });
  }

  Future<void> _markMastered(String radical) async {
    final mastered = await _progress.load();
    mastered.add(radical);
    await _progress.save(mastered);
  }

  void _next() {
    if (_index + 1 >= _pool.length) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _index++;
      _buildChoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ramp = LL.gradientFor('zh');
    final answer = _pool[_index];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Fermer',
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_index) / _pool.length,
                      color: ramp.first,
                    ),
                  ),
                  const SizedBox(width: LL.s12),
                  Text('$_correct/${_pool.length}',
                      style: context.type.labelMedium),
                ],
              ),
              const SizedBox(height: LL.s32),
              Center(
                child: Text(answer.radical,
                    style: const TextStyle(fontSize: 96, height: 1)),
              ),
              const SizedBox(height: LL.s32),
              Text('Quel est le sens de cette cle ?',
                  style: context.type.titleMedium),
              const SizedBox(height: LL.s16),
              for (final choice in _choices)
                Padding(
                  padding: const EdgeInsets.only(bottom: LL.s12),
                  child: _ChoiceButton(
                    label: choice.meaning,
                    selected: _picked == choice,
                    correct: _picked != null && choice.radical == answer.radical,
                    wrong: _picked == choice && choice.radical != answer.radical,
                    onTap: () => _pick(choice),
                  ),
                ),
              const Spacer(),
              if (_picked != null)
                FilledButton(
                  onPressed: _next,
                  child: Text(
                    _index + 1 >= _pool.length ? 'Terminer' : 'Suivant',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color? glow;
    if (correct) glow = Colors.green;
    if (wrong) glow = Colors.red;

    return Pressable(
      onPressed: onTap,
      semanticLabel: label,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: LL.s16, vertical: LL.s16),
        glow: glow,
        borderColor: glow,
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.type.bodyLarge)),
            if (correct) const Icon(Icons.check_rounded, color: Colors.green),
            if (wrong) const Icon(Icons.close_rounded, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
