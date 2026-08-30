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

  group('language speech profiles', () {
    test('Mandarin is meaningfully slower than English by default', () {
      final zh = speechProfileFor('zh-CN');
      final en = speechProfileFor('en-US');
      expect(zh.rate, lessThan(en.rate));
      // Not just slower, but noticeably so - a learner cannot hear tone
      // contours at conversational speed.
      expect(en.rate - zh.rate, greaterThanOrEqualTo(0.1));
    });

    test('Japanese sits between Mandarin and English', () {
      final zh = speechProfileFor('zh-CN');
      final ja = speechProfileFor('ja-JP');
      final en = speechProfileFor('en-US');
      expect(ja.rate, greaterThan(zh.rate));
      expect(ja.rate, lessThan(en.rate));
    });

    test('English and Spanish stay close to natural conversational rate', () {
      final en = speechProfileFor('en-US');
      final es = speechProfileFor('es-ES');
      expect(en.rate, 0.5);
      expect(es.rate, 0.5);
    });

    test('an untuned language falls back to the natural rate', () {
      final profile = speechProfileFor('fr-FR');
      expect(profile.rate, 0.5);
    });

    test('lookup is keyed on the language subtag regardless of region', () {
      expect(speechProfileFor('zh-HK').rate, speechProfileFor('zh-CN').rate);
      expect(speechProfileFor('ZH_TW').rate, speechProfileFor('zh-CN').rate);
    });

    test('cmn (ISO 639-3 Mandarin) gets the same profile as zh', () {
      expect(speechProfileFor('cmn').rate, speechProfileFor('zh').rate);
    });
  });

  group('slow multiplier', () {
    test('slow Mandarin is slower in absolute terms than slow English', () {
      final zh = speechProfileFor('zh');
      final en = speechProfileFor('en');
      final slowZh = zh.rate * zh.slowMultiplier;
      final slowEn = en.rate * en.slowMultiplier;
      expect(slowZh, lessThan(slowEn));
    });

    test('the slow multiplier scales, rather than flattens, each language\'s own baseline', () {
      // Same relative cut applied to every language keeps the gap between
      // languages instead of erasing it - "slow" should not make every
      // language converge on one speed.
      final zh = speechProfileFor('zh');
      final en = speechProfileFor('en');
      expect(zh.slowMultiplier, en.slowMultiplier);
      expect(zh.rate * zh.slowMultiplier, lessThan(en.rate));
    });
  });

  group('platform rate', () {
    test('iOS rate is scaled down relative to the base rate', () {
      const profile = LanguageSpeechProfile(rate: 0.5);
      expect(profile.platformRate(isIOS: true), lessThan(profile.platformRate(isIOS: false)));
    });

    test('non-iOS uses the rate as configured', () {
      const profile = LanguageSpeechProfile(rate: 0.42);
      expect(profile.platformRate(isIOS: false), 0.42);
    });
  });

  group('voice selection', () {
    test('prefers a higher-quality voice for the same locale', () {
      final voices = [
        const VoiceInfo(name: 'zh-CN-standard', locale: 'zh-CN', quality: 100),
        const VoiceInfo(name: 'zh-CN-enhanced', locale: 'zh-CN', quality: 400),
      ];
      final best = selectBestVoice('zh-CN', voices);
      expect(best?.name, 'zh-CN-enhanced');
    });

    test('falls back to a voice with no quality metadata when nothing else scores higher', () {
      final voices = [const VoiceInfo(name: 'en-US-default', locale: 'en-US')];
      final best = selectBestVoice('en-US', voices);
      expect(best?.name, 'en-US-default');
    });

    test('an unscored voice loses to a scored one for the same locale', () {
      final voices = [
        const VoiceInfo(name: 'en-US-plain', locale: 'en-US'),
        const VoiceInfo(name: 'en-US-premium', locale: 'en-US', quality: 400),
      ];
      final best = selectBestVoice('en-US', voices);
      expect(best?.name, 'en-US-premium');
    });

    test('ignores voices for an unrelated locale', () {
      final voices = [
        const VoiceInfo(name: 'fr-FR-voice', locale: 'fr-FR', quality: 500),
        const VoiceInfo(name: 'en-US-voice', locale: 'en-US', quality: 100),
      ];
      final best = selectBestVoice('en-US', voices);
      expect(best?.name, 'en-US-voice');
    });

    test('a regional match still counts, mirroring locale-matching rules', () {
      final voices = [const VoiceInfo(name: 'es-mx-voice', locale: 'es-MX', quality: 300)];
      final best = selectBestVoice('es-ES', voices);
      expect(best?.name, 'es-mx-voice');
    });

    test('returns null when no voice matches the requested locale', () {
      final voices = [const VoiceInfo(name: 'fr-FR-voice', locale: 'fr-FR', quality: 500)];
      expect(selectBestVoice('zh-CN', voices), isNull);
    });

    test('an empty voice list matches nothing', () {
      expect(selectBestVoice('en-US', const []), isNull);
    });

    test('a string quality hint like "enhanced" outscores "default"', () {
      final enhanced = VoiceInfo.fromMap({'name': 'v1', 'locale': 'en-US', 'quality': 'enhanced'});
      final basic = VoiceInfo.fromMap({'name': 'v2', 'locale': 'en-US', 'quality': 'default'});
      expect(enhanced.quality, greaterThan(basic.quality!));
    });

    test('a premium hint embedded in the voice identifier is picked up', () {
      final voice = VoiceInfo.fromMap({
        'name': 'com.apple.voice.premium.en-US.Ava',
        'locale': 'en-US',
      });
      expect(voice.quality, isNotNull);
    });

    test('no quality metadata at all yields a null score, not a guess', () {
      final voice = VoiceInfo.fromMap({'name': 'plain-voice', 'locale': 'en-US'});
      expect(voice.quality, isNull);
    });
  });
}
