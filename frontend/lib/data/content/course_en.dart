import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';

const _en1Grammar = GrammarLesson(
  title: 'Be, et comment poser une question',
  hook: 'Le verbe "be" et l\'ordre des mots dans une question sont les deux '
      'choses qui reviennent dans presque toutes les phrases anglaises.',
  blocks: [
    ExplanationBlock(
      heading: 'To be : am / is / are',
      body: 'Contrairement au français, l\'anglais n\'a pas de forme unique '
          '"suis/es/est" : chaque personne a sa propre forme. On ne peut '
          'jamais l\'omettre, meme quand le français le sous-entend '
          '("Enchante" reste une formule figee, mais "Je suis français" '
          'devient bien "I am French").',
    ),
    TableBlock(
      caption: 'Le verbe be au présent',
      headers: ['Sujet', 'Forme', 'Exemple'],
      rows: [
        ['I', 'am', 'I am from France.'],
        ['You', 'are', 'You are tired.'],
        ['He / She / It', 'is', 'It is on the left.'],
        ['We / You / They', 'are', 'They are here.'],
      ],
    ),
    ExplanationBlock(
      heading: 'Question : le mot interrogatif passe devant',
      body: 'Pour poser une question, l\'auxiliaire (be, do, can) passe '
          'avant le sujet. Avec un mot interrogatif (where, what, how), '
          'celui-ci se place tout devant, suivi de l\'auxiliaire puis du '
          'sujet : Where + are + you + from ?',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Where are you from?',
          native: 'D\'ou viens-tu ?',
          note: 'where + are (auxiliaire) + you (sujet)',
        ),
        GrammarExample(
          target: 'Can you speak more slowly, please?',
          native: 'Peux-tu parler plus lentement ?',
          note: 'can passe avant you, comme are',
        ),
      ],
    ),
    ExplanationBlock(
      heading: 'Negation : do not devant les autres verbes',
      body: 'Be se nie tout seul (I am not, it is not). Tous les autres '
          'verbes ont besoin de l\'auxiliaire "do" pour se nier : on ne dit '
          'jamais "I understand not", il faut "I do not understand".',
    ),
    MistakeBlock(
      wrong: 'I not understand.',
      right: 'I do not understand.',
      why: 'L\'anglais ne nie jamais un verbe ordinaire seul avec "not" : '
          'il faut l\'auxiliaire "do" (ou "does" à la 3e personne) devant.',
    ),
  ],
);

const _en2Grammar = GrammarLesson(
  title: 'Politesse et petits mots qui changent tout',
  hook: 'En anglais, la politesse et la precision passent par le choix du '
      'bon petit mot, pas par une conjugaison speciale.',
  blocks: [
    ExplanationBlock(
      heading: 'Want vs would like',
      body: '"Want" est direct et peut sembler brusque. "Would like" est la '
          'version polie utilisée au restaurant, dans un magasin, partout '
          'ou le français dirait "je voudrais" plutôt que "je veux".',
    ),
    TableBlock(
      headers: ['Direct', 'Poli'],
      rows: [
        ['I want a coffee.', 'I would like a coffee, please.'],
        ['I want to pay.', 'I would like to pay, please.'],
      ],
    ),
    ExplanationBlock(
      heading: 'How much vs how many',
      body: '"How much" interroge sur une quantite qu\'on ne compte pas '
          '(un prix, de l\'argent, du temps). "How many" interroge sur un '
          'nombre d\'objets qu\'on peut compter un par un.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'How much is it?',
          native: 'Combien ca coûte ?',
          note: 'un prix ne se compte pas : how much',
        ),
        GrammarExample(
          target: 'How many coffees do you want?',
          native: 'Combien de cafes veux-tu ?',
          note: 'des cafes se comptent un par un : how many',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'How many is it?',
      right: 'How much is it?',
      why: 'Un prix est une quantite continue, pas un nombre d\'objets : '
          'seul "how much" fonctionne ici.',
    ),
  ],
);

