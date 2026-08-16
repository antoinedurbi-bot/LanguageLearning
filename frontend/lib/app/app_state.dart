import 'package:flutter/material.dart';
import 'package:learning_app/data/content/courses.dart';
import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/entitlement.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:learning_app/data/repository/collection_repository.dart';
import 'package:learning_app/data/repository/progress_repository.dart';
import 'package:learning_app/data/srs/scheduler.dart';
import 'package:learning_app/data/srs/session.dart';
import 'package:learning_app/features/language/app_language.dart';

/// Whether Firebase initialised successfully. When false the app runs fully
/// locally — every feature still works, progress simply is not backed up.
class AppState {
  static bool firebaseReady = false;
}

/// The single source of truth for the learner's session and progress.
class LearningController extends ChangeNotifier {
  LearningController({
    ProgressRepository? repository,
    SettingsRepository? settings,
    CollectionRepository? collections,
    this.scheduler = const Scheduler(),
  })  : _repository = repository ?? ProgressRepository(),
        _settings = settings ?? SettingsRepository(),
        _collections = collections ?? CollectionRepository();

  final ProgressRepository _repository;
  final SettingsRepository _settings;
  final CollectionRepository _collections;
  final Scheduler scheduler;
  final SessionBuilder _builder = const SessionBuilder();

  bool _ready = false;
  AppLanguage? _language;
  LanguageProgress? _progress;
  LanguageCollection? _collection;
  ThemeMode _themeMode = ThemeMode.dark;
  bool _soundEnabled = true;
  bool _isPremium = false;
  String? _freeLanguageCode;

  bool get ready => _ready;
  AppLanguage? get language => _language;
  LanguageProgress? get progress => _progress;
  LanguageCollection? get collection => _collection;
  ThemeMode get themeMode => _themeMode;
  bool get soundEnabled => _soundEnabled;
  bool get isPremium => _isPremium;

  /// The language a free account is allowed to study — the first one ever
  /// picked. Null until a language has been chosen at least once.
  String? get freeLanguageCode => _freeLanguageCode;

  /// Whether the current account can study [code] right now.
  bool canSelectLanguage(String code) =>
      _isPremium || _freeLanguageCode == null || _freeLanguageCode == code;

  Course? get course => _language == null ? null : courseFor(_language!.code);

  /// Restores the selected language, its progress, and display preferences.
  Future<void> bootstrap() async {
    final mode = await _settings.themeMode();
    _themeMode = switch (mode) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
    _soundEnabled = await _settings.soundEnabled();
    _isPremium = await _settings.premiumUnlocked();
    _freeLanguageCode = await _settings.freeLanguageCode();

    final code = await _settings.selectedLanguage();
    final language = languageFor(code);
    if (language != null) {
      _language = language;
      _progress = await _repository.load(language.code);
      _collection = await _collections.load(language.code);
    }

    _ready = true;
    notifyListeners();
  }

  /// Switches the active language. Returns false without changing anything
  /// if a free account tries to switch away from its one allowed language —
  /// the UI is expected to check [canSelectLanguage] before offering the
  /// option at all, so this is the defensive second check, not the primary
  /// gate.
  Future<bool> selectLanguage(AppLanguage language) async {
    if (!canSelectLanguage(language.code)) return false;

    _language = language;
    _progress = null;
    _collection = null;
    notifyListeners();

    await _settings.setSelectedLanguage(language.code);
    _progress = await _repository.load(language.code);
    _collection = await _collections.load(language.code);

    if (_freeLanguageCode == null) {
      _freeLanguageCode = language.code;
      await _settings.setFreeLanguageCode(language.code);
    }

    notifyListeners();
    return true;
  }

  Future<void> unlockPremium(String code) async {
    if (!PromoCode.isValid(code)) return;
    _isPremium = true;
    notifyListeners();
    await _settings.setPremiumUnlocked(true);
  }

  Future<void> clearLanguage() async {
    _language = null;
    _progress = null;
    _collection = null;
    await _settings.setSelectedLanguage(null);
    notifyListeners();
  }

  // ----------------------------------------------------------- collection

  bool isSaved(String id) => _collection?.contains(id) ?? false;

