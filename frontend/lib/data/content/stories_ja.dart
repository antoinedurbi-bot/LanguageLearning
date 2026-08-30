import 'package:learning_app/data/models/story.dart';

/// Japanese texts are bracketed exhaustively, the same way Mandarin ones
/// are: Japanese is written without spaces between words, so a reader who
/// cannot yet segment a sentence sees an undifferentiated string of kana and
/// kanji. Every chunk here is cut by hand at the word boundary and carries
/// its romaji reading.
StoryLine _l(
  String source, {
  required String native,
  required String romanization,
  String? speaker,
  String? note,
}) =>
    StoryLine.parse(source,
        native: native,
        romanization: romanization,
        speaker: speaker,
        note: note);

final storiesJa = <Story>[
  Story(
    id: 'ja-story-cafe',
    languageCode: 'ja',
    title: 'カフェで',
    titleNative: 'Au café',
    blurb: 'Le premier vrai dialogue : commander, payer, et les formules '
        'polies qui encadrent l\'échange. Chaque bloc porte sa lecture '
        'romaji.',
    level: StoryLevel.first,
    takeaway: 'Trois structures à emporter : ...を おねがいします (pour '
        'commander), いくらですか (combien ça coûte) et ありがとうございます '
        '(merci poli). Elles suffisent pour tout achat simple.',
    lines: [
      _l('[いらっしゃいませ|bienvenue|irasshaimase]。',
          speaker: '店員 · le serveur',
          native: 'Bienvenue !',
          romanization: 'Irasshaimase.',
          note: 'Formule figée dite par tout commerçant à l\'entrée d\'un '
              'client : on ne répond jamais "merci" en retour, on l\'ignore '
              'poliment.'),
      _l('[コーヒー|café|koohii][を|(objet)|o][ひとつ|un(objet)|hitotsu]'
              '[おねがいします|s\'il vous plaît|onegaishimasu]。',
          speaker: '客 · le client',
          native: 'Un café, s\'il vous plaît.',
          romanization: 'Koohii o hitotsu onegaishimasu.',
          note: 'ひとつ = "un" pour un objet compté sans compteur spécial — '
              'la série ひとつ、ふたつ、みっつ... couvre la plupart des objets du '
              'quotidien.'),
      _l('[かしこまりました|bien compris (très poli)|kashikomarimashita]。',
          speaker: '店員 · le serveur',
          native: 'Bien reçu.',
          romanization: 'Kashikomarimashita.',
          note: 'Version très polie de わかりました, utilisée par le personnel '
              'de service envers les clients.'),
      _l('[すみません|excusez-moi|sumimasen]、[これ|ceci|kore][は|(topic)|wa]'
              '[いくら|combien|ikura][ですか|est-ce|desu ka]？',
          speaker: '客 · le client',
          native: 'Excusez-moi, ça coûte combien, ceci ?',
          romanization: 'Sumimasen, kore wa ikura desu ka?',
          note: 'いくら interroge sur un prix ; どのくらい interrogerait plutôt '
              'sur une quantité ou une durée.'),
      _l('[さんびゃく|trois cents|sanbyaku][えん|yens|en][です|est|desu]。',
          speaker: '店員 · le serveur',
          native: 'Ça fait trois cents yens.',
          romanization: 'Sanbyaku en desu.',
          note: '百 (hyaku) se lit びゃく après "san" à cause d\'un changement '
              'de son régulier — comme さんぽん pour "trois bouteilles".'),
      _l('[ありがとうございます|merci beaucoup|arigatou gozaimasu]。',
          speaker: '客 · le client',
          native: 'Merci beaucoup.',
          romanization: 'Arigatou gozaimasu.'),
      _l('[ありがとうございました|merci beaucoup (passé)|arigatou gozaimashita]。',
          speaker: '店員 · le serveur',
          native: 'Merci beaucoup (pour votre visite).',
          romanization: 'Arigatou gozaimashita.',
          note: 'Le commerçant utilise le passé ございました : l\'échange est '
              'termine, contrairement au client qui remercie sur le moment.'),
      _l('[また|encore|mata][きます|viendrai|kimasu]。',
          speaker: '客 · le client',
          native: 'Je reviendrai.',
          romanization: 'Mata kimasu.',
          note: 'また + verbe = "faire encore", ici "revenir".'),
      _l('[おまちして|attendrons(humble)|omachi shite][います|sommes(en train de)|imasu]。',
          speaker: '店員 · le serveur',
          native: 'Nous vous attendrons.',
          romanization: 'Omachi shite imasu.',
          note: 'お + verbe + して = forme humble, utilisee par le personnel '
              'envers un client.'),
      _l('[きょう|aujourd\'hui|kyou][は|(topic)|wa][いい|bonne|ii]'
              '[てんき|meteo|tenki][ですね|est n\'est-ce pas|desu ne]。',
          speaker: '客 · le client',
          native: 'Il fait beau aujourd\'hui, n\'est-ce pas.',
          romanization: 'Kyou wa ii tenki desu ne.',
          note: 'ね en fin de phrase invite l\'autre a confirmer — proche de '
              '"n\'est-ce pas".'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Que commande le client ?',
        options: ['Un thé', 'Un café', 'De l\'eau', 'Un gâteau'],
        answerIndex: 1,
        explanation: 'コーヒーを ひとつ おねがいします : "un café, s\'il vous plaît".',
      ),
      const StoryQuestion(
        question: 'Combien coûte la commande ?',
        options: ['100 yens', '200 yens', '300 yens', '3000 yens'],
        answerIndex: 2,
        explanation: 'さんびゃくえんです = "ça fait 300 yens".',
      ),
    ],
  ),
  Story(
    id: 'ja-story-michiannai',
    languageCode: 'ja',
    title: 'みちを きく',
    titleNative: 'Demander son chemin',
    blurb: 'Un dialogue dans la rue pour demander et comprendre un '
        'itinéraire simple : tout droit, à droite, au coin de la rue.',
    level: StoryLevel.first,
    takeaway: 'Pour demander un chemin : すみません、...は どこですか。Pour '
        'comprendre la réponse, retiens まっすぐ (tout droit), みぎ／ひだり '
        '(droite/gauche) et かど (le coin de la rue).',
    lines: [
      _l('[すみません|excusez-moi|sumimasen]、[えき|la gare|eki][は|(topic)|wa]'
              '[どこ|où|doko][ですか|est-ce|desu ka]？',
          speaker: '旅行者 · le voyageur',
          native: 'Excusez-moi, où est la gare ?',
          romanization: 'Sumimasen, eki wa doko desu ka?'),
      _l('[まっすぐ|tout droit|massugu][いって|allez|itte][ください|s\'il vous '
              'plaît|kudasai]。',
          speaker: '住民 · l\'habitant',
          native: 'Allez tout droit, s\'il vous plaît.',
          romanization: 'Massugu itte kudasai.',
          note: '～てください est la forme polie de demande/instruction : '
              'verbe en て + ください.'),
      _l('[つぎ|le prochain|tsugi][の|(lien)|no][かど|coin de rue|kado][を|'
              '(objet)|o][みぎ|à droite|migi][に|vers|ni][まがって|tournez|'
              'magatte][ください|s\'il vous plaît|kudasai]。',
          speaker: '住民 · l\'habitant',
          native: 'Tournez à droite au prochain coin de rue.',
          romanization: 'Tsugi no kado o migi ni magatte kudasai.',
          note: '曲がる (tourner) se construit avec を pour le lieu du '
              'virage et に pour la direction : かどを みぎに まがる.'),
      _l('[えき|la gare|eki][は|(topic)|wa][とおい|loin|tooi][です|est|desu]'
              'か？',
          speaker: '旅行者 · le voyageur',
          native: 'La gare est loin ?',
          romanization: 'Eki wa tooi desu ka?'),
      _l('[いいえ|non|iie]、[あるいて|à pied|aruite][ごふん|cinq minutes|gofun]'
              'です。',
          speaker: '住民 · l\'habitant',
          native: 'Non, c\'est à cinq minutes à pied.',
          romanization: 'Iie, aruite gofun desu.',
          note: '歩いて (aruite) + durée + です est la structure standard '
              'pour donner un temps de trajet à pied.'),
      _l('[コンビニ|le konbini|konbini][の|(lien)|no][まえ|devant|mae][に|à|'
              'ni][あります|il y a|arimasu]。',
          speaker: '住民 · l\'habitant',
          native: 'Elle se trouve devant le konbini.',
          romanization: 'Konbini no mae ni arimasu.',
          note: 'あります s\'utilise pour situer un objet ou un lieu '
              'inanimé, jamais います qui est réservé aux êtres vivants.'),
      _l('[わかりました|j\'ai compris|wakarimashita]。[どうも|merci beaucoup|'
              'doumo][ありがとうございます|merci beaucoup|arigatou gozaimasu]。',
          speaker: '旅行者 · le voyageur',
          native: 'D\'accord, merci beaucoup.',
          romanization: 'Wakarimashita. Doumo arigatou gozaimasu.'),
      _l('[きを|attention|ki o][つけて|faites|tsukete]。',
          speaker: '住民 · l\'habitant',
          native: 'Faites attention (à vous).',
          romanization: 'Ki o tsukete.',
          note: '気を つけて est une formule d\'adieu bienveillante, dite à '
              'quelqu\'un qui part — littéralement "faites attention à '
              'votre esprit/énergie".'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Où le voyageur doit-il tourner à droite ?',
        options: [
          'Au prochain coin de rue',
          'Devant le konbini',
          'Il ne doit pas tourner',
        ],
        answerIndex: 0,
        explanation: 'つぎの かどを みぎに まがってください。',
      ),
      const StoryQuestion(
        question: 'À combien de temps se trouve la gare ?',
        options: ['Cinq minutes à pied', 'Dix minutes en bus', 'Très loin'],
        answerIndex: 0,
        explanation: 'あるいて ごふんです。',
      ),
      const StoryQuestion(
        question: 'Que veut dire 気をつけて ?',
        options: [
          'Dépêchez-vous',
          'Faites attention à vous',
          'Ne vous perdez pas',
        ],
        answerIndex: 1,
        explanation: 'Formule d\'adieu bienveillante, littéralement '
            '"prenez soin de votre énergie".',
      ),
    ],
  ),
  Story(
    id: 'ja-story-jikoshoukai',
    languageCode: 'ja',
    title: 'じこしょうかい',
    titleNative: 'Se présenter',
    blurb: 'Une présentation courte et complète, du niveau A1 : nom, '
        'origine, métier et une phrase de clôture polie.',
    level: StoryLevel.first,
    takeaway: 'La présentation japonaise suit toujours le même ordre : '
        'salutation, nom, origine/métier, formule de clôture (どうぞ '
        'よろしく おねがいします).',
    lines: [
      _l('[はじめまして|enchanté(à la 1ère rencontre)|hajimemashite]。',
          native: 'Enchanté.',
          romanization: 'Hajimemashite.'),
      _l('[わたし|moi|watashi][は|(topic)|wa][マリー|Marie|marii][です|suis|desu]。',
          native: 'Je m\'appelle Marie.',
          romanization: 'Watashi wa Marii desu.'),
      _l('[フランス|France|furansu][から|depuis|kara][きました|suis venu(e)|kimashita]。',
          native: 'Je viens de France.',
          romanization: 'Furansu kara kimashita.',
          note: 'から marque le point de départ, exactement comme "de/depuis" '
              'en français.'),
      _l('[パリ|Paris|pari][に|à|ni][すんでいます|habite|sunde imasu]。',
          native: 'J\'habite à Paris.',
          romanization: 'Pari ni sunde imasu.'),
      _l('[がっこう|école|gakkou][で|(lieu)|de][にほんご|japonais|nihongo]'
              '[を|(objet)|o][おしえています|enseigne|oshiete imasu]。',
          native: 'J\'enseigne le japonais dans une école.',
          romanization: 'Gakkou de nihongo o oshiete imasu.',
          note: 'で marque le lieu ou se déroule l\'action d\'enseigner.'),
      _l('[しゅみ|loisir|shumi][は|(topic)|wa][どくしょ|lecture|dokusho][です|est|desu]。',
          native: 'Mon loisir, c\'est la lecture.',
          romanization: 'Shumi wa dokusho desu.'),
      _l('[にほん|Japon|nihon][りょうり|cuisine|ryouri][が|(sujet)|ga]'
              '[すきです|aimee-est|suki desu]。',
          native: 'J\'aime la cuisine japonaise.',
          romanization: 'Nihon ryouri ga suki desu.',
          note: 'すき (aimer) se construit avec が, pas avec を : ce que l\'on '
              'aime est traite comme un sujet, pas comme un objet direct.'),
      _l('[どうぞ|s\'il vous plaît|douzo][よろしく|bien|yoroshiku]'
              '[おねがいします|je vous demande|onegaishimasu]。',
          native: 'Ravie de faire votre connaissance.',
          romanization: 'Douzo yoroshiku onegaishimasu.',
          note: 'Formule de clôture quasi obligatoire après une '
              'présentation, sans équivalent figé en français.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'D\'où vient Marie ?',
        options: ['Du Japon', 'De France', 'de Paris uniquement', 'Elle ne le dit pas'],
        answerIndex: 1,
        explanation: 'フランスから きました = "je viens de France".',
      ),
      const StoryQuestion(
        question: 'Que fait Marie ?',
        options: [
          'Elle étudie le japonais',
          'Elle enseigne le japonais',
          'Elle travaille dans un café',
          'Elle est étudiante en France',
        ],
        answerIndex: 1,
        explanation: 'がっこうで にほんごを おしえています = "j\'enseigne le '
            'japonais dans une école".',
      ),
    ],
  ),
];
