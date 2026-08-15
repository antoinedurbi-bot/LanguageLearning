import 'package:learning_app/data/models/story.dart';

const _lex = {
  'a': 'un, une',
  'an': 'un, une',
  'the': 'le, la, les',
  'and': 'et',
  'or': 'ou',
  'but': 'mais',
  'so': 'donc, alors',
  'because': 'parce que',
  'if': 'si',
  'when': 'quand',
  'that': 'que, ce',
  'this': 'ce, ceci',
  'it': 'il, ce',
  'is': 'est',
  'are': 'sont, es',
  'was': 'était',
  'were': 'étaient',
  'not': 'ne… pas',
  'no': 'non, aucun',
  'yes': 'oui',
  'i': 'je',
  'you': 'tu, vous',
  'he': 'il',
  'she': 'elle',
  'we': 'nous',
  'they': 'ils, elles',
  'my': 'mon, ma',
  'your': 'ton, votre',
  'his': 'son, sa (à lui)',
  'her': 'son, sa (à elle)',
  'their': 'leur',
  'to': 'à, vers',
  'of': 'de',
  'in': 'dans',
  'on': 'sur',
  'at': 'à (lieu, heure)',
  'for': 'pour, pendant',
  'with': 'avec',
  'from': 'de, depuis',
  'about': 'à propos de',
  'up': 'en haut',
  'out': 'dehors',
  'very': 'très',
  'too': 'trop, aussi',
  'more': 'plus',
  'just': 'juste, seulement',
  'here': 'ici',
  'there': 'là',
  'now': 'maintenant',
  'then': 'ensuite, alors',
  'always': 'toujours',
  'never': 'jamais',
  'only': 'seulement',
  'all': 'tout',
  'some': 'quelques, du',
  'any': 'aucun, n\'importe quel',
  'good': 'bon, bien',
  'well': 'bien',
  'one': 'un',
  'two': 'deux',
  'three': 'trois',
  'do': 'faire',
  'does': 'fait',
  'did': 'a fait',
  'have': 'avoir',
  'has': 'a',
  'had': 'avait',
  'can': 'pouvoir',
  'will': 'futur (auxiliaire)',
  'would': 'conditionnel (auxiliaire)',
  'what': 'quoi, que',
  'who': 'qui',
  'how': 'comment',
  'why': 'pourquoi',
  'where': 'où',
};

StoryLine _l(
  String source, {
  required String native,
  String? speaker,
  String? note,
}) =>
    StoryLine.parse(source,
        native: native, speaker: speaker, note: note, lexicon: _lex);

