import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/stories.dart';
import 'package:learning_app/data/models/story.dart';

void main() {
  group('story markup', () {
    test('bracketed chunks keep their surface form and gain a gloss', () {
      final line = StoryLine.parse('Yo [quiero|je veux] agua.',
          native: 'Je veux de l\'eau.');

      expect(line.text, 'Yo quiero agua.');
      final quiero = line.tokens.firstWhere((t) => t.text == 'quiero');
      expect(quiero.gloss, 'je veux');
      expect(quiero.taught, isTrue);
    });

    test('a third field carries romanization', () {
      final line = StoryLine.parse('[我|je|wǒ][要|veux|yào]',
          native: 'Je veux', romanization: 'Wǒ yào');

      expect(line.text, '我要');
      expect(line.tokens.first.romanization, 'wǒ');
      expect(line.tokens.last.gloss, 'veux');
    });

    test('unbracketed words fall back to the shared lexicon', () {
      final line = StoryLine.parse('No [entiendo|je comprends] nada.',
          native: 'Je ne comprends rien.',
          lexicon: const {'no': 'ne… pas', 'nada': 'rien'});

      final no = line.tokens.firstWhere((t) => t.text == 'No');
      expect(no.gloss, 'ne… pas', reason: 'lexicon lookup is case-insensitive');
      expect(no.taught, isFalse,
          reason: 'lexicon words are not teaching points and must not be marked');
      expect(line.tokens.firstWhere((t) => t.text == 'nada').gloss, 'rien');
    });

    test('a word with no gloss anywhere is still a tappable token', () {
      final line = StoryLine.parse('Madrid es grande.', native: 'Madrid est grand.');
      final madrid = line.tokens.firstWhere((t) => t.text == 'Madrid');
      expect(madrid.isWord, isTrue);
      expect(madrid.hasGloss, isFalse,
          reason: 'no gloss is better than an invented one');
    });

    test('punctuation and spacing survive untouched', () {
      const source = '¿[Quieren|Voulez-vous] postre o café?';
      final line = StoryLine.parse(source, native: '...');
      expect(line.text, '¿Quieren postre o café?');
      expect(line.tokens.where((t) => !t.isWord).map((t) => t.text).join(),
          contains('?'));
    });

    test('apostrophes stay inside the word', () {
      final line = StoryLine.parse("I don't know.", native: 'Je ne sais pas.');
      expect(line.tokens.any((t) => t.text == "don't"), isTrue);
    });

    test('an unbalanced bracket degrades to plain text instead of losing it',
        () {
      final line = StoryLine.parse('Hola [mundo', native: 'Bonjour monde');
      expect(line.text, 'Hola [mundo');
    });

    test('CJK punctuation is not treated as a word', () {
      final line = StoryLine.parse('[好|bien|hǎo]。', native: 'Bien.');
      expect(line.tokens.last.isWord, isFalse);
      expect(line.tokens.last.text, '。');
    });
  });

  group('story content', () {
    test('every language ships readable texts', () {
      for (final code in ['en', 'es', 'zh', 'tr', 'ja']) {
        final list = storiesFor(code);
        expect(list, isNotEmpty, reason: '$code has no stories');
        for (final story in list) {
          expect(story.lines, isNotEmpty);
          expect(story.languageCode, code);
          expect(story.blurb.trim().length, greaterThan(20));
        }
      }
    });

    test('story ids are unique across the app', () {
      final seen = <String>{};
      for (final list in stories.values) {
        for (final story in list) {
          expect(seen.add(story.id), isTrue, reason: 'duplicate ${story.id}');
        }
      }
    });

    test('every line has a translation and at least one word', () {
      for (final list in stories.values) {
        for (final story in list) {
          for (final line in story.lines) {
            expect(line.native.trim(), isNotEmpty,
                reason: '${story.id}: untranslated line "${line.text}"');
            expect(line.tokens.any((t) => t.isWord), isTrue,
                reason: '${story.id}: wordless line');
          }
        }
      }
    });

    test('bracketed teaching points always carry a gloss', () {
      for (final list in stories.values) {
        for (final story in list) {
          for (final line in story.lines) {
            for (final token in line.tokens) {
              if (!token.taught) continue;
              expect(token.hasGloss, isTrue,
                  reason:
                      '${story.id}: "${token.text}" is marked as taught but '
                      'has no gloss');
            }
          }
        }
      }
    });

    test('Mandarin is segmented and romanized throughout', () {
      for (final story in storiesFor('zh')) {
        for (final line in story.lines) {
          expect(line.romanization, isNotNull,
              reason: '${story.id}: a Chinese line without pinyin is unreadable');
          for (final token in line.tokens) {
            if (!token.isWord) continue;
            expect(token.taught, isTrue,
                reason:
                    '${story.id}: "${token.text}" was not cut by hand — Chinese '
                    'has no spaces, so every chunk must be bracketed');
            expect(token.romanization, isNotNull,
                reason: '${story.id}: "${token.text}" has no pinyin');
          }
        }
      }
    });

    test('comprehension answers point at a real option', () {
      for (final list in stories.values) {
        for (final story in list) {
          for (final question in story.questions) {
            expect(question.options.length, greaterThanOrEqualTo(2));
            expect(question.answerIndex, greaterThanOrEqualTo(0));
            expect(question.answerIndex, lessThan(question.options.length),
                reason: '${story.id}: answerIndex out of range');
            expect(question.options.toSet().length, question.options.length,
                reason: '${story.id}: duplicate options make the quiz unfair');
          }
        }
      }
    });

    test('reading time is honest and non-zero', () {
      for (final list in stories.values) {
        for (final story in list) {
          expect(story.wordCount, greaterThan(20));
          expect(story.minutes, greaterThanOrEqualTo(1));
        }
      }
    });

    test('storyById finds a story and returns null for an unknown id', () {
      expect(storyById('zh-story-shichang')?.languageCode, 'zh');
      expect(storyById('nope'), isNull);
    });

    test('every core language got a new everyday-situation story in this '
        'pass, distinct from what already existed', () {
      const newStoryIds = {
        'en': 'en-story-doctor',
        'es': 'es-story-direcciones',
        'zh': 'zh-story-kanfangzi',
        'ja': 'ja-story-michiannai',
      };
      newStoryIds.forEach((code, id) {
        final story = storyById(id);
        expect(story, isNotNull, reason: 'missing new story $id for $code');
        expect(story!.languageCode, code);
        expect(story.lines.length, greaterThanOrEqualTo(8),
            reason: '$id is too short to match the existing stories');
        expect(story.questions.length, greaterThanOrEqualTo(2),
            reason: '$id needs comprehension questions like its siblings');
      });
    });
  });
}
