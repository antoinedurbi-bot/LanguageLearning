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
    VocabTheme(
      id: 'ja-t3',
      title: 'Compter et décrire',
      subtitle: 'Nombres, jours et couleurs qui manquaient à l\'appel',
      entries: [
        VocabEntry(
          id: 'ja-v-numbers-1-10',
          target: 'いち、に、さん...じゅう',
          native: 'un, deux, trois... dix',
          pos: 'nombres',
          romanization: 'ichi, ni, san... jū',
          example: 'きょうだいが さんにん います。',
          exampleNative: 'J\'ai trois frères et sœurs.',
          note: 'La lecture change selon ce qu\'on compte : さんにん (trois '
              'personnes) n\'utilise pas le même suffixe que さんまい (trois '
              'feuilles/billets) ou さんこ (trois objets). Le nombre nu '
              'いち・に・さん sert surtout à compter dans l\'abstrait.',
        ),
        VocabEntry(
          id: 'ja-v-days',
          target: 'げつようび、かようび、すいようび...',
          native: 'lundi, mardi, mercredi...',
          pos: 'noms',
          romanization: 'getsuyōbi, kayōbi, suiyōbi...',
          example: 'げつようびに あいましょう。',
          exampleNative: 'On se voit lundi.',
          note: 'Chaque jour finit par 曜日 (yōbi, "jour de la semaine") '
              'précédé d\'un caractère lié à un élément : 月 (lune, lundi), '
              '火 (feu, mardi), 水 (eau, mercredi) — un moule à reconnaître '
              'plutôt que sept mots isolés.',
        ),
        VocabEntry(
          id: 'ja-v-colors',
          target: 'あかい、あおい、しろい、くろい',
          native: 'rouge, bleu, blanc, noir',
          pos: 'adjectifs -i',
          romanization: 'akai, aoi, shiroi, kuroi',
          example: 'あかい かばんが すきです。',
          exampleNative: 'J\'aime le sac rouge.',
          note: 'Ces couleurs sont des adjectifs en -い (i-keiyōshi) : elles '
              'se conjuguent comme un verbe (あかくない = pas rouge) et se '
              'placent directement avant le nom, sans particule.',
        ),
        VocabEntry(
          id: 'ja-v-ookii-chiisai',
          target: 'おおきい / ちいさい',
          native: 'grand / petit',
          pos: 'adjectifs -i',
          romanization: 'ōkii / chiisai',
          example: 'いえは ちいさいですが、だいどころは おおきいです。',
          exampleNative: 'La maison est petite mais la cuisine est grande.',
          note: 'Adjectifs en -い : la forme négative remplace le い final '
              'par くない (ちいさくない = pas petit). Devant un nom, ils restent '
              'inchangés : おおきい いえ.',
        ),
        VocabEntry(
          id: 'ja-v-ii-warui',
          target: 'いい / わるい',
          native: 'bon / mauvais',
          pos: 'adjectifs -i',
          romanization: 'ii / warui',
          example: 'この レストランは いいです。',
          exampleNative: 'Ce restaurant est bon.',
          note: 'いい est irrégulier à la forme négative et passée : on '
              'conjugue en fait よい (よくない, pas よくくない). Un piège classique '
              'pour qui apprend les adjectifs -い par un seul modèle.',
        ),
        VocabEntry(
          id: 'ja-v-hoshii-iru',
          target: 'ほしい / いる',
          native: 'vouloir (un objet) / avoir besoin de',
          pos: 'adjectif / verbe',
          romanization: 'hoshii / iru',
          example: 'コーヒーが ほしいです。じかんが いります。',
          exampleNative: 'Je veux un café. J\'ai besoin de temps.',
          note: 'ほしい est un adjectif -い, pas un verbe : "je veux X" se dit '
              'littéralement "X est désirable pour moi", avec が et non を. '
              'いる ici est le verbe "être nécessaire", homophone du verbe '
              '"exister" pour les êtres animés.',
        ),
        VocabEntry(
          id: 'ja-v-dekiru-nakerebanaranai',
          target: 'できる / なければならない',
          native: 'pouvoir (capacité) / devoir (obligation)',
          pos: 'verbe / structure',
          romanization: 'dekiru / nakereba naranai',
          example: 'ここで まつことが できます。でも きっぷを みせなければ '
              'なりません。',
          exampleNative: 'Tu peux attendre ici, mais tu dois montrer ton '
              'billet.',
          note: 'できる (pouvoir/savoir faire) se construit avec un nom '
              'verbal + こと. なければならない (devoir) est une structure longue '
              'mais fixe, construite sur la forme négative du verbe — bien '
              'plus lourde que le "must" anglais ou le "devoir" français.',
        ),
      ],
    ),
    VocabTheme(
      id: 'ja-t4',
      title: '家族 - La famille',
      subtitle: 'Le mot change selon qu\'on parle de sa famille ou de celle des autres',
      entries: [
        VocabEntry(
          id: 'ja-v-kazoku',
          target: 'かぞく',
          native: 'famille',
          pos: 'nom',
          romanization: 'kazoku',
          example: 'かぞくは　なんにんですか。',
          exampleNative: 'Vous êtes combien dans votre famille ?',
          note: 'Mot neutre pour parler de sa propre famille comme de '
              'celle des autres. Le kanji est 家族.',
        ),
        VocabEntry(
          id: 'ja-v-ryoushin',
          target: 'りょうしん',
          native: 'parents (père et mère)',
          pos: 'nom',
          romanization: 'ryōshin',
          example: 'りょうしんは　おおさかに　います。',
          exampleNative: 'Mes parents sont à Osaka.',
          note: 'Kanji 両親, littéralement "les deux parents". Pour parler '
              'des parents de quelqu\'un d\'autre poliment, on dit ご両親 '
              '(go-ryōshin).',
        ),
        VocabEntry(
          id: 'ja-v-ani-otouto',
          target: 'あに / おとうと',
          native: 'frère aîné / frère cadet (les miens)',
          pos: 'nom',
          romanization: 'ani / otōto',
          example: 'あにが　ひとり、おとうとが　ひとり　います。',
          exampleNative: 'J\'ai un frère aîné et un frère cadet.',
          note: 'Distinction cruciale : あに/おとうと servent uniquement '
              'pour parler de SES propres frères. Pour le frère de '
              'quelqu\'un d\'autre, on dit toujours お兄さん (onii-san) ou '
              '弟さん (otōto-san), quel que soit son âge.',
        ),
        VocabEntry(
          id: 'ja-v-ane-imouto',
          target: 'あね / いもうと',
          native: 'sœur aînée / sœur cadette (les miennes)',
          pos: 'nom',
          romanization: 'ane / imōto',
          example: 'あねは　わたしより　みっつ　うえです。',
          exampleNative: 'Ma sœur aînée a trois ans de plus que moi.',
          note: 'Même logique que あに/おとうと : réservé à sa propre '
              'famille. Pour la sœur de quelqu\'un d\'autre : お姉さん '
              '(onee-san) ou 妹さん (imōto-san).',
        ),
        VocabEntry(
          id: 'ja-v-kodomo',
          target: 'こども',
          native: 'enfant',
          pos: 'nom',
          romanization: 'kodomo',
          example: 'こどもが　ふたり　います。',
          exampleNative: 'J\'ai deux enfants.',
          note: 'Kanji 子供. S\'emploie aussi bien pour "un enfant" que '
              'pour "les enfants" en général, le japonais ne marquant pas '
              'toujours le pluriel.',
        ),
        VocabEntry(
          id: 'ja-v-hitorikko',
          target: 'ひとりっこ',
          native: 'enfant unique',
          pos: 'nom',
          romanization: 'hitorikko',
          example: 'わたしは　ひとりっこです。',
          exampleNative: 'Je suis enfant unique.',
          note: 'Construit sur ひとり (un/seul) + 子 (enfant) : littéralement '
              '"l\'enfant seul(e)".',
        ),
        VocabEntry(
          id: 'ja-v-sodateru',
          target: 'そだてる',
          native: 'élever (un enfant)',
          pos: 'verbe',
          romanization: 'sodateru',
          example: 'ひとりで　さんにんの　こどもを　そだてました。',
          exampleNative: 'Elle a élevé seule trois enfants.',
          note: 'Verbe transitif en る (ichidan) : そだてる (élever qqn) a '
              'pour pendant intransitif そだつ (grandir, se développer).',
        ),
        VocabEntry(
          id: 'ja-v-niru',
          target: 'にる',
          native: 'ressembler à',
          pos: 'verbe',
          romanization: 'niru',
          example: 'あなたは　おかあさんに　にていますね。',
          exampleNative: 'Vous ressemblez à votre mère.',
          note: 'S\'emploie presque toujours à la forme en ている (にている) : '
              'l\'état de ressemblance est vu comme un résultat durable, pas '
              'une action ponctuelle.',
        ),
        VocabEntry(
          id: 'ja-v-nakagaii',
          target: 'なかがいい',
          native: 'bien s\'entendre (avec qqn)',
          pos: 'expression',
          romanization: 'naka ga ii',
          example: 'あねと　なかが　いいです。',
          exampleNative: 'Je m\'entends bien avec ma sœur.',
          note: 'Littéralement "la relation (仲) est bonne". L\'antonyme, '
              'なかが悪い (naka ga warui), veut dire "être en froid avec '
              'qqn".',
        ),
        VocabEntry(
          id: 'ja-v-sokkuri',
          target: 'そっくり',
          native: 'qui se ressemble comme deux gouttes d\'eau',
          pos: 'adjectif',
          romanization: 'sokkuri',
          example: 'ふたごは　そっくりです。',
          exampleNative: 'Les jumeaux se ressemblent trait pour trait.',
          note: 'Plus fort et plus imagé que にている : réservé à une '
              'ressemblance frappante, presque parfaite.',
        ),
        VocabEntry(
          id: 'ja-v-otona',
          target: 'おとな',
          native: 'adulte',
          pos: 'nom',
          romanization: 'otona',
          example: 'こどもは　むりょうですが、おとなは　はらいます。',
          exampleNative: 'C\'est gratuit pour les enfants, mais les '
              'adultes paient.',
          note: 'Kanji 大人, littéralement "grande personne". Terme neutre '
              'et administratif, utilisé partout des tarifs de musée aux '
              'formulaires officiels.',
        ),
      ],
    ),
    VocabTheme(
      id: 'ja-t5',
      title: '気持ち - Les émotions',
      subtitle: 'Nuancer ce qu\'on ressent, au-delà de うれしい/かなしい',
      entries: [
        VocabEntry(
          id: 'ja-v-kimochi',
          target: 'きもち',
          native: 'sentiment, ressenti',
          pos: 'nom',
          romanization: 'kimochi',
          example: 'きもちが　わかります。',
          exampleNative: 'Je comprends ce que vous ressentez.',
          note: 'Kanji 気持ち, littéralement "ce que le qi/l\'énergie '
              'porte". Mot de base pour introduire n\'importe quel état '
              'émotionnel.',
        ),
        VocabEntry(
          id: 'ja-v-ureshii',
          target: 'うれしい',
          native: 'content, heureux (à propos d\'un événement précis)',
          pos: 'adjectif',
          romanization: 'ureshii',
          example: 'あえて　うれしいです。',
          exampleNative: 'Je suis content de vous rencontrer.',
          note: 'Décrit une joie ponctuelle liée à un événement, à la '
              'différence de しあわせ (shiawase), un bonheur plus profond '
              'et durable (la vie en général).',
        ),
        VocabEntry(
          id: 'ja-v-kanashii',
          target: 'かなしい',
          native: 'triste',
          pos: 'adjectif',
          romanization: 'kanashii',
          example: 'その　にゅーすを　きいて　かなしかったです。',
          exampleNative: 'J\'ai été triste en apprenant cette nouvelle.',
          note: 'Adjectif en い classique : se conjugue au passé en '
              'かなしかった, comme tous les adjectifs de cette classe.',
        ),
        VocabEntry(
          id: 'ja-v-shinpai',
          target: 'しんぱい',
          native: 'inquiétude, s\'inquiéter',
          pos: 'nom, verbe',
          romanization: 'shinpai',
          example: 'しんぱいしないでください。',
          exampleNative: 'Ne vous inquiétez pas.',
          note: 'Nom verbal en する : しんぱいする (s\'inquiéter). Kanji 心配, '
              'littéralement "distribution du cœur" — l\'idée que l\'esprit '
              'se disperse sur plusieurs soucis.',
        ),
        VocabEntry(
          id: 'ja-v-okoru',
          target: 'おこる',
          native: 'se mettre en colère',
          pos: 'verbe',
          romanization: 'okoru',
          example: 'せんせいが　おこりました。',
          exampleNative: 'Le professeur s\'est mis en colère.',
          note: 'Verbe intransitif (godan). L\'adjectif dérivé おこりっぽい '
              'décrit une personne "qui s\'énerve facilement".',
        ),
        VocabEntry(
          id: 'ja-v-kinchou',
          target: 'きんちょう',
          native: 'nervosité, stress',
          pos: 'nom, verbe',
          romanization: 'kinchō',
          example: 'めんせつの　まえは　きんちょうします。',
          exampleNative: 'Je suis stressé avant un entretien.',
          note: 'Nom verbal en する : きんちょうする. S\'emploie aussi pour '
              'une situation tendue (国際緊張, tensions internationales), '
              'pas seulement pour une personne.',
        ),
        VocabEntry(
          id: 'ja-v-anshin',
          target: 'あんしん',
          native: 'tranquillité, être rassuré',
          pos: 'nom, verbe',
          romanization: 'anshin',
          example: 'それを　きいて　あんしんしました。',
          exampleNative: 'J\'ai été rassuré en entendant ça.',
          note: 'Kanji 安心, littéralement "cœur en paix" — l\'antonyme '
              'exact de しんぱい (l\'inquiétude).',
        ),
        VocabEntry(
          id: 'ja-v-hazukashii',
          target: 'はずかしい',
          native: 'gêné, honteux',
          pos: 'adjectif',
          romanization: 'hazukashii',
          example: 'まちがえて　はずかしかったです。',
          exampleNative: 'J\'étais gêné d\'avoir fait une erreur.',
          note: 'Couvre à la fois la timidité passagère et la honte plus '
              'profonde ; le contexte seul permet de distinguer les deux '
              'nuances.',
        ),
        VocabEntry(
          id: 'ja-v-gakkari',
          target: 'がっかり',
          native: 'déçu',
          pos: 'adverbe, verbe',
          romanization: 'gakkari',
          example: 'けっかを　きいて　がっかりしました。',
          exampleNative: 'J\'ai été déçu en apprenant le résultat.',
          note: 'S\'emploie surtout avec する : がっかりする. Onomatopée '
              'expressive à l\'origine, très courante à l\'oral.',
        ),
        VocabEntry(
          id: 'ja-v-urayamashii',
          target: 'うらやましい',
          native: 'envieux (admiratif, pas négatif)',
          pos: 'adjectif',
          romanization: 'urayamashii',
          example: 'あなたの　せいかつが　うらやましいです。',
          exampleNative: 'J\'envie votre style de vie (admiration).',
          note: 'Contrairement au français où "envieux" sonne souvent '
              'négatif, うらやましい est un compliment sincère porté à ce que '
              'quelqu\'un d\'autre a ou vit.',
        ),
        VocabEntry(
          id: 'ja-v-tanoshimi',
          target: 'たのしみ',
          native: 'hâte, quelque chose qu\'on attend avec plaisir',
          pos: 'nom',
          romanization: 'tanoshimi',
          example: 'りょこうが　たのしみです。',
          exampleNative: 'J\'ai hâte d\'être en voyage.',
          note: 'Expression figée très fréquente : X が たのしみです ("j\'ai '
              'hâte de/pour X"), jamais de verbe "avoir hâte" à proprement '
              'parler en japonais.',
        ),
        VocabEntry(
          id: 'ja-v-sabishii',
          target: 'さびしい',
          native: 'triste de l\'absence de qqn, seul(e) qui manque',
          pos: 'adjectif',
          romanization: 'sabishii',
          example: 'あなたが　いなくて　さびしいです。',
          exampleNative: 'Tu me manques, je me sens seul sans toi.',
          note: 'Different de ひとりで (seul physiquement) : さびしい porte '
              'sur le sentiment d\'un manque affectif, avec ou sans '
              'solitude physique.',
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
