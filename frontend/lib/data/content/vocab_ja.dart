import 'package:learning_app/data/models/vocabulary.dart';

/// Japanese vocabulary for French speakers.
///
/// Japanese words carry register the way Chinese words carry measure-word
/// constraints: almost every note here is about which of several
/// near-synonyms a situation calls for, or what politeness level a word
/// belongs to — a dictionary translation alone would produce sentences that
/// are understandable but socially off.
const vocabJa = VocabularyPack(
  languageCode: 'ja',
  themes: [
    VocabTheme(
      id: 'ja-t1',
      title: 'Les indispensables',
      subtitle: 'Particules et mots qui structurent toutes les phrases',
      entries: [
        VocabEntry(
          id: 'ja-v-wa',
          target: 'は',
          native: 'particule de topic',
          pos: 'particule',
          romanization: 'wa',
          example: 'わたしは がくせいです。',
          exampleNative: 'Moi, je suis étudiant.',
          note: 'Se prononce "wa" dans ce role, malgre son ecriture en は. '
              'Annonce le sujet dont on parle, pas forcement le sujet '
              'grammatical de l\'action.',
        ),
        VocabEntry(
          id: 'ja-v-ga',
          target: 'が',
          native: 'particule de sujet',
          pos: 'particule',
          romanization: 'ga',
          example: 'あめが ふっています。',
          exampleNative: 'Il pleut.',
          note: 'Marque le sujet grammatical, souvent une information '
              'nouvelle ou non-connue de l\'auditeur — a l\'inverse de は qui '
              'reprend un sujet deja etabli.',
        ),
        VocabEntry(
          id: 'ja-v-desu',
          target: 'です',
          native: 'être (poli)',
          pos: 'copule',
          romanization: 'desu',
          example: 'これは ペンです。',
          exampleNative: 'Ceci est un stylo.',
          note: 'Ne se conjugue pas comme un verbe francais : porte '
              'seulement la politesse, jamais l\'accord de personne.',
        ),
        VocabEntry(
          id: 'ja-v-ka',
          target: 'か',
          native: 'particule de question',
          pos: 'particule',
          romanization: 'ka',
          example: 'げんきですか。',
          exampleNative: 'Ça va ?',
          note: 'Ajoutee en fin de phrase, sans inversion ni changement '
              'd\'intonation obligatoire — la particule seule fait la '
              'question.',
        ),
        VocabEntry(
          id: 'ja-v-arigatou',
          target: 'ありがとう',
          native: 'merci',
          pos: 'expression',
          romanization: 'arigatou',
          example: 'ありがとうございます。',
          exampleNative: 'Merci beaucoup.',
          note: 'Seul, ありがとう est familier ; ございます a la fin le rend '
              'poli, la forme par defaut avec des inconnus.',
        ),
      ],
    ),
    VocabTheme(
      id: 'ja-t2',
      title: 'Au restaurant',
      subtitle: 'Commander et payer',
      entries: [
        VocabEntry(
          id: 'ja-v-onegai',
          target: 'おねがいします',
          native: 's\'il vous plaît (pour demander qqch)',
          pos: 'expression',
          romanization: 'onegaishimasu',
          example: 'みずを おねがいします。',
          exampleNative: 'De l\'eau, s\'il vous plaît.',
          note: 'S\'utilise pour demander un objet ou un service ; pour '
              'demander une action, on utilise plutot て + ください.',
        ),
        VocabEntry(
          id: 'ja-v-oishii',
          target: 'おいしい',
          native: 'délicieux',
          pos: 'adjectif (い)',
          romanization: 'oishii',
          example: 'これは とても おいしいです。',
          exampleNative: 'C\'est très bon.',
          note: 'Adjectif en い : se conjugue seul (おいしくない = pas bon), '
              'です n\'ajoute que la politesse.',
        ),
        VocabEntry(
          id: 'ja-v-okaikei',
          target: 'おかいけい',
          native: 'l\'addition',
          pos: 'nom',
          romanization: 'okaikei',
          example: 'おかいけい おねがいします。',
          exampleNative: 'L\'addition, s\'il vous plaît.',
          note: 'お- honorifique colle a beaucoup de noms du quotidien '
              '(おかね, おちゃ, おさけ) : l\'enlever ne choque pas mais sonne '
              'un peu brut.',
        ),
        VocabEntry(
          id: 'ja-v-mizu',
          target: 'みず',
          native: 'eau (froide)',
          pos: 'nom',
          romanization: 'mizu',
          example: 'みずを ください。',
          exampleNative: 'De l\'eau, s\'il vous plaît.',
          note: 'おゆ (お湯) designe l\'eau chaude : ce n\'est pas la meme '
              'entree de vocabulaire, contrairement au français "eau".',
        ),
        VocabEntry(
          id: 'ja-v-itadakimasu',
          target: 'いただきます',
          native: 'formule dite avant de manger',
          pos: 'expression',
          romanization: 'itadakimasu',
          example: '（りょうりの まえに）いただきます。',
          exampleNative: '(avant le repas) Merci pour ce repas.',
          note: 'Dite systematiquement avant de commencer a manger, seul ou '
              'a table — pas une simple politesse optionnelle.',
        ),
      ],
    ),
    VocabTheme(
      id: 'ja-t3',
      title: 'Le temps et les nombres',
      subtitle: 'Heures, jours, et compter',
      entries: [
        VocabEntry(
          id: 'ja-v-ichi',
          target: '一',
          native: 'un',
          pos: 'nombre',
          romanization: 'ichi',
          example: '一じ',
          exampleNative: 'une heure',
          note: 'Se lit いち en isolation, mais ひと(つ) devant certains '
              'compteurs (ひとつ = "un objet") : les nombres japonais ont '
              'deux series de lectures.',
        ),
        VocabEntry(
          id: 'ja-v-kyou',
          target: 'きょう',
          native: 'aujourd\'hui',
          pos: 'nom',
          romanization: 'kyou',
          example: 'きょうは にちようびです。',
          exampleNative: 'Aujourd\'hui, c\'est dimanche.',
          note: 'S\'utilise sans particule de temps (に) : "aujourd\'hui, '
              'demain, hier" sont des exceptions qui n\'en prennent jamais.',
        ),
        VocabEntry(
          id: 'ja-v-nanji',
          target: 'なんじ',
          native: 'quelle heure',
          pos: 'expression',
          romanization: 'nanji',
          example: 'いま なんじですか。',
          exampleNative: 'Quelle heure est-il ?',
          note: 'なん (quel) + じ (heure) : le meme patron なん+ compteur sert '
              'pour "combien" dans beaucoup de contextes (なんにん = combien '
              'de personnes).',
        ),
        VocabEntry(
          id: 'ja-v-mainichi',
          target: 'まいにち',
          native: 'tous les jours',
          pos: 'adverbe',
          romanization: 'mainichi',
          example: 'まいにち にほんごを べんきょうします。',
          exampleNative: 'J\'étudie le japonais tous les jours.',
          note: 'まい- (chaque) prefixe aussi まいあさ (chaque matin), まいしゅう '
              '(chaque semaine) : un prefixe productif a reconnaitre.',
        ),
        VocabEntry(
          id: 'ja-v-jikan',
          target: 'じかん',
          native: 'temps, durée, heure (unité)',
          pos: 'nom',
          romanization: 'jikan',
          example: 'じかんが ありません。',
          exampleNative: 'Je n\'ai pas le temps.',
          note: 'じ seul compte les heures precises (三じ = 3h), じかん compte '
              'une duree en heures (三じかん = 3 heures de duree) : deux '
              'lectures du meme kanji 時 pour deux notions differentes.',
        ),
      ],
    ),
  ],
  phrases: [
    KeyPhrase(
      id: 'ja-p-daijoubu',
      target: 'だいじょうぶです。',
      native: 'Ça va, c\'est bon.',
      whenToUse: 'Pour rassurer, refuser poliment une offre, ou dire que '
          'tout va bien après un petit incident.',
      category: 'reparation',
      romanization: 'Daijoubu desu.',
    ),
    KeyPhrase(
      id: 'ja-p-gomennasai',
      target: 'ごめんなさい。',
      native: 'Je suis désolé(e).',
      whenToUse: 'Excuse plus sincere et plus personnelle que すみません, '
          'reservee a de vraies fautes plutot qu\'a un simple derangement.',
      category: 'reparation',
      romanization: 'Gomennasai.',
    ),
    KeyPhrase(
      id: 'ja-p-sumimasen',
      target: 'すみません。',
      native: 'Excusez-moi. / Pardon.',
      whenToUse: 'Pour interpeller quelqu\'un, s\'excuser d\'un derangement '
          'mineur, ou meme dire merci quand on a derange quelqu\'un pour '
          'nous aider.',
      category: 'survie',
      romanization: 'Sumimasen.',
      literal: 'Ne-se-termine-pas (litteralement : "ce n\'est pas fini/regle")',
    ),
    KeyPhrase(
      id: 'ja-p-wakarimasen',
      target: 'わかりません。',
      native: 'Je ne comprends pas.',
      whenToUse: 'Quand on n\'a pas compris ce qui vient d\'etre dit — plus '
          'poli et plus precis que de simplement rester silencieux.',
      category: 'survie',
      romanization: 'Wakarimasen.',
    ),
    KeyPhrase(
      id: 'ja-p-mouichido',
      target: 'もういちど おねがいします。',
      native: 'Encore une fois, s\'il vous plaît.',
      whenToUse: 'Pour demander une repetition sans avoir a formuler une '
          'phrase complete de zero.',
      category: 'survie',
      romanization: 'Mou ichido onegaishimasu.',
      literal: 'Encore-une-fois s\'il-vous-plait',
    ),
    KeyPhrase(
      id: 'ja-p-eigo',
      target: 'えいごが はなせますか。',
      native: 'Parlez-vous anglais ?',
      whenToUse: 'Pour verifier si on peut basculer sur une langue commune '
          'avant de s\'engager dans un echange complique.',
      category: 'survie',
      romanization: 'Eigo ga hanasemasu ka.',
    ),
    KeyPhrase(
      id: 'ja-p-onamae',
      target: 'おなまえは？',
      native: 'Votre nom ?',
      whenToUse: 'Version courte et neutre de la question du nom, une fois '
          'la conversation deja engagee.',
      category: 'politesse',
      romanization: 'Onamae wa?',
    ),
    KeyPhrase(
      id: 'ja-p-otsukaresama',
      target: 'おつかれさまです。',
      native: 'Merci pour votre travail. (formule de fin de journée)',
      whenToUse: 'Dite a des collegues en partant, ou pour saluer l\'effort '
          'de quelqu\'un — n\'a pas d\'equivalent figé en français.',
      category: 'politesse',
      romanization: 'Otsukaresama desu.',
      literal: 'Vous-etes-fatigue(honorifique) (reconnait l\'effort fourni)',
    ),
  ],
);