const _en3Grammar = GrammarLesson(
  title: 'Les prepositions qui ne se traduisent pas',
  hook: 'La plupart des erreurs de debutant en anglais viennent d\'une '
      'preposition traduite mot a mot depuis le français.',
  blocks: [
    ExplanationBlock(
      heading: 'On, at, in : trois "a" differents',
      body: 'Le français dit "a" pour à peu près tout. L\'anglais distingue '
          'la position sur une surface ou un côté (on), un point précis '
          '(at) et l\'interieur d\'un lieu (in).',
    ),
    TableBlock(
      headers: ['Preposition', 'Usage', 'Exemple'],
      rows: [
        ['on', 'sur une surface, un cote', 'on the left'],
        ['at', 'un point precis', 'at the station'],
        ['in', 'a l\'interieur d\'un lieu', 'in the city'],
      ],
    ),
    ExplanationBlock(
      heading: 'Les verbes a particule : get to, look for',
      body: 'Certains verbes anglais changent de sens completement selon la '
          'particule qui les suit, et cette particule est obligatoire. '
          '"Look" seul veut dire regarder ; "look for" veut dire chercher.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'How do I get to the airport?',
          native: 'Comment aller a l\'aeroport ?',
          note: 'get to = rejoindre un lieu (pas "arrive to")',
        ),
        GrammarExample(
          target: 'I am looking for this address.',
          native: 'Je cherche cette adresse.',
          note: 'look FOR : le "for" est obligatoire, jamais "look this"',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'I am looking this address.',
      right: 'I am looking for this address.',
      why: '"Look" sans particule veut dire "regarder" : sans "for", la '
          'phrase ne veut plus dire "chercher".',
    ),
  ],
);

const _en4Grammar = GrammarLesson(
  title: 'Present simple vs present continuous',
  hook: 'L\'anglais a deux presents qui ne s\'emploient jamais l\'un pour '
      'l\'autre : l\'habitude, et l\'action en train de se passer.',
  blocks: [
    ExplanationBlock(
      heading: 'Simple : habitudes et verites generales',
      body: 'Le présent simple décrit ce qui se répète ou reste vrai dans '
          'la durée : un metier, un horaire, une routine. A la 3e personne '
          'du singulier (he/she/it), le verbe prend un -s.',
    ),
    TableBlock(
      caption: 'Le -s de la 3e personne',
      headers: ['Sujet', 'Verbe'],
      rows: [
        ['I / you / we / they', 'work'],
        ['he / she / it', 'works'],
      ],
    ),
    ExplanationBlock(
      heading: 'Continuous : l\'action se deroule maintenant',
      body: 'Le présent continuous (be + verbe-ing) décrit une action en '
          'cours au moment ou l\'on parle, pas une habitude. On ne peut pas '
          'l\'utiliser pour dire ce qu\'on fait "d\'habitude".',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'She works in a hospital.',
          native: 'Elle travaille dans un hopital.',
          note: 'un fait durable : présent simple + -s',
        ),
        GrammarExample(
          target: 'He is watching a film right now.',
          native: 'Il regarde un film en ce moment.',
          note: 'action en cours : is + watching',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'He watch television every day.',
      right: 'He watches television every day.',
      why: 'A la 3e personne du singulier, le présent simple prend '
          'toujours un -s : he/she/it + verbe-s.',
    ),
  ],
);

