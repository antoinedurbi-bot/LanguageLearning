import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/app/language_learning_app.dart';
import 'package:learning_app/services/sound_service.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;
  if (options.projectId != 'demo-learning-app') {
    try {
      await Firebase.initializeApp(options: options);
      AppState.firebaseReady = true;
    } catch (error) {
      // No Firebase project configured yet: the app runs entirely on local
      // storage, so this is a degraded mode rather than a failure.
      debugPrint('Firebase unavailable, running locally: $error');
      AppState.firebaseReady = false;
    }
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  final controller = LearningController();
  await controller.bootstrap();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: controller),
        Provider(create: (_) => TtsService(), dispose: (_, tts) => tts.stop()),
        Provider(
          create: (_) => SoundService(),
          dispose: (_, sound) => sound.dispose(),
        ),
      ],
      child: const LanguageLearningApp(),
    ),
  );
}
