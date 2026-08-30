import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';
import 'package:learning_app/data/models/story.dart';

StoryLine _jaLine(
  String source, {
  required String native,
  String? speaker,
  String? note,
  String? romanization,
}) =>
    StoryLine.parse(source,
        native: native,
        speaker: speaker,
        note: note,
        romanization: romanization);

/// Japanese course for French speakers.
///
/// Word order is close to Turkish in spirit (verb-final, particles instead
/// of prepositions) but the surface is entirely different: every sentence
/// mixes hiragana (grammar), katakana (loanwords) and kanji (content words),
/// so cards here are written the way a real sentence would be — not
/// romanized — with romaji carried in [CardItem.romanization] as a reading
/// aid, exactly like pinyin does for Mandarin. Kanji used in cards is
/// limited to the starter set taught in the kanji lab
/// (`data/kana/kanji.dart`), so nothing on a card is unglossed.
final courseJa = Course(
  languageCode: 'ja',
  ttsLocale: 'ja-JP',
  units: [
    Unit(
      id: 'ja-u1',
      title: 'Premiers pas',
      subtitle: 'Se presenter poliment',
      level: 'A1',
      grammarLesson: _u1Grammar,
      cards: [
        const CardItem(
          id: 'ja-1-1',
          target: 'こんにちは。',
          native: 'Bonjour.',
          gloss: 'Bonjour (dans la journee).',
          romanization: 'Konnichiwa.',
          tokens: ['こんにちは。'],
          distractors: ['こんばんは。', 'おはよう。'],
          focus: 'Salutation neutre, utilisable l\'apres-midi',
        ),
        const CardItem(
          id: 'ja-1-2',
          target: 'はじめまして。',
          native: 'Enchante (a la premiere rencontre).',
          gloss: 'Pour-la-premiere-fois.',
          romanization: 'Hajimemashite.',
          tokens: ['はじめまして。'],
          distractors: ['さようなら。', 'すみません。'],
          focus: 'Phrase figee, seulement a la toute premiere rencontre',
        ),
        const CardItem(
          id: 'ja-1-3',
          target: 'わたしはフランスじんです。',
          native: 'Je suis français(e).',
          gloss: 'Moi-topic Français-personne-suis.',
          romanization: 'Watashi wa furansujin desu.',
          tokens: ['わたしは', 'フランスじんです。'],
          distractors: ['わたしが', 'フランスじんでした。', 'フランスじんの'],
          focus: 'は marque le sujet dont on parle (topic), です = "suis/est"',
        ),
        const CardItem(
          id: 'ja-1-4',
          target: 'どうぞよろしくおねがいします。',
          native: 'Ravi de faire votre connaissance.',
          gloss: 'S\'il-vous-plait bien-veuillez-me-traiter.',
          romanization: 'Douzo yoroshiku onegaishimasu.',
          tokens: ['どうぞ', 'よろしく', 'おねがいします。'],
          distractors: ['ありがとう', 'すみません', 'おねがいしました。'],
          focus: 'Formule figee dite juste apres はじめまして',
        ),
        const CardItem(
          id: 'ja-1-5',
          target: 'おなまえはなんですか。',
          native: 'Quel est votre nom ?',
          gloss: 'Honorifique-nom-topic quoi-est ?',
          romanization: 'Onamae wa nan desu ka.',
          tokens: ['おなまえは', 'なんですか。'],
          distractors: ['おなまえが', 'だれですか。', 'なにでしたか。'],
          focus: 'か final transforme une phrase en question, sans inversion',
        ),
        const CardItem(
          id: 'ja-1-6',
          target: 'ありがとうございます。',
          native: 'Merci beaucoup (poli).',
          gloss: 'Merci-poli.',
          romanization: 'Arigatou gozaimasu.',
          tokens: ['ありがとうございます。'],
          distractors: ['ありがとう。', 'すみません。', 'どういたしまして。'],
          focus: 'ございます ajoute le niveau de politesse formelle',
        ),
      ],
    ),
    const Unit(
      id: 'ja-u2',
      title: 'Objets et lieux',
      subtitle: 'Designer et situer les choses',
      level: 'A1',
      grammarLesson: _u2Grammar,
      cards: [
        const CardItem(
          id: 'ja-2-1',
          target: 'これはほんです。',
          native: 'Ceci est un livre.',
          gloss: 'Ceci-topic livre-est.',
          romanization: 'Kore wa hon desu.',
          tokens: ['これは', 'ほんです。'],
          distractors: ['それは', 'あれは', 'ほんでした。'],
          focus: 'これ = "ceci" (pres de moi)',
        ),
        const CardItem(
          id: 'ja-2-2',
          target: 'それはわたしのかばんです。',
          native: 'Ça, c\'est mon sac.',
          gloss: 'Cela-topic moi-de sac-est.',
          romanization: 'Sore wa watashi no kaban desu.',
          tokens: ['それは', 'わたしの', 'かばんです。'],
          distractors: ['あなたの', 'わたしは', 'かばんでした。'],
          focus: 'の relie un possesseur a ce qu\'il possede, comme "de"',
        ),
        const CardItem(
          id: 'ja-2-3',
          target: 'テーブルのうえにねこがいます。',
          native: 'Il y a un chat sur la table.',
          gloss: 'Table-de dessus-a chat-sujet est(anime).',
          romanization: 'Teeburu no ue ni neko ga imasu.',
          tokens: ['テーブルの', 'うえに', 'ねこが', 'います。'],
          distractors: ['あります。', 'ねこは', 'したに'],
          focus: 'います pour les etres anime (personnes, animaux)',
        ),
        const CardItem(
          id: 'ja-2-4',
          target: 'つくえのうえにほんがあります。',
          native: 'Il y a un livre sur le bureau.',
          gloss: 'Bureau-de dessus-a livre-sujet est(inanime).',
          romanization: 'Tsukue no ue ni hon ga arimasu.',
          tokens: ['つくえの', 'うえに', 'ほんが', 'あります。'],
          distractors: ['います。', 'ほんは', 'したに'],
          focus: 'あります pour les objets et plantes (inanimes)',
        ),
        const CardItem(
          id: 'ja-2-5',
          target: 'トイレはどこですか。',
          native: 'Où sont les toilettes ?',
          gloss: 'Toilettes-topic ou-est ?',
          romanization: 'Toire wa doko desu ka.',
          tokens: ['トイレは', 'どこですか。'],
          distractors: ['なんですか。', 'だれですか。', 'どこでしたか。'],
          focus: 'どこ = "ou", un des mots interrogatifs de base',
        ),
      ],
    ),
    const Unit(
      id: 'ja-u3',
      title: 'Actions du quotidien',
      subtitle: 'La forme -ます au present et au passe',
      level: 'A1',
      grammarLesson: _u3Grammar,
      cards: [
        const CardItem(
          id: 'ja-3-1',
          target: 'まいあさパンをたべます。',
          native: 'Je mange du pain tous les matins.',
          gloss: 'Chaque-matin pain-objet mange.',
          romanization: 'Mai asa pan o tabemasu.',
          tokens: ['まいあさ', 'パンを', 'たべます。'],
          distractors: ['たべました。', 'パンが', 'たべません。'],
          focus: 'を marque l\'objet direct du verbe',
        ),
        const CardItem(
          id: 'ja-3-2',
          target: 'きのうコーヒーをのみました。',
          native: 'Hier, j\'ai bu du café.',
          gloss: 'Hier café-objet ai-bu.',
          romanization: 'Kinou koohii o nomimashita.',
          tokens: ['きのう', 'コーヒーを', 'のみました。'],
          distractors: ['のみます。', 'コーヒーが', 'のみません。'],
          focus: 'ました = passe poli de ます',
        ),
        const CardItem(
          id: 'ja-3-3',
          target: 'にちようびにがっこうへいきません。',
          native: 'Je ne vais pas à l\'école le dimanche.',
          gloss: 'Dimanche-a ecole-vers ne-vais-pas.',
          romanization: 'Nichiyoubi ni gakkou e ikimasen.',
          tokens: ['にちようびに', 'がっこうへ', 'いきません。'],
          distractors: ['いきます。', 'がっこうを', 'いきませんでした。'],
          focus: 'ません = negatif poli present ; に marque un point dans le temps',
        ),
        const CardItem(
          id: 'ja-3-4',
          target: 'としょかんでほんをよみます。',
          native: 'Je lis un livre à la bibliothèque.',
          gloss: 'Bibliotheque-a(lieu) livre-objet lis.',
          romanization: 'Toshokan de hon o yomimasu.',
          tokens: ['としょかんで', 'ほんを', 'よみます。'],
          distractors: ['としょかんに', 'よみました。', 'ほんが'],
          focus: 'で marque le lieu ou une action se deroule (different de に)',
        ),
        const CardItem(
          id: 'ja-3-5',
          target: 'ともだちとえいがをみました。',
          native: 'J\'ai vu un film avec un ami.',
          gloss: 'Ami-avec film-objet ai-vu.',
          romanization: 'Tomodachi to eiga o mimashita.',
          tokens: ['ともだちと', 'えいがを', 'みました。'],
          distractors: ['ともだちに', 'みます。', 'えいがが'],
          focus: 'と = "avec" entre deux personnes qui font l\'action ensemble',
        ),
        const CardItem(
          id: 'ja-3-6',
          target: 'でんしゃでかいしゃにいきます。',
          native: 'Je vais au bureau en train.',
          gloss: 'Train-par(moyen) bureau-vers vais.',
          romanization: 'Densha de kaisha ni ikimasu.',
          tokens: ['でんしゃで', 'かいしゃに', 'いきます。'],
          distractors: ['でんしゃに', 'かいしゃで', 'いきました。'],
          focus: 'で marque aussi le moyen de transport ; に marque la destination',
        ),
      ],
    ),
    const Unit(
      id: 'ja-u4',
      title: 'Décrire',
      subtitle: 'Adjectifs en い et adjectifs en な',
      level: 'A2',
      grammarLesson: _u4Grammar,
      cards: [
        const CardItem(
          id: 'ja-4-1',
          target: 'このみせはたかいです。',
          native: 'Ce magasin est cher.',
          gloss: 'Ce-magasin-topic cher-est.',
          romanization: 'Kono mise wa takai desu.',
          tokens: ['このみせは', 'たかいです。'],
          distractors: ['たかいでした。', 'たかくないです。', 'たかいな'],
          focus: 'Adjectif en い : porte lui-meme le present, です n\'ajoute que la politesse',
        ),
        const CardItem(
          id: 'ja-4-2',
          target: 'このみせはたかくないです。',
          native: 'Ce magasin n\'est pas cher.',
          gloss: 'Ce-magasin-topic cher-pas-est.',
          romanization: 'Kono mise wa takakunai desu.',
          tokens: ['このみせは', 'たかくないです。'],
          distractors: ['たかいです。', 'たかいくない', 'たかくなかった'],
          focus: 'Negatif d\'un adjectif en い : い devient くない',
        ),
        const CardItem(
          id: 'ja-4-3',
          target: 'きのうはあつかったです。',
          native: 'Hier, il faisait chaud.',
          gloss: 'Hier-topic chaud-etait.',
          romanization: 'Kinou wa atsukatta desu.',
          tokens: ['きのうは', 'あつかったです。'],
          distractors: ['あついです。', 'あつくないです。', 'あつかったでした。'],
          focus: 'Passe d\'un adjectif en い : い devient かった',
        ),
        const CardItem(
          id: 'ja-4-4',
          target: 'このまちはきれいです。',
          native: 'Cette ville est belle/propre.',
          gloss: 'Cette ville-topic belle-est.',
          romanization: 'Kono machi wa kirei desu.',
          tokens: ['この', 'まちは', 'きれいです。'],
          distractors: ['きれいいです。', 'きれいな', 'きれかったです。'],
          focus: 'きれい est un adjectif en な malgre son い final : ne pas le conjuguer comme un adjectif en い',
        ),
        const CardItem(
          id: 'ja-4-5',
          target: 'しずかなへやがすきです。',
          native: 'J\'aime les chambres calmes.',
          gloss: 'Calme-na chambre-sujet aimee-est.',
          romanization: 'Shizuka na heya ga suki desu.',
          tokens: ['しずかな', 'へやが', 'すきです。'],
          distractors: ['しずかい', 'へやを', 'すきいです。'],
          focus: 'Un adjectif en な prend な seulement devant un nom',
        ),
      ],
    ),
    const Unit(
      id: 'ja-u5',
      title: 'Poli et familier',
      subtitle: 'La forme neutre (辞書形) a cote du ます',
      level: 'A2',
      grammarLesson: _u5Grammar,
      cards: [
        const CardItem(
          id: 'ja-5-1',
          target: 'まいにちにほんごをべんきょうする。',
          native: 'J\'étudie le japonais tous les jours. (familier)',
          gloss: 'Chaque-jour japonais-objet etudier(forme neutre).',
          romanization: 'Mainichi nihongo o benkyou suru.',
          tokens: ['まいにち', 'にほんごを', 'べんきょうする。'],
          distractors: ['べんきょうします。', 'べんきょうした。', 'べんきょうしない。'],
          focus: 'する = forme neutre/dictionnaire, utilisee entre amis ou dans un journal',
        ),
        const CardItem(
          id: 'ja-5-2',
          target: 'あした、ともだちにあう。',
          native: 'Demain, je vois un ami. (familier)',
          gloss: 'Demain, ami-a rencontrer(neutre).',
          romanization: 'Ashita, tomodachi ni au.',
          tokens: ['あした、', 'ともだちに', 'あう。'],
          distractors: ['あいます。', 'あった。', 'あわない。'],
          focus: 'に marque la personne qu\'on rencontre',
        ),
        const CardItem(
          id: 'ja-5-3',
          target: 'それ、しらない。',
          native: 'Ça, je (ne le) sais pas. (familier)',
          gloss: 'Cela, ne-sais-pas(neutre).',
          romanization: 'Sore, shiranai.',
          tokens: ['それ、', 'しらない。'],
          distractors: ['しりません。', 'しった。', 'しる。'],
          focus: 'Negatif neutre : る devient らない pour ce verbe irregulier de sens',
        ),
        const CardItem(
          id: 'ja-5-4',
          target: 'せんせいはがっこうにいらっしゃいます。',
          native: 'Le professeur est à l\'école. (très poli)',
          gloss: 'Professeur-topic ecole-a est(honorifique).',
          romanization: 'Sensei wa gakkou ni irasshaimasu.',
          tokens: ['せんせいは', 'がっこうに', 'いらっしゃいます。'],
          distractors: ['います。', 'いる。', 'いらっしゃる。'],
          focus: 'いらっしゃいます = forme honorifique de います, utilisee pour une personne qu\'on respecte',
        ),
      ],
    ),
    const Unit(
      id: 'ja-u6',
      title: 'Enchaîner les actions',
      subtitle: 'La forme て',
      level: 'A2',
      grammarLesson: _u6Grammar,
      cards: [
        const CardItem(
          id: 'ja-6-1',
          target: 'あさおきて、シャワーをあびます。',
          native: 'Le matin, je me lève et je prends une douche.',
          gloss: 'Matin se-lever-et, douche-objet prends.',
          romanization: 'Asa okite, shawaa o abimasu.',
          tokens: ['あさ', 'おきて、', 'シャワーを', 'あびます。'],
          distractors: ['おきます、', 'おきた、', 'あびて。'],
          focus: 'La forme て relie deux actions dans l\'ordre, sans repeter le sujet',
        ),
        const CardItem(
          id: 'ja-6-2',
          target: 'ここでまってください。',
          native: 'Attendez ici, s\'il vous plaît.',
          gloss: 'Ici attendre-et s\'il-vous-plait.',
          romanization: 'Koko de matte kudasai.',
          tokens: ['ここで', 'まって', 'ください。'],
          distractors: ['まちます', 'まった', 'ください'],
          focus: 'て + ください = demande polie',
        ),
        const CardItem(
          id: 'ja-6-3',
          target: 'いま、ばんごはんをたべています。',
          native: 'Je suis en train de dîner.',
          gloss: 'Maintenant, diner-objet mange-en-train.',
          romanization: 'Ima, bangohan o tabete imasu.',
          tokens: ['いま、', 'ばんごはんを', 'たべています。'],
          distractors: ['たべます。', 'たべました。', 'たべて。'],
          focus: 'て + います = action en cours, comme "etre en train de"',
        ),
        const CardItem(
          id: 'ja-6-4',
          target: 'でんきをけして、ねました。',
          native: 'J\'ai éteint la lumière et je me suis couché.',
          gloss: 'Electricite-objet eteindre-et, ai-dormi.',
          romanization: 'Denki o keshite, nemashita.',
          tokens: ['でんきを', 'けして、', 'ねました。'],
          distractors: ['けします、', 'けした、', 'ねて。'],
          focus: 'Meme logique que 6-1 : て enchaine, seul le dernier verbe porte le temps',
        ),
      ],
    ),
  ],
);

