import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';

const _es1Grammar = GrammarLesson(
  title: 'Ser et estar : deux verbes pour "etre"',
  hook: 'C\'est la premiere vraie difficulte de l\'espagnol pour un '
      'francophone : la ou le francais dit toujours "etre", l\'espagnol '
      'choisit entre deux verbes selon la nature de ce qu\'on decrit.',
  blocks: [
    ExplanationBlock(
      heading: 'Ser : identite et caracteristiques durables',
      body: 'Ser sert pour l\'origine, la nationalite, le metier, le '
          'caractere, l\'heure : tout ce qui definit ce qu\'une chose ou une '
          'personne EST fondamentalement, independamment du moment.',
    ),
    ExplanationBlock(
      heading: 'Estar : etat et position, ce qui peut changer',
      body: 'Estar sert pour la localisation et pour les etats temporaires : '
          'la fatigue, l\'humeur, la sante. La meme phrase francaise '
          '"je suis..." peut donc se traduire par ser OU estar selon si la '
          'qualite dure ou non.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Soy de Francia.',
          native: 'Je viens de France.',
          note: 'origine, permanent : soy (ser)',
        ),
        GrammarExample(
          target: 'Estoy muy cansado hoy.',
          native: 'Je suis tres fatigue aujourd\'hui.',
          note: '"hoy" (aujourd\'hui) signale un etat passager : estoy (estar)',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'Soy cansado.',
      right: 'Estoy cansado.',
      why: 'La fatigue est un etat temporaire, pas une caracteristique '
          'permanente de la personne : elle appelle toujours estar, jamais ser.',
    ),
  ],
);

const _es2Grammar = GrammarLesson(
  title: 'Quisiera : la politesse par le mode',
  hook: 'L\'espagnol rend une phrase polie en changeant la terminaison du '
      'verbe, pas en ajoutant un mot comme "s\'il vous plait" tout seul.',
  blocks: [
    ExplanationBlock(
      heading: 'Quiero vs quisiera',
      body: '"Quiero" (je veux) est direct. "Quisiera" est une forme du '
          'subjonctif imparfait employee comme formule de politesse : elle '
          'adoucit la demande, exactement comme "je voudrais" adoucit "je '
          'veux" en francais.',
    ),
    TableBlock(
      headers: ['Direct', 'Poli'],
      rows: [
        ['Quiero un cafe.', 'Quisiera un cafe, por favor.'],
        ['Quiero pagar.', 'Quisiera pagar, por favor.'],
      ],
    ),
    ExplanationBlock(
      heading: 'Cuanto : l\'accent qui change tout',
      body: '¿Cuánto? avec un accent ecrit est la question "combien ?". '
          'Sans accent, "cuanto" est une conjonction ordinaire. L\'accent '
          'ecrit marque toujours un mot interrogatif ou exclamatif en '
          'espagnol.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: '¿Cuánto cuesta?',
          native: 'Combien ca coute ?',
          note: 'cuanto accentue = mot interrogatif',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'Para favor.',
      right: 'Por favor.',
      why: '"Por" exprime la raison ou la faveur demandee ; "para" exprime '
          'un but ou une destination. La formule de politesse est figee : '
          'por favor, jamais para favor.',
    ),
  ],
);

