import 'package:learning_app/data/models/story.dart';

/// Function words, glossed once instead of once per line.
const _lex = {
  'a': 'à',
  'al': 'au',
  'un': 'un',
  'una': 'une',
  'el': 'le',
  'la': 'la',
  'los': 'les',
  'las': 'les',
  'de': 'de',
  'del': 'du',
  'en': 'dans, en',
  'con': 'avec',
  'sin': 'sans',
  'por': 'par, pour (cause)',
  'para': 'pour (but)',
  'y': 'et',
  'o': 'ou',
  'pero': 'mais',
  'que': 'que, qui',
  'qué': 'quoi, quel',
  'no': 'ne… pas',
  'sí': 'oui',
  'me': 'me, moi',
  'te': 'te, toi',
  'se': 'se',
  'le': 'lui',
  'lo': 'le, ce',
  'mi': 'mon, ma',
  'su': 'son, sa, votre',
  'tu': 'ton, ta',
  'yo': 'je',
  'él': 'il',
  'ella': 'elle',
  'usted': 'vous (poli)',
  'es': 'est (essence)',
  'está': 'est (état, lieu)',
  'son': 'sont',
  'hay': 'il y a',
  'muy': 'très',
  'más': 'plus',
  'menos': 'moins',
  'todo': 'tout',
  'todos': 'tous',
  'nada': 'rien',
  'nadie': 'personne',
  'algo': 'quelque chose',
  'aquí': 'ici',
  'allí': 'là-bas',
  'ahora': 'maintenant',
  'siempre': 'toujours',
  'nunca': 'jamais',
  'también': 'aussi',
  'tampoco': 'non plus',
  'cuando': 'quand',
  'porque': 'parce que',
  'como': 'comme',
  'bien': 'bien',
  'mal': 'mal',
  'poco': 'peu',
  'mucho': 'beaucoup',
  'otra': 'autre',
  'otro': 'autre',
  'este': 'ce',
  'esta': 'cette',
  'eso': 'ça',
  'esto': 'ceci',
};

StoryLine _l(
  String source, {
  required String native,
  String? speaker,
  String? note,
}) =>
    StoryLine.parse(source,
        native: native, speaker: speaker, note: note, lexicon: _lex);

