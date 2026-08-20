import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/content/chengyu_zh.dart';
import 'package:learning_app/data/models/chengyu.dart';
import 'package:learning_app/data/repository/chengyu_progress_repository.dart';

/// Advanced content pack: four-character idioms with the story behind them.
///
/// Chengyu are what makes a speaker sound literate rather than merely
/// functional in Chinese — a native speaker reaches for one the way a French
/// speaker reaches for a proverb. They are deliberately kept separate from
/// the vocabulary pack: knowing all four characters of an idiom does not
/// mean knowing the idiom, so the unit of learning here is the whole
/// expression plus its story, not four flashcards.
class ChengyuScreen extends StatefulWidget {
  const ChengyuScreen({super.key});

  @override
  State<ChengyuScreen> createState() => _ChengyuScreenState();
}

class _ChengyuScreenState extends State<ChengyuScreen> {
  final _progress = ChengyuProgressRepository();
  Set<String> _known = {};

  @override
  void initState() {
    super.initState();
    _progress.load().then((value) {
      if (mounted) setState(() => _known = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor('zh');

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
                        Text('CHINOIS', style: context.type.labelSmall),
                        Text('Chengyu 成语', style: context.type.headlineSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LL.s20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_known.length} / ${chengyuZh.length} connus.',
                  style: context.type.labelMedium
                      ?.copyWith(color: c.textTertiary),
                ),
              ),
            ),
            const SizedBox(height: LL.s8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    LL.s20, LL.s8, LL.s20, LL.s32 + 64),
                itemCount: chengyuZh.length,
                separatorBuilder: (_, __) => const SizedBox(height: LL.s12),
                itemBuilder: (context, index) {
                  final item = chengyuZh[index];
                  return Reveal(
                    index: index.clamp(0, 12),
                    child: _ChengyuRow(
                      chengyu: item,
                      known: _known.contains(item.id),
                      colors: ramp,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ChengyuDetailScreen(
                              chengyu: item,
                              colors: ramp,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChengyuRow extends StatelessWidget {
  const _ChengyuRow({
    required this.chengyu,
    required this.known,
    required this.colors,
    required this.onTap,
  });

  final Chengyu chengyu;
  final bool known;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onTap,
      semanticLabel: '${chengyu.characters}, ${chengyu.meaning}',
      child: GlassCard(
        padding: const EdgeInsets.all(LL.s16),
        glow: known ? colors.first : null,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chengyu.characters,
                      style: context.type.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: LL.s2),
                  Text(chengyu.pinyin, style: context.type.labelMedium),
                  const SizedBox(height: LL.s4),
                  Text(
                    chengyu.meaning,
                    style: context.type.bodyMedium
                        ?.copyWith(color: c.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (known)
              Icon(Icons.check_circle_rounded, color: colors.first)
            else
              Icon(Icons.chevron_right_rounded, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// The story, usage note and an example sentence for one chengyu.
class ChengyuDetailScreen extends StatefulWidget {
  const ChengyuDetailScreen({
    super.key,
    required this.chengyu,
    required this.colors,
  });

  final Chengyu chengyu;
  final List<Color> colors;

  @override
  State<ChengyuDetailScreen> createState() => _ChengyuDetailScreenState();
}

class _ChengyuDetailScreenState extends State<ChengyuDetailScreen> {
  final _progress = ChengyuProgressRepository();
  bool _known = false;

  @override
  void initState() {
    super.initState();
    _progress.load().then((value) {
      if (mounted) setState(() => _known = value.contains(widget.chengyu.id));
    });
  }

  Future<void> _toggle() async {
    final known = await _progress.load();
    setState(() {
      if (!known.remove(widget.chengyu.id)) known.add(widget.chengyu.id);
      _known = known.contains(widget.chengyu.id);
    });
    await _progress.save(known);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final chengyu = widget.chengyu;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Retour',
                ),
                const Spacer(),
                IconButton(
                  onPressed: _toggle,
                  icon: Icon(
                    _known
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: _known ? widget.colors.first : c.textTertiary,
                  ),
                  tooltip: _known ? 'Marquer comme non connu' : 'Je connais',
                ),
              ],
            ),
            Center(
              child: Text(chengyu.characters,
                  style:
                      const TextStyle(fontSize: 56, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: LL.s8),
            Center(
              child: Text(chengyu.pinyin, style: context.type.titleMedium),
            ),
            const SizedBox(height: LL.s24),
            _Section(title: 'Sens litteral', body: chengyu.literal, colors: widget.colors),
            const SizedBox(height: LL.s12),
            _Section(title: 'Signification', body: chengyu.meaning, colors: widget.colors),
            const SizedBox(height: LL.s12),
            _Section(title: 'Origine', body: chengyu.story, colors: widget.colors),
            const SizedBox(height: LL.s12),
            _Section(title: 'Usage', body: chengyu.usage, colors: widget.colors),
            const SizedBox(height: LL.s12),
            _Section(
              title: 'Exemple',
              body: '${chengyu.example}\n${chengyu.exampleNative}',
              colors: widget.colors,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body, required this.colors});

  final String title;
  final String body;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glow: colors.first.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: context.type.labelSmall),
          const SizedBox(height: LL.s8),
          Text(body, style: context.type.bodyLarge),
        ],
      ),
    );
  }
}
