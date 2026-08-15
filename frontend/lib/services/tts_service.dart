import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Whether the device can actually pronounce a given language.
enum VoiceStatus {
  /// A matching voice exists.
  ready,

  /// The engine works but has no voice for this language. Playback would be
  /// silent or, worse, read the text with the wrong accent.
  missing,

  /// The engine could not be questioned. Never claim a problem we cannot see.
  unknown,
}

/// Speaks target-language sentences through the platform speech engine.
///
/// Audio is not decoration here: a learner who only ever reads a language
/// builds a private pronunciation for every word and then cannot understand
/// native speech.
///
/// The engine is the operating system's, not ours — on the web it is whatever
/// voices the browser exposes. A missing voice used to make every play button
/// do nothing at all, with no way for the learner to find out why. The service
/// now reports that state instead of failing silently.
class TtsService {
  TtsService();

  final FlutterTts _tts = FlutterTts();
  String? _configuredLocale;
  List<String>? _locales;

  /// Locales the engine says it can speak, lowercased and normalised.
  ///
  /// Cached: enumerating voices is slow on some platforms and the answer does
  /// not change while the app is running.
  Future<List<String>?> availableLocales() async {
    if (_locales != null) return _locales;
    try {
      final raw = await _tts.getLanguages;
      if (raw is! List) return null;
      _locales = [
        for (final entry in raw) entry.toString().toLowerCase().replaceAll('_', '-'),
      ];
      return _locales;
    } catch (error) {
      debugPrint('TTS could not list languages: $error');
      return null;
    }
  }

  /// Whether [locale] can be pronounced on this device.
  Future<VoiceStatus> voiceStatus(String locale) async {
    final locales = await availableLocales();
    if (locales == null || locales.isEmpty) return VoiceStatus.unknown;
    return matches(locale, locales) ? VoiceStatus.ready : VoiceStatus.missing;
  }

  /// Matches a requested locale against what the engine offers.
  ///
  /// Comparison is on the language subtag: a learner asking for `zh-CN` is
  /// served perfectly well by a `zh-HK`-tagged Mandarin voice, and engines
  /// label Chinese inconsistently (`zh`, `zh-CN`, `cmn-Hans-CN`). Requiring an
  /// exact match would report a missing voice on devices that have one.
  @visibleForTesting
  static bool matches(String requested, List<String> available) {
    final wanted = requested.toLowerCase().replaceAll('_', '-');
    final subtag = wanted.split('-').first;
    for (final entry in available) {
      final candidate = entry.toLowerCase().replaceAll('_', '-');
      if (candidate == wanted) return true;
      if (candidate.split('-').first == subtag) return true;
      // Mandarin is sometimes tagged by its ISO 639-3 code rather than 'zh'.
      if (subtag == 'zh' && candidate.startsWith('cmn')) return true;
      if (subtag == 'cmn' && candidate.startsWith('zh')) return true;
    }
    return false;
  }

  Future<void> _configure(String locale) async {
    if (_configuredLocale == locale) return;
    try {
      await _tts.setLanguage(locale);
      // Slightly under natural pace: fast enough to sound real, slow enough
      // to be parsed by someone who has heard the language for a week.
      await _tts.setSpeechRate(_defaultRate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      _configuredLocale = locale;
    } catch (error) {
      debugPrint('TTS could not select $locale: $error');
    }
  }

  // flutter_tts uses different rate scales per platform; 0.5 is roughly
  // natural on Android/web, while iOS treats 0.5 as very fast.
  static double get _defaultRate =>
      defaultTargetPlatform == TargetPlatform.iOS ? 0.45 : 0.5;

  Future<void> speak(String text, String locale, {bool slow = false}) async {
    if (text.trim().isEmpty) return;
    await _configure(locale);
    try {
      await _tts.stop();
      await _tts.setSpeechRate(slow ? _defaultRate * 0.6 : _defaultRate);
      await _tts.speak(text);
    } catch (error) {
      debugPrint('TTS speak failed: $error');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Stopping a stopped engine is not an error worth surfacing.
    }
  }
}
