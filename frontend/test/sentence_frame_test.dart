import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/content/frames.dart';
import 'package:learning_app/data/models/sentence_frame.dart';

const _frame = SentenceFrame(
  id: 'test',
  languageCode: 'es',
  label: 'Test',
  why: 'pour tester',
  nativePattern: 'J\'ai besoin {objeto} pour {momento}.',
  parts: [
    FrameText('Necesito '),
    FrameSlot(id: 'objeto', label: 'objet', options: [
      SlotOption(target: 'ayuda', native: 'd\'aide'),
      SlotOption(target: 'un billete', native: 'd\'un billet'),
    ]),
    FrameText(' para '),
    FrameSlot(id: 'momento', label: 'moment', options: [
      SlotOption(target: 'mañana', native: 'demain'),
    ]),
    FrameText('.'),
  ],
);

void main() {
  group('rendering', () {
    test('an empty frame shows blanks, not a broken sentence', () {
      expect(_frame.render(const {}), 'Necesito … para ….');
      expect(_frame.renderNative(const {}), 'J\'ai besoin … pour ….');
    });

    test('a filled frame produces the real sentence in both languages', () {
      const chosen = {'objeto': 0, 'momento': 0};
      expect(_frame.render(chosen), 'Necesito ayuda para mañana.');
      expect(_frame.renderNative(chosen), 'J\'ai besoin d\'aide pour demain.');
    });

    test('a partially filled frame keeps the blanks it still has', () {
      expect(_frame.render(const {'objeto': 1}),
          'Necesito un billete para ….');
    });

    test('an out-of-range choice degrades to a blank rather than crashing', () {
      expect(_frame.render(const {'objeto': 99}), 'Necesito … para ….');
      expect(_frame.render(const {'objeto': -1}), 'Necesito … para ….');
    });

    test('completeness requires every slot', () {
      expect(_frame.isComplete(const {}), isFalse);
      expect(_frame.isComplete(const {'objeto': 0}), isFalse);
      expect(_frame.isComplete(const {'objeto': 0, 'momento': 0}), isTrue);
    });

    test('combinations is the product of the slot sizes', () {
      expect(_frame.combinations, 2);
    });

    test('a frame without romanization returns null for it', () {
      expect(_frame.renderRomanization(const {'objeto': 0, 'momento': 0}),
          isNull);
    });
  });

  group('content', () {
    test('every language ships frames', () {
      for (final code in ['en', 'es', 'zh', 'tr']) {
        expect(framesFor(code), isNotEmpty, reason: '$code has no frames');
      }
    });

    test('frame ids are unique', () {
      final seen = <String>{};
      for (final list in frames.values) {
        for (final frame in list) {
          expect(seen.add(frame.id), isTrue, reason: 'duplicate ${frame.id}');
        }
      }
    });

    test('every slot has at least two real choices', () {
      for (final list in frames.values) {
        for (final frame in list) {
          expect(frame.slots, isNotEmpty,
              reason: '${frame.id} has nothing to substitute');
          for (final slot in frame.slots) {
            expect(slot.options.length, greaterThanOrEqualTo(2),
                reason: '${frame.id}/${slot.id} offers no real choice');
            for (final option in slot.options) {
              expect(option.target.trim(), isNotEmpty);
              expect(option.native.trim(), isNotEmpty);
            }
          }
        }
      }
    });

    test('the French pattern references exactly the frame slots', () {
      // Slot ids may be Chinese (时间, 地方…), which \w does not cover.
      final placeholder = RegExp(r'\{([^{}]+)\}', unicode: true);
      for (final list in frames.values) {
        for (final frame in list) {
          final referenced = placeholder
              .allMatches(frame.nativePattern)
              .map((m) => m.group(1))
              .toSet();
          final declared = frame.slots.map((s) => s.id).toSet();
          expect(referenced, declared,
              reason: '${frame.id}: the French pattern and the slots disagree, '
                  'so the translation would show a stray {placeholder}');
        }
      }
    });

    test('a fully chosen frame leaves no placeholder in the French', () {
      for (final list in frames.values) {
        for (final frame in list) {
          final chosen = {for (final slot in frame.slots) slot.id: 0};
          expect(frame.renderNative(chosen), isNot(contains('{')));
          expect(frame.render(chosen), isNot(contains('…')));
        }
      }
    });

    test('Mandarin frames are fully romanized', () {
      for (final frame in framesFor('zh')) {
        final chosen = {for (final slot in frame.slots) slot.id: 0};
        final roman = frame.renderRomanization(chosen);
        expect(roman, isNotNull, reason: '${frame.id} has no pinyin');
        expect(roman, isNot(contains('…')));
        for (final slot in frame.slots) {
          for (final option in slot.options) {
            expect(option.romanization, isNotNull,
                reason: '${frame.id}: "${option.target}" has no pinyin');
          }
        }
      }
    });

    test('each frame is worth using: at least a dozen sentences', () {
      for (final list in frames.values) {
        for (final frame in list) {
          expect(frame.combinations, greaterThanOrEqualTo(4),
              reason: '${frame.id} barely substitutes anything');
        }
      }
    });
  });
}