const _en5Grammar = GrammarLesson(
  title: 'Parler du passe : trois outils, trois usages',
  hook: 'Le passé simple, le présent perfect et le passe en -ing ne '
      'racontent pas la meme chose, meme quand le français utiliserait le '
      'meme temps pour les trois.',
  blocks: [
    ExplanationBlock(
      heading: 'Past simple : un fait termine, à un moment précis',
      body: 'Utilise pour un evenement fini, souvent avec une date ou un '
          'marqueur temporel (last year, yesterday). Beaucoup de verbes '
          'sont irreguliers et changent de forme.',
    ),
    TableBlock(
      caption: 'Verbes irreguliers frequents',
      headers: ['Base', 'Passe', 'Participe passe'],
      rows: [
        ['go', 'went', 'gone'],
        ['see', 'saw', 'seen'],
        ['have', 'had', 'had'],
        ['be', 'was / were', 'been'],
      ],
    ),
    ExplanationBlock(
      heading: 'Présent perfect : une experience de vie, sans date',
      body: '"Have + participe passe" repond a "est-ce que ca t\'est deja '
          'arrive ?", sans preciser quand. Des qu\'une date ou un moment '
          'précis apparaît, il faut repasser au past simple.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'I went to London last year.',
          native: 'Je suis allé a Londres l\'année dernière.',
          note: 'date precisee (last year) : past simple',
        ),
        GrammarExample(
          target: 'Have you ever been to Japan?',
          native: 'Es-tu deja allé au Japon ?',
          note: 'experience sans date : have + been',
        ),
      ],
    ),
    ExplanationBlock(
      heading: 'Past continuous : le decor de l\'histoire',
      body: '"Was/were + verbe-ing" plante le decor autour d\'un evenement '
          'ponctuel : "It was raining" installe l\'ambiance dans laquelle '
          'autre chose s\'est produit.',
    ),
    MistakeBlock(
      wrong: 'I have went to London last year.',
      right: 'I went to London last year.',
      why: 'Une date precise (last year) exige le past simple ; le présent '
          'perfect ne se combine jamais avec un moment précis du passe.',
    ),
  ],
);

const _en6Grammar = GrammarLesson(
  title: 'Hypotheses, projets et prepositions figees',
  hook: 'Nuancer en anglais demande des structures que le français n\'a '
      'pas telles quelles : le conditionnel irreel et be going to.',
  blocks: [
    ExplanationBlock(
      heading: 'If + passe, would + base : l\'hypothese irreelle',
      body: 'Pour une situation imaginaire au présent ("si j\'avais..."), '
          'l\'anglais met le verbe après "if" au passé simple, et "would" '
          'devant le verbe de la consequence. Le passe ici n\'indique pas '
          'le temps, il marque l\'irrealite.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'If I had more time, I would travel.',
          native: 'Si j\'avais plus de temps, je voyagerais.',
          note: 'if + had (passe) ..., + would + travel (base)',
        ),
        GrammarExample(
          target: 'I am going to look for a new job.',
          native: 'Je vais chercher un nouveau travail.',
          note: 'be going to = intention deja decidee, pas "will"',
        ),
      ],
    ),
    ExplanationBlock(
      heading: 'Be going to vs will',
      body: '"Be going to" annonce une decision deja prise avant l\'instant '
          'de parole. "Will" sert plutôt à une decision prise sur le '
          'moment, ou à une prediction.',
    ),
    ExplanationBlock(
      heading: 'Prepositions figees : depend ON, used TO',
      body: 'Certains verbes exigent toujours la meme preposition, sans '
          'lien avec le français : "depend" se construit avec "on" (jamais '
          '"of"), et "be used to" est suivi d\'un verbe en -ing, pas de '
          'l\'infinitif.',
    ),
    MistakeBlock(
      wrong: 'I am used to work late.',
      right: 'I am used to working late.',
      why: 'Ici "to" fait partie de l\'expression "be used to" (être '
          'habitue a) et se comporte comme une preposition : il est suivi '
          'd\'un verbe en -ing, pas de l\'infinitif.',
    ),
  ],
);

