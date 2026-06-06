import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/app/language_learning_app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final options = DefaultFirebaseOptions.currentPlatform;

  if (options.projectId != 'demo-learning-app') {
    try {
      await Firebase.initializeApp(options: options);
      AppState.firebaseReady = true;
    } catch (_) {
      AppState.firebaseReady = false;
    }
  }

  runApp(const LanguageLearningApp());
}