final _u1Grammar = GrammarLesson(
  title: 'は, です, et les niveaux de politesse',
  hook: 'Le japonais courant repose sur trois reflexes des la premiere '
      'phrase : annoncer le sujet avec は, conclure avec です, et choisir '
      'un registre de politesse — rien de tout cela n\'a d\'equivalent '
      'direct en français.',
  longForm: LongFormContent(
    narrative: [
      'Une phrase française commence presque toujours par son sujet, '
          'suivi immédiatement du verbe : "Je suis étudiant." Le japonais '
          'inverse cette logique de deux façons à la fois. D\'abord, il '
          'annonce le sujet avec une particule dédiée, は (prononcée "wa" '
          'dans ce rôle précis), qui ne se traduit par rien en français — '
          'elle signale seulement "voici de quoi je vais parler". Ensuite, '
          'le verbe n\'arrive jamais avant la fin de la phrase : わたしは '
          'がくせいです se découpe littéralement en "moi (sujet) / étudiant '
          '(attribut) / suis", le verbe fermant la phrase au lieu de '
          'l\'ouvrir.',
      'Un francophone cherche presque toujours un équivalent à は, et '
          'c\'est l\'erreur à éviter : ce n\'est ni un pronom, ni un article, '
          'ni une marque du sujet grammatical au sens où le français '
          'l\'entend (le japonais a une autre particule, が, pour ça). は '
          'marque le THÈME de la phrase — ce dont on parle — et peut porter '
          'aussi bien sur une personne, un objet, un lieu ou une idée. '
          'Traduire は par "je" ou "ce" mot à mot mène régulièrement à des '
          'phrases qui sonnent juste en apparence mais trahissent une '
          'incompréhension du mécanisme.',
      'Le deuxième réflexe à construire porte sur la politesse, qui en '
          'japonais n\'est pas une nuance de ton mais un choix de forme '
          'verbale obligatoire. です et ます sont le degré poli standard, '
          'celui qu\'on apprend en premier et qu\'on utilise par défaut avec '
          'des inconnus, des collègues, dans n\'importe quelle situation '
          'neutre. La forme familière (だ, ou le verbe seul) existe, mais '
          'l\'employer trop tôt avec quelqu\'un qu\'on ne connaît pas produit '
          'le même effet qu\'un tutoiement intempestif en français : ce '
          'n\'est pas incompréhensible, c\'est déplacé.',
      'Retiens donc l\'ordre des opérations pour une phrase japonaise '
          'simple : d\'abord le thème suivi de は, puis l\'information '
          'nouvelle, puis です/ます à la fin pour clore poliment. Cet ordre '
          'ne varie presque jamais, ce qui en fait, paradoxalement, l\'une '
          'des structures les plus prévisibles à apprendre — une fois '
          'qu\'on a arrêté de chercher où placer le verbe "comme en '
          'français".',
    ],
    dialogue: [
      _jaLine(
        '[はじめまして|enchanté|hajimemashite]。[わたしは|moi (thème)|watashi wa][たなかです|je suis Tanaka|Tanaka desu]。',
        speaker: 'Tanaka',
        native: 'Enchanté. Je suis Tanaka.',
        note: 'わたしは introduit le thème (moi), たなかです ferme la phrase '
            'avec le verbe : ordre thème → information → です.',
      ),
      _jaLine(
        '[はじめまして|enchanté|hajimemashite]。[わたしも|moi aussi (thème)|watashi mo][がくせいです|je suis étudiant|gakusei desu]。',
        speaker: 'Léa',
        native: 'Enchantée. Moi aussi je suis étudiante.',
        note: 'も remplace は pour dire "moi AUSSI" — même position, même '
            'rôle de marqueur de thème.',
      ),
      _jaLine(
        '[たなかさんは|Tanaka (thème, poli)|Tanaka-san wa][にほんじんですか|êtes-vous japonais ?|nihonjin desu ka]？',
        speaker: 'Léa',
        native: 'Monsieur Tanaka, êtes-vous japonais ?',
        note: 'か final transforme l\'affirmation en question, sans '
            'inversion : même ordre des mots, juste か ajouté.',
      ),
      _jaLine(
        '[はい|oui|hai]，[にほんじんです|je suis japonais|nihonjin desu]。[れいさんは|et vous, Léa (thème)|Rei-san wa]？',
        speaker: 'Tanaka',
        native: 'Oui, je suis japonais. Et vous, Léa ?',
        note: 'さん après un nom marque le respect ; on ne l\'utilise '
            'jamais pour se désigner soi-même.',
      ),
      _jaLine(
        '[わたしは|moi (thème)|watashi wa][フランスじんです|je suis française|furansujin desu]。',
        speaker: 'Léa',
        native: 'Moi, je suis française.',
      ),
      _jaLine(
        '[どうぞよろしく|ravi de vous connaître|dōzo yoroshiku]。',
        speaker: 'Tanaka',
        native: 'Ravi de faire votre connaissance.',
        note: 'Formule figée de clôture, quasi obligatoire après une '
            'première présentation polie.',
      ),
    ],
    walkthroughs: [
      WorkedExample(
        target: 'わたしはがくせいです。',
        native: 'Je suis étudiant.',
        romanization: 'Watashi wa gakusei desu.',
        parts: [
          WorkedExamplePart(
            chunk: 'わたし',
            explanation: '"je/moi" — le pronom qui sera le thème de la '
                'phrase.',
          ),
          WorkedExamplePart(
            chunk: 'は',
            explanation:
                'particule de thème (prononcée "wa" ici) : annonce que la '
                'phrase va parler de わたし. Aucune traduction directe en '
                'français.',
          ),
          WorkedExamplePart(
            chunk: 'がくせい',
            explanation:
                'l\'information nouvelle sur le thème : "étudiant", posée '
                'sans verbe pour l\'instant.',
          ),
          WorkedExamplePart(
            chunk: 'です',
            explanation:
                'copule polie qui ferme la phrase et joue le rôle du verbe '
                '"être" : elle vient toujours en dernier, jamais entre le '
                'thème et l\'attribut.',
          ),
        ],
      ),
      WorkedExample(
        target: 'たなかさんはにほんじんですか。',
        native: 'Monsieur Tanaka est-il japonais ?',
        romanization: 'Tanaka-san wa nihonjin desu ka.',
        parts: [
          WorkedExamplePart(
            chunk: 'たなかさん',
            explanation:
                'nom + さん (marque de respect) : jamais utilisé pour '
                'soi-même, réservé à autrui.',
          ),
          WorkedExamplePart(
            chunk: 'は',
            explanation:
                'même particule de thème que dans l\'exemple précédent : '
                'la phrase va parler de Tanaka.',
          ),
          WorkedExamplePart(
            chunk: 'にほんじん',
            explanation: '"japonais (nationalité)" — l\'information posée '
                'sur le thème.',
          ),
          WorkedExamplePart(
            chunk: 'です',
            explanation: 'copule polie, identique à l\'affirmative.',
          ),
          WorkedExamplePart(
            chunk: 'か。',
            explanation:
                'particule finale de question : transforme l\'affirmation '
                'en question sans toucher à l\'ordre des mots, contrairement '
                'à l\'inversion sujet-auxiliaire du français ou de '
                'l\'anglais.',
          ),
        ],
      ),
    ],
  ),
  blocks: [
    ExplanationBlock(
      heading: 'は marque le sujet dont on parle',
      body: 'は (prononce "wa" dans ce role) ne se traduit pas : il annonce '
          'simplement "voici de quoi je parle". わたしは フランスじんです se '
          'decoupe en "moi (topic) / Français (attribut) / suis". Le verbe '
          '"etre" (です) vient toujours a la fin.',
    ),
    ExampleBlock(
      heading: 'La meme structure, trois sujets',
      examples: [
        GrammarExample(
          target: 'わたしはがくせいです。',
          native: 'Je suis étudiant.',
          romanization: 'Watashi wa gakusei desu.',
        ),
        GrammarExample(
          target: 'かのじょはせんせいです。',
          native: 'Elle est professeure.',
          romanization: 'Kanojo wa sensei desu.',
        ),
        GrammarExample(
          target: 'これはわたしのほんです。',
          native: 'Ceci est mon livre.',
          romanization: 'Kore wa watashi no hon desu.',
          note: 'は peut porter sur une personne ou une chose : c\'est un '
              'marqueur grammatical, pas un pronom.',
        ),
      ],
    ),
    TableBlock(
      caption: 'Trois degres de politesse pour une meme idee',
      headers: ['Registre', 'Exemple', 'Usage'],
      rows: [
        ['Tres poli', 'いらっしゃいます', 'clients, superieurs, personnes agees'],
        ['Poli standard (です/ます)', 'います', 'inconnus, collegues — le defaut a apprendre'],
        ['Familier', 'いる', 'famille, amis proches, meme age'],
      ],
    ),
    MistakeBlock(
      wrong: 'わたしは がくせいだ。 (dit a un inconnu)',
      right: 'わたしは がくせいです。',
      why: 'だ est la forme neutre de です : grammaticalement juste, mais '
          'trop familiere pour une premiere rencontre. Tant que le contexte '
          'n\'est pas explicitement etabli comme informel, です/ます reste le '
          'choix par defaut, exactement comme le vouvoiement en français.',
    ),
  ],
);

