import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/features/chinese/character_detail_screen.dart';

/// A searchable index of every bundled character and HSK 1-2 word.
///
/// Searching by pinyin works without tone marks, because a learner reaching
/// for a character usually cannot yet produce `ǎ` on a French keyboard — and
/// making them fight the input is a good way to stop them looking things up.
class CharacterExplorerScreen extends StatefulWidget {
  const CharacterExplorerScreen({super.key, required this.repository});

  final HanziRepository repository;

  @override
  State<CharacterExplorerScreen> createState() =>
      _CharacterExplorerScreenState();
}

class _CharacterExplorerScreenState extends State<CharacterExplorerScreen> {
  final _controller = TextEditingController();

  String _query = '';
  int _level = 0; // 0 = all levels

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');

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
                          Text('Caractères', style: context.type.headlineSmall),
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
                    hintText: 'Caractère, pinyin (ni hao), ou sens',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LL.s20),
                child: Row(
                  children: [
                    for (final level in [0, 1, 2])
                      Padding(
                        padding: const EdgeInsets.only(right: LL.s8),
                        child: Pressable(
                          onPressed: () => setState(() => _level = level),
                          semanticLabel: level == 0
                              ? 'Tous les niveaux'
                              : 'Niveau HSK $level',
                          child: AnimatedContainer(
                            duration: LL.fast,
                            padding: const EdgeInsets.symmetric(
                              horizontal: LL.s16,
                              vertical: LL.s8 + 2,
                            ),
                            decoration: BoxDecoration(
                              color: _level == level
                                  ? c.accent.withValues(alpha: 0.18)
                                  : c.glassFill,
                              borderRadius: BorderRadius.circular(LL.rPill),
                              border: Border.all(
                                color:
                                    _level == level ? c.accent : c.glassStroke,
                              ),
                            ),
                            child: Text(
                              level == 0 ? 'Tout' : 'HSK $level',
                              style: context.type.labelMedium?.copyWith(
                                color: _level == level
                                    ? c.accent
                                    : c.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: LL.s12),
              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return FutureBuilder<Map<String, Hanzi>>(
      future: widget.repository.characters(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final all = snapshot.data!.values.toList();
        final needle = HanziRepository.stripTones(_query.trim().toLowerCase());

        final matches = [
          for (final hanzi in all)
            if ((_level == 0 || hanzi.hskLevel == _level) &&
                (needle.isEmpty ||
                    _query.contains(hanzi.character) ||
                    hanzi.pinyin.any((p) =>
                        HanziRepository.stripTones(p.toLowerCase())
                            .startsWith(needle)) ||
                    hanzi.definition.toLowerCase().contains(needle)))
              hanzi,
        ]..sort((a, b) {
            // Simplest characters first: stroke count is the closest thing to
            // a difficulty ordering that needs no extra data.
            final byLevel = a.hskLevel.compareTo(b.hskLevel);
            if (byLevel != 0 && a.hskLevel != 0 && b.hskLevel != 0) {
              return byLevel;
            }
            return a.strokeCount.compareTo(b.strokeCount);
          });

        if (matches.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(LL.s32),
              child: Text(
                'Aucun caractère ne correspond a "$_query".',
                textAlign: TextAlign.center,
                style: context.type.bodyLarge,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(LL.s20, 0, LL.s20, LL.s32),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 108,
            mainAxisSpacing: LL.s12,
            crossAxisSpacing: LL.s12,
            childAspectRatio: 0.82,
          ),
          itemCount: matches.length,
          itemBuilder: (context, index) => _CharacterTile(
            hanzi: matches[index],
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CharacterDetailScreen(
                  hanzi: matches[index],
                  repository: widget.repository,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({required this.hanzi, required this.onTap});

  final Hanzi hanzi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onTap,
      semanticLabel: '${hanzi.character}, '
          '${hanzi.pinyin.isEmpty ? '' : hanzi.pinyin.first}',
      child: Container(
        decoration: BoxDecoration(
          color: c.glassFill,
          borderRadius: BorderRadius.circular(LL.rMd),
          border: Border.all(color: c.glassStroke),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hanzi.character,
              style: context.type.displayMedium?.copyWith(fontSize: 38),
            ),
            const SizedBox(height: LL.s4),
            Text(
              hanzi.pinyin.isEmpty ? '—' : hanzi.pinyin.first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.type.labelMedium?.copyWith(color: c.accentAlt),
            ),
            const SizedBox(height: LL.s2),
            Text('${hanzi.strokeCount} traits', style: context.type.labelSmall),
          ],
        ),
      ),
    );
  }
}
