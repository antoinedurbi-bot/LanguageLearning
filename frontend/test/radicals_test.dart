import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/data/hanzi/radicals.dart';

/// Reads the real generated asset straight from disk, same rationale as
/// hanzi_test.dart: this is a shipped file, so a fixture would only prove the
/// parser works, not that the app can actually load what it bundles.
Future<String> _asset(String key) => File(key).readAsString();

void main() {
  group('bundled radical asset', () {
    late List<Radical> radicals;

    setUpAll(() async {
      radicals =
          await RadicalRepository(assetBundleLoader: _asset).radicals();
    });

    test('is not empty and covers a real curriculum-sized set', () {
      // The Kangxi set has 214 radicals; this app bundles only the ones its
      // own 615 characters actually use.
      expect(radicals.length, greaterThan(100));
      expect(radicals.length, lessThan(214));
    });

    test('every radical has a pinyin, a meaning and at least one example',
        () {
      for (final radical in radicals) {
        expect(radical.radical, isNotEmpty);
        expect(radical.pinyin, isNotEmpty, reason: radical.radical);
        expect(radical.meaning, isNotEmpty, reason: radical.radical);
        expect(radical.strokeCount, greaterThan(0), reason: radical.radical);
        expect(radical.examples, isNotEmpty, reason: radical.radical);
        expect(radical.characterCount, greaterThanOrEqualTo(radical.examples.length),
            reason: radical.radical);
      }
    });

    test('is sorted by teaching priority: most characters unlocked first',
        () {
      for (var i = 1; i < radicals.length; i++) {
        expect(radicals[i - 1].characterCount,
            greaterThanOrEqualTo(radicals[i].characterCount),
            reason: '${radicals[i - 1].radical} then ${radicals[i].radical}');
      }
    });

    test('every example character exists in the bundled hanzi data and '
        'really uses that radical', () async {
      final characters =
          await HanziRepository(assetBundleLoader: _asset).characters();

      for (final radical in radicals) {
        for (final example in radical.examples) {
          final hanzi = characters[example];
          expect(hanzi, isNotNull,
              reason: '${radical.radical} example $example is not bundled');
          expect(hanzi!.radical, radical.radical,
              reason: '$example is not actually indexed under '
                  '${radical.radical}');
        }
      }
    });

    test('a well-known radical carries the expected data', () {
      // 氵 (water) is one of the most productive radicals in the language and
      // must be present with a sane meaning.
      final water = radicals.firstWhere((r) => r.radical == '氵');
      expect(water.pinyin, 'shuǐ');
      expect(water.meaning.toLowerCase(), contains('eau'));
      expect(water.characterCount, greaterThan(5));
    });

    test('no two radicals share the same glyph', () {
      final seen = <String>{};
      for (final radical in radicals) {
        expect(seen.add(radical.radical), isTrue, reason: radical.radical);
      }
    });
  });
}
