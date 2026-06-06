import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/app_theme.dart';
import 'package:learning_app/features/auth/auth_gate.dart';

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}
