import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/sentence_frame.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Pick a structure, choose the meaning, hear the result.
class SentenceForgeScreen extends StatelessWidget {
  const SentenceForgeScreen({
    super.key,
    required this.frames,
    required this.languageCode,
    required this.ttsLocale,
  });

  final List<SentenceFrame> frames;
  final String languageCode;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(languageCode);
    final total = frames.fold<int>(0, (sum, f) => sum + f.combinations);

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
                          Text('ATELIER DE PHRASES',
                              style: context.type.labelSmall),
                          Text('Construire, pas traduire',
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
                      child: Text(
                        'Chaque structure ci-dessous est grammaticalement '
                        'juste. Tu choisis le sens, pas la grammaire — donc '
                        'tout ce que tu produis ici est correct. Ces '
                        '${frames.length} structures suffisent à former '
                        '$total phrases différentes.',
                        style: context.type.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: LL.s24),
                    for (var i = 0; i < frames.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s16),
                        child: Reveal(
                          index: i + 1,
                          child: _FrameCard(
                            frame: frames[i],
                            ttsLocale: ttsLocale,
                            colors: ramp,
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

class _FrameCard extends StatefulWidget {
  const _FrameCard({
    required this.frame,
    required this.ttsLocale,
    required this.colors,
  });

  final SentenceFrame frame;
  final String ttsLocale;
  final List<Color> colors;

  @override
  State<_FrameCard> createState() => _FrameCardState();
}

class _FrameCardState extends State<_FrameCard> {
  final Map<String, int> _chosen = {};
  final _random = math.Random();

  void _pick(FrameSlot slot) async {
    final index = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _OptionSheet(slot: slot, chosen: _chosen[slot.id]),
    );
    if (index == null || !mounted) return;
    setState(() => _chosen[slot.id] = index);
  }

  void _shuffle() {
    setState(() {
      for (final slot in widget.frame.slots) {
        _chosen[slot.id] = _random.nextInt(slot.options.length);
      }
    });
  }

  void _speak() {
    final controller = context.read<LearningController>();
    if (!controller.soundEnabled) return;
    context
        .read<TtsService>()
        .speak(widget.frame.render(_chosen, blank: ''), widget.ttsLocale);
  }

  Future<void> _save() async {
    final controller = context.read<LearningController>();
    final target = widget.frame.render(_chosen);
    final saved = await controller.toggleSaved(
      SavedItem(
        id: 'forge-${widget.frame.id}-'
            '${widget.frame.slots.map((s) => _chosen[s.id]).join('-')}',
        kind: SavedKind.sentence,
        target: target,
        native: widget.frame.renderNative(_chosen),
        savedAt: DateTime.now(),
        romanization: widget.frame.renderRomanization(_chosen),
        note: 'Phrase que tu as construite avec la structure '
            '« ${widget.frame.label} ».',
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(saved
            ? 'Phrase ajoutée à ta collection.'
            : 'Phrase retirée de ta collection.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final frame = widget.frame;
    final complete = frame.isComplete(_chosen);
    final romanization = frame.renderRomanization(_chosen);

    return GlassCard(
      glow: complete ? widget.colors.first : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(frame.label, style: context.type.titleMedium),
                    const SizedBox(height: LL.s4),
                    Text(frame.why, style: context.type.bodyMedium),
                  ],
                ),
              ),
              LLChip(
                label: '${frame.combinations} phrases',
                color: c.accentAlt,
              ),
            ],
          ),
          const SizedBox(height: LL.s20),

          // The sentence being built. Slots are inline chips so the reader
          // sees a sentence with holes, not a form to fill in.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(LL.s16),
            decoration: BoxDecoration(
              color: c.glassFill,
              borderRadius: BorderRadius.circular(LL.rMd),
              border: Border.all(
                color: complete
                    ? widget.colors.first.withValues(alpha: 0.5)
                    : c.glassStroke,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  runSpacing: LL.s8,
                  children: [
                    for (final part in frame.parts)
                      switch (part) {
                        FrameText(:final text) => Text(
                            text,
                            style: context.type.titleMedium,
                          ),
                        FrameSlot slot => _SlotChip(
                            slot: slot,
                            chosen: _chosen[slot.id],
                            colors: widget.colors,
                            onPressed: () => _pick(slot),
                          ),
                      },
                  ],
                ),
                if (romanization != null) ...[
                  const SizedBox(height: LL.s8),
                  Text(
                    romanization,
                    style:
                        context.type.bodyMedium?.copyWith(color: c.accentAlt),
                  ),
                ],
                const SizedBox(height: LL.s12),
                Divider(color: c.divider, height: 1),
                const SizedBox(height: LL.s12),
                Text(
                  frame.renderNative(_chosen),
                  style: context.type.bodyLarge?.copyWith(
                    color: complete ? c.textPrimary : c.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (frame.grammarNote != null) ...[
            const SizedBox(height: LL.s12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.school_rounded, size: 14, color: c.warning),
                const SizedBox(width: LL.s8),
                Expanded(
                  child: Text(
                    frame.grammarNote!,
                    style: context.type.labelSmall
                        ?.copyWith(color: c.textSecondary, letterSpacing: 0.1),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: LL.s16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _shuffle,
                  icon: const Icon(Icons.casino_rounded, size: 18),
                  label: const Text('Au hasard'),
                ),
              ),
              const SizedBox(width: LL.s8),
              _RoundAction(
                icon: Icons.volume_up_rounded,
                tint: c.accentAlt,
                label: 'Écouter',
                onPressed: complete ? _speak : null,
              ),
              const SizedBox(width: LL.s8),
              _RoundAction(
                icon: Icons.bookmark_add_outlined,
                tint: c.success,
                label: 'Enregistrer',
                onPressed: complete ? _save : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.slot,
    required this.chosen,
    required this.colors,
    required this.onPressed,
  });

  final FrameSlot slot;
  final int? chosen;
  final List<Color> colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final filled = chosen != null && chosen! < slot.options.length;
    final label = filled ? slot.options[chosen!].target : slot.label;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: filled ? 'Changer : $label' : 'Choisir ${slot.label}',
      child: AnimatedContainer(
        duration: LL.fast,
        padding:
            const EdgeInsets.symmetric(horizontal: LL.s8 + 2, vertical: LL.s4),
        decoration: BoxDecoration(
          color: filled
              ? colors.first.withValues(alpha: 0.22)
              : c.accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(
            color: filled
                ? colors.first.withValues(alpha: 0.6)
                : c.accent.withValues(alpha: 0.45),
            // A dashed look is not available; a lighter border reads as
            // "empty" well enough next to a filled one.
            width: filled ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.type.titleMedium?.copyWith(
                color: filled ? c.textPrimary : c.accent,
                fontStyle: filled ? FontStyle.normal : FontStyle.italic,
              ),
            ),
            const SizedBox(width: LL.s4),
            Icon(
              filled ? Icons.swap_horiz_rounded : Icons.add_rounded,
              size: 14,
              color: filled ? c.textTertiary : c.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.tint,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final Color tint;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final enabled = onPressed != null;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: label,
      child: Tooltip(
        message: enabled ? label : 'Complète la phrase d\'abord',
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: enabled
                ? tint.withValues(alpha: 0.16)
                : c.glassFill,
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled ? tint.withValues(alpha: 0.4) : c.glassStroke,
            ),
          ),
          child: Icon(icon,
              size: 20, color: enabled ? tint : c.textTertiary),
        ),
      ),
    );
  }
}

class _OptionSheet extends StatelessWidget {
  const _OptionSheet({required this.slot, required this.chosen});

  final FrameSlot slot;
  final int? chosen;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(LL.s20, LL.s12, LL.s20, LL.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: LL.s20),
                  decoration: BoxDecoration(
                    color: c.glassStroke,
                    borderRadius: BorderRadius.circular(LL.rPill),
                  ),
                ),
              ),
              Text(slot.label.toUpperCase(), style: context.type.labelSmall),
              const SizedBox(height: LL.s16),
              for (var i = 0; i < slot.options.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: LL.s8),
                  child: _OptionRow(
                    option: slot.options[i],
                    selected: i == chosen,
                    onPressed: () => Navigator.of(context).pop(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final SlotOption option;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: '${option.target}, ${option.native}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(LL.s16),
        decoration: BoxDecoration(
          color: selected ? c.accent.withValues(alpha: 0.16) : c.glassFill,
          borderRadius: BorderRadius.circular(LL.rMd),
          border: Border.all(color: selected ? c.accent : c.glassStroke),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.target, style: context.type.titleSmall),
                  if (option.romanization != null)
                    Text(
                      option.romanization!,
                      style: context.type.labelSmall
                          ?.copyWith(color: c.accentAlt, letterSpacing: 0.1),
                    ),
                  const SizedBox(height: LL.s2),
                  Text(option.native, style: context.type.bodyMedium),
                  if (option.note != null) ...[
                    const SizedBox(height: LL.s4),
                    Text(
                      option.note!,
                      style: context.type.labelSmall?.copyWith(
                          color: c.textTertiary, letterSpacing: 0.1),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, size: 20, color: c.accent),
          ],
        ),
      ),
    );
  }
}
