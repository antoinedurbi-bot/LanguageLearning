import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/illustration.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/services/ai_service.dart';
import 'package:provider/provider.dart';

/// Free conversation with an AI tutor, in the language being learned.
///
/// The point is not to answer questions about the language — the grammar
/// lessons already do that — it is to produce the one thing nothing else in
/// the app can: an open-ended exchange with no fixed correct answer, where
/// the learner has to actually generate language instead of recognising or
/// filling a blank. Corrections arrive folded into the reply, not as a
/// separate verdict, so the conversation never stops to grade itself.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.languageName,
    required this.languageCode,
  });

  final String languageName;
  final String languageCode;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatEntry {
  _ChatEntry({required this.role, required this.content, this.failed = false});

  final String role;
  String content;
  bool failed;
}

class _ChatScreenState extends State<ChatScreen> {
  final _service = AiService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatEntry> _messages = [];
  bool _sending = false;
  bool _unavailable = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add(_ChatEntry(role: 'user', content: text));
      _controller.clear();
      _sending = true;
    });
    _scrollToEnd();

    try {
      final reply = await _service.chat(
        targetLanguage: widget.languageName,
        level: 'beginner',
        history: [
          for (final m in _messages) ChatTurn(role: m.role, content: m.content),
        ],
      );

      if (!mounted) return;
      setState(() {
        _sending = false;
        if (reply.available && reply.text != null) {
          _messages.add(_ChatEntry(role: 'assistant', content: reply.text!));
        } else {
          _unavailable = true;
        }
      });
    } catch (_) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() {
        _sending = false;
        _messages.add(_ChatEntry(
          role: 'assistant',
          content: 'Je n\'ai pas pu répondre — vérifie ta connexion.',
          failed: true,
        ));
      });
    }
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();
    final ramp = LL.gradientFor(widget.languageCode);

    return Scaffold(
      body: ColoredBox(
        color: c.background,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Retour',
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TUTEUR IA',
                              style: context.type.labelSmall
                                  ?.copyWith(color: ramp.first)),
                          Text(widget.languageName,
                              style: context.type.titleMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_unavailable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LL.s20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(LL.s12),
                    decoration: BoxDecoration(
                      color: c.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(LL.rSm),
                      border:
                          Border.all(color: c.warning.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cloud_off_rounded, size: 16, color: c.warning),
                        const SizedBox(width: LL.s8),
                        Expanded(
                          child: Text(
                            'Le tuteur IA n\'est pas configuré côté serveur '
                            'pour l\'instant.',
                            style: context.type.labelSmall
                                ?.copyWith(color: c.warning),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: _messages.isEmpty
                    ? _EmptyState(languageName: widget.languageName)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                            LL.s20, LL.s16, LL.s20, LL.s16),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: LL.s12),
                          child: _Bubble(entry: _messages[i], colors: ramp),
                        ),
                      ),
              ),
              if (_sending)
                const Padding(
                  padding: EdgeInsets.only(bottom: LL.s8),
                  child: _TypingIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(LL.s16, 0, LL.s16, LL.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        enabled: !_sending,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText:
                              'Écris en ${controller.language?.name ?? "..."}',
                        ),
                      ),
                    ),
                    const SizedBox(width: LL.s8),
                    Pressable(
                      onPressed: _sending ? null : _send,
                      semanticLabel: 'Envoyer',
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ramp.first,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: LLColors.pressedShadeOf(ramp.first),
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_upward_rounded,
                            color: Colors.white),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.languageName});

  final String languageName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LL.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Illustration(Illust.speech, size: 88),
            const SizedBox(height: LL.s16),
            Text(
              'Écris quelque chose en $languageName, même une phrase simple. '
              'Le tuteur répond et corrige au passage — rien n\'est noté.',
              textAlign: TextAlign.center,
              style: context.type.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.entry, required this.colors});

  final _ChatEntry entry;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final isUser = entry.role == 'user';

    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: LL.s16, vertical: LL.s12),
            decoration: BoxDecoration(
              color: isUser
                  ? colors.first
                  : (entry.failed
                      ? c.danger.withValues(alpha: 0.12)
                      : c.glassFill),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(LL.rMd),
                topRight: const Radius.circular(LL.rMd),
                bottomLeft: Radius.circular(isUser ? LL.rMd : LL.s4),
                bottomRight: Radius.circular(isUser ? LL.s4 : LL.rMd),
              ),
              border: Border.all(
                width: 2,
                color: isUser
                    ? Colors.transparent
                    : (entry.failed
                        ? c.danger.withValues(alpha: 0.3)
                        : c.glassStroke),
              ),
            ),
            child: SelectableText(
              entry.content,
              style: context.type.bodyLarge?.copyWith(
                color: isUser ? Colors.white : c.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LL.s20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: c.textTertiary,
          ),
        ),
      ),
    );
  }
}