const _es3Grammar = GrammarLesson(
  title: 'Gustar : la phrase construite a l\'envers',
  hook: 'Gustar est le piege classique du francophone : le sujet de la '
      'phrase espagnole n\'est pas la personne qui aime, mais la chose aimee.',
  blocks: [
    ExplanationBlock(
      heading: 'Qui est le sujet ?',
      body: 'En francais, "j\'aime ce quartier" a "je" pour sujet. En '
          'espagnol, "me gusta este barrio" fonctionne comme "ce quartier '
          'me plait" : c\'est le quartier (este barrio) qui est le sujet du '
          'verbe, et "me" est un complement.',
    ),
    ExplanationBlock(
      heading: 'Accord au singulier ou au pluriel',
      body: 'Puisque le sujet reel est la chose aimee, le verbe s\'accorde '
          'avec elle : gusta si elle est au singulier, gustan si elle est '
          'au pluriel — jamais avec la personne qui aime.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Me gusta mucho este barrio.',
          native: 'J\'aime beaucoup ce quartier.',
          note: 'este barrio = singulier -> gusta',
        ),
        GrammarExample(
          target: 'Me gustan las peliculas antiguas.',
          native: 'J\'aime les vieux films.',
          note: 'las peliculas = pluriel -> gustan',
        ),
      ],
    ),
    TableBlock(
      caption: 'Meme structure pour d\'autres verbes',
      headers: ['Verbe', 'Exemple'],
      rows: [
        ['encantar (adorer)', 'A mi hermana le encanta bailar.'],
        ['interesar (interesser)', 'Me interesa la musica.'],
      ],
    ),
    MistakeBlock(
      wrong: 'Yo gusto las peliculas.',
      right: 'Me gustan las peliculas.',
      why: 'La personne qui aime n\'est jamais le sujet de gustar : elle '
          'devient un pronom complement (me, te, le...) devant le verbe.',
    ),
  ],
);

const _es4Grammar = GrammarLesson(
  title: 'La routine : verbes pronominaux et duree',
  hook: 'Le quotidien en espagnol se raconte avec des verbes reflechis et '
      'une facon particuliere d\'exprimer "depuis combien de temps".',
  blocks: [
    ExplanationBlock(
      heading: 'Verbes pronominaux : le pronom colle au verbe',
      body: 'Comme en francais ("se lever"), l\'espagnol a des verbes '
          'reflechis (levantarse, quedarse). Le pronom (me, te, se...) se '
          'place devant le verbe conjugue, mais se colle a la fin quand le '
          'verbe reste a l\'infinitif : quedar + me = quedarme.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Me levanto a las siete.',
          native: 'Je me leve a sept heures.',
          note: 'me devant le verbe conjugue',
        ),
        GrammarExample(
          target: 'Prefiero quedarme en casa.',
          native: 'Je prefere rester a la maison.',
          note: 'me colle a l\'infinitif : quedar + me',
        ),
      ],
    ),
    ExplanationBlock(
      heading: 'Hace... que : depuis combien de temps',
      body: 'Pour dire depuis combien de temps une action dure encore, '
          'l\'espagnol utilise "hace" + duree + "que" + verbe au present — '
          'la ou le francais dirait "cela fait... que" ou "depuis".',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Hace dos anos que vivo aqui.',
          native: 'Cela fait deux ans que j\'habite ici.',
          note: 'hace + duree + que + present',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'Prefiero quedar me en casa.',
      right: 'Prefiero quedarme en casa.',
      why: 'Avec un infinitif, le pronom reflechi se soude directement a la '
          'fin du verbe : ils forment un seul mot, sans espace.',
    ),
  ],
);

const _es5Grammar = GrammarLesson(
  title: 'Le passe : pretérito vs imparfait',
  hook: 'L\'espagnol distingue deux passes la ou le francais n\'en a '
      'souvent qu\'un a l\'oral : l\'evenement ponctuel, et le decor qui dure.',
  blocks: [
    ExplanationBlock(
      heading: 'Pretérito : l\'evenement, fini et daté',
      body: 'Le preterit (fui, viví) raconte une action achevee a un moment '
          'precis du passe : ce qui s\'est passe, un point sur la ligne du '
          'temps.',
    ),
    ExplanationBlock(
      heading: 'Imparfait : le decor, l\'habitude, ce qui durait',
      body: 'L\'imparfait (era, vivía) decrit ce qui servait de toile de '
          'fond — un etat, une habitude, une description — sans marquer de '
          'debut ni de fin precis.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Ayer fui al mercado.',
          native: 'Hier je suis alle au marche.',
          note: 'evenement ponctuel, date (ayer) : pretérito',
        ),
        GrammarExample(
          target: 'Cuando era pequeno vivia en Sevilla.',
          native: 'Quand j\'etais petit j\'habitais a Seville.',
          note: 'etat durable de l\'enfance : imparfait',
        ),
      ],
    ),
    TableBlock(
      caption: 'Participes passes irreguliers frequents',
      headers: ['Infinitif', 'Participe'],
      rows: [
        ['ver (voir)', 'visto'],
        ['poder (pouvoir)', 'podido'],
        ['decir (dire)', 'dicho'],
      ],
    ),
    MistakeBlock(
      wrong: 'Cuando fui pequeno vivi en Sevilla.',
      right: 'Cuando era pequeno vivia en Sevilla.',
      why: '"Etre petit" est un etat qui a dure des annees, pas un '
          'evenement ponctuel : il appelle l\'imparfait, pas le pretérito.',
    ),
  ],
);

