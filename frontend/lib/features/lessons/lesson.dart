class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.level,
    required this.topic,
    required this.vocabulary,
  });

  final String id;
  final String title;
  final String level;
  final String topic;
  final List<String> vocabulary;

  factory Lesson.fromMap(String id, Map<String, dynamic> data) {
    return Lesson(
      id: id,
      title: data['title'] as String? ?? 'Lecon',
      level: data['level'] as String? ?? 'A1',
      topic: data['topic'] as String? ?? 'General',
      vocabulary: List<String>.from(data['vocabulary'] as List? ?? const []),
    );
  }
}
