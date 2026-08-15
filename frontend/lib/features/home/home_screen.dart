import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/features/session/session_screen.dart';
import 'package:provider/provider.dart';

/// The daily screen. One question answered above the fold: what do I do now?
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final language = controller.language;
    final progress = controller.progress;

    if (language == null || progress == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final ramp = language.gradient;
    final due = controller.dueCount;
    final fresh = controller.newCount;
    final done = progress.reviewsToday;
    final goal = progress.dailyGoal;
    final goalReached = done >= goal;

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
      children: [
        Reveal(child: _Greeting(languageName: language.name)),
        const SizedBox(height: LL.s24),
        Reveal(
          index: 1,
          child: _DailyGoalCard(
            done: done,
            goal: goal,
            due: due,
            fresh: fresh,
            colors: ramp,
            goalReached: goalReached,
          ),
        ),
        const SizedBox(height: LL.s16),
        Reveal(
          index: 2,
          child: Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.local_fire_department_rounded,
                  value: '${progress.streak}',
                  label: progress.streak > 1 ? 'jours d\'affilee' : 'jour',
                  tint: LL.amber,
                ),
              ),
              const SizedBox(width: LL.s12),
              Expanded(
                child: _StatTile(
                  icon: Icons.verified_rounded,
                  value: '${progress.learnedCount}',
                  label: 'phrases acquises',
                  tint: context.ll.success,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: LL.s24),
        Reveal(index: 3, child: _MethodNote(due: due, fresh: fresh)),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.languageName});

  final String languageName;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 6
        ? 'Bonne nuit'
        : hour < 12
            ? 'Bonjour'
            : hour < 18
                ? 'Bon après-midi'
                : 'Bonsoir';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting.toUpperCase(), style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text(languageName, style: context.type.displayMedium),
      ],
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({
    required this.done,
    required this.goal,
    required this.due,
    required this.fresh,
    required this.colors,
    required this.goalReached,
  });

  final int done;
  final int goal;
  final int due;
  final int fresh;
  final List<Color> colors;
  final bool goalReached;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final nothingToDo = due == 0 && fresh == 0;

    final String headline;
    final String detail;
    if (nothingToDo) {
      headline = 'Tout est à jour';
      detail = 'Rien n\'est du aujourd\'hui. Revenir demain vaut mieux que '
          'réviser une carte encore fraîche : c\'est l\'oubli partiel qui '
          'consolide la mémoire.';
    } else if (due > 0) {
      headline = '$due carte${due > 1 ? 's' : ''} à réviser';
      detail = fresh > 0
          ? 'Les révisions passent avant les nouveautés.'
          : 'Ces cartes arrivent au moment où tu es sur le point de les oublier.';
    } else {
      headline = 'Nouvelles phrases';
      detail = 'Aucune révision en attente : place à $fresh nouvelle'
          '${fresh > 1 ? 's' : ''} phrase${fresh > 1 ? 's' : ''}.';
    }

    return GlassCard(
      glow: colors.first,
      padding: const EdgeInsets.all(LL.s24),
      child: Column(
        children: [
          ProgressRing(
            value: goal == 0 ? 0 : done / goal,
            colors: [colors.first, colors.last, colors.first],
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$done',
                  style: context.type.displayMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text('sur $goal', style: context.type.labelMedium),
              ],
            ),
          ),
          const SizedBox(height: LL.s24),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: context.type.headlineSmall,
          ),
          const SizedBox(height: LL.s8),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: context.type.bodyMedium,
          ),
          const SizedBox(height: LL.s20),
          if (nothingToDo)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, size: 18, color: c.success),
                const SizedBox(width: LL.s8),
                Text(
                  goalReached ? 'Objectif atteint' : 'File d\'attente vide',
                  style: context.type.labelLarge?.copyWith(color: c.success),
                ),
              ],
            )
          else
            GradientButton(
              label: goalReached ? 'Continuer quand même' : 'Commencer',
              icon: Icons.play_arrow_rounded,
              colors: colors,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SessionScreen(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(LL.s16),
      radius: LL.rMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tint, size: 22),
          const SizedBox(height: LL.s12),
          Text(
            value,
            style: context.type.headlineMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(label, style: context.type.labelMedium),
        ],
      ),
    );
  }
}

/// A short, honest explanation of why the queue looks the way it does.
/// Learners abandon spaced repetition when the schedule feels arbitrary.
class _MethodNote extends StatelessWidget {
  const _MethodNote({required this.due, required this.fresh});

  final int due;
  final int fresh;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return GlassCard(
      padding: const EdgeInsets.all(LL.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_alt_rounded, size: 18, color: c.accentAlt),
              const SizedBox(width: LL.s8),
              Text('La méthode', style: context.type.labelLarge),
            ],
          ),
          const SizedBox(height: LL.s12),
          Text(
            'Chaque phrase revient au moment où tu as environ 90 % de chances '
            'de t\'en souvenir. Réviser plus tôt coûte du temps sans rien '
            'ajouter ; réviser plus tard oblige à tout réapprendre.',
            style: context.type.bodyMedium,
          ),
          const SizedBox(height: LL.s12),
          Wrap(
            spacing: LL.s8,
            runSpacing: LL.s8,
            children: [
              LLChip(
                label: '$due en attente',
                icon: Icons.replay_rounded,
                color: c.accent,
                filled: due > 0,
              ),
              LLChip(
                label: '$fresh à découvrir',
                icon: Icons.auto_awesome_rounded,
                color: c.accentAlt,
                filled: fresh > 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
