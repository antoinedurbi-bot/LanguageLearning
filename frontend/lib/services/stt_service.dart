import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Whether the device can listen in a given language, mirroring
/// [TtsService.voiceStatus] on the input side.
enum ListenStatus { ready, missing, unknown, denied }

/// Speech-to-text for pronunciation practice: the learner speaks their
/// answer instead of typing it.
///
/// Deliberately narrow. This is not a dictation tool — it listens for one
/// short utterance, returns the best transcript, and stops. A learner
/// checking their own pronunciation needs a clear yes/no on "would this be
/// understood", not a running live-caption experience.
class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _initialized = false;
  bool _available = false;

  Future<bool> _ensureInitialized() async {
    if (_initialized) return _available;
    _initialized = true;
    try {
      _available = await _speech.initialize(
        onError: (error) => debugPrint('STT error: ${error.errorMsg}'),
        onStatus: (status) => debugPrint('STT status: $status'),
      );
    } catch (error) {
      debugPrint('STT could not initialize: $error');
      _available = false;
    }
    return _available;
  }

  /// Whether a locale can be listened to. Mirrors [TtsService.matches]:
  /// compares on the language subtag, since a device might only report
  /// `es_MX` while the course asks for `es_ES`.
  Future<ListenStatus> listenStatus(String locale) async {
    final ready = await _ensureInitialized();
    if (!ready) return ListenStatus.denied;

    try {
      final locales = await _speech.locales();
      final subtag = locale.toLowerCase().split(RegExp('[-_]')).first;
      final matches = locales.any((l) {
        final candidate = l.localeId.toLowerCase();
        return candidate == locale.toLowerCase() ||
            candidate.split(RegExp('[-_]')).first == subtag;
      });
      return matches ? ListenStatus.ready : ListenStatus.missing;
    } catch (error) {
      debugPrint('STT could not list locales: $error');
      return ListenStatus.unknown;
    }
  }

  /// Listens once and resolves with the best transcript, or null if nothing
  /// usable came through (denied permission, no speech detected, timeout).
  Future<String?> listenOnce({
    required String localeId,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final ready = await _ensureInitialized();
    if (!ready) return null;

    String? result;
    final completer = Completer<String?>();

    try {
      await _speech.listen(
        onResult: (recognition) {
          result = recognition.recognizedWords;
          if (recognition.finalResult && !completer.isCompleted) {
            completer.complete(result);
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: localeId,
          listenFor: timeout,
          pauseFor: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      debugPrint('STT listen failed: $error');
      return null;
    }

    // Falls back to whatever partial transcript arrived if the recognizer
    // never marks a final result before the timeout — better than losing an
    // attempt the learner can see was heard.
    final timedOut = Future<String?>.delayed(timeout + const Duration(seconds: 1))
        .then((_) => completer.isCompleted ? null : result);

    final value = await Future.any([completer.future, timedOut]);
    await stop();
    return (value == null || value.trim().isEmpty) ? null : value;
  }

  Future<void> stop() async {
    try {
      await _speech.stop();
    } catch (_) {
      // Stopping something that never started is not worth surfacing.
    }
  }

  bool get isListening => _speech.isListening;
}
