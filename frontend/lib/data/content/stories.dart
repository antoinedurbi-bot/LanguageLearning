import 'package:learning_app/data/content/stories_en.dart';
import 'package:learning_app/data/content/stories_es.dart';
import 'package:learning_app/data/content/stories_tr.dart';
import 'package:learning_app/data/content/stories_zh.dart';
import 'package:learning_app/data/models/story.dart';

final stories = <String, List<Story>>{
  'en': storiesEn,
  'es': storiesEs,
  'zh': storiesZh,
  'tr': storiesTr,
};

List<Story> storiesFor(String languageCode) =>
    stories[languageCode] ?? const <Story>[];

Story? storyById(String id) {
  for (final list in stories.values) {
    for (final story in list) {
      if (story.id == id) return story;
    }
  }
  return null;
}
