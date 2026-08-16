import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/kana/kana.dart';
import 'package:learning_app/data/kana/kanji.dart';

void main() {
  group('kana', () {
    test('base hiragana has exactly the 46 seion characters', () {
      final base = baseKana(KanaScript.hiragana);
      expect(base.length, 46);
      expect(base.map((k) => k.character), contains('あ'));
      expect(base.map((k) => k.character), contains('ん'));
    });

    test('base katakana mirrors base hiragana one-for-one by romaji', () {
      final hira = baseKana(KanaScript.hiragana);
      final kata = baseKana(KanaScript.katakana);
      expect(kata.length, hira.length);
      final hiraRomaji = hira.map((k) => k.romaji).toSet();
      final kataRomaji = kata.map((k) => k.romaji).toSet();
      expect(kataRomaji, hiraRomaji);
    });

    test('every kana has a non-empty romaji and stroke order note', () {
      for (final k in allKana) {
        expect(k.romaji.trim(), isNotEmpty, reason: '${k.character} has no romaji');
        expect(k.strokeOrderNote.trim(), isNotEmpty,
            reason: '${k.character} has no stroke order note');
      }
    });

    test('dakuten entries are flagged and use a voiced row', () {
      final ga = allKana.firstWhere((k) => k.character == 'が');
      expect(ga.isDakuten, isTrue);
      expect(ga.row, 'g');
    });

    test('yoon combinations are flagged as combos, not base kana', () {
      final kya = allKana.firstWhere((k) => k.character == 'きゃ');
      expect(kya.isCombo, isTrue);
      expect(baseKana(KanaScript.hiragana).map((k) => k.character),
          isNot(contains('きゃ')));
    });

    test('no duplicate characters within a script', () {
      for (final script in KanaScript.values) {
        final chars = kanaOf(script).map((k) => k.character).toList();
        expect(chars.toSet().length, chars.length,
            reason: '$script has a duplicate character');
      }
    });
  });

  group('starter kanji', () {
    test('every kanji has at least one reading and a meaning', () {
      for (final k in starterKanji) {
        expect(k.onyomi.isNotEmpty || k.kunyomi.isNotEmpty, isTrue,
            reason: '${k.character} has no reading at all');
        expect(k.meaning.trim(), isNotEmpty);
        expect(k.strokeCount, greaterThan(0));
      }
    });

    test('characters are unique', () {
      final chars = starterKanji.map((k) => k.character).toList();
      expect(chars.toSet().length, chars.length);
    });

    test('kanjiByCharacter finds a known character and returns null for a miss', () {
      expect(kanjiByCharacter('日')?.meaning, contains('jour'));
      expect(kanjiByCharacter('龍'), isNull);
    });

    test('all entries are JLPT N5, the level this starter set targets', () {
      for (final k in starterKanji) {
        expect(k.jlpt, 5);
      }
    });
  });
}
