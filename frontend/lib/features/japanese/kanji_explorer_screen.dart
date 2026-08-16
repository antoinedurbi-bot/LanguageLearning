import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/kana/kanji.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// A searchable index of the starter kanji set.
///
/// Searching works by romaji reading (with or without okurigana) or by
/// French meaning, since a beginner reaching for a kanji rarely has the
/// character itself to type.
class KanjiExplorerScreen extends StatefulWidget {
  const KanjiExplorerScreen({super.key});

  @override
  State<KanjiExplorerScreen> createState() => _KanjiExplorerScreenState();
}

class _KanjiExplorerScreenState extends State<KanjiExplorerScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('ja');
    final q = _query.trim().toLowerCase();

    final results = starterKanji.where((k) {
      if (q.isEmpty) return true;
      if (k.character.contains(q)) return true;
      if (k.meaning.toLowerCase().contains(q)) return true;
      if (k.onyomi.any((r) => r.toLowerCase().contains(q))) return true;
      if (k.kunyomi.any((r) => r.toLowerCase().contains(q))) return true;
      return false;
    }).toList();

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
                          Text('DICTIONNAIRE', style: context.type.labelSmall),
                          Text('Kanji', style: context.type.headlineSmall),
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
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Kanji, lecture (tabe), ou sens',
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
              const SizedBox(height: LL.s12),
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text('Aucun resultat',
                            style: context.type.bodyMedium),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                            LL.s20, 0, LL.s20, LL.s32),
                        itemCount: results.length,
                        itemBuilder: (context, i) =>
                            _KanjiRow(kanji: results[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KanjiRow extends StatelessWidget {
  const _KanjiRow({required this.kanji});

  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Padding(
      padding: const EdgeInsets.only(bottom: LL.s12),
      child: Pressable(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => _KanjiDetailSheet(kanji: kanji),
        ),
        child: GlassCard(
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.surfaceRaised,
                  borderRadius: BorderRadius.circular(LL.rMd),
                ),
                child: Text(kanji.character, style: context.type.headlineSmall),
              ),
              const SizedBox(width: LL.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kanji.meaning, style: context.type.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (kanji.onyomi.isNotEmpty)
                          'on: ${kanji.onyomi.join('、')}',
                        if (kanji.kunyomi.isNotEmpty)
                          'kun: ${kanji.kunyomi.join('、')}',
                      ].join('  ·  '),
                      style: context.type.labelSmall,
                    ),
                  ],
                ),
              ),
              Text('${kanji.strokeCount} traits',
                  style: context.type.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _KanjiDetailSheet extends StatelessWidget {
  const _KanjiDetailSheet({required this.kanji});

  final Kanji kanji;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(LL.s20, LL.s16, LL.s20, LL.s32),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(kanji.character, style: context.type.displaySmall),
                  const SizedBox(width: LL.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kanji.meaning, style: context.type.titleMedium),
                        Text('${kanji.strokeCount} traits · JLPT N${kanji.jlpt}',
                            style: context.type.labelSmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<TtsService>()
                        .speak(kanji.character, 'ja-JP'),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
              const SizedBox(height: LL.s16),
              if (kanji.onyomi.isNotEmpty) ...[
                Text('Lecture sino-japonaise (音読み)',
                    style: context.type.labelMedium),
                Text(kanji.onyomi.join('、'), style: context.type.bodyMedium),
                const SizedBox(height: LL.s12),
              ],
              if (kanji.kunyomi.isNotEmpty) ...[
                Text('Lecture japonaise (訓読み)',
                    style: context.type.labelMedium),
                Text(kanji.kunyomi.join('、'), style: context.type.bodyMedium),
                const SizedBox(height: LL.s12),
              ],
              if (kanji.mnemonic != null) ...[
                Text('Moyen mnemotechnique',
                    style:
                        context.type.labelMedium?.copyWith(color: c.accent)),
                Text(kanji.mnemonic!, style: context.type.bodyMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