const _u2Grammar = GrammarLesson(
  title: 'これ/それ/あれ, の, et います vs あります',
  hook: 'Designer un objet et dire "il y a" suivent deux logiques bien plus '
      'systematiques qu\'en français, une fois les bonnes categories '
      'reperees.',
  blocks: [
    ExplanationBlock(
      heading: 'La distance a trois niveaux',
      body: 'Le français a "ceci/cela", le japonais a trois positions : これ '
          '(pres de moi), それ (pres de toi), あれ (loin de nous deux). Le '
          'meme systeme se retrouve dans この/その/あの (+ nom) et ここ/そこ/あそこ '
          '(ici/la/la-bas).',
    ),
    TableBlock(
      caption: 'Le systeme こそあ',
      headers: ['Pres de moi', 'Pres de toi', 'Loin des deux', 'Lequel ?'],
      rows: [
        ['これ (ceci)', 'それ (cela)', 'あれ (cela, la-bas)', 'どれ'],
        ['この + nom', 'その + nom', 'あの + nom', 'どの + nom'],
        ['ここ (ici)', 'そこ (la)', 'あそこ (la-bas)', 'どこ'],
      ],
    ),
    ExplanationBlock(
      heading: 'います pour le vivant, あります pour le reste',
      body: 'Le japonais a deux verbes "il y a" selon que le sujet peut se '
          'deplacer par lui-meme : います pour les personnes et animaux, '
          'あります pour les objets, plantes et evenements. Confondre les deux '
          'est la faute la plus frequente des debutants — et elle ne '
          'pardonne pas, car elle change litteralement de verbe.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'こどもがいます。',
          native: 'Il y a un enfant.',
          romanization: 'Kodomo ga imasu.',
          note: 'こども (enfant) est anime -> います',
        ),
        GrammarExample(
          target: 'テーブルがあります。',
          native: 'Il y a une table.',
          romanization: 'Teeburu ga arimasu.',
          note: 'テーブル (table) est inanime -> あります',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'ねこが あります。',
      right: 'ねこが います。',
      why: 'Un chat peut se deplacer seul : c\'est toujours います, jamais '
          'あります, meme si le chat est immobile au moment ou l\'on parle.',
    ),
  ],
);

