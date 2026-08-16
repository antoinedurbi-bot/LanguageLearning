import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/data/models/entitlement.dart';
import 'package:learning_app/features/language/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PromoCode', () {
    test('accepts the known code', () {
      expect(PromoCode.isValid('ThomasLeBGetYarabe'), isTrue);
    });

    test('trims surrounding whitespace', () {
      expect(PromoCode.isValid('  ThomasLeBGetYarabe  '), isTrue);
    });

    test('is case sensitive', () {
      expect(PromoCode.isValid('thomaslebgetyarabe'), isFalse);
    });

    test('rejects anything else', () {
      expect(PromoCode.isValid(''), isFalse);
      expect(PromoCode.isValid('let me in'), isFalse);
    });
  });

  group('LearningController entitlement', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('a fresh account can pick any language first', () async {
      final controller = LearningController();
      await controller.bootstrap();

      for (final language in availableLanguages) {
        expect(controller.canSelectLanguage(language.code), isTrue);
      }
    });

    test('picking a language locks free accounts to it', () async {
      final controller = LearningController();
      await controller.bootstrap();

      final first = availableLanguages.first;
      final ok = await controller.selectLanguage(first);
      expect(ok, isTrue);
      expect(controller.freeLanguageCode, first.code);
      expect(controller.canSelectLanguage(first.code), isTrue);

      final other = availableLanguages
          .firstWhere((l) => l.code != first.code);
      expect(controller.canSelectLanguage(other.code), isFalse);
    });

    test('switching to a locked language is refused and changes nothing', () async {
      final controller = LearningController();
      await controller.bootstrap();

      final first = availableLanguages.first;
      final other = availableLanguages
          .firstWhere((l) => l.code != first.code);
      await controller.selectLanguage(first);

      final switched = await controller.selectLanguage(other);
      expect(switched, isFalse);
      expect(controller.language?.code, first.code);
    });

    test('an invalid code does not unlock premium', () async {
      final controller = LearningController();
      await controller.bootstrap();

      await controller.unlockPremium('nope');
      expect(controller.isPremium, isFalse);
    });

    test('the promo code unlocks premium and lifts the language limit',
        () async {
      final controller = LearningController();
      await controller.bootstrap();

      final first = availableLanguages.first;
      final other = availableLanguages
          .firstWhere((l) => l.code != first.code);
      await controller.selectLanguage(first);
      expect(controller.canSelectLanguage(other.code), isFalse);

      await controller.unlockPremium('ThomasLeBGetYarabe');
      expect(controller.isPremium, isTrue);
      expect(controller.canSelectLanguage(other.code), isTrue);

      final switched = await controller.selectLanguage(other);
      expect(switched, isTrue);
      expect(controller.language?.code, other.code);
    });

    test('premium status survives a fresh bootstrap from storage', () async {
      final first = LearningController();
      await first.bootstrap();
      await first.unlockPremium('ThomasLeBGetYarabe');

      final second = LearningController();
      await second.bootstrap();
      expect(second.isPremium, isTrue);
    });

    test('the free language choice survives a fresh bootstrap', () async {
      final first = LearningController();
      await first.bootstrap();
      final language = availableLanguages.first;
      await first.selectLanguage(language);

      final second = LearningController();
      await second.bootstrap();
      expect(second.freeLanguageCode, language.code);
    });
  });
}
