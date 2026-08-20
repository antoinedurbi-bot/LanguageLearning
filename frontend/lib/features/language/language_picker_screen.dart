import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/mimi_mascot.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/entitlement.dart';
import 'package:learning_app/features/language/app_language.dart';
import 'package:learning_app/features/premium/premium_screen.dart';
import 'package:provider/provider.dart';

class LanguagePickerScreen extends StatelessWidget {
  const LanguagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? LL.s32 : LL.s20,
                    vertical: LL.s32,
                  ),
                  children: [
                    const Reveal(child: _Header()),
                    const SizedBox(height: LL.s32),
                    // A Wrap rather than a fixed-aspect grid: card height
                    // depends on how the description wraps and on the user's
                    // text scale, and a locked aspect ratio would clip it.
                    Wrap(
                      spacing: LL.s16,
                      runSpacing: LL.s16,
                      children: [
                        for (var i = 0; i < availableLanguages.length; i++)
                          SizedBox(
                            width: wide
                                ? (constraints.maxWidth.clamp(0, 900) -
                                        LL.s32 * 2 -
                                        LL.s16) /
                                    2
                                : double.infinity,
                            child: Reveal(
                              index: i + 1,
                              child: _LanguageCard(
                                language: availableLanguages[i],
                                locked: !controller.canSelectLanguage(
                                    availableLanguages[i].code),
                                onTap: () {
                                  if (controller.canSelectLanguage(
                                      availableLanguages[i].code)) {
                                    HapticFeedback.mediumImpact();
                                    controller.selectLanguage(
                                        availableLanguages[i]);
                                  } else {
                                    openPaywall(context,
                                        reason: PremiumPerk.languages);
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: LL.s24),
                    Reveal(
                      index: availableLanguages.length + 1,
                      child: Text(
                        controller.freeLanguageCode == null
                            ? 'Ton choix reste gratuit à vie. Les autres '
                                'langues demandent Premium.'
                            : controller.isPremium
                                ? 'Tu peux changer de langue à tout moment, '
                                    'sans perdre ta progression.'
                                : 'Ta langue gratuite est déjà choisie. '
                                    'Premium débloque les autres.',
                        textAlign: TextAlign.center,
                        style: context.type.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MimiMascot(state: MimiState.idle, size: 96),
        const SizedBox(width: LL.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quelle langue\nveux-tu parler ?',
                  style: context.type.displayMedium),
              const SizedBox(height: LL.s12),
              Text(
                'Une seule a la fois. Apprendre deux langues en parallele '
                'divise le temps d\'exposition, et c\'est l\'exposition qui '
                'fait progresser.',
                style: context.type.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.language,
    required this.locked,
    required this.onTap,
  });

  final AppLanguage language;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = language.gradient;

    return Pressable(
      onPressed: onTap,
      semanticLabel: locked
          ? '${language.name}, verrouillé, nécessite Premium'
          : 'Apprendre ${language.name}, ${language.difficultyNote}',
      child: GlassCard(
        glow: ramp.first,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ramp.first.withValues(alpha: c.isDark ? 0.20 : 0.12),
            ramp.last.withValues(alpha: c.isDark ? 0.06 : 0.04),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: ramp),
                    borderRadius: BorderRadius.circular(LL.rSm + 4),
                  ),
                  child: Text(
                    language.script,
                    style: context.type.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: LL.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.name, style: context.type.titleMedium),
                      const SizedBox(height: LL.s2),
                      Text(
                        language.nativeName,
                        style: context.type.bodyMedium?.copyWith(
                          color: ramp.first,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (locked)
                  const LLChip(
                    label: 'Premium',
                    icon: Icons.lock_rounded,
                    color: LL.amber,
                  )
                else
                  Icon(Icons.arrow_forward_rounded, color: c.textTertiary),
              ],
            ),
            const SizedBox(height: LL.s16),
            Text(language.description, style: context.type.bodyMedium),
            const SizedBox(height: LL.s12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: c.textTertiary),
                const SizedBox(width: LL.s8),
                Expanded(
                  child: Text(
                    language.difficultyNote,
                    style: context.type.labelSmall?.copyWith(
                      color: c.textTertiary,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
