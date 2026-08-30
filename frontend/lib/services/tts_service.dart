import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Per-language speech parameters.
///
/// Every language used to be read with the same rate/pitch, i.e. whatever
/// the OS's default voice happened to sound like. That is wrong: a tonal
/// language like Mandarin needs real breathing room between syllables for a
/// learner to hear the tone contour at all, a pitch-accent language like
/// Japanese benefits from a little extra room but not as much, and slowing
/// down Latin-script languages that a learner can already parse at natural
/// speed only trains them on speech nobody actually uses.
///
/// [rate] and [pitch] are in flutter_tts's own scale (0.0-1.0 for rate on
/// Android/web, pitch centred on 1.0 everywhere). [rateMultiplierIOS] lets a
/// profile correct for the fact that iOS treats the same 0.5 rate as much
/// faster than Android/web do — mirrors the existing `_defaultRate` platform
/// split, just per language instead of a single global value.
@immutable
class LanguageSpeechProfile {
  const LanguageSpeechProfile({
    required this.rate,
    this.pitch = 1.0,
    this.iosRateMultiplier = 0.9,
  });

  /// Base (non-slow) speech rate on Android/web, where 0.5 is roughly
  /// natural conversational pace.
  final double rate;

  /// Voice pitch; 1.0 is the engine's default.
  final double pitch;

  /// Multiplier applied to [rate] on iOS, which reads the same numeric rate
  /// noticeably faster than Android/web.
  final double iosRateMultiplier;

  /// Rate for the current platform.
  double platformRate({bool isIOS = false}) => isIOS ? rate * iosRateMultiplier : rate;

  /// Extra slowdown multiplier applied on top of [rate] when a caller passes
  /// `slow: true` to [TtsService.speak].
  ///
  /// A flat multiplier would make "slow Mandarin" only as slow, in absolute
  /// terms, as "slow English" starting from a faster baseline — but Mandarin
  /// already sounds slower than English at its own default rate, so the same
  /// *relative* slowdown keeps that gap rather than erasing it.
  double get slowMultiplier => 0.6;
}

/// Speech parameters tuned per language, keyed by the ISO 639-1 subtag
/// (`zh`, `ja`, `en`, `es`, `tr`, ...) — the same granularity
/// [TtsService.matches] already uses for locale matching.
///
/// Named, inspectable table instead of magic numbers scattered through
/// `_configure`/`speak`, so the tuning is testable on its own and easy to
/// extend as more languages are added.
const Map<String, LanguageSpeechProfile> languageSpeechProfiles = {
  // Mandarin: tone perception degrades fast for a learner at conversational
  // speed, so the *default* rate is already noticeably slower than English's
  // — not just the `slow` toggle, which stacks an additional cut on top.
  'zh': LanguageSpeechProfile(rate: 0.34, pitch: 1.0),
  'cmn': LanguageSpeechProfile(rate: 0.34, pitch: 1.0),
  // Japanese: pitch-accent cues also get lost too fast, but the syllable
  // structure is simpler for a learner to track than Mandarin's tones, so a
  // moderate rate between Mandarin and Latin-script languages is enough.
  'ja': LanguageSpeechProfile(rate: 0.42, pitch: 1.0),
  // English/Spanish/Turkish: close to natural conversational rate.
  // Over-slowing these actively hurts listening comprehension training,
  // which is the opposite of what the `slow` toggle exists for.
  'en': LanguageSpeechProfile(rate: 0.5, pitch: 1.0),
  'es': LanguageSpeechProfile(rate: 0.5, pitch: 1.0),
  'tr': LanguageSpeechProfile(rate: 0.5, pitch: 1.0),
};

/// Fallback profile for a language with no dedicated entry above.
const LanguageSpeechProfile _fallbackProfile = LanguageSpeechProfile(rate: 0.5, pitch: 1.0);

/// Looks up the speech profile for [locale] by its language subtag, falling
/// back to a natural-rate default for languages not yet tuned.
LanguageSpeechProfile speechProfileFor(String locale) {
  final subtag = locale.toLowerCase().replaceAll('_', '-').split('-').first;
  return languageSpeechProfiles[subtag] ?? _fallbackProfile;
}

/// One voice as reported by `flutter_tts`'s `getVoices`, normalised into a
/// plain, platform-independent shape so the scoring logic can be tested
/// without a real platform channel.
///
/// `flutter_tts` returns a `List<Map>` whose keys vary by platform — Android
/// voices carry `quality` (an int, higher is better) and `network_required`;
/// iOS voices carry `quality` as a string (`"enhanced"`/`"premium"` vs.
/// `"default"`) in some engine versions. [VoiceInfo.fromMap] reads whichever
/// of these are present and ignores what isn't, so a platform with none of
/// this metadata just falls back to score 0 for every voice — i.e. current
/// "first match" behaviour, never a crash or a wrong guess.
@immutable
class VoiceInfo {
  const VoiceInfo({required this.name, required this.locale, this.quality});

