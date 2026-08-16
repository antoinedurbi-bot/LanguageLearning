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
