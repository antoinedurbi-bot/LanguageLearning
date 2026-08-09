import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/features/auth/sign_in_screen.dart';
import 'package:learning_app/features/home/home_shell.dart';
import 'package:learning_app/features/language/language_picker_screen.dart';
import 'package:provider/provider.dart';

/// Decides what the learner sees first.
///
/// Sign-in is deliberately optional. Requiring an account before anyone can
/// try a single card is the fastest way to lose them; progress is kept locally
/// and an account only adds backup across devices.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();

    if (!controller.ready) return const _Splash();

    if (!AppState.firebaseReady) return const _LanguageGate();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _Splash();
        }
        // A learner who has already picked a language keeps going without a
        // sign-in wall; the sign-in screen is reachable from the profile tab.
        if (!snapshot.hasData && controller.language == null) {
          return const SignInScreen();
        }
        return const _LanguageGate();
      },
    );
  }
}

class _LanguageGate extends StatelessWidget {
  const _LanguageGate();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LearningController>();
    if (controller.language == null) return const LanguagePickerScreen();
    return const HomeShell();
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('LinguaLab', style: context.type.displayMedium),
              const SizedBox(height: LL.s24),
              SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: context.ll.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
