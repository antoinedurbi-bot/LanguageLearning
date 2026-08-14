import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/core/widgets/progress_ring.dart';
import 'package:learning_app/data/models/island.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// The list of language islands.
class IslandsScreen extends StatelessWidget {
  const IslandsScreen({
    super.key,
    required this.islands,
    required this.languageCode,
    required this.ttsLocale,
  });

  final List<Island> islands;
  final String languageCode;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(languageCode);
    final collection = context.watch<LearningController>().collection;

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
                          Text('ILES LINGUISTIQUES',
                              style: context.type.labelSmall),
                          Text('Tes monologues prets',
                              style: context.type.headlineSmall),
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
                    Reveal(
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.landscape_rounded,
                                    size: 18, color: c.accent),
                                const SizedBox(width: LL.s8),
                                Text('Pourquoi des iles',
                                    style: context.type.labelLarge),
                              ],
                            ),
                            const SizedBox(height: LL.s12),
                            Text(
                              'Les deux premieres minutes d\'une conversation '
                              'sont presque toujours les memes. En preparant '
                              'quelques monologues courts sur ces sujets, puis '
                              'en les repetant jusqu\'a ce qu\'ils sortent '
                              'sans effort, tu parais bien plus a l\'aise que '
                              'ton niveau reel — et tu gagnes le calme '
                              'necessaire pour affronter la suite, qui elle '
                              'n\'est pas preparee.',
                              style: context.type.bodyMedium,
                            ),
                            const SizedBox(height: LL.s12),
                            Text(
                              'Le contenu doit etre le tien. Une ile copiee '
                              'reste un script.',
                              style: context.type.bodyMedium
                                  ?.copyWith(color: c.accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: LL.s20),
                    for (var i = 0; i < islands.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s12),
                        child: Reveal(
                          index: i + 1,
                          child: _IslandCard(
                            island: islands[i],
                            answered: collection?.answeredCount(
                                  islands[i].id,
                                  [
                                    for (final p in islands[i].prompts) p.id,
                                  ],
                                ) ??
                                0,
                            colors: ramp,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => IslandDetailScreen(
                                  island: islands[i],
                                  languageCode: languageCode,
                                  ttsLocale: ttsLocale,
                                ),
                              ),
                            ),
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

class _IslandCard extends StatelessWidget {
  const _IslandCard({
    required this.island,
    required this.answered,
    required this.colors,
    required this.onTap,
  });

  final Island island;
  final int answered;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final total = island.prompts.length;

    return Pressable(
      onPressed: onTap,
      semanticLabel: '${island.title}, $answered sur $total prepare',
      child: GlassCard(
        glow: answered == total && total > 0 ? colors.first : null,
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: ProgressRing(
                value: total == 0 ? 0 : answered / total,
                size: 56,
                stroke: 5,
                colors: [colors.first, colors.last, colors.first],
                center: Text('$answered', style: context.type.titleSmall),
              ),
            ),
            const SizedBox(width: LL.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(island.title, style: context.type.titleMedium),
                  const SizedBox(height: LL.s2),
                  Text(island.situation, style: context.type.bodyMedium),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// One island: the prompts to answer, the chunks to lift, and a rehearsal
/// view of the finished monologue.
class IslandDetailScreen extends StatefulWidget {
  const IslandDetailScreen({
    super.key,
    required this.island,
    required this.languageCode,
    required this.ttsLocale,
  });

  final Island island;
  final String languageCode;
  final String ttsLocale;

  @override
  State<IslandDetailScreen> createState() => _IslandDetailScreenState();
}

class _IslandDetailScreenState extends State<IslandDetailScreen> {
  final _controllers = <String, TextEditingController>{};
  bool _rehearsing = false;

  @override
  void initState() {
    super.initState();
    final collection = context.read<LearningController>().collection;
    for (final prompt in widget.island.prompts) {
      _controllers[prompt.id] = TextEditingController(
        text: collection?.answerFor(widget.island.id, prompt.id) ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// The answers, in prompt order, skipping the blanks.
  List<String> get _monologue => [
        for (final prompt in widget.island.prompts)
          if ((_controllers[prompt.id]?.text ?? '').trim().isNotEmpty)
            _controllers[prompt.id]!.text.trim(),
      ];

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(widget.languageCode);
    final controller = context.read<LearningController>();

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
                      child: Text(widget.island.title,
                          style: context.type.headlineSmall),
                    ),
                    Pressable(
                      onPressed: () =>
                          setState(() => _rehearsing = !_rehearsing),
                      semanticLabel:
                          _rehearsing ? 'Modifier' : 'Repeter a voix haute',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: LL.s12, vertical: LL.s8),
                        decoration: BoxDecoration(
                          color: c.accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(LL.rPill),
                          border:
                              Border.all(color: c.accent.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          _rehearsing ? 'Modifier' : 'Repeter',
                          style: context.type.labelMedium
                              ?.copyWith(color: c.accent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _rehearsing
                    ? _Rehearsal(
                        lines: _monologue,
                        ttsLocale: widget.ttsLocale,
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                            LL.s20, LL.s8, LL.s20, LL.s32),
                        children: [
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.island.situation,
                                    style: context.type.titleSmall),
                                const SizedBox(height: LL.s8),
                                Text(widget.island.why,
                                    style: context.type.bodyMedium),
                              ],
                            ),
                          ),
                          const SizedBox(height: LL.s20),
                          if (widget.island.chunks.isNotEmpty) ...[
                            Text('BRIQUES PRETES',
                                style: context.type.labelSmall),
                            const SizedBox(height: LL.s8),
                            for (final chunk in widget.island.chunks)
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: LL.s8),
                                child: _ChunkRow(
                                  chunk: chunk,
                                  ttsLocale: widget.ttsLocale,
                                ),
                              ),
                            const SizedBox(height: LL.s20),
                          ],
                          Text('TON TEXTE', style: context.type.labelSmall),
                          const SizedBox(height: LL.s8),
                          for (final prompt in widget.island.prompts)
                            Padding(
                              padding: const EdgeInsets.only(bottom: LL.s16),
                              child: _PromptField(
                                prompt: prompt,
                                controller: _controllers[prompt.id]!,
                                onChanged: (value) => controller
                                    .setIslandAnswer(
                                        widget.island.id, prompt.id, value),
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

class _ChunkRow extends StatelessWidget {
  const _ChunkRow({required this.chunk, required this.ttsLocale});

  final IslandChunk chunk;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.read<LearningController>();

    return Pressable(
      onPressed: () {
        if (!controller.soundEnabled) return;
        context.read<TtsService>().speak(chunk.target, ttsLocale);
      },
      semanticLabel: chunk.target,
      child: Container(
        padding: const EdgeInsets.all(LL.s12),
        decoration: BoxDecoration(
          color: c.glassFill,
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(color: c.glassStroke),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(chunk.target, style: context.type.titleSmall),
                  if (chunk.romanization != null)
                    Text(chunk.romanization!,
                        style: context.type.labelSmall
                            ?.copyWith(color: c.accentAlt, letterSpacing: 0.1)),
                  Text(chunk.native, style: context.type.bodyMedium),
                ],
              ),
            ),
            Icon(Icons.volume_up_rounded, size: 18, color: c.accentAlt),
          ],
        ),
      ),
    );
  }
}

class _PromptField extends StatelessWidget {
  const _PromptField({
    required this.prompt,
    required this.controller,
    required this.onChanged,
  });

  final IslandPrompt prompt;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(prompt.question, style: context.type.titleSmall),
        const SizedBox(height: LL.s4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.tips_and_updates_outlined,
                size: 14, color: c.textTertiary),
            const SizedBox(width: LL.s4 + 2),
            Expanded(
              child: Text(
                prompt.hint,
                style: context.type.labelSmall
                    ?.copyWith(color: c.textTertiary, letterSpacing: 0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: LL.s8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          minLines: 2,
          maxLines: 5,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'Ecris ta reponse dans la langue cible',
          ),
        ),
      ],
    );
  }
}

