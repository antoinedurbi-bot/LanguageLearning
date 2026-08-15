import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/services/tts_service.dart';

void main() {
  group('voice matching', () {
    test('an exact locale matches', () {
      expect(TtsService.matches('es-ES', ['es-ES', 'en-US']), isTrue);
    });

    test('a different region of the same language still counts', () {
      // A Mexican Spanish voice pronounces the course perfectly well.
      expect(TtsService.matches('es-ES', ['es-MX']), isTrue);
      expect(TtsService.matches('zh-CN', ['zh-HK']), isTrue);
    });

    test('underscores and case do not matter', () {
      expect(TtsService.matches('zh-CN', ['ZH_CN']), isTrue);
      expect(TtsService.matches('tr-TR', ['tr_tr']), isTrue);
    });

    test('a bare language tag matches a regional request', () {
      expect(TtsService.matches('en-US', ['en']), isTrue);
    });

    test('Mandarin tagged by its ISO 639-3 code is recognised', () {
      // Some engines report Mandarin as cmn-Hans-CN rather than zh-CN.
      expect(TtsService.matches('zh-CN', ['cmn-Hans-CN']), isTrue);
      expect(TtsService.matches('cmn', ['zh-CN']), isTrue);
    });

    test('an unrelated language does not match', () {
      expect(TtsService.matches('zh-CN', ['en-US', 'es-ES', 'fr-FR']), isFalse);
    });

    test('an empty engine list matches nothing', () {
      expect(TtsService.matches('en-US', const []), isFalse);
    });

    test('a language is not matched by a mere prefix collision', () {
      // 'es' must not be satisfied by 'et' (Estonian) or 'eu' (Basque).
      expect(TtsService.matches('es-ES', ['et-EE', 'eu-ES']), isFalse);
    });
  });
}