const _es6Grammar = GrammarLesson(
  title: 'Le subjonctif : douter, souhaiter, hypothese irreelle',
  hook: 'Le subjonctif espagnol s\'utilise bien plus souvent qu\'en '
      'francais : des qu\'une phrase exprime un souhait, un doute ou une '
      'condition non realisee, il s\'impose.',
  blocks: [
    ExplanationBlock(
      heading: 'Quand le subjonctif est declenche',
      body: 'Trois declencheurs frequents : un souhait ("espero que..."), '
          'un doute ou une negation d\'opinion ("no creo que..."), et une '
          'action future apres "cuando" (quand + futur se dit au '
          'subjonctif en espagnol, jamais a l\'indicatif futur).',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Espero que puedas venir.',
          native: 'J\'espere que tu pourras venir.',
          note: 'souhait -> puedas (subjonctif), pas puedes',
        ),
        GrammarExample(
          target: 'Cuando llegues, llamame.',
          native: 'Quand tu arriveras, appelle-moi.',
          note: 'cuando + futur -> subjonctif : llegues, pas llegaras',
        ),
      ],
    ),
    ExplanationBlock(
      heading: 'Hypothese irreelle : si + subjonctif imparfait + conditionnel',
      body: 'Pour une situation imaginaire au present ("si j\'avais..."), '
          'l\'espagnol met le verbe apres "si" au subjonctif imparfait '
          '(tuviera), et le conditionnel dans la consequence (viajaria).',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: 'Si tuviera tiempo, viajaria mas.',
          native: 'Si j\'avais le temps, je voyagerais plus.',
          note: 'si + tuviera (subj. imparfait), + viajaria (conditionnel)',
        ),
      ],
    ),
    MistakeBlock(
      wrong: 'Si tengo tiempo, viajaria mas.',
      right: 'Si tuviera tiempo, viajaria mas.',
      why: 'Pour une hypothese irreelle au present, "si" est suivi du '
          'subjonctif imparfait (tuviera), jamais du present de l\'indicatif '
          '(tengo).',
    ),
  ],
);

