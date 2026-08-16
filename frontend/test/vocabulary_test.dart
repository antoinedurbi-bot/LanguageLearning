import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/islands.dart';
import 'package:learning_app/data/content/vocabularies.dart';
import 'package:learning_app/data/repository/collection_repository.dart';

void main() {
  group('vocabulary packs', () {
    test('every language has a pack with themes and phrases', () {
      for (final code in ['en', 'es', 'zh', 'tr', 'ja']) {
        final pack = vocabularyFor(code);
        expect(pack, isNotNull, reason: '$code has no vocabulary pack');
        expect(pack!.themes, isNotEmpty);
        expect(pack.phrases, isNotEmpty);
      }
    });

    test('ids are unique across the whole app', () {
      final seen = <String>{};
      for (final pack in vocabularies.values) {
        for (final entry in pack.allEntries) {
          expect(seen.add(entry.id), isTrue, reason: 'duplicate ${entry.id}');
        }
        for (final phrase in pack.phrases) {
          expect(seen.add(phrase.id), isTrue, reason: 'duplicate ${phrase.id}');
        }
      }
    });

    test('no entry ships without the explanation that justifies the tap', () {
      for (final pack in vocabularies.values) {
        for (final entry in pack.allEntries) {
          expect(entry.target.trim(), isNotEmpty);
          expect(entry.native.trim(), isNotEmpty);
          expect(entry.note.trim().length, greaterThan(20),
              reason: '${entry.id} has a note too thin to be useful');
        }
        for (final phrase in pack.phrases) {
          expect(phrase.whenToUse.trim().length, greaterThan(20),
              reason: '${phrase.id} does not say when to use it');
        }
      }
    });

    test('non-latin languages carry a romanization', () {
      final zh = vocabularyFor('zh')!;
      for (final entry in zh.allEntries) {
        expect(entry.romanization, isNotNull, reason: '${entry.id} has no pinyin');
      }
      for (final phrase in zh.phrases) {
        expect(phrase.romanization, isNotNull);
      }

      final ja = vocabularyFor('ja')!;
      for (final entry in ja.allEntries) {
        expect(entry.romanization, isNotNull, reason: '${entry.id} has no romaji');
      }
      for (final phrase in ja.phrases) {
        expect(phrase.romanization, isNotNull);
      }
    });

    test('repair phrases come first in every language', () {
      for (final pack in vocabularies.values) {
        expect(pack.phraseCategories.first, 'reparation',
            reason: '${pack.languageCode} buries its repair phrases');
      }
    });
  });

  group('islands', () {
    test('every language gets islands with prompts and chunks', () {
      for (final code in ['en', 'es', 'zh', 'tr', 'ja']) {
        final islands = islandsFor(code);
        expect(islands, isNotEmpty, reason: '$code has no islands');
        for (final island in islands) {
          expect(island.prompts, isNotEmpty);
          expect(island.chunks, isNotEmpty);
        }
      }
    });

    test('prompt ids are unique inside an island', () {
      for (final island in islandsFor('en')) {
        final ids = island.prompts.map((p) => p.id).toSet();
        expect(ids.length, island.prompts.length);
      }
    });
  });

  group('collection', () {
    test('survives a round trip through json', () {
      final collection = LanguageCollection(languageCode: 'zh');
      collection.saved['a'] = SavedItem(
        id: 'a',
        kind: SavedKind.phrase,
        target: '再说一遍',
        native: 'Repete',
        savedAt: DateTime.utc(2026, 1, 2),
        romanization: 'zai shuo yi bian',
        note: 'note',
      );
      collection.islandAnswers['self/name'] = 'Je m\'appelle Antoine';

      final restored = LanguageCollection.fromJson(collection.toJson());
      expect(restored.languageCode, 'zh');
      expect(restored.saved['a']!.target, '再说一遍');
      expect(restored.saved['a']!.romanization, 'zai shuo yi bian');
      expect(restored.answerFor('self', 'name'), 'Je m\'appelle Antoine');
    });

    test('malformed stored items are dropped, not fatal', () {
      final restored = LanguageCollection.fromJson({
        'languageCode': 'en',
        'saved': {
          'ok': {'id': 'ok', 'kind': 'word', 'target': 't', 'native': 'n'},
          'bad': {'kind': 'word'},
          'worse': 'not a map',
        },
        'islandAnswers': {'x/y': 'answer', 'z': 42},
      });
      expect(restored.saved.keys, ['ok']);
      expect(restored.answerFor('x', 'y'), 'answer');
    });

    test('answeredCount only counts non-empty answers', () {
      final collection = LanguageCollection(languageCode: 'en');
      collection.islandAnswers['self/a'] = 'something';
      collection.islandAnswers['self/b'] = '   ';
      expect(collection.answeredCount('self', ['a', 'b', 'c']), 1);
    });
  });
}
