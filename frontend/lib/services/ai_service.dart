import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiService {
  AiService({String? baseUrl}) : baseUrl = baseUrl ?? (kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000');

  final String baseUrl;

  Future<String> checkAnswer({
    required String prompt,
    required String answer,
    required String targetLanguage,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/ai/check-answer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'answer': answer,
        'target_language': targetLanguage,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('AI request failed');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json['feedback'] as String? ?? 'Pas de feedback.';
  }
}
