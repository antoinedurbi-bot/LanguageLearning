import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/data/hanzi/pinyin.dart';
import 'package:learning_app/data/hanzi/radicals.dart';
import 'package:learning_app/features/chinese/character_explorer_screen.dart';
import 'package:learning_app/features/chinese/chengyu_screen.dart';
import 'package:learning_app/features/chinese/pinyin_chart_screen.dart';
import 'package:learning_app/features/chinese/radical_explorer_screen.dart';
import 'package:learning_app/features/chinese/tone_trainer_screen.dart';
import 'package:learning_app/features/chinese/writing_session_screen.dart';

/// The Chinese-only section of the app.
///
/// Mandarin asks a French speaker for three things no other language in this
/// app does: hear a pitch contour as part of a word, read a script with no
/// alphabet, and write it in a fixed stroke order. Each gets its own tool
/// here, because none of them fits the sentence-review loop the rest of the
/// app is built on.
class ChineseLabScreen extends StatefulWidget {
  const ChineseLabScreen({super.key});

  @override
  State<ChineseLabScreen> createState() => _ChineseLabScreenState();
}

class _ChineseLabScreenState extends State<ChineseLabScreen> {
  // Both repositories cache after first load, so the several megabytes of
  // JSON are decoded once per session and only if this tab is opened.
  final _hanzi = HanziRepository();
  final _pinyin = PinyinRepository();
  final _radicals = RadicalRepository();

  late Future<PinyinData> _pinyinData;

  @override
  void initState() {
    super.initState();
    _pinyinData = _pinyin.load();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32 + 64),
      children: [
        const Reveal(child: _Header()),
        const SizedBox(height: LL.s24),
        Reveal(
          index: 1,
          child: _LabCard(
            icon: Icons.hearing_rounded,
            title: 'Entrainement aux tons',
            subtitle: 'Écoute et identifie. Une syllabe, puis deux.',
            body: 'C\'est le seul exercice qui construit vraiment l\'oreille. '
                'Sans lui, on lit le pinyin et on invente les tons.',
            colors: ramp,
            onTap: () => _openWithPinyin(
              (data) => ToneTrainerScreen(data: data),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        Reveal(
          index: 2,
          child: _LabCard(
            icon: Icons.grid_on_rounded,
            title: 'Table des syllabes',
            subtitle: 'Les ~400 syllabes du mandarin, avec le son.',
            body: 'Toute la prononciation du chinois tient dans une grille '
                'finie : initiale + finale + ton.',
            colors: ramp,
            onTap: () => _openWithPinyin(
              (data) => PinyinChartScreen(data: data),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        Reveal(
          index: 3,
          child: _LabCard(
            icon: Icons.draw_rounded,
            title: 'Écrire les caractères',
            subtitle: 'Trace trait par trait, dans le bon ordre.',
            body: 'L\'ordre des traits decide des proportions, et c\'est lui '
                'qu\'attendent les claviers à reconnaissance d\'écriture.',
            colors: ramp,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => WritingSessionScreen(repository: _hanzi),
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        Reveal(
          index: 4,
          child: _LabCard(
            icon: Icons.account_tree_rounded,
            title: 'Clés (部首)',
            subtitle: '162 clés, triees par nombre de caracteres debloques.',
            body: 'Chaque caractère composé est bati sur des clés. Les '
                'reconnaitre transforme des formes arbitraires en indices de '
                'sens et de prononciation.',
            colors: ramp,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    RadicalExplorerScreen(repository: _radicals),
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        Reveal(
          index: 5,
          child: _LabCard(
            icon: Icons.auto_stories_rounded,
            title: 'Chengyu (成语)',
            subtitle: 'Idiomes en quatre caractères, avec leur histoire.',
            body: 'Le chinois avancé parle par chengyu : des expressions '
                'figées de quatre caractères, souvent issues d\'une fable ou '
                'd\'un épisode historique.',
            colors: ramp,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ChengyuScreen(),
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s12),
        Reveal(
          index: 6,
          child: _LabCard(
            icon: Icons.menu_book_rounded,
            title: 'Dictionnaire',
            subtitle: '615 caractères, 1256 mots HSK 1-2.',
            body: 'Cle, composition, ordre des traits et mots qui utilisent '
                'chaque caractère. Recherche par pinyin sans les tons.',
            colors: ramp,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CharacterExplorerScreen(repository: _hanzi),
              ),
            ),
          ),
        ),
        const SizedBox(height: LL.s24),
        Reveal(index: 7, child: _SourceNote(color: c.textTertiary)),
      ],
    );
  }

  /// Opens a screen that needs the pinyin data, showing a loader while the
  /// asset decodes rather than blocking the tap.
  void _openWithPinyin(Widget Function(PinyinData data) build) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FutureBuilder<PinyinData>(
          future: _pinyinData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(LL.s24),
                    child: Text(
                      'Les données de prononciation n\'ont pas pu être '
                      'chargees.',
                      textAlign: TextAlign.center,
                      style: context.type.bodyLarge,
                    ),
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return build(snapshot.data!);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CHINOIS', style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text('Atelier 中文', style: context.type.displayMedium),
        const SizedBox(height: LL.s12),
        Text(
          'Le mandarin demande trois choses que les autres langues de l\'app '
          'ne demandent pas : entendre les tons, lire une écriture sans '
          'alphabet, et l\'écrire dans le bon ordre.',
          style: context.type.bodyLarge,
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
      semanticLabel: '$title. $subtitle',
      child: GlassCard(
        glow: colors.first,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.first.withValues(alpha: c.isDark ? 0.18 : 0.10),
            colors.last.withValues(alpha: c.isDark ? 0.05 : 0.03),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(LL.rSm + 4),
                  ),
                  child: Icon(icon, color: LLColors.readableOn(colors.first), size: 24),
                ),
                const SizedBox(width: LL.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.type.titleMedium),
                      const SizedBox(height: LL.s2),
                      Text(subtitle, style: context.type.labelMedium),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: c.textTertiary),
              ],
            ),
            const SizedBox(height: LL.s12),
            Text(body, style: context.type.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _SourceNote extends StatelessWidget {
  const _SourceNote({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Données des traits : Make Me a Hanzi. Niveaux et fréquences : HSK 3.0. '
      'Clés : classification Kangxi (domaine public), exemples calculés '
      'depuis les 615 caractères de l\'app. Les définitions de caractères '
      'sont en anglais, telles quelles depuis ces sources.',
      style:
          context.type.labelSmall?.copyWith(color: color, letterSpacing: 0.1),
    );
  }
}
