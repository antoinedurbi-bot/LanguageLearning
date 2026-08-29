import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/features/japanese/kana_chart_screen.dart';
import 'package:learning_app/features/japanese/kanji_explorer_screen.dart';

/// The Japanese-only section of the app.
///
/// Japanese asks for a foundation no other language here does: two full
/// phonetic syllabaries before a sentence is even readable, and a kanji
/// layer on top of that. Each gets its own tool, mirroring the role the
/// Mandarin lab plays for tones and hanzi.
class JapaneseLabScreen extends StatelessWidget {
  const JapaneseLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ramp = LL.gradientFor('ja');

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
      children: [
        Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('日本語', style: context.type.labelSmall),
              Text('Atelier japonais', style: context.type.headlineSmall),
              const SizedBox(height: LL.s8),
              Text(
                'Les deux syllabaires d\'abord, les kanji ensuite : c\'est '
                'l\'ordre dans lequel un texte japonais devient lisible.',
                style: context.type.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: LL.s24),
        Reveal(
          index: 1,
          child: _LabCard(
            icon: Icons.grid_view_rounded,
            title: 'Hiragana et katakana',
            subtitle: 'Les deux syllabaires, avec le son de chaque cellule.',
            body: 'あ à ん, ア à ン, plus les sonores et les combinaisons — '
                'tout ce qu\'il faut pour lire une phrase phonetiquement.',
            colors: ramp,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const KanaChartScreen()),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        Reveal(
          index: 2,
          child: _LabCard(
            icon: Icons.translate_rounded,
            title: 'Dictionnaire de kanji',
            subtitle: 'Le premier lot de kanji, avec leurs vraies lectures.',
            body: 'Onyomi et kunyomi pour chaque caractere, cherchable par '
                'lecture ou par sens.',
            colors: ramp,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const KanjiExplorerScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabCard extends StatelessWidget {
  const _LabCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String body;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Pressable(
      onPressed: onTap,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(LL.rMd),
                  ),
                  child: Icon(icon, color: LLColors.readableOn(colors.first)),
                ),
                const SizedBox(width: LL.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.type.titleSmall),
                      Text(subtitle,
                          style: context.type.labelSmall
                              ?.copyWith(color: c.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
            const SizedBox(height: LL.s8),
            Text(body, style: context.type.bodyMedium),
          ],
        ),
      ),
    );
  }
}
