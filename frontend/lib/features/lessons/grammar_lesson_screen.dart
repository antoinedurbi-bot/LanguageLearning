import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Renders a [GrammarLesson] block by block.
///
/// Every block type maps to exactly one widget below; adding a block kind
/// means adding one case here, not redesigning the screen.
class GrammarLessonScreen extends StatelessWidget {
  const GrammarLessonScreen({
    super.key,
    required this.unit,
    required this.lesson,
    required this.ttsLocale,
    required this.colors,
  });

  final Unit unit;
  final GrammarLesson lesson;
  final String ttsLocale;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Scaffold(
      body: ColoredBox(
        color: c.background,
        child: SafeArea(
          child: Column(
            children: [
              _Header(title: lesson.title, unitTitle: unit.title),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s40),
                  children: [
                    Reveal(
                      child: GlassCard(
                        glow: colors.first,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_rounded,
                                color: colors.first, size: 20),
                            const SizedBox(width: LL.s12),
                            Expanded(
                              child: Text(lesson.hook,
                                  style: context.type.bodyLarge),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: LL.s16),
                    for (var i = 0; i < lesson.blocks.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s16),
                        child: Reveal(
                          index: i + 1,
                          child: _BlockView(
                            block: lesson.blocks[i],
                            ttsLocale: ttsLocale,
                            accent: colors.first,
                          ),
                        ),
                      ),
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

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.unitTitle});

  final String title;
  final String unitTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                Text(unitTitle.toUpperCase(), style: context.type.labelSmall),
                Text(title, style: context.type.headlineSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockView extends StatelessWidget {
  const _BlockView({
    required this.block,
    required this.ttsLocale,
    required this.accent,
  });

  final GrammarBlock block;
  final String ttsLocale;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      ExplanationBlock b => _Explanation(block: b),
      ExampleBlock b =>
        _Examples(block: b, ttsLocale: ttsLocale, accent: accent),
      TableBlock b => _Table(block: b, accent: accent),
      MistakeBlock b => _Mistake(block: b),
      ToneBlock b => _Tones(block: b, ttsLocale: ttsLocale),
      CharacterBreakdownBlock b => _Characters(block: b, accent: accent),
      MeasureWordBlock b =>
        _MeasureWords(block: b, ttsLocale: ttsLocale, accent: accent),
    };
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.block});

  final ExplanationBlock block;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(block.heading, style: context.type.titleMedium),
          const SizedBox(height: LL.s8),
          Text(block.body, style: context.type.bodyLarge),
        ],
      ),
    );
  }
}

class _Examples extends StatelessWidget {
  const _Examples(
      {required this.block, required this.ttsLocale, required this.accent});

  final ExampleBlock block;
  final String ttsLocale;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.heading != null) ...[
            Text(block.heading!, style: context.type.titleMedium),
            const SizedBox(height: LL.s12),
          ],
          for (var i = 0; i < block.examples.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == block.examples.length - 1 ? 0 : LL.s16,
              ),
              child: _ExampleRow(
                  example: block.examples[i],
                  ttsLocale: ttsLocale,
                  accent: accent),
            ),
        ],
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow(
      {required this.example, required this.ttsLocale, required this.accent});

  final GrammarExample example;
  final String ttsLocale;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(example.target, style: context.type.titleSmall),
              if (example.romanization != null) ...[
                const SizedBox(height: LL.s2),
                Text(
                  example.romanization!,
                  style: context.type.labelMedium?.copyWith(color: accent),
                ),
              ],
              const SizedBox(height: LL.s2),
              Text(example.native, style: context.type.bodyMedium),
              if (example.note != null) ...[
                const SizedBox(height: LL.s4),
                Text(
                  example.note!,
                  style: context.type.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
        Pressable(
          onPressed: () {
            if (!context.read<LearningController>().soundEnabled) return;
            context.read<TtsService>().speak(example.target, ttsLocale);
          },
          semanticLabel: 'Écouter',
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.volume_up_rounded, size: 16, color: accent),
          ),
        ),
      ],
    );
  }
}