/// Spanish course for French speakers.
///
/// French and Spanish share enough vocabulary that the bottleneck is not words
/// but grammar contrasts: ser/estar, the subjunctive, gustar-type verbs. The
/// units are ordered around those contrasts rather than around themes alone.
const courseEs = Course(
  languageCode: 'es',
  ttsLocale: 'es-ES',
  units: [
    Unit(
      id: 'es-u1',
      title: 'Primeros pasos',
      subtitle: 'Saluer et se presenter',
      level: 'A1',
      grammarLesson: _es1Grammar,
      cards: [
        CardItem(
          id: 'es-1-1',
          target: 'Hola, me llamo Marco.',
          native: 'Bonjour, je m\'appelle Marco.',
          gloss: 'Salut, me appelle Marco.',
          tokens: ['Hola,', 'me', 'llamo', 'Marco.'],
          distractors: ['mi', 'llama', 'soy llamado'],
          focus: 'llamarse est pronominal, comme en francais',
        ),
        CardItem(
          id: 'es-1-2',
          target: 'Mucho gusto.',
          native: 'Enchante.',
          gloss: 'Beaucoup plaisir.',
          tokens: ['Mucho', 'gusto.'],
          distractors: ['Mucha', 'gusta', 'placer'],
          focus: 'Formule figee de presentation',
        ),
        CardItem(
          id: 'es-1-3',
          target: 'Soy de Francia.',
          native: 'Je viens de France.',
          gloss: 'Suis de France.',
          tokens: ['Soy', 'de', 'Francia.'],
          distractors: ['Estoy', 'desde', 'la Francia'],
          focus: 'Origine = ser, jamais estar',
        ),
        CardItem(
          id: 'es-1-4',
          target: 'Estoy muy cansado hoy.',
          native: 'Je suis tres fatigue aujourd\'hui.',
          gloss: 'Suis tres fatigue aujourd-hui.',
          tokens: ['Estoy', 'muy', 'cansado', 'hoy.'],
          distractors: ['Soy', 'mucho', 'hoy dia'],
          focus: 'Etat passager = estar (contraste avec ser)',
        ),
        CardItem(
          id: 'es-1-5',
          target: 'No entiendo, lo siento.',
          native: 'Je ne comprends pas, desole.',
          gloss: 'Ne comprends, le sens.',
          tokens: ['No', 'entiendo,', 'lo', 'siento.'],
          distractors: ['entiendo no', 'me', 'siente'],
          focus: 'La negation est un simple "no" devant le verbe',
        ),
        CardItem(
          id: 'es-1-6',
          target: '¿Puedes hablar más despacio, por favor?',
          native: 'Peux-tu parler plus lentement, s\'il te plait ?',
          gloss: 'Peux parler plus lentement, par faveur ?',
          tokens: ['¿Puedes', 'hablar', 'más', 'despacio,', 'por', 'favor?'],
          distractors: ['Puede', 'lento', 'para favor'],
          focus: 'por favor (jamais "para favor")',
        ),
      ],
    ),
    Unit(
      id: 'es-u2',
      title: 'En el bar',
      subtitle: 'Commander et payer',
      level: 'A1',
      grammarLesson: _es2Grammar,
      cards: [
        CardItem(
          id: 'es-2-1',
          target: 'Quisiera un café con leche.',
          native: 'Je voudrais un cafe au lait.',
          gloss: 'Voudrais un cafe avec lait.',
          tokens: ['Quisiera', 'un', 'café', 'con', 'leche.'],
          distractors: ['Quiero', 'a', 'la leche'],
          focus: 'Quisiera = forme polie de quiero',
        ),
        CardItem(
          id: 'es-2-2',
          target: '¿Cuánto cuesta?',
          native: 'Combien ca coute ?',
          gloss: 'Combien coute ?',
          tokens: ['¿Cuánto', 'cuesta?'],
          distractors: ['¿Cuántos', 'costa', 'es'],
          focus: 'costar diphtongue: o devient ue',
        ),
        CardItem(
          id: 'es-2-3',
          target: 'La cuenta, por favor.',
          native: 'L\'addition, s\'il vous plait.',
          gloss: 'La note, par faveur.',
          tokens: ['La', 'cuenta,', 'por', 'favor.'],
          distractors: ['El', 'adicion', 'cuento'],
          focus: 'la cuenta = l\'addition',
        ),
        CardItem(
          id: 'es-2-4',
          target: '¿Tienen algo sin gluten?',
          native: 'Avez-vous quelque chose sans gluten ?',
          gloss: 'Ont quelque-chose sans gluten ?',
          tokens: ['¿Tienen', 'algo', 'sin', 'gluten?'],
          distractors: ['¿Tienes', 'alguno', 'no'],
          focus: 'algo = quelque chose (invariable)',
        ),
        CardItem(
          id: 'es-2-5',
          target: '¿Puedo pagar con tarjeta?',
          native: 'Puis-je payer par carte ?',
          gloss: 'Peux payer avec carte ?',
          tokens: ['¿Puedo', 'pagar', 'con', 'tarjeta?'],
          distractors: ['¿Puede', 'por', 'la tarjeta'],
          focus: 'pagar con + moyen de paiement',
        ),
        CardItem(
          id: 'es-2-6',
          target: 'Estaba todo muy rico, gracias.',
          native: 'Tout etait tres bon, merci.',
          gloss: 'Etait tout tres savoureux, merci.',
          tokens: ['Estaba', 'todo', 'muy', 'rico,', 'gracias.'],
          distractors: ['Era', 'mucho', 'bueno'],
          focus: 'rico se dit d\'un plat, pas seulement "riche"',
        ),
      ],
    ),
    Unit(
      id: 'es-u3',
      title: 'Me gusta',
      subtitle: 'Gouts et preferences',
      level: 'A1',
      grammarLesson: _es3Grammar,
      cards: [
        CardItem(
          id: 'es-3-1',
          target: 'Me gusta mucho este barrio.',
          native: 'J\'aime beaucoup ce quartier.',
          gloss: 'Me plait beaucoup ce quartier.',
          tokens: ['Me', 'gusta', 'mucho', 'este', 'barrio.'],
          distractors: ['Yo gusto', 'muy', 'esto'],
          focus: 'gustar se construit a l\'envers: la chose est sujet',
        ),
        CardItem(
          id: 'es-3-2',
          target: 'Me gustan las películas antiguas.',
          native: 'J\'aime les vieux films.',
          gloss: 'Me plaisent les films anciens.',
          tokens: ['Me', 'gustan', 'las', 'películas', 'antiguas.'],
          distractors: ['gusta', 'los', 'antiguos'],
          focus: 'gustan au pluriel quand la chose aimee est plurielle',
        ),
        CardItem(
          id: 'es-3-3',
          target: 'No me gusta nada el ruido.',
          native: 'Je n\'aime pas du tout le bruit.',
          gloss: 'Ne me plait rien le bruit.',
          tokens: ['No', 'me', 'gusta', 'nada', 'el', 'ruido.'],
          distractors: ['nunca', 'la', 'ruida'],
          focus: 'La double negation est obligatoire en espagnol',
        ),
        CardItem(
          id: 'es-3-4',
          target: 'A mi hermana le encanta bailar.',
          native: 'Ma soeur adore danser.',
          gloss: 'A ma soeur lui enchante danser.',
          tokens: ['A', 'mi', 'hermana', 'le', 'encanta', 'bailar.'],
          distractors: ['Mi', 'la', 'encantan'],
          focus: 'encantar suit la meme structure que gustar',
        ),
        CardItem(
          id: 'es-3-5',
          target: 'Prefiero quedarme en casa.',
          native: 'Je prefere rester a la maison.',
          gloss: 'Prefere rester-me en maison.',
          tokens: ['Prefiero', 'quedarme', 'en', 'casa.'],
          distractors: ['Prefero', 'quedar me', 'la casa'],
          focus: 'Le pronom se colle a l\'infinitif',
        ),
        CardItem(
          id: 'es-3-6',
          target: '¿Qué te parece si vamos mañana?',
          native: 'Qu\'en penses-tu si on y va demain ?',
          gloss: 'Quoi te semble si allons demain ?',
          tokens: ['¿Qué', 'te', 'parece', 'si', 'vamos', 'mañana?'],
          distractors: ['¿Cómo', 'piensas', 'iremos'],
          focus: 'Que te parece = qu\'en penses-tu',
        ),
      ],
    ),
    Unit(
      id: 'es-u4',
      title: 'La rutina',
      subtitle: 'Quotidien et verbes pronominaux',
      level: 'A2',
      grammarLesson: _es4Grammar,
      cards: [
        CardItem(
          id: 'es-4-1',
          target: 'Me levanto a las siete.',
          native: 'Je me leve a sept heures.',
          gloss: 'Me leve a les sept.',
          tokens: ['Me', 'levanto', 'a', 'las', 'siete.'],
          distractors: ['Yo levanto', 'los', 'la siete'],
          focus: 'a las + heure (article feminin pluriel)',
        ),
        CardItem(
          id: 'es-4-2',
          target: 'Siempre desayuno antes de salir.',
          native: 'Je prends toujours mon petit-dejeuner avant de sortir.',
          gloss: 'Toujours dejeune avant de sortir.',
          tokens: ['Siempre', 'desayuno', 'antes', 'de', 'salir.'],
          distractors: ['Todo el tiempo', 'que', 'saliendo'],
          focus: 'antes de + infinitif',
        ),
        CardItem(
          id: 'es-4-3',
          target: 'Trabajo desde casa los lunes.',
          native: 'Je travaille de chez moi le lundi.',
          gloss: 'Travaille depuis maison les lundis.',
          tokens: ['Trabajo', 'desde', 'casa', 'los', 'lunes.'],
          distractors: ['de', 'la casa', 'el lunes'],
          focus: 'los lunes = tous les lundis',
        ),
        CardItem(
          id: 'es-4-4',
          target: 'Estoy aprendiendo español desde enero.',
          native: 'J\'apprends l\'espagnol depuis janvier.',
          gloss: 'Suis apprenant espagnol depuis janvier.',
          tokens: ['Estoy', 'aprendiendo', 'español', 'desde', 'enero.'],
          distractors: ['Soy', 'aprendo', 'hace'],
          focus: 'estar + gerondif pour une action en cours',
        ),
        CardItem(
          id: 'es-4-5',
          target: 'Hace dos años que vivo aquí.',
          native: 'Cela fait deux ans que j\'habite ici.',
          gloss: 'Fait deux ans que vis ici.',
          tokens: ['Hace', 'dos', 'años', 'que', 'vivo', 'aquí.'],
          distractors: ['Hay', 'año', 'viví'],
          focus: 'hace + duree + que + present',
        ),
        CardItem(
          id: 'es-4-6',
          target: 'Tengo que irme, es tarde.',
          native: 'Je dois y aller, il est tard.',
          gloss: 'Ai que aller-me, est tard.',
          tokens: ['Tengo', 'que', 'irme,', 'es', 'tarde.'],
          distractors: ['Debo que', 'ir me', 'esta'],
          focus: 'tener que + infinitif = devoir',
        ),
      ],
    ),
    Unit(
      id: 'es-u5',
      title: 'Contar el pasado',
      subtitle: 'Passe simple et imparfait',
      level: 'A2',
      grammarLesson: _es5Grammar,
      cards: [
        CardItem(
          id: 'es-5-1',
          target: 'Ayer fui al mercado.',
          native: 'Hier je suis alle au marche.',
          gloss: 'Hier allai au marche.',
          tokens: ['Ayer', 'fui', 'al', 'mercado.'],
          distractors: ['iba', 'a el', 'he ido'],
          focus: 'fui = passe simple de ir (et de ser)',
        ),
        CardItem(
          id: 'es-5-2',
          target: 'Cuando era pequeño vivía en Sevilla.',
          native: 'Quand j\'etais petit j\'habitais a Seville.',
          gloss: 'Quand etais petit vivais en Seville.',
          tokens: ['Cuando', 'era', 'pequeño', 'vivía', 'en', 'Sevilla.'],
          distractors: ['fui', 'viví', 'a'],
          focus: 'Imparfait pour le decor, passe simple pour l\'evenement',
        ),
        CardItem(
          id: 'es-5-3',
          target: 'Hemos visto una película muy buena.',
          native: 'Nous avons vu un tres bon film.',
          gloss: 'Avons vu un film tres bon.',
          tokens: ['Hemos', 'visto', 'una', 'película', 'muy', 'buena.'],
          distractors: ['Habemos', 'vido', 'mucho'],
          focus: 'ver donne le participe irregulier visto',
        ),
        CardItem(
          id: 'es-5-4',
          target: 'No pude venir porque estaba enfermo.',
          native: 'Je n\'ai pas pu venir parce que j\'etais malade.',
          gloss: 'Ne pus venir parce-que etais malade.',
          tokens: ['No', 'pude', 'venir', 'porque', 'estaba', 'enfermo.'],
          distractors: ['podía', 'por que', 'era'],
          focus: 'porque en un mot = parce que',
        ),
        CardItem(
          id: 'es-5-5',
          target: 'Nos quedamos allí una semana.',
          native: 'Nous y sommes restes une semaine.',
          gloss: 'Nous restames la-bas une semaine.',
          tokens: ['Nos', 'quedamos', 'allí', 'una', 'semana.'],
          distractors: ['Se', 'quedábamos', 'ahí de'],
          focus: 'quedarse = rester quelque part',
        ),
        CardItem(
          id: 'es-5-6',
          target: 'Fue mejor de lo que esperaba.',
          native: 'C\'etait mieux que ce que j\'attendais.',
          gloss: 'Fut meilleur de ce que attendais.',
          tokens: ['Fue', 'mejor', 'de', 'lo', 'que', 'esperaba.'],
          distractors: ['Era', 'más bueno', 'que'],
          focus: 'de lo que devant une proposition comparative',
        ),
      ],
    ),
    Unit(
      id: 'es-u6',
      title: 'Matizar',
      subtitle: 'Subjonctif et hypotheses',
      level: 'B1',
      grammarLesson: _es6Grammar,
      cards: [
        CardItem(
          id: 'es-6-1',
          target: 'Espero que puedas venir.',
          native: 'J\'espere que tu pourras venir.',
          gloss: 'Espere que puisses venir.',
          tokens: ['Espero', 'que', 'puedas', 'venir.'],
          distractors: ['puedes', 'podras', 'de'],
          focus: 'Souhait = subjonctif dans la subordonnee',
        ),
        CardItem(
          id: 'es-6-2',
          target: 'No creo que sea buena idea.',
          native: 'Je ne crois pas que ce soit une bonne idee.',
          gloss: 'Ne crois que soit bonne idee.',
          tokens: ['No', 'creo', 'que', 'sea', 'buena', 'idea.'],
          distractors: ['es', 'este', 'una buena'],
          focus: 'Doute ou negation declenchent le subjonctif',
        ),
        CardItem(
          id: 'es-6-3',
          target: 'Cuando llegues, llamame.',
          native: 'Quand tu arriveras, appelle-moi.',
          gloss: 'Quand arrives, appelle-moi.',
          tokens: ['Cuando', 'llegues,', 'llamame.'],
          distractors: ['llegas', 'llegaras', 'me llama'],
          focus: 'cuando + futur se dit au subjonctif',
        ),
        CardItem(
          id: 'es-6-4',
          target: 'Si tuviera tiempo, viajaria mas.',
          native: 'Si j\'avais le temps, je voyagerais plus.',
          gloss: 'Si eusse temps, voyagerais plus.',
          tokens: ['Si', 'tuviera', 'tiempo,', 'viajaria', 'mas.'],
          distractors: ['tengo', 'viajare', 'mucho'],
          focus: 'Hypothese irreelle: imparfait du subjonctif + conditionnel',
        ),
        CardItem(
          id: 'es-6-5',
          target: 'Depende de lo que quieras hacer.',
          native: 'Ca depend de ce que tu veux faire.',
          gloss: 'Depend de ce que veuilles faire.',
          tokens: ['Depende', 'de', 'lo', 'que', 'quieras', 'hacer.'],
          distractors: ['Dependa', 'que', 'quieres'],
          focus: 'lo que = ce que',
        ),
        CardItem(
          id: 'es-6-6',
          target: 'Es justo lo que queria decir.',
          native: 'C\'est exactement ce que je voulais dire.',
          gloss: 'Est juste ce que voulais dire.',
          tokens: ['Es', 'justo', 'lo', 'que', 'queria', 'decir.'],
          distractors: ['Esta', 'exacto', 'quiero'],
          focus: 'justo employe au sens de "exactement"',
        ),
      ],
    ),
  ],
);
