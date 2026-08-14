import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/app_theme.dart';
import 'package:learning_app/features/language/app_language.dart';
import 'package:learning_app/features/language/language_picker_screen.dart';
import 'package:learning_app/data/content/vocabularies.dart';
import 'package:learning_app/features/session/session_screen.dart';
import 'package:learning_app/features/vocabulary/vocabulary_screen.dart';
import 'package:learning_app/services/tts_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(Widget child, LearningController controller) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: controller),
      Provider(create: (_) => TtsService()),
    ],
    child: MaterialApp(
      theme: AppTheme.dark,
      // The aurora background animates forever, so pumpAndSettle would never
      // return. Asserting reduced motion here doubles as a check that the
      // accessibility path actually stops the tickers.
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: child,
      ),
    ),
  );
}

void main() {
  setUp(() {
    // The repository writes through SharedPreferences; the in-memory mock
    // keeps each test isolated.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('the picker offers every language and selects one',
      (tester) async {
    final controller = LearningController();
    await controller.bootstrap();

    await tester.pumpWidget(_wrap(const LanguagePickerScreen(), controller));
    await tester.pump();

    for (final language in availableLanguages) {
      expect(find.text(language.name), findsOneWidget);
    }

    await tester.tap(find.text('Espagnol'));
    await tester.pumpAndSettle();

    expect(controller.language?.code, 'es');
    expect(controller.progress, isNotNull);
  });

  testWidgets('a session presents a card and records the answer',
      (tester) async {
    // A phone-sized surface: on the default 800x600 test view an option can
    // sit under the sticky footer and the tap silently misses.
    tester.view.physicalSize = const Size(860, 1864);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final controller = LearningController();
    await controller.bootstrap();
    await controller.selectLanguage(availableLanguages.first);

    final items = controller.buildSession(maxItems: 3, seed: 42);
    expect(items, isNotEmpty);

    await tester.pumpWidget(_wrap(SessionScreen(items: items), controller));
    await tester.pumpAndSettle();

    // A fresh learner starts on recognition items: the target sentence and
    // four possible meanings.
    expect(find.text('Verifier'), findsOneWidget);
    expect(find.text(items.first.card.target), findsOneWidget);

    // Answering correctly reveals the explanation and the grading buttons.
    await tester.tap(find.text(items.first.card.native).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verifier'));
    await tester.pumpAndSettle();

    expect(find.text('Correct'), findsWidgets);
    expect(find.text('Facile'), findsOneWidget);

    await tester.tap(find.text('Facile'));
    await tester.pumpAndSettle();

    expect(controller.progress!.totalReviews, 1);
    expect(controller.progress!.states[items.first.card.id], isNotNull);
    expect(controller.progress!.streak, 1);
  });

  testWidgets('an empty queue lands on the summary rather than a blank screen',
      (tester) async {
    final controller = LearningController();
    await controller.bootstrap();
    await controller.selectLanguage(availableLanguages.first);

    await tester.pumpWidget(
      _wrap(const SessionScreen(items: []), controller),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rien a reviser'), findsOneWidget);
    expect(find.text('Terminer'), findsOneWidget);
  });

  testWidgets('the summary reports the session score inside the ring',
      (tester) async {
    // A phone-sized surface: on the default 800x600 test view the last option
    // sits under the sticky footer and cannot be tapped.
    tester.view.physicalSize = const Size(860, 1864);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final controller = LearningController();
    await controller.bootstrap();
    await controller.selectLanguage(availableLanguages.first);

    final items = controller.buildSession(maxItems: 1, seed: 7);
    expect(items.length, 1);

    await tester.pumpWidget(_wrap(SessionScreen(items: items), controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text(items.first.card.native).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verifier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Facile'));
    await tester.pumpAndSettle();

    expect(find.text('Session terminee'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('de reussite'), findsOneWidget);
    expect(find.text('1 / 1'), findsOneWidget);
  });

  testWidgets('tapping a vocabulary word explains it and can save it',
      (tester) async {
    tester.view.physicalSize = const Size(860, 1864);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final controller = LearningController();
    await controller.bootstrap();
    await controller.selectLanguage(
      availableLanguages.firstWhere((l) => l.code == 'es'),
    );

    final pack = vocabularyFor('es')!;
    final entry = pack.allEntries.first;

    await tester.pumpWidget(_wrap(
      VocabularyScreen(pack: pack, ttsLocale: 'es-ES'),
      controller,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text(entry.target).first);
    await tester.pumpAndSettle();

    // The sheet always shows the usage note: that is the whole point of
    // making the row tappable.
    expect(find.text(entry.note), findsOneWidget);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(controller.isSaved(entry.id), isTrue);
  });
}