class _Table extends StatelessWidget {
  const _Table({required this.block, required this.accent});

  final TableBlock block;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.caption != null) ...[
            Text(block.caption!, style: context.type.titleMedium),
            const SizedBox(height: LL.s12),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder(
                horizontalInside: BorderSide(color: c.divider),
                bottom: BorderSide(color: c.divider),
              ),
              children: [
                TableRow(
                  children: [
                    for (final header in block.headers)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: LL.s8, right: LL.s16),
                        child: Text(
                          header,
                          style:
                              context.type.labelMedium?.copyWith(color: accent),
                        ),
                      ),
                  ],
                ),
                for (final row in block.rows)
                  TableRow(
                    children: [
                      for (final cell in row)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: LL.s8, bottom: LL.s8, right: LL.s16),
                          child: Text(cell, style: context.type.bodyMedium),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Mistake extends StatelessWidget {
  const _Mistake({required this.block});

  final MistakeBlock block;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return GlassCard(
      borderColor: c.warning.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.report_rounded, size: 18, color: c.warning),
              const SizedBox(width: LL.s8),
              Text('Erreur fréquente',
                  style: context.type.labelLarge?.copyWith(color: c.warning)),
            ],
          ),
          const SizedBox(height: LL.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.close_rounded, size: 18, color: c.danger),
              const SizedBox(width: LL.s8),
              Expanded(
                child: Text(
                  block.wrong,
                  style: context.type.bodyLarge?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: c.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: LL.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_rounded, size: 18, color: c.success),
              const SizedBox(width: LL.s8),
              Expanded(child: Text(block.right, style: context.type.bodyLarge)),
            ],
          ),
          const SizedBox(height: LL.s12),
          Text(block.why, style: context.type.bodyMedium),
        ],
      ),
    );
  }
}

/// Renders each tone as a small pitch-contour glyph rather than relying on
/// the diacritic alone, since a first-time reader cannot yet hear the
/// difference between ā, á, ǎ, à from the mark alone.
class _Tones extends StatelessWidget {
  const _Tones({required this.block, required this.ttsLocale});

  final ToneBlock block;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.heading != null) ...[
            Text(block.heading!, style: context.type.titleMedium),
            const SizedBox(height: LL.s12),
          ],
          for (var i = 0; i < block.entries.length; i++)
            Padding(
              padding: EdgeInsets.only(
                  bottom: i == block.entries.length - 1 ? 0 : LL.s12),
              child: _ToneRow(entry: block.entries[i], ttsLocale: ttsLocale),
            ),
        ],
      ),
    );
  }
}

class _ToneRow extends StatelessWidget {
  const _ToneRow({required this.entry, required this.ttsLocale});

  final ToneExample entry;
  final String ttsLocale;

  static const _toneColors = {
    0: LL.violet,
    1: LL.indigo,
    2: LL.mint,
    3: LL.amber,
    4: LL.rose,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final tint = _toneColors[entry.tone] ?? c.accent;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(LL.rSm),
            border: Border.all(color: tint.withValues(alpha: 0.4)),
          ),
          child: Text(
            entry.syllable,
            style: context.type.titleMedium?.copyWith(color: tint),
          ),
        ),
        const SizedBox(width: LL.s12),
        SizedBox(
          width: 44,
          height: 24,
          child:
              CustomPaint(painter: _TonePainter(tone: entry.tone, color: tint)),
        ),
        const SizedBox(width: LL.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${entry.pinyin} · ton ${entry.tone == 0 ? 'neutre' : entry.tone}',
                  style: context.type.titleSmall),
              Text('${entry.contour} - ${entry.meaning}',
                  style: context.type.bodyMedium),
            ],
          ),
        ),
        Pressable(
          onPressed: () {
            if (!context.read<LearningController>().soundEnabled) return;
            context
                .read<TtsService>()
                .speak(entry.syllable, ttsLocale, slow: true);
          },
          semanticLabel: 'Écouter',
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.14), shape: BoxShape.circle),
            child: Icon(Icons.volume_up_rounded, size: 16, color: tint),
          ),
        ),
      ],
    );
  }
}

