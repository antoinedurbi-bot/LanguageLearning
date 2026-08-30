import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/card_item.dart';

/// Shared header: the prompt the learner is answering.
class PromptCard extends StatelessWidget {
  const PromptCard({
    super.key,
    required this.instruction,
    required this.text,
    this.romanization,
    this.onSpeak,
    this.large = false,
    this.obscured = false,
  });

  final String instruction;
  final String text;
  final String? romanization;
  final VoidCallback? onSpeak;
  final bool large;

  /// Listening items hide the written form until the learner answers, so the
  /// exercise trains the ear instead of being solved by reading.
  final bool obscured;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return GlassCard(
      padding: const EdgeInsets.all(LL.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  instruction.toUpperCase(),
                  style: context.type.labelSmall,
                ),
              ),
              if (onSpeak != null)
                _SpeakButton(onPressed: onSpeak!, tint: c.accentAlt),
            ],
          ),
          const SizedBox(height: LL.s16),
          if (obscured)
            Row(
              children: [
                Icon(Icons.graphic_eq_rounded, color: c.textTertiary, size: 20),
                const SizedBox(width: LL.s12),
                Expanded(
                  child: Text(
                    'Écoute puis réponds. Le texte apparaît après.',
                    style: context.type.bodyMedium,
                  ),
                ),
              ],
            )
          else ...[
            SelectableText(
              text,
              style: large
                  ? context.type.headlineMedium
                  : context.type.headlineSmall,
            ),
            if (romanization != null) ...[
              const SizedBox(height: LL.s8),
              Text(
                romanization!,
                style: context.type.bodyLarge?.copyWith(
                  color: c.accentAlt,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SpeakButton extends StatelessWidget {
  const _SpeakButton({required this.onPressed, required this.tint});

  final VoidCallback onPressed;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Écouter',
      child: Pressable(
        onPressed: onPressed,
        semanticLabel: 'Écouter la phrase',
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.16),
            shape: BoxShape.circle,
            border: Border.all(color: tint.withValues(alpha: 0.35)),
          ),
          child: Icon(Icons.volume_up_rounded, color: tint, size: 22),
        ),
      ),
    );
  }
}

/// Multiple choice. Used for recognition and listening items.
class ChoiceExercise extends StatelessWidget {
  const ChoiceExercise({
    super.key,
    required this.options,
    required this.correct,
    required this.selected,
    required this.revealed,
    required this.onSelect,
  });

  final List<String> options;
  final String correct;
  final String? selected;
  final bool revealed;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: LL.s12),
            child: _ChoiceTile(
              label: option,
              // Correctness is carried by an icon and a border as well as by
              // colour, so it is legible without colour vision.
              state: !revealed
                  ? (selected == option
                      ? _ChoiceState.selected
                      : _ChoiceState.idle)
                  : option == correct
                      ? _ChoiceState.correct
                      : (selected == option
                          ? _ChoiceState.wrong
                          : _ChoiceState.idle),
              onTap: revealed ? null : () => onSelect(option),
              colors: c,
            ),
          ),
      ],
    );
  }
}

