import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/features/memory/memory_card.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/features/auth/sign_in_screen.dart';
import 'package:learning_app/features/profile/credits_screen.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    final language = controller.language;
    final progress = controller.progress;
    final course = controller.course;

    if (language == null || progress == null || course == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final total = course.allCards.length;
    final ramp = language.gradient;

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
      children: [
        const Reveal(child: _Header()),
        const SizedBox(height: LL.s24),
        Reveal(
          index: 1,
          child: _MasteryCard(
            learned: progress.learnedCount,
            seen: progress.seenCount,
            total: total,
            colors: ramp,
          ),
        ),
        const SizedBox(height: LL.s16),
        const Reveal(index: 2, child: MemoryCard()),
        const SizedBox(height: LL.s16),
        Reveal(index: 3, child: _NumbersCard(progress: progress)),
        const SizedBox(height: LL.s16),
        Reveal(index: 4, child: _HeatmapCard(progress: progress, colors: ramp)),
        const SizedBox(height: LL.s16),
        Reveal(index: 5, child: _GoalCard(progress: progress)),
        const SizedBox(height: LL.s16),
        const Reveal(index: 6, child: _SettingsCard()),
        const SizedBox(height: LL.s16),
        const Reveal(index: 7, child: _AccountCard()),
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
        Text('PROGRÈS', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text('Où tu en es', style: context.type.displayMedium),
      ],
    );
  }
}

class _MasteryCard extends StatelessWidget {
  const _MasteryCard({
    required this.learned,
    required this.seen,
    required this.total,
    required this.colors,
  });

