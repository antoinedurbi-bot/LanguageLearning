import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiFeedback {
  const AiFeedback({
    required this.isCorrect,
    required this.feedback,
    this.correctedAnswer,
    this.notes = const [],
    this.fromServer = true,
  });

  final bool isCorrect;
  final String feedback;
  final String? correctedAnswer;

  /// Point-by-point remarks, one per difference found.
  final List<String> notes;

  /// False when the answer was graded locally because the API was
  /// unreachable, so the UI can say so instead of implying a server verdict.
  final bool fromServer;
}

/// One turn of a chat conversation.
class ChatTurn {
  const ChatTurn({required this.role, required this.content});

  /// "user" or "assistant".
  final String role;
  final String content;

  Map<String, String> toJson() => {'role': role, 'content': content};
}

/// The tutor's reply, or the honest absence of one.
class ChatReply {
  const ChatReply({required this.text, required this.available});

  final String? text;

  /// False when the backend could not reach the LLM at all (no key
  /// configured, timeout) — distinct from a network error on our own request,
  /// which throws instead.
  final bool available;
}

/// Client for the FastAPI correction endpoint.
///
/// The base URL is compile-time configurable so a real deployment does not
/// have to ship a localhost address:
/// `flutter build web --dart-define=AI_API_BASE_URL=https://api.example.com`
class AiService {
  AiService({String? baseUrl})
      : baseUrl = baseUrl ??
            const String.fromEnvironment(
              'AI_API_BASE_URL',
              defaultValue: '',
            );

  final String baseUrl;

  /// Where to reach the API when nothing was configured: the Android emulator
  /// reaches the host through 10.0.2.2, everything else through localhost.
  String get _resolvedBase {
    if (baseUrl.isNotEmpty) return baseUrl;
    if (kIsWeb) return 'http://127.0.0.1:8000';
    return defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8000'
        : 'http://127.0.0.1:8000';
  }

  Future<AiFeedback> checkAnswer({
    required String prompt,
    required String answer,
    required String targetLanguage,
    String? expectedAnswer,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_resolvedBase/api/ai/check-answer'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'prompt': prompt,
            'answer': answer,
            'target_language': targetLanguage,
            if (expectedAnswer != null) 'expected_answer': expectedAnswer,
          }),
        )
        .timeout(const Duration(seconds: 8));

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Correction indisponible (${response.statusCode})',
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Reponse inattendue du serveur');
    }

    return AiFeedback(
      isCorrect: json['is_correct'] as bool? ?? false,
      feedback: json['feedback'] as String? ?? 'Pas de retour.',
      correctedAnswer: json['corrected_answer'] as String?,
      notes: [
        for (final note in (json['notes'] as List? ?? const []))
          note.toString(),
      ],
    );
  }

  Future<ChatReply> chat({
    required String targetLanguage,
    required String level,
    required List<ChatTurn> history,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_resolvedBase/api/ai/chat'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'target_language': targetLanguage,
            'level': level,
            'history': [for (final turn in history) turn.toJson()],
          }),
        )
        .timeout(const Duration(seconds: 22));

    if (response.statusCode >= 400) {
      throw http.ClientException(
        'Tuteur indisponible (${response.statusCode})',
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Reponse inattendue du serveur');
    }

    return ChatReply(
      text: json['reply'] as String?,
      available: json['available'] as bool? ?? false,
    );
  }
}
