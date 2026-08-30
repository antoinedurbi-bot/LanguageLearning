import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.script,
    required this.description,
    required this.difficultyNote,
  });

  final String code;
  final String name;
  final String nativeName;

  /// A glyph from the language's own writing system, used as its mark. A real
  /// character beats a flag: languages are not countries.
  final String script;

  final String description;

  /// Honest expectation-setting, based on the US Foreign Service Institute's
  /// published category ratings for English speakers.
  final String difficultyNote;

  List<Color> get gradient => LL.gradientFor(code);
}

const availableLanguages = [
  AppLanguage(
    code: 'en',
    name: 'Anglais',
    nativeName: 'English',
    script: 'Aa',
    description: 'Voyage, travail, et tout le reste.',
    difficultyNote: 'Proche du français - environ 600 h pour un bon niveau',
  ),
  AppLanguage(
    code: 'es',
    name: 'Espagnol',
    nativeName: 'Español',
    script: 'Ñ',
    description: 'La langue la plus rentable pour un francophone.',
    difficultyNote: 'Très proche du français - environ 600 h',
  ),
  AppLanguage(
    code: 'zh',
    name: 'Chinois',
    nativeName: '中文',
    script: '中',
    description: 'Mandarin: tons, caractères, grammaire simple.',
    difficultyNote: 'Distance maximale - environ 2200 h, mais sans conjugaison',
  ),
  AppLanguage(
    code: 'tr',
    name: 'Turc',
    nativeName: 'Türkçe',
    script: 'Ş',
    description: 'Agglutinante et d\'une regularite rare.',
    difficultyNote:
        'Structure inhabituelle - environ 1100 h, mais peu d\'exceptions',
  ),
  AppLanguage(
    code: 'ja',
    name: 'Japonais',
    nativeName: '日本語',
    script: 'あ',
    description: 'Deux syllabaires, des kanji, une politesse a plusieurs '
        'niveaux.',
    difficultyNote:
        'Distance maximale - environ 2200 h, une grammaire tres reguliere',
  ),
];

AppLanguage? languageFor(String? code) {
  if (code == null) return null;
  for (final language in availableLanguages) {
    if (language.code == code) return language;
  }
  return null;
}