final storiesEs = <Story>[
  Story(
    id: 'es-story-primer-dia',
    languageCode: 'es',
    title: 'El primer día',
    titleNative: 'Le premier jour',
    blurb:
        'Un texte au présent, écrit avec les mots que tu connais déjà. '
        'Objectif : lire dix lignes sans t\'arrêter.',
    level: StoryLevel.first,
    takeaway:
        'Tu viens de lire un texte entier en espagnol. Ce que tu n\'as pas '
        'compris mot à mot, tu l\'as compris quand même — c\'est exactement '
        'comme ça qu\'on apprend une langue.',
    lines: [
      _l('[Llego|j\'arrive] a Madrid un [martes|mardi] por la [tarde|après-midi].',
          native: 'J\'arrive à Madrid un mardi après-midi.'),
      _l('No [conozco|je connais] a nadie.',
          native: 'Je ne connais personne.',
          note:
              'Le "a" devant une personne est obligatoire en espagnol : conozco '
              'a Juan, mais conozco Madrid.'),
      _l('En el [aeropuerto|aéroport], una [señora|dame] me [pregunta|demande] si [necesito|j\'ai besoin de] [ayuda|aide].',
          native:
              'À l\'aéroport, une dame me demande si j\'ai besoin d\'aide.'),
      _l('Le [digo|je dis] que sí, [aunque|bien que] no [entiendo|je comprends] todo lo que [dice|elle dit].',
          native:
              'Je lui dis que oui, bien que je ne comprenne pas tout ce qu\'elle dit.'),
      _l('Ella [habla|parle] [despacio|lentement]. Se lo [agradezco|je l\'en remercie].',
          native: 'Elle parle lentement. Je l\'en remercie.'),
      _l('Mi [piso|appartement] está en un [barrio|quartier] [tranquilo|calme], [encima de|au-dessus de] una [panadería|boulangerie].',
          native:
              'Mon appartement est dans un quartier calme, au-dessus d\'une boulangerie.'),
      _l('Por la [mañana|matin] [huele|ça sent] a [pan|pain] [caliente|chaud].',
          native: 'Le matin, ça sent le pain chaud.',
          note:
              '"Oler a" = sentir (une odeur). Le verbe est irrégulier : huelo, hueles, huele.'),
      _l('El [primer|premier] [día|jour] no [hablo|je parle] con casi nadie.',
          native: 'Le premier jour, je ne parle presque avec personne.'),
      _l('Pero [compro|j\'achète] el pan, y digo «[buenos días|bonjour]», y la [mujer|femme] me [contesta|répond].',
          native:
              'Mais j\'achète le pain, et je dis « bonjour », et la femme me répond.'),
      _l('Es poco. Es un [principio|début].',
          native: 'C\'est peu. C\'est un début.',
          note:
              '"Principio" veut dire début, pas principe — un faux ami classique.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Pourquoi le narrateur remercie-t-il la dame ?',
        options: [
          'Parce qu\'elle parle lentement',
          'Parce qu\'elle porte ses bagages',
          'Parce qu\'elle lui donne son adresse',
        ],
        answerIndex: 0,
        explanation:
            '« Ella habla despacio. Se lo agradezco. » — c\'est la lenteur qu\'il remercie.',
      ),
      const StoryQuestion(
        question: 'Qu\'y a-t-il en dessous de son appartement ?',
        options: ['Une pharmacie', 'Une boulangerie', 'Un bar'],
        answerIndex: 1,
        explanation: '« encima de una panadería » = au-dessus d\'une boulangerie.',
      ),
      const StoryQuestion(
        question: 'Que veut dire la dernière ligne ?',
        options: [
          'Qu\'il a raté sa première journée',
          'Qu\'il a un principe à respecter',
          'Que c\'est peu, mais que c\'est un commencement',
        ],
        answerIndex: 2,
        explanation:
            '« principio » = début. Le narrateur relativise : peu, mais un vrai début.',
      ),
    ],
  ),
  Story(
    id: 'es-story-la-cuenta',
    languageCode: 'es',
    title: 'La cuenta, por favor',
    titleNative: 'L\'addition, s\'il vous plaît',
    blurb:
        'Un dialogue au restaurant, avec le malentendu qui arrive vraiment. '
        'Repère comment le client s\'en sort sans connaître le mot exact.',
    level: StoryLevel.first,
    takeaway:
        'Le client ne connaît pas le mot « propina ». Il s\'en sort en '
        'demandant. C\'est la compétence la plus rentable de toutes.',
    lines: [
      _l('¿[Han terminado|Vous avez terminé] [ustedes|vous (pluriel)]?',
          speaker: 'Camarero',
          native: 'Vous avez terminé ?',
          note:
              'En Espagne on vouvoie au restaurant avec "ustedes" + verbe à la 3e personne du pluriel.'),
      _l('Sí, [gracias|merci]. [Estaba|C\'était] [buenísimo|excellent].',
          speaker: 'Cliente',
          native: 'Oui, merci. C\'était excellent.',
          note:
              'Le suffixe -ísimo est le raccourci espagnol pour "très" : bueno → buenísimo.'),
      _l('¿[Quieren|Voulez-vous] [postre|un dessert] o [café|un café]?',
          speaker: 'Camarero',
          native: 'Vous voulez un dessert ou un café ?'),
      _l('Para mí, un café [solo|noir]. Y la [cuenta|addition], por favor.',
          speaker: 'Cliente',
          native: 'Pour moi, un café noir. Et l\'addition, s\'il vous plaît.',
          note:
              '"Café solo" = expresso. "Café con leche" = avec du lait. Demander "un café" tout court laisse le choix au serveur.'),
      _l('[Ahora mismo|Tout de suite] [se la traigo|je vous l\'apporte].',
          speaker: 'Camarero',
          native: 'Je vous l\'apporte tout de suite.'),
      _l('[Perdone|Excusez-moi], ¿[está incluido|est-ce compris] el [servicio|service]?',
          speaker: 'Cliente',
          native: 'Excusez-moi, le service est-il compris ?'),
      _l('Sí, está incluido. La [propina|le pourboire] es [voluntaria|facultatif].',
          speaker: 'Camarero',
          native: 'Oui, il est compris. Le pourboire est facultatif.'),
      _l('[Vale|D\'accord]. [Entonces|Alors] [dejo|je laisse] esto. [Muchas gracias|Merci beaucoup].',
          speaker: 'Cliente',
          native: 'D\'accord. Alors je laisse ça. Merci beaucoup.'),
      _l('A [ustedes|vous]. [Que vaya bien|Bonne continuation].',
          speaker: 'Camarero',
          native: 'C\'est moi qui vous remercie. Bonne continuation.',
          note:
              '« A ustedes » répond à « gracias » : littéralement "à vous", sous-entendu "merci à vous".'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Le service est-il compris ?',
        options: ['Oui', 'Non', 'Le serveur ne le sait pas'],
        answerIndex: 0,
        explanation: '« Sí, está incluido. »',
      ),
      const StoryQuestion(
        question: 'Que commande le client à la fin du repas ?',
        options: ['Un dessert', 'Un café noir', 'Rien'],
        answerIndex: 1,
        explanation: '« Para mí, un café solo. »',
      ),
    ],
  ),
  Story(
    id: 'es-story-echo-de-menos',
    languageCode: 'es',
    title: 'Lo que echo de menos',
    titleNative: 'Ce qui me manque',
    blurb:
        'Un texte au passé et à l\'imparfait, plus personnel. Le vrai saut : '
        'raconter, et pas seulement décrire.',
    level: StoryLevel.building,
    takeaway:
        'L\'imparfait (vivía, sabía) sert au décor et à l\'habitude ; le passé '
        'simple (llegué, entendí) sert à l\'événement. C\'est la distinction '
        'la plus utile de tout l\'espagnol.',
    lines: [
      _l('[Llevo|Cela fait] [tres años|trois ans] [viviendo|que je vis] [fuera|à l\'étranger].',
          native: 'Cela fait trois ans que je vis à l\'étranger.',
          note:
              '"Llevar + durée + gérondif" est LA façon espagnole de dire "depuis". Plus courante que "hace... que".'),
      _l('[Cuando|Quand] [llegué|je suis arrivé], [pensaba|je pensais] que lo [difícil|difficile] [sería|serait] el [idioma|la langue].',
          native:
              'Quand je suis arrivé, je pensais que le difficile serait la langue.'),
      _l('[Me equivocaba|Je me trompais].',
          native: 'Je me trompais.',
          note:
              'Imparfait : un état mental qui durait. "Me equivoqué" dirait "je me suis trompé, une fois".'),
      _l('El idioma [se aprende|s\'apprend]. Lo que no se aprende es el [ruido|bruit] de [fondo|fond].',
          native:
              'La langue, ça s\'apprend. Ce qui ne s\'apprend pas, c\'est le bruit de fond.'),
      _l('En [mi país|mon pays], [sabía|je savais] [exactamente|exactement] [cuánto|combien] [costaba|coûtait] un [café|café].',
          native:
              'Dans mon pays, je savais exactement combien coûtait un café.'),
      _l('[Sabía|Je savais] [cuándo|quand] [callarme|me taire] y cuándo [reírme|rire].',
          native: 'Je savais quand me taire et quand rire.'),
      _l('[Aquí|Ici], [durante|pendant] [meses|des mois], [llegué|j\'arrivais] [tarde|en retard] a [todas|toutes] las [bromas|blagues].',
          native: 'Ici, pendant des mois, j\'arrivais en retard à toutes les blagues.'),
      _l('[Un día|Un jour], en el [ascensor|ascenseur], un [vecino|voisin] [dijo|a dit] algo y me [reí|j\'ai ri] [antes|avant] de [traducirlo|le traduire].',
          native:
              'Un jour, dans l\'ascenseur, un voisin a dit quelque chose et j\'ai ri avant de le traduire.'),
      _l('[Fue|Ce fut] el [mejor|meilleur] día [desde|depuis] que [estoy|je suis] aquí.',
          native: 'Ce fut le meilleur jour depuis que je suis ici.'),
      _l('[Todavía|Encore] [echo de menos|il me manque] [cosas|des choses]. Pero ya [tengo|j\'ai] otras.',
          native: 'Il me manque encore des choses. Mais j\'en ai d\'autres maintenant.',
          note:
              '"Echar de menos" = manquer, au sens affectif. En Amérique latine on dit plutôt "extrañar".'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Que croyait le narrateur en arrivant ?',
        options: [
          'Que la langue serait le plus dur',
          'Qu\'il repartirait vite',
          'Que le climat serait le plus dur',
        ],
        answerIndex: 0,
        explanation: '« pensaba que lo difícil sería el idioma ».',
      ),
      const StoryQuestion(
        question: 'Pourquoi ce jour dans l\'ascenseur compte-t-il autant ?',
        options: [
          'Il a rencontré un ami',
          'Il a ri sans avoir eu besoin de traduire',
          'Il a compris une blague après l\'avoir traduite',
        ],
        answerIndex: 1,
        explanation:
            '« me reí antes de traducirlo » — le rire est arrivé avant la traduction.',
      ),
      const StoryQuestion(
        question: 'Que signifie « echo de menos » ?',
        options: ['Je jette', 'Je manque de', 'Ça me manque'],
        answerIndex: 2,
        explanation:
            'Attention à l\'ordre : c\'est la chose qui manque au sujet, comme "gustar".',
      ),
    ],
  ),
];
