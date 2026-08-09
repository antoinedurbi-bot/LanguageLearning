import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Speaks target-language sentences through the platform speech engine.
///
/// Audio is not decoration here: a learner who only ever reads a language
/// builds a private pronunciation for every word and then cannot understand
/// native speech. Every card can be played, and listening exercises depend on
/// it. If no voice is installed for a locale the call degrades to a no-op
/// rather than throwing — the exercise stays usable, just silent.
class TtsService {
  TtsService();

  final FlutterTts _tts = FlutterTts();
  String? _configuredLocale;
  bool _available = true;

  bool get available => _available;

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
      _available = true;
    } catch (error) {
      debugPrint('TTS unavailable for $locale: $error');
      _available = false;
    }
  }

  // flutter_tts uses different rate scales per platform; 0.5 is roughly
  // natural on Android/web, while iOS treats 0.5 as very fast.
  static double get _defaultRate =>
      defaultTargetPlatform == TargetPlatform.iOS ? 0.45 : 0.5;

  Future<void> speak(String text, String locale, {bool slow = false}) async {
    if (text.trim().isEmpty) return;
    await _configure(locale);
    if (!_available) return;
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