enum _ChoiceState { idle, selected, correct, wrong }

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.state,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final _ChoiceState state;
  final VoidCallback? onTap;
  final LLColors colors;

  @override
  Widget build(BuildContext context) {
    final (border, fill, icon, iconColor) = switch (state) {
      _ChoiceState.idle => (colors.glassStroke, colors.glassFill, null, null),
      _ChoiceState.selected => (
          colors.accent,
          colors.accent.withValues(alpha: 0.14),
          null,
          null,
        ),
      _ChoiceState.correct => (
          colors.success,
          colors.success.withValues(alpha: 0.16),
          Icons.check_circle_rounded,
          colors.success,
        ),
      _ChoiceState.wrong => (
          colors.danger,
          colors.danger.withValues(alpha: 0.14),
          Icons.cancel_rounded,
          colors.danger,
        ),
    };

    return Semantics(
      button: onTap != null,
      selected: state == _ChoiceState.selected,
      child: Pressable(
        onPressed: onTap,
        // A revealed answer must stay readable even though it is no longer
        // tappable, so the disabled dimming is switched off here.
        disabledOpacity: 1,
        child: AnimatedContainer(
          duration: LL.fast,
          curve: LL.enter,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(
            horizontal: LL.s16,
            vertical: LL.s12,
          ),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(LL.rSm + 4),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(label, style: context.type.titleSmall),
              ),
              if (icon != null) ...[
                const SizedBox(width: LL.s12),
                Icon(icon, color: iconColor, size: 22),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Word-bank sentence building: tap chunks in order to reconstruct the
/// sentence. Production with scaffolding.
class BuildExercise extends StatelessWidget {
  const BuildExercise({
    super.key,
    required this.bank,
    required this.chosen,
    required this.revealed,
    required this.onPick,
    required this.onUnpick,
  });

  final List<String> bank;
  final List<String> chosen;
  final bool revealed;
  final ValueChanged<int> onPick;
  final ValueChanged<int> onUnpick;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Answer tray. Keeps a fixed minimum height so picking the first
        // chunk does not shove the word bank down the screen.
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 96),
          padding: const EdgeInsets.all(LL.s12),
          decoration: BoxDecoration(
            color: c.glassFill,
            borderRadius: BorderRadius.circular(LL.rMd),
            border: Border.all(color: c.glassStroke),
          ),
          child: chosen.isEmpty
              ? Center(
                  child: Text(
                    'Choisis les mots dans l\'ordre',
                    style: context.type.bodyMedium,
                  ),
                )
              : Wrap(
                  spacing: LL.s8,
                  runSpacing: LL.s8,
                  children: [
                    for (var i = 0; i < chosen.length; i++)
                      _Token(
                        label: chosen[i],
                        filled: true,
                        onTap: revealed ? null : () => onUnpick(i),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: LL.s20),
        Wrap(
          spacing: LL.s8,
          runSpacing: LL.s8,
          children: [
            for (var i = 0; i < bank.length; i++)
              _Token(
                label: bank[i],
                filled: false,
                onTap: revealed ? null : () => onPick(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _Token extends StatelessWidget {
  const _Token({required this.label, required this.filled, this.onTap});

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Pressable(
      onPressed: onTap,
      disabledOpacity: 1,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: LL.s16,
          vertical: LL.s8 + 2,
        ),
        decoration: BoxDecoration(
          color: filled ? c.accent.withValues(alpha: 0.18) : c.surface,
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(color: filled ? c.accent : c.glassStroke),
        ),
        child: Text(label, style: context.type.titleSmall),
      ),
    );
  }
}

/// Free typing, used for cloze and full production.
class TypeExercise extends StatelessWidget {
  const TypeExercise({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.revealed,
    required this.onSubmit,
    required this.hint,
    this.helper,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool revealed;
  final VoidCallback onSubmit;
  final String hint;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: !revealed,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmit(),
      minLines: 2,
      maxLines: 4,
      style: context.type.titleSmall,
      decoration: InputDecoration(
        labelText: 'Ta réponse',
        hintText: hint,
        helperText: helper,
        helperMaxLines: 2,
      ),
    );
  }
}

/// Shown after answering: the full sentence, its meaning, and the one point
/// the card is teaching.
class ExplanationPanel extends StatelessWidget {
  const ExplanationPanel({
    super.key,
    required this.card,
    required this.correct,
    this.onSpeak,
  });

  final CardItem card;
  final bool correct;
  final VoidCallback? onSpeak;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final tint = correct ? c.success : c.danger;

    return GlassCard(
      glow: tint,
      borderColor: tint.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct ? Icons.check_circle_rounded : Icons.info_rounded,
                color: tint,
                size: 20,
              ),
              const SizedBox(width: LL.s8),
              Text(
                correct ? 'Correct' : 'La bonne réponse',
                style: context.type.labelLarge?.copyWith(color: tint),
              ),
              const Spacer(),
              if (onSpeak != null)
                _SpeakButton(onPressed: onSpeak!, tint: c.accentAlt),
            ],
          ),
          const SizedBox(height: LL.s16),
          SelectableText(card.target, style: context.type.titleMedium),
          if (card.romanization != null) ...[
            const SizedBox(height: LL.s4),
            Text(
              card.romanization!,
              style: context.type.bodyMedium?.copyWith(color: c.accentAlt),
            ),
          ],
          const SizedBox(height: LL.s8),
          Text(card.native, style: context.type.bodyLarge),
          const SizedBox(height: LL.s16),
          Divider(color: c.divider),
          const SizedBox(height: LL.s16),
          _Detail(label: 'Mot à mot', value: card.gloss),
          const SizedBox(height: LL.s12),
          _Detail(label: 'A retenir', value: card.focus, tint: c.accent),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value, this.tint});

  final String label;
  final String value;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: context.type.labelSmall),
        const SizedBox(height: LL.s4),
        Text(
          value,
          style: context.type.bodyMedium?.copyWith(
            color: tint ?? context.ll.textSecondary,
            fontWeight: tint != null ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
