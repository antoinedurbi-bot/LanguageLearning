import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// The one place anything tappable explains itself.
///
/// Every word, phrase and sentence in the app opens this same sheet, so the
/// learner never has to wonder whether a given thing is tappable or what a tap
/// will do. It always shows the same four things: what it is, how it sounds,
/// how it is used, and a way to keep it.
class ExplanationSheet extends StatelessWidget {
  const ExplanationSheet({
    super.key,
    required this.id,
    required this.kind,
    required this.target,
    required this.native,
    required this.explanation,
    this.romanization,
    this.tag,
    this.example,
    this.exampleNative,
    this.literal,
  });

  final String id;
  final SavedKind kind;
  final String target;
  final String native;

  /// The usage note — the reason this sheet exists rather than a tooltip.
  final String explanation;

  final String? romanization;

  /// Part of speech, category, level... shown as a chip.
  final String? tag;

  final String? example;
  final String? exampleNative;

  /// Word-for-word rendering, when it is instructive.
  final String? literal;

  /// Opens the sheet. Kept as a static so call sites read as one line.
  static Future<void> show(
    BuildContext context, {
    required String id,
    required SavedKind kind,
    required String target,
    required String native,
    required String explanation,
    String? romanization,
    String? tag,
    String? example,
    String? exampleNative,
    String? literal,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExplanationSheet(
        id: id,
        kind: kind,
        target: target,
        native: native,
        explanation: explanation,
        romanization: romanization,
        tag: tag,
        example: example,
        exampleNative: exampleNative,
        literal: literal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final code = controller.language?.code ?? 'en';
    final locale = _ttsLocale(code);
    final saved = controller.isSaved(id);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            LL.s20,
            LL.s12,
            LL.s20,
            LL.s20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          target,
                          style: context.type.headlineMedium,
                        ),
                        if (romanization != null) ...[
                          const SizedBox(height: LL.s4),
                          Text(
                            romanization!,
                            style: context.type.titleSmall
                                ?.copyWith(color: c.accentAlt),
                          ),
                        ],
                        const SizedBox(height: LL.s8),
                        Text(native, style: context.type.bodyLarge),
                      ],
                    ),
                  ),
                  const SizedBox(width: LL.s12),
                  _RoundButton(
                    icon: Icons.volume_up_rounded,
                    tint: c.accentAlt,
                    semanticLabel: 'Écouter',
                    onPressed: () {
                      if (!controller.soundEnabled) return;
                      context.read<TtsService>().speak(target, locale);
                    },
                  ),
                ],
              ),
              if (tag != null) ...[
                const SizedBox(height: LL.s12),
                LLChip(label: tag!, color: c.textTertiary),
              ],
              const SizedBox(height: LL.s20),
              GlassCard(
                borderColor: c.accent.withValues(alpha: 0.35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_rounded,
                            size: 18, color: c.accent),
                        const SizedBox(width: LL.s8),
                        Text('A savoir',
                            style: context.type.labelLarge
                                ?.copyWith(color: c.accent)),
                      ],
                    ),
                    const SizedBox(height: LL.s12),
                    Text(explanation, style: context.type.bodyLarge),
                  ],
                ),
              ),
              if (literal != null) ...[
                const SizedBox(height: LL.s16),
                Text('MOT À MOT', style: context.type.labelSmall),
                const SizedBox(height: LL.s4),
                Text(literal!, style: context.type.bodyMedium),
              ],
              if (example != null) ...[
                const SizedBox(height: LL.s20),
                Text('EN CONTEXTE', style: context.type.labelSmall),
                const SizedBox(height: LL.s8),
                Pressable(
                  onPressed: () {
                    if (!controller.soundEnabled) return;
                    context.read<TtsService>().speak(example!, locale);
                  },
                  semanticLabel: 'Écouter l\'exemple',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(LL.s16),
                    decoration: BoxDecoration(
                      color: c.glassFill,
                      borderRadius: BorderRadius.circular(LL.rSm + 4),
                      border: Border.all(color: c.glassStroke),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                example!,
                                style: context.type.titleSmall,
                              ),
                            ),
                            Icon(Icons.volume_up_rounded,
                                size: 18, color: c.accentAlt),
                          ],
                        ),
                        if (exampleNative != null) ...[
                          const SizedBox(height: LL.s4),
                          Text(exampleNative!,
                              style: context.type.bodyMedium),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: LL.s24),
              _SaveButton(
                saved: saved,
                onPressed: () async {
                  final nowSaved = await controller.toggleSaved(
                    SavedItem(
                      id: id,
                      kind: kind,
                      target: target,
                      native: native,
                      savedAt: DateTime.now(),
                      romanization: romanization,
                      note: explanation,
                    ),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        nowSaved
                            ? 'Ajoute à ta collection.'
                            : 'Retire de ta collection.',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _ttsLocale(String code) => switch (code) {
        'es' => 'es-ES',
        'zh' => 'zh-CN',
        'tr' => 'tr-TR',
        _ => 'en-US',
      };
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tint,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final Color tint;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: tint.withValues(alpha: 0.16),
          shape: BoxShape.circle,
          border: Border.all(color: tint.withValues(alpha: 0.35)),
        ),
        child: Icon(icon, color: tint, size: 22),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.saved, required this.onPressed});

  final bool saved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Pressable(
      onPressed: onPressed,
      semanticLabel: saved ? 'Retirer de la collection' : 'Enregistrer',
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: saved ? c.success.withValues(alpha: 0.16) : c.glassFill,
          borderRadius: BorderRadius.circular(LL.rSm + 6),
          border: Border.all(color: saved ? c.success : c.glassStroke),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              saved ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
              size: 20,
              color: saved ? c.success : c.textSecondary,
            ),
            const SizedBox(width: LL.s8 + 2),
            Text(
              saved ? 'Dans ta collection' : 'Enregistrer',
              style: context.type.labelLarge?.copyWith(
                color: saved ? c.success : c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
