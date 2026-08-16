import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/chengyu_zh.dart';

void main() {
  group('chengyu pack', () {
    test('is a real, substantial pack rather than a stub', () {
      expect(chengyuZh.length, greaterThanOrEqualTo(20));
    });

    test('ids are unique', () {
      final ids = chengyuZh.map((c) => c.id).toSet();
      expect(ids.length, chengyuZh.length);
    });

    test('every entry is a real four-character idiom', () {
      for (final chengyu in chengyuZh) {
        expect(chengyu.characters.length, 4,
            reason: '${chengyu.id}: ${chengyu.characters}');
        // Every character must be a genuine CJK ideograph, not punctuation
        // or a placeholder slipped in by mistake.
        expect(chengyu.characters, matches(RegExp(r'^[一-鿿]{4}$')),
            reason: chengyu.id);
      }
    });

    test('every field that must never be empty is filled in', () {
      for (final chengyu in chengyuZh) {
        expect(chengyu.pinyin, isNotEmpty, reason: chengyu.id);
        expect(chengyu.literal, isNotEmpty, reason: chengyu.id);
        expect(chengyu.meaning, isNotEmpty, reason: chengyu.id);
        expect(chengyu.story, isNotEmpty, reason: chengyu.id);
        expect(chengyu.usage, isNotEmpty, reason: chengyu.id);
        expect(chengyu.example, isNotEmpty, reason: chengyu.id);
        expect(chengyu.exampleNative, isNotEmpty, reason: chengyu.id);
      }
    });

    test('every example sentence actually contains the idiom', () {
      for (final chengyu in chengyuZh) {
        expect(chengyu.example, contains(chengyu.characters),
            reason: chengyu.id);
      }
    });
  });
}