const _u3Grammar = GrammarLesson(
  title: 'を, に, で : trois particules, trois roles',
  hook: 'Le japonais n\'a pas de prepositions avant le nom : c\'est une '
      'particule apres le nom qui dit son role dans la phrase — et を, に, で '
      'sont les trois qu\'un debutant utilise dans presque chaque phrase.',
  blocks: [
    TableBlock(
      caption: 'Qui fait quoi',
      headers: ['Particule', 'Role', 'Exemple'],
      rows: [
        ['を', 'objet direct du verbe', 'パンを たべます (mange du pain)'],
        ['に', 'destination, point dans le temps, personne visee', 'がっこうに いきます (vais a l\'ecole)'],
        ['で', 'lieu de l\'action, moyen/instrument', 'いえで たべます (mange a la maison)'],
      ],
    ),
    ExplanationBlock(
      heading: 'に vs で : le piege classique',
      body: 'に marque une destination ou un point fixe (aller VERS, exister '
          'A un endroit) ; で marque le lieu OU une action se produit. '
          '"がっこうに いきます" (destination) mais "がっこうで べんきょうします" '
          '(l\'etude se produit a l\'ecole). Le meme mot がっこう prend une '
          'particule differente selon ce que fait le verbe.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'こうえんにいきます。',
          native: 'Je vais au parc.',
          romanization: 'Kouen ni ikimasu.',
          note: 'に : destination du deplacement',
        ),
        GrammarExample(
          target: 'こうえんであそびます。',
          native: 'Je joue au parc.',
          romanization: 'Kouen de asobimasu.',
          note: 'で : lieu ou l\'action de jouer se deroule',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'でんしゃに べんきょうします。',
      right: 'でんしゃで べんきょうします。',
      why: 'Etudier se deroule DANS le train : c\'est un lieu d\'action, donc '
          'で. に serait correct seulement si "train" etait une destination, '
          'ce qui n\'a pas de sens ici.',
    ),
  ],
);