  final int learned;
  final int seen;
  final int total;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return GlassCard(
      glow: colors.first,
      child: Row(
        children: [
          ProgressRing(
            value: total == 0 ? 0 : learned / total,
            size: 104,
            stroke: 10,
            colors: [colors.first, colors.last, colors.first],
            center: Text(
              '$learned',
              style: context.type.headlineSmall?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: LL.s20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phrases acquises', style: context.type.titleMedium),
                const SizedBox(height: LL.s8),
                Text(
                  '$learned sur $total, et $seen rencontrées au moins une fois.',
                  style: context.type.bodyMedium,
                ),
                const SizedBox(height: LL.s8),
                Text(
                  'Une phrase compte comme acquise quand son intervalle de '
                  'révision dépasse trois semaines.',
                  style: context.type.labelSmall
                      ?.copyWith(color: c.textTertiary, letterSpacing: 0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumbersCard extends StatelessWidget {
  const _NumbersCard({required this.progress});

  final LanguageProgress progress;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return GlassCard(
      padding: const EdgeInsets.all(LL.s20),
      child: Row(
        children: [
          _Number(
            value: '${progress.streak}',
            label: 'série',
            tint: LL.amber,
          ),
          _Divider(color: c.divider),
          _Number(
            value: '${progress.bestStreak}',
            label: 'record',
            tint: c.accentAlt,
          ),
          _Divider(color: c.divider),
          _Number(
            value: '${progress.totalReviews}',
            label: 'révisions',
            tint: c.accent,
          ),
          _Divider(color: c.divider),
          _Number(
            value: progress.totalReviews == 0
                ? '-'
                : '${(progress.accuracy * 100).round()}%',
            label: 'réussite',
            tint: c.success,
          ),
        ],
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({required this.value, required this.label, required this.tint});

  final String value;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: context.type.headlineSmall?.copyWith(
              color: tint,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: LL.s2),
          Text(label,
              style: context.type.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 34, color: color);
}

/// Twelve weeks of activity. Colour encodes volume, and every cell carries a
/// tooltip with the exact count, so the chart is readable without relying on
/// colour perception alone.
class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.progress, required this.colors});

  final LanguageProgress progress;
  final List<Color> colors;

  static const _weeks = 12;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Align the grid so each column is a week ending today.
    final days = <DateTime>[
      for (var i = _weeks * 7 - 1; i >= 0; i--)
        today.subtract(Duration(days: i)),
    ];
    final maxCount = progress.reviewsPerDay.values.isEmpty
        ? 1
        : progress.reviewsPerDay.values.reduce((a, b) => a > b ? a : b);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activité', style: context.type.titleMedium),
          const SizedBox(height: LL.s4),
          Text('Les 12 dernières semaines', style: context.type.labelSmall),
          const SizedBox(height: LL.s16),
          if (progress.totalReviews == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: LL.s20),
              child: Text(
                'Aucune révision pour l\'instant. La grille se remplira des '
                'la première session.',
                style: context.type.bodyMedium,
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var week = 0; week < _weeks; week++)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: [
                          for (var day = 0; day < 7; day++)
                            _Cell(
                              date: days[week * 7 + day],
                              count: progress.reviewsPerDay[
                                      LanguageProgress.dayKey(
                                          days[week * 7 + day])] ??
                                  0,
                              maxCount: maxCount,
                              tint: colors.first,
                              empty: c.glassStroke,
                            ),
                        ],
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

class _Cell extends StatelessWidget {
  const _Cell({
    required this.date,
    required this.count,
    required this.maxCount,
    required this.tint,
    required this.empty,
  });

  final DateTime date;
  final int count;
  final int maxCount;
  final Color tint;
  final Color empty;

  @override
  Widget build(BuildContext context) {
    final intensity = count == 0 ? 0.0 : (count / maxCount).clamp(0.18, 1.0);
    final label = '${LanguageProgress.dayKey(date)}: $count révision'
        '${count > 1 ? 's' : ''}';

    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: count == 0 ? empty : tint.withValues(alpha: intensity),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.progress});

  final LanguageProgress progress;

  static const _options = [10, 20, 30, 50];

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LearningController>();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Objectif quotidien', style: context.type.titleMedium),
          const SizedBox(height: LL.s4),
          Text(
            'Un objectif tenu tous les jours bat un gros objectif tenu une '
            'fois par semaine.',
            style: context.type.bodyMedium,
          ),
          const SizedBox(height: LL.s16),
          Row(
            children: [
              for (final option in _options)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: option == _options.last ? 0 : LL.s8,
                    ),
                    child: _GoalOption(
                      value: option,
                      selected: progress.dailyGoal == option,
                      onTap: () => controller.setDailyGoal(option),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Semantics(
      selected: selected,
      child: Pressable(
        onPressed: onTap,
        semanticLabel: '$value cartes par jour',
        child: AnimatedContainer(
          duration: LL.fast,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.accent.withValues(alpha: 0.18) : c.glassFill,
            borderRadius: BorderRadius.circular(LL.rSm),
            border: Border.all(
              color: selected ? c.accent : c.glassStroke,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            '$value',
            style: context.type.titleSmall?.copyWith(
              color: selected ? c.accent : c.textSecondary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: LL.s8, horizontal: LL.s8),
      child: Column(
        children: [
          SwitchListTile(
            value: controller.soundEnabled,
            onChanged: controller.setSoundEnabled,
            title: const Text('Prononciation audio'),
            subtitle: const Text('Lit les phrases dans la langue cible'),
            secondary: const Icon(Icons.volume_up_rounded),
          ),
          if (controller.soundEnabled) const _VoiceDiagnostic(),
          ListTile(
            leading: const Icon(Icons.dark_mode_rounded),
            title: const Text('Thème'),
            subtitle: Text(switch (controller.themeMode) {
              ThemeMode.dark => 'Sombre',
              ThemeMode.light => 'Clair',
              ThemeMode.system => 'Système',
            }),
            trailing: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.nights_stay_rounded, size: 18),
                  tooltip: 'Sombre',
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_rounded, size: 18),
                  tooltip: 'Clair',
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.smartphone_rounded, size: 18),
                  tooltip: 'Système',
                ),
              ],
              selected: {controller.themeMode},
              onSelectionChanged: (values) =>
                  controller.setThemeMode(values.first),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.translate_rounded),
            title: const Text('Changer de langue'),
            subtitle: Text(controller.language?.name ?? ''),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: controller.clearLanguage,
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.read<LearningController>();
    final user =
        AppState.firebaseReady ? FirebaseAuth.instance.currentUser : null;

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: LL.s8, horizontal: LL.s8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: c.accent.withValues(alpha: 0.18),
              child: Icon(Icons.person_rounded, color: c.accent),
            ),
            title: Text(user?.email ?? 'Progression locale'),
            subtitle: Text(
              user != null
                  ? 'Progression sauvegardee en ligne'
                  : 'Stockee sur cet appareil uniquement',
            ),
          ),
          if (AppState.firebaseReady)
            ListTile(
              leading: Icon(
                user != null ? Icons.logout_rounded : Icons.login_rounded,
              ),
              title: Text(user != null ? 'Se deconnecter' : 'Se connecter'),
              subtitle: Text(
                user != null
                    ? 'La progression locale est conservee'
                    : 'Pour synchroniser entre appareils',
              ),
              onTap: () {
                if (user != null) {
                  FirebaseAuth.instance.signOut();
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignInScreen(),
                    ),
                  );
                }
              },
            ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('À propos'),
            subtitle: const Text('Crédits et licences'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CreditsScreen()),
            ),
          ),
          // Destructive action, visually separated from everything above.
          Divider(color: c.divider, indent: LL.s16, endIndent: LL.s16),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded, color: c.danger),
            title: Text(
              'Reinitialiser la progression',
              style: TextStyle(color: c.danger),
            ),
            subtitle: const Text('Pour la langue en cours'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tout effacer ?'),
                  content: const Text(
                    'Les intervalles de révision, la série et l\'historique de '
                    'cette langue seront perdus. Cette action est définitive.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Effacer',
                        style: TextStyle(color: context.ll.danger),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed ?? false) await controller.resetProgress();
            },
          ),
        ],
      ),
    );
  }
}