final storiesEn = <Story>[
  Story(
    id: 'en-story-room',
    languageCode: 'en',
    title: 'A room, eventually',
    titleNative: 'Une chambre, à force',
    blurb:
        'Un texte au présent, dix lignes, sur la recherche d\'un logement. '
        'Objectif : aller jusqu\'au bout sans t\'arrêter.',
    level: StoryLevel.first,
    takeaway:
        'Tu viens de lire un texte entier en anglais. Les mots que tu n\'as '
        'pas reconnus, le contexte les a portés — c\'est le mécanisme normal '
        'de la lecture, pas un échec.',
    lines: [
      _l('I [look at|je regarde] [eleven|onze] [rooms|chambres] in [four|quatre] [days|jours].',
          native: 'Je visite onze chambres en quatre jours.'),
      _l('The [first|première] one has no [window|fenêtre]. The [agent|agent] [calls|appelle] it [cosy|douillet].',
          native:
              'La première n\'a pas de fenêtre. L\'agent la qualifie de « douillette ».',
          note:
              'Dans les annonces, "cosy" veut souvent dire petit. Le code des annonces immobilières est le même partout.'),
      _l('The [second|deuxième] one is [above|au-dessus d\'] a [pub|pub]. I can [hear|entendre] the [music|musique] [through|à travers] the [floor|plancher].',
          native:
              'La deuxième est au-dessus d\'un pub. J\'entends la musique à travers le plancher.'),
      _l('The [landlord|propriétaire] [says|dit] it [gets|devient] [quiet|calme] [after|après] [midnight|minuit].',
          native: 'Le propriétaire dit que ça se calme après minuit.'),
      _l('[By|Au bout de] the [seventh|septième], I [stop|j\'arrête de] [asking|demander] [questions|des questions].',
          native: 'Au bout de la septième, j\'arrête de poser des questions.'),
      _l('The [last|dernière] one is [smaller|plus petite] [than|que] the [others|les autres].',
          native: 'La dernière est plus petite que les autres.'),
      _l('But the [light|lumière] [comes in|entre] [sideways|de biais] in the [morning|matin], and the [woman|femme] [who|qui] [lives|vit] [downstairs|en bas] [offers|propose] me [tea|du thé].',
          native:
              'Mais la lumière entre de biais le matin, et la femme qui vit en bas me propose du thé.'),
      _l('I [take|je prends] it [before|avant] I [see|de voir] the [bathroom|salle de bain].',
          native: 'Je la prends avant même d\'avoir vu la salle de bain.'),
      _l('The [bathroom|salle de bain] is [bad|mauvaise].',
          native: 'La salle de bain est mauvaise.'),
      _l('I [stay|je reste] [two|deux] [years|ans].',
          native: 'J\'y reste deux ans.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Pourquoi le narrateur choisit-il la dernière chambre ?',
        options: [
          'Elle est la moins chère',
          'La lumière et la voisine lui plaisent',
          'La salle de bain est belle',
        ],
        answerIndex: 1,
        explanation:
            'La lumière du matin et le thé de la voisine — la salle de bain, elle, est « bad ».',
      ),
      const StoryQuestion(
        question: 'Que veut dire « cosy » dans une annonce ?',
        options: ['Lumineux', 'Petit', 'Récemment rénové'],
        answerIndex: 1,
        explanation: 'Un euphémisme d\'agent immobilier, la note le signale.',
      ),
    ],
  ),
  Story(
    id: 'en-story-seat',
    languageCode: 'en',
    title: 'Is this seat taken?',
    titleNative: 'Cette place est prise ?',
    blurb:
        'Un dialogue dans un train. Court, mais il contient presque toutes '
        'les formules de politesse anglaises que tu utiliseras.',
    level: StoryLevel.first,
    takeaway:
        'L\'anglais poli fonctionne par atténuation : "sorry", "would you mind", '
        '"I\'m afraid". Ce sont des amortisseurs, pas des excuses.',
    lines: [
      _l('[Sorry|Pardon] — is this [seat|place] [taken|prise]?',
          speaker: 'Passenger',
          native: 'Pardon — cette place est prise ?',
          note:
              '"Sorry" ouvre une phrase sur deux en anglais britannique. Il ne veut pas dire "je suis désolé" mais "excusez-moi".'),
      _l('No, [go ahead|allez-y].',
          speaker: 'Woman', native: 'Non, allez-y.'),
      _l('[Thanks|Merci]. [Would you mind|Cela vous dérange-t-il] if I [put|je mets] my [bag|sac] up [there|là-haut]?',
          speaker: 'Passenger',
          native: 'Merci. Cela vous dérange si je mets mon sac là-haut ?',
          note:
              'Piège : "would you mind" se répond par "no" quand on accepte. "No, not at all" = allez-y.'),
      _l('[Not at all|Pas du tout].',
          speaker: 'Woman', native: 'Pas du tout.'),
      _l('Do you [know|savez-vous] if this [train|train] [stops|s\'arrête] at [Reading|Reading]?',
          speaker: 'Passenger',
          native: 'Savez-vous si ce train s\'arrête à Reading ?'),
      _l('[I\'m afraid|Je crains que] it [doesn\'t|non]. You [want|voulez] the [slow|lent] one, [platform|quai] [three|trois].',
          speaker: 'Woman',
          native:
              'Je crains que non. C\'est le train lent qu\'il vous faut, quai trois.',
          note:
              '"I\'m afraid" n\'a rien à voir avec la peur : c\'est la façon polie d\'annoncer une mauvaise nouvelle.'),
      _l('[Oh no|Oh non]. [Really|Vraiment]?',
          speaker: 'Passenger', native: 'Oh non. Vraiment ?'),
      _l('You\'ve got [time|le temps]. It [leaves|part] in [nine|neuf] [minutes|minutes].',
          speaker: 'Woman',
          native: 'Vous avez le temps. Il part dans neuf minutes.'),
      _l('[You\'re a lifesaver|Vous me sauvez la vie]. [Thank you|Merci] [so much|beaucoup].',
          speaker: 'Passenger',
          native: 'Vous me sauvez la vie. Merci beaucoup.'),
      _l('[No worries|De rien]. [Run|Courez].',
          speaker: 'Woman', native: 'De rien. Courez.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Le train s\'arrête-t-il à Reading ?',
        options: ['Oui', 'Non', 'Seulement le week-end'],
        answerIndex: 1,
        explanation: '« I\'m afraid it doesn\'t » = malheureusement non.',
      ),
      const StoryQuestion(
        question: 'Comment accepte-t-on une demande en « Would you mind… ? »',
        options: [
          'En disant "yes"',
          'En disant "no, not at all"',
          'Les deux marchent',
        ],
        answerIndex: 1,
        explanation:
            'La question porte sur la gêne : "non, ça ne me dérange pas".',
      ),
    ],
  ),
  Story(
    id: 'en-story-what-you-do',
    languageCode: 'en',
    title: 'So, what do you do?',
    titleNative: 'Alors, tu fais quoi dans la vie ?',
    blurb:
        'La conversation qu\'on te fera cent fois. Ici, elle est décortiquée : '
        'la question, la réponse, et la relance qui la rend vivante.',
    level: StoryLevel.building,
    takeaway:
        'Une bonne réponse à "what do you do?" tient en deux temps : ce que tu '
        'fais, puis un détail concret. Le détail est ce qui donne une prise à '
        'l\'autre pour rebondir.',
    lines: [
      _l('So, what do you do?',
          speaker: 'Amir',
          native: 'Alors, tu fais quoi dans la vie ?',
          note:
              '"What do you do?" (présent simple) = quel est ton métier. "What are you doing?" = qu\'es-tu en train de faire. Une lettre de différence, deux questions différentes.'),
      _l('I\'m a [structural engineer|ingénieur structure]. [Mostly|Surtout] [bridges|des ponts].',
          speaker: 'Lena',
          native: 'Je suis ingénieure structure. Surtout des ponts.'),
      _l('[Bridges|Des ponts]? [That\'s|C\'est] [not something|pas une chose] you [hear|entend] [every day|tous les jours].',
          speaker: 'Amir',
          native: 'Des ponts ? On n\'entend pas ça tous les jours.'),
      _l('[People|Les gens] [assume|supposent] it\'s [all|surtout] [maths|des maths]. It\'s [mostly|surtout] [arguing|des discussions] [about|à propos de] [concrete|béton].',
          speaker: 'Lena',
          native:
              'Les gens croient que c\'est surtout des maths. C\'est surtout des débats sur le béton.'),
      _l('[Arguing|Se disputer] with [whom|avec qui]?',
          speaker: 'Amir', native: 'Se disputer avec qui ?'),
      _l('[Contractors|Les entreprises]. They [want|veulent] it [cheap|pas cher]. I [want|je veux] it [standing|debout] in [forty|quarante] [years|ans].',
          speaker: 'Lena',
          native:
              'Les entreprises. Elles le veulent pas cher. Moi je le veux encore debout dans quarante ans.'),
      _l('[Fair enough|C\'est légitime]. [Who|Qui] [usually|d\'habitude] [wins|gagne]?',
          speaker: 'Amir',
          native: 'C\'est légitime. Qui gagne, d\'habitude ?',
          note:
              '"Fair enough" = ça se tient, j\'accepte l\'argument. Extrêmement courant et impossible à traduire mot à mot.'),
      _l('[Whoever|Celui qui] [writes|rédige] the [report|rapport].',
          speaker: 'Lena', native: 'Celui qui rédige le rapport.'),
      _l('[And|Et] who [writes|rédige] the [report|rapport]?',
          speaker: 'Amir', native: 'Et qui rédige le rapport ?'),
      _l('[I|Je] do.',
          speaker: 'Lena',
          native: 'C\'est moi.',
          note:
              '"I do" reprend le verbe de la question sans le répéter. C\'est le réflexe anglais le plus utile à copier.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'En quoi consiste vraiment le métier de Lena, selon elle ?',
        options: [
          'Faire des calculs mathématiques',
          'Négocier sur la qualité du béton',
          'Dessiner des plans',
        ],
        answerIndex: 1,
        explanation: '« mostly arguing about concrete ».',
      ),
      const StoryQuestion(
        question: 'Que veut dire « Fair enough » ?',
        options: [
          'C\'est assez juste, j\'accepte',
          'Ce n\'est pas assez',
          'C\'est équitable financièrement',
        ],
        answerIndex: 0,
        explanation: 'Marqueur d\'accord, très fréquent à l\'oral.',
      ),
      const StoryQuestion(
        question: 'Pourquoi la dernière ligne est-elle drôle ?',
        options: [
          'Parce que Lena admet qu\'elle perd toujours',
          'Parce que Lena rédige le rapport, donc gagne toujours',
          'Parce que personne ne rédige de rapport',
        ],
        answerIndex: 1,
        explanation:
            'Elle vient de dire que le gagnant est celui qui rédige le rapport — et c\'est elle.',
      ),
    ],
  ),
];
