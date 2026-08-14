import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/vocabulary.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/features/vocabulary/explanation_sheet.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// The scrollable vocabulary, grouped by theme.
///
/// Every row is tappable and every tap opens the same explanation sheet, so
/// there is nothing in this list that is merely decorative.
class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({
    super.key,
    required this.pack,
    required this.ttsLocale,
  });

  final VocabularyPack pack;
  final String ttsLocale;

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _matches(VocabEntry entry) {
    if (_query.trim().isEmpty) return true;
    final needle = _query.toLowerCase().trim();
    return entry.target.toLowerCase().contains(needle) ||
        entry.native.toLowerCase().contains(needle) ||
        (entry.romanization?.toLowerCase().contains(needle) ?? false) ||
        entry.note.toLowerCase().contains(needle);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(widget.pack.languageCode);

    final themes = [
      for (final theme in widget.pack.themes)
        (theme: theme, entries: theme.entries.where(_matches).toList()),
    ].where((t) => t.entries.isNotEmpty).toList();

    return Scaffold(
      body: AuroraBackground(
        colors: [ramp.first, ramp.last, c.auroraC],
        intensity: 0.5,
        child: SafeArea(
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
                          Text('VOCABULAIRE', style: context.type.labelSmall),
                          Text('Les mots qui comptent',
                              style: context.type.headlineSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LL.s20),
                child: TextField(
                  controller: _controller,
                  autocorrect: false,
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Chercher un mot ou un sens',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Effacer',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                          ),
                  ),
                ),
              ),
              Expanded(
                child: themes.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(LL.s32),
                          child: Text(
                            'Aucun mot ne correspond a "$_query".',
                            textAlign: TextAlign.center,
                            style: context.type.bodyLarge,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                            LL.s20, LL.s16, LL.s20, LL.s32),
                        children: [
                          for (var i = 0; i < themes.length; i++) ...[
                            Reveal(
                              index: i,
                              child: _ThemeHeader(
                                theme: themes[i].theme,
                                shown: themes[i].entries.length,
                                total: themes[i].theme.entries.length,
                              ),
                            ),
                            const SizedBox(height: LL.s12),
                            for (final entry in themes[i].entries)
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: LL.s8 + 2),
                                child: _EntryRow(
                                  entry: entry,
                                  ttsLocale: widget.ttsLocale,
                                ),
                              ),
                            const SizedBox(height: LL.s24),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeHeader extends StatelessWidget {
  const _ThemeHeader({
    required this.theme,
    required this.shown,
    required this.total,
  });

  final VocabTheme theme;
  final int shown;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(theme.title, style: context.type.titleMedium),
            ),
            Text(
              shown == total ? '$total' : '$shown / $total',
              style: context.type.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: LL.s2),
        Text(theme.subtitle, style: context.type.labelMedium),
      ],
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry, required this.ttsLocale});

  final VocabEntry entry;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final saved = controller.isSaved(entry.id);

    return Pressable(
      onPressed: () => ExplanationSheet.show(
        context,
        id: entry.id,
        kind: SavedKind.word,
        target: entry.target,
        native: entry.native,
        explanation: entry.note,
        romanization: entry.romanization,
        tag: entry.pos,
        example: entry.example,
        exampleNative: entry.exampleNative,
      ),
      semanticLabel: '${entry.target}, ${entry.native}',
      child: Container(
        padding: const EdgeInsets.all(LL.s16),
        decoration: BoxDecoration(
          color: c.glassFill,
          borderRadius: BorderRadius.circular(LL.rMd),
          border: Border.all(color: c.glassStroke),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          entry.target,
                          style: context.type.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (saved) ...[
                        const SizedBox(width: LL.s8),
                        Icon(Icons.bookmark_rounded,
                            size: 14, color: c.success),
                      ],
                    ],
                  ),
                  if (entry.romanization != null)
                    Text(
                      entry.romanization!,
                      style: context.type.labelSmall
                          ?.copyWith(color: c.accentAlt, letterSpacing: 0.1),
                    ),
                  const SizedBox(height: LL.s2),
                  Text(
                    entry.native,
                    style: context.type.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: LL.s8),
            Pressable(
              onPressed: () {
                if (!controller.soundEnabled) return;
                context.read<TtsService>().speak(entry.target, ttsLocale);
              },
              semanticLabel: 'Ecouter ${entry.target}',
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.accentAlt.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.volume_up_rounded,
                    size: 18, color: c.accentAlt),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
