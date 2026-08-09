import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/data/models/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores progress locally, and mirrors it to Firestore when the learner is
/// signed in.
///
/// Local storage is the source of truth during a session: a review must never
/// be lost because the network blinked, and the app has to work completely
/// offline. Firestore is a best-effort backup written after each save, so a
/// failure there degrades sync rather than losing the review.
class ProgressRepository {
  static const _prefix = 'progress_v1_';

  Future<LanguageProgress> load(String languageCode) async {
    final now = DateTime.now();
    final local = await _loadLocal(languageCode, now);
    if (local != null) return local;

    final remote = await _loadRemote(languageCode, now);
    if (remote != null) {
      await save(remote);
      return remote;
    }

    return LanguageProgress(languageCode: languageCode);
  }

  Future<void> save(LanguageProgress progress) async {
    progress.prune(DateTime.now());
    final payload = jsonEncode(progress.toJson());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix${progress.languageCode}', payload);

    unawaited(_saveRemote(progress));
  }

  Future<void> clear(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$languageCode');
  }

  Future<LanguageProgress?> _loadLocal(String languageCode, DateTime now) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$languageCode');
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return LanguageProgress.fromJson(
        Map<String, dynamic>.from(decoded),
        now,
      );
    } catch (error, stack) {
      // Corrupt payload: start clean rather than trapping the learner on a
      // screen that cannot load.
      debugPrint('Local progress unreadable: $error\n$stack');
      return null;
    }
  }

  DocumentReference<Map<String, dynamic>>? _doc(String languageCode) {
    if (!AppState.firebaseReady) return null;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(languageCode);
  }

  Future<LanguageProgress?> _loadRemote(String languageCode, DateTime now) async {
    final doc = _doc(languageCode);
    if (doc == null) return null;
    try {
      final snapshot = await doc.get();
      final data = snapshot.data();
      if (data == null) return null;
      return LanguageProgress.fromJson(data, now);
    } catch (error) {
      debugPrint('Remote progress unavailable: $error');
      return null;
    }
  }

  Future<void> _saveRemote(LanguageProgress progress) async {
    final doc = _doc(progress.languageCode);
    if (doc == null) return;
    try {
      await doc.set(progress.toJson());
    } catch (error) {
      debugPrint('Remote progress not synced: $error');
    }
  }
}

/// Small key-value store for preferences that are not per-language.
class SettingsRepository {
  static const _language = 'selected_language';
  static const _themeMode = 'theme_mode';
  static const _sound = 'sound_enabled';

  Future<String?> selectedLanguage() async =>
      (await SharedPreferences.getInstance()).getString(_language);

  Future<void> setSelectedLanguage(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_language);
    } else {
      await prefs.setString(_language, code);
    }
  }

  Future<String?> themeMode() async =>
      (await SharedPreferences.getInstance()).getString(_themeMode);

  Future<void> setThemeMode(String value) async =>
      (await SharedPreferences.getInstance()).setString(_themeMode, value);

  Future<bool> soundEnabled() async =>
      (await SharedPreferences.getInstance()).getBool(_sound) ?? true;

  Future<void> setSoundEnabled(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_sound, value);
}