/// A tiny hand-drawn pitch line: flat-high, rising, dip, or falling, plus a
/// dot for the short neutral tone.
class _TonePainter extends CustomPainter {
  const _TonePainter({required this.tone, required this.color});

  final int tone;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width, h = size.height;

    switch (tone) {
      case 1: // high and flat
        path.moveTo(0, h * 0.15);
        path.lineTo(w, h * 0.15);
      case 2: // rising
        path.moveTo(0, h * 0.75);
        path.lineTo(w, h * 0.1);
      case 3: // dips then rises
        path.moveTo(0, h * 0.4);
        path.quadraticBezierTo(w * 0.5, h * 1.05, w, h * 0.2);
      case 4: // falling
        path.moveTo(0, h * 0.1);
        path.lineTo(w, h * 0.85);
      default: // neutral: a short flat dot mid-height
        canvas.drawCircle(Offset(w / 2, h / 2), 2.5, Paint()..color = color);
        return;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TonePainter old) =>
      old.tone != tone || old.color != color;
}

class _Characters extends StatelessWidget {
  const _Characters({required this.block, required this.accent});

  final CharacterBreakdownBlock block;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.heading != null) ...[
            Text(block.heading!, style: context.type.titleMedium),
            const SizedBox(height: LL.s12),
          ],
          for (var i = 0; i < block.entries.length; i++)
            Padding(
              padding: EdgeInsets.only(
                  bottom: i == block.entries.length - 1 ? 0 : LL.s16),
              child: _CharacterRow(entry: block.entries[i], accent: accent),
            ),
        ],
      ),
    );
  }
}

class _CharacterRow extends StatelessWidget {
  const _CharacterRow({required this.entry, required this.accent});

  final CharacterBreakdown entry;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.glassFill,
            borderRadius: BorderRadius.circular(LL.rSm),
            border: Border.all(color: c.glassStroke),
          ),
          child: Text(entry.character, style: context.type.headlineSmall),
        ),
        const SizedBox(width: LL.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${entry.pinyin} · ${entry.meaning}',
                  style: context.type.titleSmall),
              const SizedBox(height: LL.s4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: LL.s8, vertical: 2),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(LL.rSm),
                    ),
                    child: Text(
                      '${entry.radical} = ${entry.radicalMeaning}',
                      style: context.type.labelSmall?.copyWith(color: accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LL.s4),
              Text(entry.mnemonic, style: context.type.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeasureWords extends StatelessWidget {
  const _MeasureWords(
      {required this.block, required this.ttsLocale, required this.accent});

  final MeasureWordBlock block;
  final String ttsLocale;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.heading != null) ...[
            Text(block.heading!, style: context.type.titleMedium),
            const SizedBox(height: LL.s12),
          ],
          for (var i = 0; i < block.entries.length; i++)
            Padding(
              padding: EdgeInsets.only(
                  bottom: i == block.entries.length - 1 ? 0 : LL.s12),
              child: _MeasureWordRow(
                  entry: block.entries[i],
                  ttsLocale: ttsLocale,
                  accent: accent),
            ),
        ],
      ),
    );
  }
}

class _MeasureWordRow extends StatelessWidget {
  const _MeasureWordRow(
      {required this.entry, required this.ttsLocale, required this.accent});

  final MeasureWordEntry entry;
  final String ttsLocale;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(LL.rSm),
          ),
          child: Text(entry.word,
              style: context.type.titleMedium?.copyWith(color: accent)),
        ),
        const SizedBox(width: LL.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${entry.pinyin} · ${entry.usedFor}',
                  style: context.type.titleSmall),
              const SizedBox(height: LL.s2),
              Text(entry.example, style: context.type.bodyMedium),
              Text(entry.exampleNative,
                  style: context.type.labelMedium
                      ?.copyWith(color: c.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }
}
