import 'package:learning_app/data/content/course_en.dart';
import 'package:learning_app/data/content/course_es.dart';
import 'package:learning_app/data/content/course_tr.dart';
import 'package:learning_app/data/content/course_zh.dart';
import 'package:learning_app/data/models/card_item.dart';

const courses = <String, Course>{
  'en': courseEn,
  'es': courseEs,
  'zh': courseZh,
  'tr': courseTr,
};

Course? courseFor(String languageCode) => courses[languageCode];
