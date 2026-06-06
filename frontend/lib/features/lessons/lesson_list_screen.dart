import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/features/language/app_language.dart';
import 'package:learning_app/features/lessons/lesson.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key, required this.language});

  final AppLanguage language;

  static const previewLessonsByLanguage = {
    'en': [
      Lesson(id: 'en-a1-coffee', title: 'Commander un cafe', level: 'A1', topic: 'Cafe', vocabulary: ['coffee', 'please', 'I would like']),
      Lesson(id: 'en-a1-greetings', title: 'Se presenter', level: 'A1', topic: 'Presentation', vocabulary: ['hello', 'my name is', 'nice to meet you']),
    ],
    'zh': [
      Lesson(id: 'zh-a1-hello', title: 'Dire bonjour', level: 'A1', topic: 'Salutations', vocabulary: ['ni hao', 'xie xie', 'zai jian']),
      Lesson(id: 'zh-a1-tea', title: 'Commander un the', level: 'A1', topic: 'Cafe', vocabulary: ['cha', 'qing', 'wo yao']),
    ],
    'es': [
      Lesson(id: 'es-a1-greetings', title: 'Saluer quelqu\'un', level: 'A1', topic: 'Salutations', vocabulary: ['hola', 'gracias', 'adios']),
      Lesson(id: 'es-a1-travel', title: 'Demander son chemin', level: 'A1', topic: 'Voyage', vocabulary: ['donde', 'calle', 'por favor']),
    ],
    'tr': [
      Lesson(id: 'tr-a1-hello', title: 'Premieres salutations', level: 'A1', topic: 'Salutations', vocabulary: ['merhaba', 'tesekkurler', 'gule gule']),
      Lesson(id: 'tr-a1-cafe', title: 'Au cafe', level: 'A1', topic: 'Cafe', vocabulary: ['kahve', 'lutfen', 'istiyorum']),
    ],
  };

  @override
  Widget build(BuildContext context) {
    if (!AppState.firebaseReady) {
      return _LessonList(language: language, lessons: previewLessonsByLanguage[language.code] ?? const []);
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('lessons').where('language', isEqualTo: language.code).orderBy('level').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final lessons = snapshot.data?.docs.map((doc) => Lesson.fromMap(doc.id, doc.data())).toList() ?? const <Lesson>[];

        if (lessons.isEmpty) {
          return Center(child: Text('Aucune lecon en ${language.name} pour le moment.'));
        }

        return _LessonList(language: language, lessons: lessons);
      },
    );
  }
}

class _LessonList extends StatelessWidget {
  const _LessonList({required this.language, required this.lessons});

  final AppLanguage language;
  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${language.name} - niveau debutant',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          );
        }

        final lesson = lessons[index - 1];
        return Card(
          child: ListTile(
            title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${lesson.level} - ${lesson.topic}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        );
      },
    );
  }
}