const _u4Grammar = GrammarLesson(
  title: 'Adjectifs en い et adjectifs en な',
  hook: 'Le japonais a deux familles d\'adjectifs qui se conjuguent selon '
      'des regles differentes — les confondre produit des formes qui '
      'sonnent immediatement fautives.',
  blocks: [
    ExplanationBlock(
      heading: 'Deux familles, deux conjugaisons',
      body: 'Les adjectifs en い (たかい, おいしい, あつい) se conjuguent seuls, '
          'sans です pour porter le temps : です ne fait qu\'ajouter la '
          'politesse. Les adjectifs en な (きれい, しずか, げんき) se comportent '
          'comme des noms : ils prennent な devant un nom et se conjuguent '
          'avec です/だ comme un nom le ferait.',
    ),
    TableBlock(
      caption: 'Conjugaison de たかい (cher) — adjectif en い',
      headers: ['Forme', 'Japonais', 'Sens'],
      rows: [
        ['Present affirmatif', 'たかいです', 'est cher'],
        ['Present negatif', 'たかくないです', 'n\'est pas cher'],
        ['Passe affirmatif', 'たかかったです', 'etait cher'],
        ['Passe negatif', 'たかくなかったです', 'n\'etait pas cher'],
      ],
    ),
    TableBlock(
      caption: 'Conjugaison de しずか (calme) — adjectif en な',
      headers: ['Forme', 'Japonais', 'Sens'],
      rows: [
        ['Present affirmatif', 'しずかです', 'est calme'],
        ['Present negatif', 'しずかじゃないです', 'n\'est pas calme'],
        ['Devant un nom', 'しずかな へや', 'une chambre calme'],
      ],
    ),
    MistakeBlock(
      wrong: 'きれいい へや',
      right: 'きれいな へや',
      why: 'きれい se termine par い a l\'oral mais appartient a la famille '
          'des adjectifs en な (comme げんき, きらい) : un petit groupe '
          'd\'exceptions a apprendre par cœur plutot qu\'a deviner par la '
          'forme.',
    ),
  ],
);

