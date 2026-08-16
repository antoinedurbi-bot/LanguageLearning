/// A starter kanji set: the ~60 most essential first-grade / JLPT N5
/// characters, reused across the numbers, calendar, and daily-verb
/// vocabulary the rest of the Japanese module teaches.
///
/// See `data/kana/kana.dart` for the note on why this ships readings and a
/// stroke count rather than animated stroke paths: the Chinese module's
/// stroke animation is driven by a vendored corpus (Make Me A Hanzi), and
/// doing the same for kanji needs the KanjiVG corpus vendored the same way,
/// not hand-typed path data.
library;

/// One kanji, with its real readings — never invented.
class Kanji {
  const Kanji({
    required this.character,
    required this.onyomi,
    required this.kunyomi,
    required this.meaning,
    required this.strokeCount,
    required this.jlpt,
    this.mnemonic,
  });

  final String character;

  /// Chinese-derived readings (音読み), katakana convention rendered here in
  /// romaji, most common first. Empty for kanji with no on'yomi in common use.
  final List<String> onyomi;

  /// Native Japanese readings (訓読み), okurigana shown in parentheses,
  /// e.g. "たべ(る)" for 食. Empty for kanji with no kun'yomi in common use.
  final List<String> kunyomi;

  /// French gloss.
  final String meaning;
  final int strokeCount;

  /// JLPT level this kanji is drilled at: always 5 (N5) in this starter set.
  final int jlpt;
  final String? mnemonic;
}

