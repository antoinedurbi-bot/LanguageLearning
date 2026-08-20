import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/illustration.dart';

/// Attribution for third-party assets, as required by their licenses.
///
/// The illustrations are CC BY-SA 4.0, which makes this screen a license
/// obligation rather than a nice-to-have: attribution has to be reachable
/// from inside the app, not only in a file in the repository nobody using the
/// app will ever open.
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

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
                        Text('RÉGLAGES', style: context.type.labelSmall),
                        Text('À propos', style: context.type.headlineSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    LL.s20, LL.s8, LL.s20, LL.s32),
                children: [
                  const Center(child: Illustration(Illust.owl, size: 96)),
                  const SizedBox(height: LL.s24),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ILLUSTRATIONS', style: context.type.labelSmall),
                        const SizedBox(height: LL.s12),
                        Text(
                          'Les illustrations de l\'app viennent d\'OpenMoji, '
                          'un projet d\'icônes open source.',
                          style: context.type.bodyMedium,
                        ),
                        const SizedBox(height: LL.s12),
                        Text(
                          'openmoji.org',
                          style: context.type.bodyMedium
                              ?.copyWith(color: c.accent),
                        ),
                        const SizedBox(height: LL.s4),
                        Text(
                          'Licence CC BY-SA 4.0 — © the OpenMoji project.',
                          style: context.type.labelSmall?.copyWith(
                            color: c.textTertiary,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: LL.s16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ANIMATION', style: context.type.labelSmall),
                        const SizedBox(height: LL.s12),
                        Text(
                          'L\'animation de fin de session parfaite utilise '
                          'Rive, un fichier d\'exemple du kit de '
                          'développement rive-flutter.',
                          style: context.type.bodyMedium,
                        ),
                        const SizedBox(height: LL.s12),
                        Text(
                          'github.com/rive-app/rive-flutter',
                          style: context.type.bodyMedium
                              ?.copyWith(color: c.accent),
                        ),
                        const SizedBox(height: LL.s4),
                        Text(
                          'Licence MIT — © Rive.',
                          style: context.type.labelSmall?.copyWith(
                            color: c.textTertiary,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: LL.s16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MÉTHODE', style: context.type.labelSmall),
                        const SizedBox(height: LL.s12),
                        Text(
                          'La répétition espacée s\'appuie sur FSRS-4.5. Le '
                          'contenu de lecture, de grammaire et de vocabulaire '
                          'est écrit à la main, pas généré.',
                          style: context.type.bodyMedium,
                        ),
                      ],
                    ),
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