const _u5Grammar = GrammarLesson(
  title: 'La forme neutre, a cote de ます',
  hook: 'ます n\'est qu\'un des deux presents du japonais : la forme neutre '
      '(dictionnaire) est necessaire pour parler avec des proches, lire un '
      'roman, ou chercher un verbe dans un dictionnaire.',
  blocks: [
    ExplanationBlock(
      heading: 'Deux registres, une seule grammaire',
      body: 'Chaque verbe a une forme neutre (たべる, いく, する...) et une '
          'forme polie (たべます, いきます, します...). Ce n\'est pas une '
          'nuance de sens : c\'est un choix de registre, comme choisir "tu" '
          'ou "vous". Les manuels enseignent d\'abord ます parce qu\'il est '
          'toujours poli et jamais deplace ; la forme neutre vient ensuite, '
          'des qu\'on cotoie des japonais dans un cadre informel.',
    ),
    TableBlock(
      caption: 'Correspondance ます / forme neutre pour les verbes courants',
      headers: ['Poli (ます)', 'Neutre (forme dictionnaire)', 'Sens'],
      rows: [
        ['たべます', 'たべる', 'manger'],
        ['のみます', 'のむ', 'boire'],
        ['いきます', 'いく', 'aller'],
        ['みます', 'みる', 'voir'],
        ['します', 'する', 'faire'],
        ['きます', 'くる', 'venir'],
      ],
    ),
    ExplanationBlock(
      heading: 'Le negatif neutre',
      body: 'Le negatif neutre remplace le う final par わない (のむ -> のまない), '
          'ou transforme る en ない pour les verbes en る (たべる -> たべない). '
          'する et くる sont irreguliers : しない, こない.',
    ),
    MistakeBlock(
      wrong: 'ともだちに、いきます。 (dit a un ami proche)',
      right: 'ともだちに、いく。',
      why: 'Utiliser ます entre amis proches n\'est pas incorrect '
          'grammaticalement, mais sonne distant — l\'equivalent de vouvoyer '
          'un ami d\'enfance. Le registre doit suivre la relation, pas '
          'l\'inverse.',
    ),
  ],
);

