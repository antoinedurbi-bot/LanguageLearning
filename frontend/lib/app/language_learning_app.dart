import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/app_theme.dart';
import 'package:learning_app/features/auth/auth_gate.dart';
import 'package:provider/provider.dart';

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<LearningController, ThemeMode>(
      (controller) => controller.themeMode,
    );

    return MaterialApp(
      title: 'LinguaLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const AuthGate(),
      builder: (context, child) {
        // Clamp the system text scale: the layouts stretch gracefully up to
        // 1.4x, beyond which the sentence cards stop fitting on a small phone.
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.4,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
