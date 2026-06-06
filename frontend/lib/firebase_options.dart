import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
        apiKey: 'demo-api-key',
        appId: '1:000000000000:web:demo',
        messagingSenderId: '000000000000',
        projectId: 'demo-learning-app',
      );
}