const _u6Grammar = GrammarLesson(
  title: 'La forme て : enchainer et decrire une action en cours',
  hook: 'Une seule transformation du verbe ouvre trois usages essentiels : '
      'enchainer des actions, demander poliment, et dire qu\'une action est '
      'en train de se produire.',
  blocks: [
    ExplanationBlock(
      heading: 'Formation de la forme て',
      body: 'Pour les verbes en る : remplacer る par て (たべる -> たべて). Pour '
          'les verbes en う (forme neutre finissant par う/く/ぐ/す/つ/ぬ/ぶ/む/る), '
          'la terminaison change selon un ensemble de regles regulieres, par '
          'exemple く -> いて (かく -> かいて), む/ぬ/ぶ -> んで (のむ -> のんで). '
          'する -> して et くる -> きて sont irreguliers.',
    ),
    TableBlock(
      caption: 'Trois usages de la forme て',
      headers: ['Usage', 'Exemple', 'Sens'],
      rows: [
        ['Enchainer deux actions', 'おきて、たべます', 'je me leve et je mange'],
        ['Demande polie', 'まって ください', 'attendez, s\'il vous plait'],
        ['Action en cours', 'たべています', 'je suis en train de manger'],
      ],
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'あさごはんをたべて、がっこうにいきます。',
          native: 'Je prends le petit-déjeuner et je vais à l\'école.',
          romanization: 'Asagohan o tabete, gakkou ni ikimasu.',
          note: 'Le premier verbe (たべて) ne porte ni temps ni politesse : '
              'seul le dernier verbe de la chaine les porte.',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'たべますて、いきます。',
      right: 'たべて、いきます。',
      why: 'La forme て remplace ます, elle ne s\'y ajoute pas : on part '
          'toujours de la forme neutre (たべる) pour construire たべて.',
    ),
  ],
);
