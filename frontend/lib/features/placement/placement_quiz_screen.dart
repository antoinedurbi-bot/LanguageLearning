import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/mimi_mascot.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/placement/placement_quiz.dart';
import 'package:provider/provider.dart';

/// A one-time, per-language placement quiz shown right after picking a
/// language: a handful of sentences of increasing difficulty, sampled from
/// the course itself, used to *recommend* — never force — a starting unit.
///
/// A learner is always free to skip straight to unit 1 with the button in
/// the header; this screen exists to save an already-capable learner from a
/// boring stretch of material they do not need, not to gatekeep anyone.
class PlacementQuizScreen extends StatefulWidget {
  const PlacementQuizScreen({super.key});

  @override
  State<PlacementQuizScreen> createState() => _PlacementQuizScreenState();
}

class _PlacementQuizScreenState extends State<PlacementQuizScreen> {
  static const _builder = PlacementQuizBuilder();

  late final List<PlacementQuestion> _questions;
  late final List<int?> _answers;
  int _index = 0;
  PlacementResult? _result;

  @override
  void initState() {
    super.initState();
    final controller = context.read<LearningController>();
    final course = controller.course;
    _questions = _builder.build(course?.units ?? const []);
    _answers = List<int?>.filled(_questions.length, null);
  }

  void _answer(int optionIndex) {
    setState(() => _answers[_index] = optionIndex);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      if (_index + 1 < _questions.length) {
        setState(() => _index++);
      } else {
        _finish();
      }
    });
  }

  void _finish() {
    final controller = context.read<LearningController>();
    final unitCount = controller.course?.units.length ?? 1;
    final result = _builder.score(_questions, _answers, unitCount);
    setState(() => _result = result);
  }

  Future<void> _skip() async {
    await context.read<LearningController>().resolvePlacement();
  }

  Future<void> _accept() async {
    await context.read<LearningController>().resolvePlacement(
          recommendedUnitIndex: _result!.recommendedUnitIndex,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      // Nothing to sample from (a course with no units) — do not block.
      WidgetsBinding.instance.addPostFrameCallback((_) => _skip());
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LL.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _result == null
                          ? 'Petit test de niveau'
                          : 'Résultat',
                      style: context.type.displaySmall,
                    ),
                  ),
                  if (_result == null)
                    TextButton(
                      onPressed: _skip,
                      child: const Text('Passer, commencer à l\'unité 1'),
                    ),
                ],
              ),
              const SizedBox(height: LL.s16),
              Expanded(
                child: _result == null ? _buildQuiz() : _buildResult(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final question = _questions[_index];
    final selected = _answers[_index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_index) / _questions.length,
          minHeight: 6,
          borderRadius: BorderRadius.circular(LL.rPill),
        ),
        const SizedBox(height: LL.s8),
        Text(
          'Question ${_index + 1} / ${_questions.length}',
          style: context.type.labelMedium,
        ),
        const SizedBox(height: LL.s20),
        GlassCard(
          padding: const EdgeInsets.all(LL.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Que veut dire cette phrase ?',
                  style: context.type.labelLarge),
              const SizedBox(height: LL.s12),
              Text(question.card.target, style: context.type.headlineSmall),
              if (question.card.romanization != null) ...[
                const SizedBox(height: LL.s4),
                Text(
                  question.card.romanization!,
                  style: context.type.bodyMedium,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: LL.s20),
        Expanded(
          child: ListView.separated(
            itemCount: question.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: LL.s12),
            itemBuilder: (context, i) {
              final isSelected = selected == i;
              final revealed = selected != null;
              final isCorrect = i == question.correctIndex;

              Color? tint;
              if (revealed && isSelected) {
                tint = isCorrect ? LL.sage : LL.coral;
              } else if (revealed && isCorrect) {
                tint = LL.sage;
              }

              return Pressable(
                onPressed: selected == null ? () => _answer(i) : null,
                child: GlassCard(
                  padding: const EdgeInsets.all(LL.s16),
                  tint: tint,
                  child: Text(
                    question.options[i],
                    style: context.type.bodyLarge?.copyWith(
                      color: tint != null ? Colors.white : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final result = _result!;
    return Center(
      child: Reveal(
        child: GlassCard(
          padding: const EdgeInsets.all(LL.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MimiMascot(state: MimiState.celebrating, size: 88),
              const SizedBox(height: LL.s16),
              Text(
                '${result.correctCount} / ${result.totalCount} correctes',
                style: context.type.headlineSmall,
              ),
              const SizedBox(height: LL.s8),
              Text(
                result.recommendedUnitIndex == 0
                    ? 'On te propose de commencer par le début — c\'est la '
                        'meilleure base pour la suite.'
                    : 'Tu sembles déjà à l\'aise avec les premières unités. '
                        'On te propose de démarrer à l\'unité '
                        '${result.recommendedUnitIndex + 1}.',
                textAlign: TextAlign.center,
                style: context.type.bodyMedium,
              ),
              const SizedBox(height: LL.s24),
              GradientButton(
                label: result.recommendedUnitIndex == 0
                    ? 'Commencer'
                    : 'Démarrer à l\'unité ${result.recommendedUnitIndex + 1}',
                onPressed: _accept,
              ),
              const SizedBox(height: LL.s8),
              TextButton(
                onPressed: _skip,
                child: const Text('Non merci, je préfère l\'unité 1'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
