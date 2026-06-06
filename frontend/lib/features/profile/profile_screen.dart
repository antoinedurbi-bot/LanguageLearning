import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/features/language/app_language.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final email = AppState.firebaseReady ? FirebaseAuth.instance.currentUser?.email : 'Mode apercu local';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Profil', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(email ?? 'Utilisateur'),
            subtitle: Text('Langue cible: ${language.name} - niveau A1'),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.local_fire_department),
            title: Text('Serie actuelle'),
            subtitle: Text('0 jour'),
          ),
        ),
      ],
    );
  }
}
