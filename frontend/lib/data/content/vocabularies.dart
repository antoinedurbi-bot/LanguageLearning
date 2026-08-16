import 'package:learning_app/data/content/vocab_en.dart';
import 'package:learning_app/data/content/vocab_es.dart';
import 'package:learning_app/data/content/vocab_tr.dart';
import 'package:learning_app/data/content/vocab_zh.dart';
import 'package:learning_app/data/models/vocabulary.dart';
import 'package:learning_app/data/content/vocab_ja.dart';

const vocabularies = <String, VocabularyPack>{
  'en': vocabEn,
  'es': vocabEs,
  'zh': vocabZh,
  'tr': vocabTr,
  'ja': vocabJa,
};

VocabularyPack? vocabularyFor(String languageCode) => vocabularies[languageCode];