/// Tells the learner, in the one place they would look, whether their device
/// can actually pronounce the language they are studying.
///
/// Without this the play buttons simply do nothing when no voice is installed,
/// which reads as a broken app rather than a missing system component.
class _VoiceDiagnostic extends StatefulWidget {
  const _VoiceDiagnostic();

  @override
  State<_VoiceDiagnostic> createState() => _VoiceDiagnosticState();
}

class _VoiceDiagnosticState extends State<_VoiceDiagnostic> {
  VoiceStatus? _status;
  String? _checkedLocale;

  Future<void> _check(String locale) async {
    if (_checkedLocale == locale) return;
    _checkedLocale = locale;
    final status = await context.read<TtsService>().voiceStatus(locale);
    if (!mounted) return;
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final course = controller.course;
    final language = controller.language;
    if (course == null || language == null) return const SizedBox.shrink();

    // Kick off the lookup on first build for this locale.
    WidgetsBinding.instance.addPostFrameCallback((_) => _check(course.ttsLocale));

    final status = _status;
    if (status == null || status == VoiceStatus.unknown) {
      // Saying nothing is right here: we have no evidence either way.
      return const SizedBox.shrink();
    }

    if (status == VoiceStatus.ready) {
      return ListTile(
        dense: true,
        leading: Icon(Icons.check_circle_rounded, size: 18, color: c.success),
        title: Text(
          'Voix ${language.name.toLowerCase()} détectée sur cet appareil',
          style: context.type.labelSmall?.copyWith(color: c.success),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(LL.s16, 0, LL.s16, LL.s12),
      child: Container(
        padding: const EdgeInsets.all(LL.s12),
        decoration: BoxDecoration(
          color: c.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(color: c.warning.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.volume_off_rounded, size: 18, color: c.warning),
            const SizedBox(width: LL.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aucune voix ${language.name.toLowerCase()} sur cet appareil',
                    style:
                        context.type.labelLarge?.copyWith(color: c.warning),
                  ),
                  const SizedBox(height: LL.s4),
                  Text(
                    'Les boutons de lecture resteront muets tant que le pack '
                    'vocal n\'est pas installé. L\'app utilise les voix du '
                    'système, elle n\'en embarque pas.\n\n'
                    'Windows : Paramètres → Heure et langue → Voix → Ajouter '
                    'des voix.\n'
                    'Android : Paramètres → Langues → Synthèse vocale.\n'
                    'iOS : Réglages → Accessibilité → Contenu énoncé → Voix.',
                    style: context.type.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