  /// Adds an item, or removes it if it was already saved. Returns the state
  /// the item ended up in, so the caller can confirm it to the learner.
  Future<bool> toggleSaved(SavedItem item) async {
    final collection = _collection;
    if (collection == null) return false;

    final nowSaved = !collection.saved.containsKey(item.id);
    if (nowSaved) {
      collection.saved[item.id] = item;
    } else {
      collection.saved.remove(item.id);
    }

    notifyListeners();
    await _collections.save(collection);
    return nowSaved;
  }

  Future<void> setIslandAnswer(
    String islandId,
    String promptId,
    String answer,
  ) async {
    final collection = _collection;
    if (collection == null) return;

    final key = '\$islandId/\$promptId';
    if (answer.trim().isEmpty) {
      collection.islandAnswers.remove(key);
    } else {
      collection.islandAnswers[key] = answer;
    }

    notifyListeners();
    await _collections.save(collection);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _settings.setThemeMode(switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
    });
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    notifyListeners();
    await _settings.setSoundEnabled(value);
  }

  Future<void> setDailyGoal(int goal) async {
    final progress = _progress;
    if (progress == null) return;
    progress.dailyGoal = goal.clamp(5, 100);
    notifyListeners();
    await _repository.save(progress);
  }

  // ------------------------------------------------------------- queries

  int get dueCount {
    final course = this.course;
    final progress = _progress;
    if (course == null || progress == null) return 0;
    return _builder.dueCards(course, progress, DateTime.now()).length;
  }

  int get newCount {
    final course = this.course;
    final progress = _progress;
    if (course == null || progress == null) return 0;
    return _builder.newCards(course, progress).length;
  }

  /// Cards in this unit that the learner has met at least once.
  int startedInUnit(Unit unit) {
    final progress = _progress;
    if (progress == null) return 0;
    return unit.cards.where((c) => progress.states.containsKey(c.id)).length;
  }

  /// Cards in this unit consolidated past the three-week mark.
  int masteredInUnit(Unit unit) {
    final progress = _progress;
    if (progress == null) return 0;
    return unit.cards
        .where((c) => (progress.states[c.id]?.stability ?? 0) >= 21)
        .length;
  }

  /// A unit opens once the previous one is at least half started, so the
  /// learner is never dropped into material built on things they have not met.
  bool isUnitUnlocked(Course course, int index) {
    if (index == 0) return true;
    final previous = course.units[index - 1];
    return startedInUnit(previous) >= (previous.cards.length / 2).ceil();
  }

  List<SessionItem> buildSession({int maxItems = 20, int? seed}) {
    final course = this.course;
    final progress = _progress;
    if (course == null || progress == null) return const [];
    return _builder.build(
      course: course,
      progress: progress,
      now: DateTime.now(),
      maxItems: maxItems,
      seed: seed,
    );
  }

  /// A session restricted to one unit, for deliberate practice of a theme.
  List<SessionItem> buildUnitSession(Unit unit, {int maxItems = 12}) {
    final progress = _progress;
    if (progress == null) return const [];
    final now = DateTime.now();

    final items = [
      for (final card in unit.cards)
        SessionItem(
          card: card,
          mode: ExerciseMode.recognize,
          state: progress.states[card.id] ?? MemoryState.fresh(now),
          isNew: !progress.states.containsKey(card.id),
        ),
    ];
    return items.take(maxItems).toList();
  }

  // ------------------------------------------------------------- mutation

  /// Applies a grade to a card and persists the result.
  Future<void> grade(CardItem card, Grade grade) async {
    final progress = _progress;
    if (progress == null) return;

    final now = DateTime.now();
    final current = progress.states[card.id] ?? MemoryState.fresh(now);
    progress.states[card.id] = scheduler.review(current, grade, now);
    progress.registerReview(correct: grade != Grade.again, now: now);

    notifyListeners();
    await _repository.save(progress);
  }

  /// Wipes review progress for the current language.
  ///
  /// The saved collection is deliberately left alone: it is material the
  /// learner chose and wrote, not a schedule the app generated.
  Future<void> resetProgress() async {
    final language = _language;
    if (language == null) return;
    await _repository.clear(language.code);
    _progress = LanguageProgress(languageCode: language.code);
    notifyListeners();
    await _repository.save(_progress!);
  }
}