/// The finished monologue, laid out to be read aloud.
class _Rehearsal extends StatelessWidget {
  const _Rehearsal({required this.lines, required this.ttsLocale});

  final List<String> lines;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.read<LearningController>();

    if (lines.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(LL.s32),
          child: Text(
            'Ecris d\'abord tes reponses, puis reviens ici pour les repeter '
            'a voix haute.',
            textAlign: TextAlign.center,
            style: context.type.bodyLarge,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(LL.s20, LL.s8, LL.s20, LL.s32),
      children: [
        GlassCard(
          child: Text(
            'Lis-le a voix haute, plusieurs fois, jusqu\'a ne plus avoir '
            'besoin de regarder. Une ile n\'est prete que quand elle sort '
            'sans reflechir.',
            style: context.type.bodyMedium,
          ),
        ),
        const SizedBox(height: LL.s20),
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: LL.s12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(LL.s16),
              decoration: BoxDecoration(
                color: c.glassFill,
                borderRadius: BorderRadius.circular(LL.rMd),
                border: Border.all(color: c.glassStroke),
              ),
              child: SelectableText(line, style: context.type.titleSmall),
            ),
          ),
        const SizedBox(height: LL.s12),
        Center(
          child: TextButton.icon(
            onPressed: () {
              if (!controller.soundEnabled) return;
              context.read<TtsService>().speak(lines.join(' '), ttsLocale);
            },
            icon: const Icon(Icons.volume_up_rounded, size: 18),
            label: const Text('Ecouter tout'),
          ),
        ),
      ],
    );
  }
}
