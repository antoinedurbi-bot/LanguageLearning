import 'package:flutter/material.dart';
import 'package:learning_app/features/language/app_language.dart';
import 'package:learning_app/services/ai_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, required this.language});

  final AppLanguage language;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final aiService = AiService();
  final answerController = TextEditingController();
  String feedback = '';
  bool isChecking = false;

  Future<void> checkAnswer() async {
    setState(() => isChecking = true);
    try {
      final result = await aiService.checkAnswer(
        prompt: widget.language.samplePrompt,
        answer: answerController.text,
        targetLanguage: widget.language.code,
      );
      setState(() => feedback = result);
    } catch (_) {
      setState(() => feedback = 'Le service IA est indisponible pour le moment.');
    } finally {
      if (mounted) setState(() => isChecking = false);
    }
  }

  @override
  void didUpdateWidget(covariant PracticeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.code != widget.language.code) {
      answerController.clear();
      feedback = '';
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Pratique IA - ${widget.language.name}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.language.samplePrompt, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                TextField(controller: answerController, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'Ta reponse')),
                const SizedBox(height: 16),
                FilledButton(onPressed: isChecking ? null : checkAnswer, child: Text(isChecking ? 'Correction...' : 'Corriger')),
              ],
            ),
          ),
        ),
        if (feedback.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(feedback))),
        ],
      ],
    );
  }
}
