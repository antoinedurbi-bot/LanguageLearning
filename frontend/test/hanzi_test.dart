import 'dart:io';
import 'dart:ui' show Offset, Rect;

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/hanzi/hanzi.dart';
import 'package:learning_app/data/hanzi/pinyin.dart';
import 'package:learning_app/data/hanzi/stroke_scoring.dart';
import 'package:learning_app/data/hanzi/svg_path.dart';

/// Reads the real generated assets straight from disk. These are shipped
/// files, so testing the parser against fixtures would prove nothing about
/// whether the app can actually render them.
Future<String> _asset(String key) => File(key).readAsString();

void main() {
  group('SVG path parsing', () {
    test('parses the commands the glyph data actually uses', () {
      // M, L, Q, C and Z, all absolute.
      final path = HanziPath.parse(
        'M 100 800 L 200 800 Q 300 800 400 700 C 500 600 600 500 700 400 Z',
        1024,
      );
      final bounds = path.getBounds();

      expect(bounds.isEmpty, isFalse);
      expect(bounds.left, closeTo(100, 0.5));
      expect(bounds.right, closeTo(700, 0.5));
    });

    test('applies the documented y-flip', () {
      // y' = 900 - y, then scaled. At size 1024 the scale is 1.
      final p = HanziPath.point(100, 900, 1024);
      expect(p.dx, closeTo(100, 1e-9));
      expect(p.dy, closeTo(0, 1e-9));

      final q = HanziPath.point(0, 0, 1024);
      expect(q.dy, closeTo(900, 1e-9));
    });

    test('scales to the requested canvas size', () {
      final full = HanziPath.point(512, 450, 1024);
      final half = HanziPath.point(512, 450, 512);
      expect(half.dx, closeTo(full.dx / 2, 1e-9));
      expect(half.dy, closeTo(full.dy / 2, 1e-9));
    });

    test(
        'handles negative coordinates without merging them into the previous number',
        () {
      final path = HanziPath.parse('M -10 20 L 30 -40 Z', 1024);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('an unknown command does not throw or desynchronise', () {
      // 'A' (arc) never appears upstream, but must not corrupt what follows.
      final path = HanziPath.parse('M 0 0 A 1 2 3 4 5 6 7 L 500 500 Z', 1024);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('empty input yields an empty path rather than throwing', () {
      expect(HanziPath.parse('', 1024).getBounds(), Rect.zero);
    });
  });

  group('bundled hanzi asset', () {
    late Map<String, Hanzi> characters;

    setUpAll(() async {
      final repository = HanziRepository(assetBundleLoader: _asset);
      characters = await repository.characters();
    });

    test('covers every character used by the Mandarin course', () async {
      final course =
          await File('lib/data/content/course_zh.dart').readAsString();
      final used =
          RegExp(r'[一-鿿]').allMatches(course).map((m) => m.group(0)!).toSet();

      final missing = used.where((ch) => !characters.containsKey(ch)).toList();
      expect(missing, isEmpty,
          reason: 'course characters with no data: ${missing.join()}');
    });

    test('every character has one median per stroke', () {
      for (final hanzi in characters.values) {
        expect(hanzi.strokes, isNotEmpty, reason: hanzi.character);
        expect(hanzi.medians.length, hanzi.strokes.length,
            reason: hanzi.character);
        expect(hanzi.strokeCount, hanzi.strokes.length,
            reason: hanzi.character);
        expect(hanzi.hasStrokeData, isTrue, reason: hanzi.character);
      }
    });

    test('every stroke parses to a non-empty path', () {
      // The whole feature rests on this: an unparseable stroke is an
      // invisible one.
      for (final hanzi in characters.values) {
        for (var i = 0; i < hanzi.strokes.length; i++) {
          final path = HanziPath.parse(hanzi.strokes[i], 1024);
          expect(path.getBounds().isEmpty, isFalse,
              reason: 'stroke $i of ${hanzi.character} parsed to nothing');
        }
      }
    });

    test('all strokes land inside the drawing box', () {
      for (final hanzi in characters.values) {
        for (final stroke in hanzi.strokes) {
          final b = HanziPath.parse(stroke, 1024).getBounds();
          // A small margin: a few glyphs legitimately touch the edges.
          expect(b.left, greaterThan(-40), reason: hanzi.character);
          expect(b.top, greaterThan(-40), reason: hanzi.character);
          expect(b.right, lessThan(1064), reason: hanzi.character);
          expect(b.bottom, lessThan(1064), reason: hanzi.character);
        }
      }
    });

    test('medians stay inside the box too', () {
      for (final hanzi in characters.values) {
        for (final median in hanzi.medians) {
          expect(median, isNotEmpty, reason: hanzi.character);
          for (final point in median) {
            final p = HanziPath.point(point.dx, point.dy, 1024);
            expect(p.dx, inInclusiveRange(-40, 1064), reason: hanzi.character);
            expect(p.dy, inInclusiveRange(-40, 1064), reason: hanzi.character);
          }
        }
      }
    });

    test('known characters carry the expected metadata', () {
      final ni = characters['你']!;
      expect(ni.strokeCount, 7);
      expect(ni.pinyin, contains('nǐ'));
      expect(ni.radical, '亻');
      expect(ni.decomposition, '⿰亻尔');
      expect(ni.structureLabel, 'gauche-droite');
      expect(ni.components, ['亻', '尔']);
      expect(ni.hskLevel, 1);

      // 一 is the simplest possible case: one stroke.
      expect(characters['一']!.strokeCount, 1);
    });

    test('decomposition placeholders are not shown as components', () {
      for (final hanzi in characters.values) {
        expect(hanzi.components, isNot(contains('？')), reason: hanzi.character);
      }
    });
  });

  group('search', () {
    late HanziRepository repository;

    setUp(() => repository = HanziRepository(assetBundleLoader: _asset));

    test('finds a character by its pinyin without tone marks', () async {
      final results = await repository.search('ni');
      expect(results.characters.map((h) => h.character), contains('你'));
    });

    test('finds a character by the character itself', () async {
      final results = await repository.search('好');
      expect(results.characters.map((h) => h.character), contains('好'));
    });

    test('finds words by pinyin typed without spaces or tones', () async {
      // HSK 3.0 lists 你们 as a word (你好 it splits into 你 and 好), so this
      // is a genuine multi-syllable entry to match against.
      final results = await repository.search('nimen');
      expect(results.words.map((w) => w.word), contains('你们'));
    });

    test('an empty query returns nothing rather than everything', () async {
      expect((await repository.search('   ')).isEmpty, isTrue);
    });

    test('stripTones normalises every pinyin vowel', () {
      expect(HanziRepository.stripTones('nǐ hǎo'), 'ni hao');
      expect(HanziRepository.stripTones('lǜsè'), 'lvse');
      expect(HanziRepository.stripTones('zhōngguó'), 'zhongguo');
    });
  });

  group('HSK words asset', () {
    test('loads and is sorted by level', () async {
      final repository = HanziRepository(assetBundleLoader: _asset);
      final words = await repository.words();

      expect(words.length, greaterThan(1000));
      expect(words.first.level, 1);
      expect(words.last.level, 2);
      for (final word in words) {
        expect(word.word, isNotEmpty);
        expect(word.pinyin, isNotEmpty);
        expect(word.level, inInclusiveRange(1, 2));
      }
    });
  });

  group('stroke scoring', () {
    const scorer = StrokeScorer();
    const box = 300.0;

    List<Offset> line(Offset from, Offset to, {int points = 24}) => [
          for (var i = 0; i < points; i++)
            Offset.lerp(from, to, i / (points - 1))!,
        ];

    test('accepts a trace that follows the model', () {
      final model = line(const Offset(50, 150), const Offset(250, 150));
      final result = scorer.score(drawn: model, model: model, boxSize: box);

      expect(result.accepted, isTrue);
      expect(result.meanDeviation, closeTo(0, 1e-6));
    });

    test('tolerates a wobbly but recognisable trace', () {
      final model = line(const Offset(50, 150), const Offset(250, 150));
      final wobbly = [
        for (var i = 0; i < model.length; i++)
          model[i] + Offset(0, i.isEven ? 6 : -6),
      ];

      expect(scorer.score(drawn: wobbly, model: model, boxSize: box).accepted,
          isTrue);
    });

    test('rejects a stroke in the wrong place', () {
      final model = line(const Offset(50, 60), const Offset(250, 60));
      final elsewhere = line(const Offset(50, 240), const Offset(250, 240));

      final result = scorer.score(drawn: elsewhere, model: model, boxSize: box);
      expect(result.accepted, isFalse);
      expect(result.reversed, isFalse);
    });

    test('rejects the right shape drawn backwards, and says so', () {
      final model = line(const Offset(50, 150), const Offset(250, 150));
      final backwards = model.reversed.toList();

      final result = scorer.score(drawn: backwards, model: model, boxSize: box);
      expect(result.accepted, isFalse);
      expect(result.reversed, isTrue);
    });

    test('rejects a tap as too short', () {
      final model = line(const Offset(50, 150), const Offset(250, 150));
      final tap = [const Offset(150, 150), const Offset(151, 150)];

      final result = scorer.score(drawn: tap, model: model, boxSize: box);
      expect(result.accepted, isFalse);
      expect(result.tooShort, isTrue);
    });

    test('a short dot stroke can still be traced', () {
      // 丶 is only a few percent of the box; the threshold must scale to the
      // model stroke or dots would be impossible to write.
      final model = line(const Offset(150, 150), const Offset(162, 162));
      final result = scorer.score(drawn: model, model: model, boxSize: box);

      expect(result.tooShort, isFalse);
      expect(result.accepted, isTrue);
    });

    test('handles degenerate input without throwing', () {
      expect(
        scorer.score(drawn: const [], model: const [], boxSize: box).accepted,
        isFalse,
      );
      expect(
        scorer.score(
          drawn: [const Offset(1, 1)],
          model: [const Offset(1, 1)],
          boxSize: 0,
        ).accepted,
        isFalse,
      );
    });

    test('scores a real stroke traced along its own median', () async {
      final repository = HanziRepository(assetBundleLoader: _asset);
      final ni = (await repository.characters())['你']!;

      for (var i = 0; i < ni.medians.length; i++) {
        final model = [
          for (final p in ni.medians[i]) HanziPath.point(p.dx, p.dy, box),
        ];
        final result = scorer.score(drawn: model, model: model, boxSize: box);
        expect(result.accepted, isTrue, reason: 'stroke $i of 你');
      }
    });
  });

  group('pinyin asset', () {
    late PinyinData data;

    setUpAll(() async {
      data = await PinyinRepository(assetBundleLoader: _asset).load();
    });

    test('every tone example is a real single syllable with a real tone', () {
      expect(data.toneExamples, isNotEmpty);
      for (final example in data.toneExamples) {
        expect(example.tone, inInclusiveRange(1, 4),
            reason: '${example.word} has no tone');
        expect(example.word.length, 1, reason: example.word);
        expect(example.syllable, isNotEmpty);
        // The stored syllable is the toneless spelling (nü), while search
        // folds ü to v for keyboards; normalising both is what must agree.
        expect(
          HanziRepository.stripTones(example.pinyin),
          HanziRepository.stripTones(example.syllable),
          reason: example.pinyin,
        );
        expect(example.syllable,
            isNot(matches(RegExp(r'[āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ]'))),
            reason: '${example.syllable} still carries a tone mark');
      }
    });

    test('all four tones have examples to drill', () {
      for (var tone = 1; tone <= 4; tone++) {
        expect(data.examplesForTone(tone), isNotEmpty, reason: 'tone $tone');
      }
    });

    test('covers all 20 tone-pair combinations', () {
      // 4 starting tones x (4 tones + neutral) is the full set a learner
      // has to be able to hear.
      expect(data.tonePairs.length, 20);
      for (final key in PinyinData.pairOrder) {
        expect(data.tonePairs[key], isNotEmpty, reason: 'missing pair $key');
      }
    });

    test('tone pairs never start on a neutral tone', () {
      // A neutral tone cannot begin a word; a leading 0 means the upstream
      // transcription lost a mark.
      for (final entry in data.tonePairs.entries) {
        for (final example in entry.value) {
          expect(example.first, inInclusiveRange(1, 4),
              reason: '${example.word} (${entry.key})');
          expect(example.second, inInclusiveRange(0, 4));
          expect(example.word.length, 2, reason: example.word);
        }
      }
    });

    test('the chart contains only real Mandarin finals', () {
      const validFinals = {
        'a',
        'o',
        'e',
        'ê',
        'er',
        'ai',
        'ei',
        'ao',
        'ou',
        'an',
        'en',
        'ang',
        'eng',
        'ong',
        'i',
        'ia',
        'ie',
        'iao',
        'iu',
        'ian',
        'in',
        'iang',
        'ing',
        'iong',
        'u',
        'ua',
        'uo',
        'uai',
        'ui',
        'uan',
        'un',
        'uang',
        'ueng',
        'ü',
        'üe',
        'üan',
        'ün',
        'v',
        've',
        'van',
        'vn',
      };

      expect(data.chart, isNotEmpty);
      for (final initial in data.chart.entries) {
        for (final finalPart in initial.value.entries) {
          expect(validFinals, contains(finalPart.key),
              reason: '${initial.key}${finalPart.key} is not a syllable');
          expect(finalPart.value, isNotEmpty);
          for (final tone in finalPart.value) {
            expect(tone, inInclusiveRange(0, 4));
          }
        }
      }
    });

    test('the chart includes the initials a chart is expected to show', () {
      for (final initial in ['b', 'p', 'm', 'zh', 'ch', 'sh', 'j', 'q', 'x']) {
        expect(data.chart.containsKey(initial), isTrue, reason: initial);
      }
    });
  });

  group('tone mark placement', () {
    test('marks a, e and o before any other vowel', () {
      expect(SyllableToneMark.apply('hao', 3), 'hǎo');
      expect(SyllableToneMark.apply('bei', 1), 'bēi');
      expect(SyllableToneMark.apply('guo', 2), 'guó');
    });

    test('falls back to the last vowel when there is no a, e or o', () {
      expect(SyllableToneMark.apply('shi', 4), 'shì');
      expect(SyllableToneMark.apply('gui', 1), 'guī');
      expect(SyllableToneMark.apply('nv', 3), 'nǚ');
    });

    test('a neutral tone leaves the syllable untouched', () {
      expect(SyllableToneMark.apply('ma', 0), 'ma');
    });
  });

  group('asset bundling', () {
    test('every generated data file is declared in pubspec', () async {
      // A file generated into assets/data but not bundled fails only at
      // runtime, on the screen that needs it — which is exactly how the
      // pinyin trainer shipped broken once.
      final pubspec = await File('pubspec.yaml').readAsString();
      final declaresDirectory = pubspec.contains('- assets/data/');

      final files = Directory('assets/data')
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .where((name) => name.endsWith('.json'))
          .toList();

      expect(files, isNotEmpty);
      for (final name in files) {
        expect(
          declaresDirectory || pubspec.contains('assets/data/$name'),
          isTrue,
          reason: '$name is generated but never bundled',
        );
      }
    });

    test('all three generated assets exist and parse', () async {
      for (final name in ['hanzi.json', 'hsk_words.json', 'pinyin.json']) {
        final file = File('assets/data/$name');
        expect(file.existsSync(), isTrue, reason: '$name is missing');
        expect(file.lengthSync(), greaterThan(1000),
            reason: '$name looks empty');
      }
    });
  });
}