  final String name;
  final String locale;

  /// Normalised quality score, higher is better. Null when the platform
  /// exposed no usable quality signal for this voice.
  final int? quality;

  factory VoiceInfo.fromMap(Map<dynamic, dynamic> map) {
    final name = (map['name'] ?? '').toString();
    final locale = (map['locale'] ?? '').toString();
    return VoiceInfo(name: name, locale: locale, quality: _qualityOf(map, name));
  }

  static int? _qualityOf(Map<dynamic, dynamic> map, String name) {
    final raw = map['quality'];
    if (raw is num) {
      // Android's TTS_QUALITY_* constants: higher is better, e.g. 400/500
      // for "very high"/network voices vs. 100 for low quality.
      return raw.round();
    }
    if (raw is String) {
      final lower = raw.toLowerCase();
      if (lower.contains('premium') || lower.contains('enhanced')) return 400;
      if (lower.contains('default')) return 100;
    }
    // Some iOS engine versions encode quality in the voice identifier
    // instead of a separate field (e.g. "com.apple.voice.premium.en-US...").
    final lowerName = name.toLowerCase();
    if (lowerName.contains('premium') || lowerName.contains('enhanced')) return 400;
    return null;
  }

  /// Whether picking this voice would require a network round trip. Not used
  /// to score today (a slow network voice can still beat no metadata at
  /// all), but kept on the model for callers that want to filter it out.
  bool get networkRequired => false;
}

/// Picks the best available voice for [locale] out of [voices], or `null`
/// when nothing on the device matches — meaning the caller should fall back
/// to whatever `setLanguage` defaults to, today's behaviour.
///
/// "Best" means: matches the requested locale by [TtsService.matches]'s
/// rules, then prefers higher [VoiceInfo.quality]; a voice with no quality
/// signal scores lowest but is still picked over no match at all, so a
/// platform lacking this metadata degrades to "first match" rather than
/// losing voice selection entirely.
@visibleForTesting
VoiceInfo? selectBestVoice(String requestedLocale, List<VoiceInfo> voices) {
  VoiceInfo? best;
  for (final voice in voices) {
    if (voice.locale.isEmpty) continue;
    if (!TtsService.matches(requestedLocale, [voice.locale])) continue;
    if (best == null) {
      best = voice;
      continue;
    }
    final voiceScore = voice.quality ?? -1;
    final bestScore = best.quality ?? -1;
    if (voiceScore > bestScore) best = voice;
  }
  return best;
}

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

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _configure(String locale) async {
    if (_configuredLocale == locale) return;
    final profile = speechProfileFor(locale);
    try {
      final voice = await _bestVoiceFor(locale);
      if (voice != null) {
        // A specific, better-quality voice beats whatever setLanguage would
        // default to on its own. setVoice implies the language for engines
        // that support it, but we still call setLanguage first for the ones
        // that don't.
        await _tts.setLanguage(locale);
        await _tts.setVoice({'name': voice.name, 'locale': voice.locale});
      } else {
        await _tts.setLanguage(locale);
      }
      await _tts.setSpeechRate(profile.platformRate(isIOS: _isIOS));
      await _tts.setPitch(profile.pitch);
      await _tts.setVolume(1.0);
      _configuredLocale = locale;
    } catch (error) {
      debugPrint('TTS could not select $locale: $error');
    }
  }

  /// Best voice for [locale] per [selectBestVoice], or `null` if the
  /// platform exposes no voice list (or none of it matches) — meaning the
  /// caller should stick to the current setLanguage-only behaviour.
  Future<VoiceInfo?> _bestVoiceFor(String locale) async {
    try {
      final raw = await _tts.getVoices;
      if (raw is! List) return null;
      final voices = [
        for (final entry in raw)
          if (entry is Map) VoiceInfo.fromMap(entry),
      ];
      return selectBestVoice(locale, voices);
    } catch (error) {
      // getVoices is not implemented on every platform; that is not an
      // error worth surfacing, just a signal to fall back.
      return null;
    }
  }

  Future<void> speak(String text, String locale, {bool slow = false}) async {
    if (text.trim().isEmpty) return;
    await _configure(locale);
    final profile = speechProfileFor(locale);
    final rate = profile.platformRate(isIOS: _isIOS) * (slow ? profile.slowMultiplier : 1.0);
    try {
      await _tts.stop();
      await _tts.setSpeechRate(rate);
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
