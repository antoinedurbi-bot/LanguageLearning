import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/features/language/app_language.dart';
import 'package:learning_app/features/language/language_picker_screen.dart';
import 'package:learning_app/features/lessons/lesson_list_screen.dart';
import 'package:learning_app/features/practice/practice_screen.dart';
import 'package:learning_app/features/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  AppLanguage? selectedLanguage;

  void selectLanguage(AppLanguage language) {
    setState(() {
      selectedLanguage = language;
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = selectedLanguage;

    if (language == null) {
      return LanguagePickerScreen(onLanguageSelected: selectLanguage);
    }

    final screens = [
      LessonListScreen(language: language),
      PracticeScreen(language: language),
      ProfileScreen(language: language),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LinguaLab'),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => selectedLanguage = null),
            icon: const Icon(Icons.translate),
            label: Text(language.name),
          ),
          if (AppState.firebaseReady)
            IconButton(
              tooltip: 'Deconnexion',
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Lecons'),
          NavigationDestination(icon: Icon(Icons.psychology_outlined), selectedIcon: Icon(Icons.psychology), label: 'Pratique'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
