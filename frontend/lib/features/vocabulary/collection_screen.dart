import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/features/vocabulary/explanation_sheet.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

/// Everything the learner chose to keep.
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({
    super.key,
    required this.languageCode,
    required this.ttsLocale,
  });

  final String languageCode;
  final String ttsLocale;

  static const _kindLabels = {
    SavedKind.word: 'Mots',
    SavedKind.phrase: 'Phrases',
    SavedKind.sentence: 'Phrases du cours',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = LL.gradientFor(languageCode);
    final collection = context.watch<LearningController>().collection;
    final items = collection?.items ?? const <SavedItem>[];

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
                          Text('MA COLLECTION', style: context.type.labelSmall),
                          Text(
                            items.isEmpty
                                ? 'Rien pour l\'instant'
                                : '${items.length} element'
                                    '${items.length > 1 ? 's' : ''}',
                            style: context.type.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? _EmptyState(color: c.textSecondary)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                            LL.s20, LL.s8, LL.s20, LL.s32),
                        children: [
                          for (final kind in SavedKind.values)
                            if (collection!.itemsOfKind(kind).isNotEmpty) ...[
                              Text(
                                (_kindLabels[kind] ?? '').toUpperCase(),
                                style: context.type.labelSmall,
                              ),
                              const SizedBox(height: LL.s8),
                              for (final item in collection.itemsOfKind(kind))
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: LL.s8 + 2),
                                  child: _SavedRow(
                                    item: item,
                                    ttsLocale: ttsLocale,
                                  ),
                                ),
                              const SizedBox(height: LL.s20),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LL.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 48, color: color),
            const SizedBox(height: LL.s16),
            Text(
              'Touche n\'importe quel mot ou phrase dans l\'app, puis '
              '« Enregistrer ». Ce que tu gardes ici est a toi : cette '
              'collection n\'est pas effacee quand tu reinitialises ta '
              'progression.',
              textAlign: TextAlign.center,
              style: context.type.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  const _SavedRow({required this.item, required this.ttsLocale});

  final SavedItem item;
  final String ttsLocale;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.read<LearningController>();

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: LL.s20),
        decoration: BoxDecoration(
          color: c.danger.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(LL.rMd),
        ),
        child: Icon(Icons.delete_outline_rounded, color: c.danger),
      ),
      onDismissed: (_) async {
        await controller.toggleSaved(item);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.target} retire.'),
            action: SnackBarAction(
              label: 'Annuler',
              // Re-saving restores it exactly: the item carries its own text,
              // so undo cannot lose anything.
              onPressed: () => controller.toggleSaved(item),
            ),
          ),
        );
      },
      child: Pressable(
        onPressed: () => ExplanationSheet.show(
          context,
          id: item.id,
          kind: item.kind,
          target: item.target,
          native: item.native,
          explanation: item.note ?? 'Enregistre depuis l\'app.',
          romanization: item.romanization,
        ),
        semanticLabel: '${item.target}, ${item.native}',
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
                    Text(item.target,
                        style: context.type.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    if (item.romanization != null)
                      Text(item.romanization!,
                          style: context.type.labelSmall?.copyWith(
                              color: c.accentAlt, letterSpacing: 0.1)),
                    const SizedBox(height: LL.s2),
                    Text(item.native,
                        style: context.type.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: LL.s8),
              Pressable(
                onPressed: () {
                  if (!controller.soundEnabled) return;
                  context.read<TtsService>().speak(item.target, ttsLocale);
                },
                semanticLabel: 'Ecouter',
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
      ),
    );
  }
}