const List<Kanji> starterKanji = [
  Kanji(character: '一', onyomi: ['ichi'], kunyomi: ['hito(tsu)'], meaning: 'un', strokeCount: 1, jlpt: 5),
  Kanji(character: '二', onyomi: ['ni'], kunyomi: ['futa(tsu)'], meaning: 'deux', strokeCount: 2, jlpt: 5),
  Kanji(character: '三', onyomi: ['san'], kunyomi: ['mit(tsu)'], meaning: 'trois', strokeCount: 3, jlpt: 5),
  Kanji(character: '四', onyomi: ['shi'], kunyomi: ['yon', 'yot(tsu)'], meaning: 'quatre', strokeCount: 5, jlpt: 5),
  Kanji(character: '五', onyomi: ['go'], kunyomi: ['itsu(tsu)'], meaning: 'cinq', strokeCount: 4, jlpt: 5),
  Kanji(character: '六', onyomi: ['roku'], kunyomi: ['mut(tsu)'], meaning: 'six', strokeCount: 4, jlpt: 5),
  Kanji(character: '七', onyomi: ['shichi'], kunyomi: ['nana(tsu)'], meaning: 'sept', strokeCount: 2, jlpt: 5),
  Kanji(character: '八', onyomi: ['hachi'], kunyomi: ['yat(tsu)'], meaning: 'huit', strokeCount: 2, jlpt: 5),
  Kanji(character: '九', onyomi: ['kyuu', 'ku'], kunyomi: ['kokono(tsu)'], meaning: 'neuf', strokeCount: 2, jlpt: 5),
  Kanji(character: '十', onyomi: ['juu'], kunyomi: ['too'], meaning: 'dix', strokeCount: 2, jlpt: 5),
  Kanji(character: '百', onyomi: ['hyaku'], kunyomi: [], meaning: 'cent', strokeCount: 6, jlpt: 5),
  Kanji(character: '千', onyomi: ['sen'], kunyomi: [], meaning: 'mille', strokeCount: 3, jlpt: 5),
  Kanji(character: '万', onyomi: ['man', 'ban'], kunyomi: [], meaning: 'dix mille', strokeCount: 3, jlpt: 5),
  Kanji(character: '円', onyomi: ['en'], kunyomi: [], meaning: 'yen / cercle', strokeCount: 4, jlpt: 5),
  Kanji(
    character: '日',
    onyomi: ['nichi', 'jitsu'],
    kunyomi: ['hi', 'ka'],
    meaning: 'jour / soleil',
    strokeCount: 4,
    jlpt: 5,
    mnemonic: 'Un carre avec un trait au milieu : la fenetre carree du '
        'soleil vu dans le ciel.',
  ),
  Kanji(
    character: '月',
    onyomi: ['getsu', 'gatsu'],
    kunyomi: ['tsuki'],
    meaning: 'mois / lune',
    strokeCount: 4,
    jlpt: 5,
    mnemonic: 'La forme d\'un croissant de lune dans un cadre.',
  ),
  Kanji(character: '火', onyomi: ['ka'], kunyomi: ['hi'], meaning: 'feu', strokeCount: 4, jlpt: 5),
  Kanji(character: '水', onyomi: ['sui'], kunyomi: ['mizu'], meaning: 'eau', strokeCount: 4, jlpt: 5),
  Kanji(character: '木', onyomi: ['moku', 'boku'], kunyomi: ['ki'], meaning: 'arbre', strokeCount: 4, jlpt: 5),
  Kanji(character: '金', onyomi: ['kin', 'kon'], kunyomi: ['kane'], meaning: 'or / argent', strokeCount: 8, jlpt: 5),
  Kanji(character: '土', onyomi: ['do', 'to'], kunyomi: ['tsuchi'], meaning: 'terre', strokeCount: 3, jlpt: 5),
  Kanji(
    character: '人',
    onyomi: ['jin', 'nin'],
    kunyomi: ['hito'],
    meaning: 'personne',
    strokeCount: 2,
    jlpt: 5,
    mnemonic: 'Deux jambes qui marchent : une personne debout.',
  ),
  Kanji(character: '子', onyomi: ['shi', 'su'], kunyomi: ['ko'], meaning: 'enfant', strokeCount: 3, jlpt: 5),
  Kanji(character: '女', onyomi: ['jo', 'nyo'], kunyomi: ['onna'], meaning: 'femme', strokeCount: 3, jlpt: 5),
  Kanji(character: '男', onyomi: ['dan', 'nan'], kunyomi: ['otoko'], meaning: 'homme', strokeCount: 7, jlpt: 5),
  Kanji(character: '大', onyomi: ['dai', 'tai'], kunyomi: ['ooki(i)'], meaning: 'grand', strokeCount: 3, jlpt: 5),
  Kanji(character: '小', onyomi: ['shou'], kunyomi: ['chii(sai)'], meaning: 'petit', strokeCount: 3, jlpt: 5),
  Kanji(character: '上', onyomi: ['jou'], kunyomi: ['ue', 'nobo(ru)', 'a(geru)'], meaning: 'dessus / monter', strokeCount: 3, jlpt: 5),
  Kanji(character: '下', onyomi: ['ka', 'ge'], kunyomi: ['shita', 'kuda(ru)', 'sa(geru)'], meaning: 'dessous / descendre', strokeCount: 3, jlpt: 5),
  Kanji(character: '中', onyomi: ['chuu'], kunyomi: ['naka'], meaning: 'milieu / dans', strokeCount: 4, jlpt: 5),
  Kanji(character: '外', onyomi: ['gai', 'ge'], kunyomi: ['soto', 'hazu(reru)'], meaning: 'exterieur', strokeCount: 5, jlpt: 5),
  Kanji(character: '左', onyomi: ['sa'], kunyomi: ['hidari'], meaning: 'gauche', strokeCount: 5, jlpt: 5),
  Kanji(character: '右', onyomi: ['u', 'yuu'], kunyomi: ['migi'], meaning: 'droite', strokeCount: 5, jlpt: 5),
  Kanji(character: '前', onyomi: ['zen'], kunyomi: ['mae'], meaning: 'avant / devant', strokeCount: 9, jlpt: 5),
  Kanji(character: '後', onyomi: ['go', 'kou'], kunyomi: ['ato', 'ushi(ro)', 'nochi'], meaning: 'apres / derriere', strokeCount: 9, jlpt: 5),
  Kanji(character: '間', onyomi: ['kan', 'ken'], kunyomi: ['aida', 'ma'], meaning: 'intervalle / entre', strokeCount: 12, jlpt: 5),
  Kanji(character: '年', onyomi: ['nen'], kunyomi: ['toshi'], meaning: 'annee', strokeCount: 6, jlpt: 5),
  Kanji(character: '今', onyomi: ['kon', 'kin'], kunyomi: ['ima'], meaning: 'maintenant', strokeCount: 4, jlpt: 5),
  Kanji(character: '何', onyomi: ['ka'], kunyomi: ['nani', 'nan'], meaning: 'quoi', strokeCount: 7, jlpt: 5),
  Kanji(character: '時', onyomi: ['ji'], kunyomi: ['toki'], meaning: 'heure / temps', strokeCount: 10, jlpt: 5),
  Kanji(character: '分', onyomi: ['fun', 'bun', 'bu'], kunyomi: ['wa(keru)'], meaning: 'minute / partie', strokeCount: 4, jlpt: 5),
  Kanji(character: '話', onyomi: ['wa'], kunyomi: ['hana(su)', 'hanashi'], meaning: 'parler', strokeCount: 13, jlpt: 5),
  Kanji(character: '語', onyomi: ['go'], kunyomi: ['kata(ru)'], meaning: 'langue / mot', strokeCount: 14, jlpt: 5),
  Kanji(character: '読', onyomi: ['doku'], kunyomi: ['yo(mu)'], meaning: 'lire', strokeCount: 14, jlpt: 5),
  Kanji(character: '書', onyomi: ['sho'], kunyomi: ['ka(ku)'], meaning: 'ecrire', strokeCount: 10, jlpt: 5),
  Kanji(character: '聞', onyomi: ['bun', 'mon'], kunyomi: ['ki(ku)'], meaning: 'ecouter / entendre', strokeCount: 14, jlpt: 5),
  Kanji(character: '見', onyomi: ['ken'], kunyomi: ['mi(ru)'], meaning: 'voir', strokeCount: 7, jlpt: 5),
  Kanji(character: '食', onyomi: ['shoku'], kunyomi: ['ta(beru)', 'ku(u)'], meaning: 'manger', strokeCount: 9, jlpt: 5),
  Kanji(character: '飲', onyomi: ['in'], kunyomi: ['no(mu)'], meaning: 'boire', strokeCount: 12, jlpt: 5),
  Kanji(character: '行', onyomi: ['kou', 'gyou'], kunyomi: ['i(ku)', 'okona(u)'], meaning: 'aller / effectuer', strokeCount: 6, jlpt: 5),
  Kanji(character: '来', onyomi: ['rai'], kunyomi: ['ku(ru)', 'kita(ru)'], meaning: 'venir', strokeCount: 7, jlpt: 5),
  Kanji(character: '学', onyomi: ['gaku'], kunyomi: ['mana(bu)'], meaning: 'etudier', strokeCount: 8, jlpt: 5),
  Kanji(character: '校', onyomi: ['kou'], kunyomi: [], meaning: 'ecole', strokeCount: 10, jlpt: 5),
  Kanji(character: '生', onyomi: ['sei', 'shou'], kunyomi: ['i(kiru)', 'u(mareru)', 'nama'], meaning: 'vie / naitre / cru', strokeCount: 5, jlpt: 5),
  Kanji(character: '先', onyomi: ['sen'], kunyomi: ['saki'], meaning: 'avant / precedent', strokeCount: 6, jlpt: 5),
  Kanji(character: '私', onyomi: ['shi'], kunyomi: ['watashi'], meaning: 'je / prive', strokeCount: 7, jlpt: 5),
  Kanji(character: '友', onyomi: ['yuu'], kunyomi: ['tomo'], meaning: 'ami', strokeCount: 4, jlpt: 5),
  Kanji(character: '買', onyomi: ['bai'], kunyomi: ['ka(u)'], meaning: 'acheter', strokeCount: 12, jlpt: 5),
  Kanji(character: '国', onyomi: ['koku'], kunyomi: ['kuni'], meaning: 'pays', strokeCount: 8, jlpt: 5),
  Kanji(character: '山', onyomi: ['san'], kunyomi: ['yama'], meaning: 'montagne', strokeCount: 3, jlpt: 5),
];

Kanji? kanjiByCharacter(String character) {
  for (final k in starterKanji) {
    if (k.character == character) return k;
  }
  return null;
}