/// English course for French speakers.
///
/// Sentences are ordered by the frequency of the words they contain: the first
/// units are built almost entirely from the ~300 most common English words,
/// which is where the steepest part of the comprehension curve lives. Each
/// card introduces about one new element over the previous one.
const courseEn = Course(
  languageCode: 'en',
  ttsLocale: 'en-US',
  units: [
    Unit(
      id: 'en-u1',
      title: 'Premiers mots',
      subtitle: 'Se presenter et répondre',
      level: 'A1',
      grammarLesson: _en1Grammar,
      cards: [
        CardItem(
          id: 'en-1-1',
          target: 'Hello, my name is Anna.',
          native: 'Bonjour, je m\'appelle Anna.',
          gloss: 'Bonjour, mon nom est Anna.',
          tokens: ['Hello,', 'my', 'name', 'is', 'Anna.'],
          distractors: ['me', 'am', 'called'],
          focus: 'my name is = je m\'appelle',
        ),
        CardItem(
          id: 'en-1-2',
          target: 'Nice to meet you.',
          native: 'Enchante.',
          gloss: 'Agreable de rencontrer toi.',
          tokens: ['Nice', 'to', 'meet', 'you.'],
          distractors: ['Good', 'know', 'see'],
          focus: 'Formule fixe, ne se traduit pas mot a mot',
        ),
        CardItem(
          id: 'en-1-3',
          target: 'Where are you from?',
          native: 'D\'ou viens-tu ?',
          gloss: 'Ou es tu de ?',
          tokens: ['Where', 'are', 'you', 'from?'],
          distractors: ['come', 'do', 'What'],
          focus: 'La preposition "from" ferme la question',
        ),
        CardItem(
          id: 'en-1-4',
          target: 'I am from France.',
          native: 'Je viens de France.',
          gloss: 'Je suis de France.',
          tokens: ['I', 'am', 'from', 'France.'],
          distractors: ['come', 'is', 'the'],
          focus: 'On dit "I am from", pas "I come from"',
        ),
        CardItem(
          id: 'en-1-5',
          target: 'Sorry, I do not understand.',
          native: 'Désolé, je ne comprends pas.',
          gloss: 'Desole, je fais pas comprendre.',
          tokens: ['Sorry,', 'I', 'do', 'not', 'understand.'],
          distractors: ['am', 'no', 'understanding'],
          focus: 'La negation utilise l\'auxiliaire "do not"',
        ),
        CardItem(
          id: 'en-1-6',
          target: 'Can you speak more slowly, please?',
          native: 'Peux-tu parler plus lentement, s\'il te plait ?',
          gloss: 'Peux tu parler plus lentement, s\'il plait ?',
          tokens: ['Can', 'you', 'speak', 'more', 'slowly,', 'please?'],
          distractors: ['Do', 'slow', 'talking'],
          focus: 'Can + verbe a l\'infinitif sans "to"',
        ),
      ],
    ),
    Unit(
      id: 'en-u2',
      title: 'Commander',
      subtitle: 'Cafe, restaurant, boutique',
      level: 'A1',
      grammarLesson: _en2Grammar,
      cards: [
        CardItem(
          id: 'en-2-1',
          target: 'I would like a coffee, please.',
          native: 'Je voudrais un cafe, s\'il vous plait.',
          gloss: 'Je voudrais un cafe, s\'il plait.',
          tokens: ['I', 'would', 'like', 'a', 'coffee,', 'please.'],
          distractors: ['want', 'the', 'like to'],
          focus: '"I would like" est la forme polie de "I want"',
        ),
        CardItem(
          id: 'en-2-2',
          target: 'How much is it?',
          native: 'Combien ca coûte ?',
          gloss: 'Combien beaucoup est il ?',
          tokens: ['How', 'much', 'is', 'it?'],
          distractors: ['many', 'cost', 'does'],
          focus: 'How much pour un prix, how many pour un nombre',
        ),
        CardItem(
          id: 'en-2-3',
          target: 'Can I pay by card?',
          native: 'Puis-je payer par carte ?',
          gloss: 'Peux je payer par carte ?',
          tokens: ['Can', 'I', 'pay', 'by', 'card?'],
          distractors: ['with', 'the', 'paying'],
          focus: 'by card / in cash: prepositions figees',
        ),
        CardItem(
          id: 'en-2-4',
          target: 'Do you have anything without meat?',
          native: 'Avez-vous quelque chose sans viande ?',
          gloss: 'Faites vous avoir quelque-chose sans viande ?',
          tokens: ['Do', 'you', 'have', 'anything', 'without', 'meat?'],
          distractors: ['something', 'no', 'Are'],
          focus: '"anything" dans les questions, "something" en affirmatif',
        ),
        CardItem(
          id: 'en-2-5',
          target: 'The bill, please.',
          native: 'L\'addition, s\'il vous plait.',
          gloss: 'La note, s\'il plait.',
          tokens: ['The', 'bill,', 'please.'],
          distractors: ['A', 'addition', 'check'],
          focus: 'bill (UK) / check (US)',
        ),
        CardItem(
          id: 'en-2-6',
          target: 'It was delicious, thank you.',
          native: 'C\'était delicieux, merci.',
          gloss: 'Il etait delicieux, merci toi.',
          tokens: ['It', 'was', 'delicious,', 'thank', 'you.'],
          distractors: ['is', 'were', 'thanks to'],
          focus: 'was = passe de is',
        ),
      ],
    ),
    Unit(
      id: 'en-u3',
      title: 'S\'orienter',
      subtitle: 'Demander son chemin, les transports',
      level: 'A1',
      grammarLesson: _en3Grammar,
      cards: [
        CardItem(
          id: 'en-3-1',
          target: 'Excuse me, where is the station?',
          native: 'Excusez-moi, ou est la gare ?',
          gloss: 'Excuse moi, ou est la gare ?',
          tokens: ['Excuse', 'me,', 'where', 'is', 'the', 'station?'],
          distractors: ['Sorry', 'are', 'a'],
          focus: 'Excuse me pour aborder, sorry pour s\'excuser',
        ),
        CardItem(
          id: 'en-3-2',
          target: 'It is on the left.',
          native: 'C\'est a gauche.',
          gloss: 'Il est sur la gauche.',
          tokens: ['It', 'is', 'on', 'the', 'left.'],
          distractors: ['at', 'to', 'a'],
          focus: 'on the left / on the right',
        ),
        CardItem(
          id: 'en-3-3',
          target: 'How do I get to the airport?',
          native: 'Comment aller a l\'aeroport ?',
          gloss: 'Comment fais je arriver a l\'aeroport ?',
          tokens: ['How', 'do', 'I', 'get', 'to', 'the', 'airport?'],
          distractors: ['go', 'at', 'can'],
          focus: '"get to" = rejoindre un lieu',
        ),
        CardItem(
          id: 'en-3-4',
          target: 'The train leaves at half past six.',
          native: 'Le train part a six heures et demie.',
          gloss: 'Le train part a demi passe six.',
          tokens: ['The', 'train', 'leaves', 'at', 'half', 'past', 'six.'],
          distractors: ['departs', 'in', 'and half'],
          focus: 'half past + heure = et demie',
        ),
        CardItem(
          id: 'en-3-5',
          target: 'Is it far from here?',
          native: 'Est-ce loin d\'ici ?',
          gloss: 'Est il loin de ici ?',
          tokens: ['Is', 'it', 'far', 'from', 'here?'],
          distractors: ['Does', 'of', 'there'],
          focus: 'far from = loin de',
        ),
        CardItem(
          id: 'en-3-6',
          target: 'I am looking for this address.',
          native: 'Je cherche cette adresse.',
          gloss: 'Je suis cherchant pour cette adresse.',
          tokens: ['I', 'am', 'looking', 'for', 'this', 'address.'],
          distractors: ['look', 'at', 'that'],
          focus: 'look for = chercher (le "for" est obligatoire)',
        ),
      ],
    ),
    Unit(
      id: 'en-u4',
      title: 'Le quotidien',
      subtitle: 'Habitudes et présent simple',
      level: 'A2',
      grammarLesson: _en4Grammar,
      cards: [
        CardItem(
          id: 'en-4-1',
          target: 'I usually wake up at seven.',
          native: 'Je me reveille généralement a sept heures.',
          gloss: 'Je habituellement reveille haut a sept.',
          tokens: ['I', 'usually', 'wake', 'up', 'at', 'seven.'],
          distractors: ['am waking', 'in', 'the seven'],
          focus: 'L\'adverbe de frequence se place avant le verbe',
        ),
        CardItem(
          id: 'en-4-2',
          target: 'She works in a hospital.',
          native: 'Elle travaille dans un hopital.',
          gloss: 'Elle travaille dans un hopital.',
          tokens: ['She', 'works', 'in', 'a', 'hospital.'],
          distractors: ['work', 'at', 'the'],
          focus: 'Le -s de la 3e personne du singulier',
        ),
        CardItem(
          id: 'en-4-3',
          target: 'We do not work on Sundays.',
          native: 'Nous ne travaillons pas le dimanche.',
          gloss: 'Nous faisons pas travailler sur dimanches.',
          tokens: ['We', 'do', 'not', 'work', 'on', 'Sundays.'],
          distractors: ['are not', 'in', 'the Sunday'],
          focus: 'on + jour de la semaine',
        ),
        CardItem(
          id: 'en-4-4',
          target: 'What time do you finish?',
          native: 'A quelle heure finis-tu ?',
          gloss: 'Quelle heure fais tu finir ?',
          tokens: ['What', 'time', 'do', 'you', 'finish?'],
          distractors: ['Which', 'hour', 'are'],
          focus: 'What time, pas "which hour"',
        ),
        CardItem(
          id: 'en-4-5',
          target: 'I am tired because I did not sleep.',
          native: 'Je suis fatigue parce que je n\'ai pas dormi.',
          gloss: 'Je suis fatigue parce-que je fis pas dormir.',
          tokens: ['I', 'am', 'tired', 'because', 'I', 'did', 'not', 'sleep.'],
          distractors: ['have', 'slept', 'why'],
          focus: 'Après "did not", le verbe reste à la base',
        ),
        CardItem(
          id: 'en-4-6',
          target: 'He is watching a film right now.',
          native: 'Il regarde un film en ce moment.',
          gloss: 'Il est regardant un film droit maintenant.',
          tokens: ['He', 'is', 'watching', 'a', 'film', 'right', 'now.'],
          distractors: ['watches', 'the', 'actually'],
          focus: 'Action en cours = be + verbe-ing',
        ),
      ],
    ),
    Unit(
      id: 'en-u5',
      title: 'Raconter',
      subtitle: 'Le passe et les recits',
      level: 'A2',
      grammarLesson: _en5Grammar,
      cards: [
        CardItem(
          id: 'en-5-1',
          target: 'I went to London last year.',
          native: 'Je suis allé a Londres l\'année dernière.',
          gloss: 'Je allai a Londres derniere annee.',
          tokens: ['I', 'went', 'to', 'London', 'last', 'year.'],
          distractors: ['goed', 'in', 'the last'],
          focus: 'go devient went (verbe irregulier)',
        ),
        CardItem(
          id: 'en-5-2',
          target: 'We stayed there for a week.',
          native: 'Nous y sommes restes une semaine.',
          gloss: 'Nous restames la pour une semaine.',
          tokens: ['We', 'stayed', 'there', 'for', 'a', 'week.'],
          distractors: ['stay', 'during', 'one'],
          focus: 'for + durée (jamais "during")',
        ),
        CardItem(
          id: 'en-5-3',
          target: 'It was raining all day.',
          native: 'Il a plu toute la journée.',
          gloss: 'Il etait pleuvant tout jour.',
          tokens: ['It', 'was', 'raining', 'all', 'day.'],
          distractors: ['rained', 'every', 'the all'],
          focus: 'was + -ing = decor du recit',
        ),
        CardItem(
          id: 'en-5-4',
          target: 'Have you ever been to Japan?',
          native: 'Es-tu deja allé au Japon ?',
          gloss: 'As tu jamais ete a Japon ?',
          tokens: ['Have', 'you', 'ever', 'been', 'to', 'Japan?'],
          distractors: ['Did', 'already', 'gone'],
          focus: 'Experience de vie = have + participe passe',
        ),
        CardItem(
          id: 'en-5-5',
          target: 'I have never tried this before.',
          native: 'Je n\'ai jamais essaye ca avant.',
          gloss: 'Je ai jamais essaye ceci avant.',
          tokens: ['I', 'have', 'never', 'tried', 'this', 'before.'],
          distractors: ['ever', 'try', 'that'],
          focus: 'never porte deja la negation',
        ),
        CardItem(
          id: 'en-5-6',
          target: 'The food was better than I expected.',
          native: 'La nourriture était meilleure que ce que j\'attendais.',
          gloss: 'La nourriture etait meilleure que je attendais.',
          tokens: ['The', 'food', 'was', 'better', 'than', 'I', 'expected.'],
          distractors: ['more good', 'that', 'as'],
          focus: 'good devient better au comparatif',
        ),
      ],
    ),
    Unit(
      id: 'en-u6',
      title: 'Nuancer',
      subtitle: 'Opinions, projets, hypotheses',
      level: 'B1',
      grammarLesson: _en6Grammar,
      cards: [
        CardItem(
          id: 'en-6-1',
          target: 'I think we should leave earlier.',
          native: 'Je pense que nous devrions partir plus tôt.',
          gloss: 'Je pense nous devrions partir plus-tot.',
          tokens: ['I', 'think', 'we', 'should', 'leave', 'earlier.'],
          distractors: ['that we', 'would', 'more early'],
          focus: '"that" s\'omet après think en anglais courant',
        ),
        CardItem(
          id: 'en-6-2',
          target: 'If I had more time, I would travel.',
          native: 'Si j\'avais plus de temps, je voyagerais.',
          gloss: 'Si je avais plus temps, je voudrais voyager.',
          tokens: ['If', 'I', 'had', 'more', 'time,', 'I', 'would', 'travel.'],
          distractors: ['have', 'will', 'of time'],
          focus: 'Hypothese: if + passe, puis would',
        ),
        CardItem(
          id: 'en-6-3',
          target: 'I am going to look for a new job.',
          native: 'Je vais chercher un nouveau travail.',
          gloss: 'Je suis allant a chercher pour un nouveau travail.',
          tokens: ['I', 'am', 'going', 'to', 'look', 'for', 'a', 'new', 'job.'],
          distractors: ['will', 'search', 'the'],
          focus: 'be going to = intention deja decidee',
        ),
        CardItem(
          id: 'en-6-4',
          target: 'It depends on what you want.',
          native: 'Ca depend de ce que tu veux.',
          gloss: 'Il depend sur quoi tu veux.',
          tokens: ['It', 'depends', 'on', 'what', 'you', 'want.'],
          distractors: ['of', 'that', 'depend'],
          focus: 'depend ON, jamais "depend of"',
        ),
        CardItem(
          id: 'en-6-5',
          target: 'I am used to working late.',
          native: 'J\'ai l\'habitude de travailler tard.',
          gloss: 'Je suis habitue a travaillant tard.',
          tokens: ['I', 'am', 'used', 'to', 'working', 'late.'],
          distractors: ['use', 'work', 'lately'],
          focus: 'be used to + verbe-ing (piege classique)',
        ),
        CardItem(
          id: 'en-6-6',
          target: 'That is exactly what I meant.',
          native: 'C\'est exactement ce que je voulais dire.',
          gloss: 'Cela est exactement quoi je voulais-dire.',
          tokens: ['That', 'is', 'exactly', 'what', 'I', 'meant.'],
          distractors: ['This', 'that', 'mean'],
          focus: 'mean devient meant au passe',
        ),
      ],
    ),
  ],
);
