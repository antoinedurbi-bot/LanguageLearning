import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/celebration_confetti.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/mimi_mascot.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/features/session/session_screen.dart';
import 'package:provider/provider.dart';

/// The daily screen — "Accueil" in the Mimi mockup. One question answered
/// above the fold: what do I do now?
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _confetti = CelebrationConfettiController();
  bool _goalReachedBefore = false;

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
    final goalReached = done >= goal && goal > 0;

    // A streak milestone or a freshly-hit daily goal is exactly the
    // "meaningful moment" the confetti package is meant for — a quiet
    // in-place toggle, not a modal.
    if (goalReached && !_goalReachedBefore) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _confetti.burst());
    }
    _goalReachedBefore = goalReached;

    return CelebrationConfetti(
      controller: _confetti,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
        children: [
          Reveal(
            child: _GreetingRow(
              languageName: language.name,
              streak: progress.streak,
            ),
          ),
          const SizedBox(height: LL.s20),
          Reveal(index: 1, child: _MimiTipCard(due: due, fresh: fresh)),
          const SizedBox(height: LL.s16),
          Reveal(
            index: 2,
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    value: '${progress.streak}',
                    label: progress.streak > 1 ? 'jours de suite' : 'jour',
                    icon: Icons.local_fire_department_rounded,
                    tint: LL.marigold,
                  ),
                ),
                const SizedBox(width: LL.s12),
                Expanded(
                  child: _StatTile(
                    value: '${progress.learnedCount}',
                    label: 'phrases acquises',
                    icon: Icons.emoji_events_rounded,
                    tint: LL.sage,
                  ),
                ),
                const SizedBox(width: LL.s12),
                Expanded(
                  child: _StatTile(
                    value: '$due',
                    label: due > 1 ? 'à réviser' : 'à réviser',
                    icon: Icons.replay_rounded,
                    tint: LL.teal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: LL.s16),
          Reveal(
            index: 3,
            child: _PathCard(
              done: done,
              goal: goal,
              due: due,
              fresh: fresh,
              colors: ramp,
              goalReached: goalReached,
            ),
          ),
          const SizedBox(height: LL.s24),
          Reveal(index: 4, child: _MethodNote(due: due, fresh: fresh)),
        ],
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  const _GreetingRow({required this.languageName, required this.streak});

  final String languageName;
  final int streak;

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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting.toUpperCase(),
                style: context.type.labelSmall,
              ),
              const SizedBox(height: LL.s4),
              Text(languageName, style: context.type.displayMedium),
            ],
          ),
        ),
        // Streak pill: a pressed-keycap chip in marigold, the mockup's
        // small persistent celebration of the streak count.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: LL.s12, vertical: LL.s8),
          decoration: BoxDecoration(
            color: LL.marigold,
            borderRadius: BorderRadius.circular(LL.rPill),
            boxShadow: [
              BoxShadow(color: LLColors.pressedShadeOf(LL.marigold), offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Marigold is too light for white to clear AA contrast
              // (~2:1) — LLColors.readableOn picks ink here instead.
              Icon(Icons.local_fire_department_rounded,
                  color: LLColors.readableOn(LL.marigold), size: 18),
              const SizedBox(width: LL.s4),
              Text(
                '$streak',
                style: context.type.labelLarge?.copyWith(
                  fontFamily: 'SpaceMono',
                  color: LLColors.readableOn(LL.marigold),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mimi's card: the toucan mascot beside a rotating tip. The tip rotates by
/// context (the same "why the queue looks this way" honesty the previous
/// method note carried) rather than being decorative filler.
class _MimiTipCard extends StatelessWidget {
  const _MimiTipCard({required this.due, required this.fresh});

  final int due;
  final int fresh;

  static const _idleTips = [
    'Une petite série vaut mieux qu\'une grande, une fois par semaine.',
    'Relire à voix haute aide autant que relire des yeux.',
    'Le sommeil consolide ce que tu viens d\'apprendre — vise une vraie nuit.',
  ];

  @override
  Widget build(BuildContext context) {
    final MimiState state;
    final String message;

    if (due > 0) {
      state = MimiState.streakProud;
      message = due == 1
          ? 'Une carte t\'attend — le bon moment pour la revoir, c\'est maintenant.'
          : '$due cartes t\'attendent. On y va ?';
    } else if (fresh > 0) {
      state = MimiState.idle;
      message = '$fresh nouvelle${fresh > 1 ? 's' : ''} phrase'
          '${fresh > 1 ? 's' : ''} prête${fresh > 1 ? 's' : ''} à découvrir.';
    } else {
      state = MimiState.celebrating;
      final tip = _idleTips[DateTime.now().day % _idleTips.length];
      message = 'Tout est à jour aujourd\'hui. $tip';
    }

    final fg = LLColors.readableOn(LL.teal);
    return GlassCard(
      tint: LL.teal,
      padding: const EdgeInsets.all(LL.s20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MimiMascot(state: state, size: 76),
          const SizedBox(width: LL.s16),
          Expanded(
            child: Text(
              message,
              style: context.type.bodyLarge?.copyWith(color: fg),
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
    // Picked per-tint: white fails AA contrast on the lighter marigold/sage
    // tiles (~2-2.5:1) even though it reads fine on teal/coral.
    final fg = LLColors.readableOn(tint);
    return GlassCard(
      tint: tint,
      padding: const EdgeInsets.all(LL.s16),
      radius: LL.rMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(LL.rSm - 4),
            ),
            child: Icon(icon, color: fg, size: 18),
          ),
          const SizedBox(height: LL.s12),
          Text(
            value,
            style: context.type.headlineMedium?.copyWith(
              color: fg,
              fontFamily: 'SpaceMono',
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: context.type.labelMedium?.copyWith(
              color: fg.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// The daily-goal / language-path card: a progress ring plus the CTA.
class _PathCard extends StatelessWidget {
  const _PathCard({
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
                    fontFamily: 'SpaceMono',
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
            Column(
              children: [
                MimiMascot(
                  state: goalReached ? MimiState.celebrating : MimiState.idle,
                  size: 72,
                ),
                const SizedBox(height: LL.s8),
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
              colors: [colors.first],
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
