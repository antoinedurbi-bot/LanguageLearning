import 'package:learning_app/data/models/vocabulary.dart';

/// Spanish vocabulary for French speakers.
///
/// French and Spanish share so much vocabulary that a plain word list teaches
/// almost nothing. The entries here concentrate on the places the resemblance
/// breaks: false friends, verbs that take a different preposition, and pairs
/// where Spanish makes a distinction French does not.
const vocabEs = VocabularyPack(
  languageCode: 'es',
  themes: [
    VocabTheme(
      id: 'es-t1',
      title: 'Les indispensables',
      subtitle: 'Les mots qu\'on utilise dans toutes les phrases',
      entries: [
        VocabEntry(
          id: 'es-v-ser',
          target: 'ser',
          native: 'être (essence)',
          pos: 'verbe',
          example: 'Soy de Francia.',
          exampleNative: 'Je viens de France.',
          note: 'Pour ce qui definit : origine, nationalite, metier, '
              'caractère, heure. Si la qualite fait partie de l\'identite, '
              'c\'est ser.',
        ),
        VocabEntry(
          id: 'es-v-estar',
          target: 'estar',
          native: 'être (état, lieu)',
          pos: 'verbe',
          example: 'Estoy muy cansado hoy.',
          exampleNative: 'Je suis tres fatigue aujourd\'hui.',
          note: 'Pour ce qui peut changer : humeur, sante, position. '
              'Test rapide : si tu peux ajouter "en ce moment", c\'est estar.',
        ),
        VocabEntry(
          id: 'es-v-hay',
          target: 'hay',
          native: 'il y a',
          pos: 'verbe',
          example: 'Hay un problema.',
          exampleNative: 'Il y à un problème.',
          note: 'Forme unique et invariable : "hay un libro" comme "hay muchos '
              'libros". Ne jamais l\'accorder au pluriel.',
        ),
        VocabEntry(
          id: 'es-v-quedar',
          target: 'quedar / quedarse',
          native: 'rester, se trouver',
          pos: 'verbe',
          example: 'Prefiero quedarme en casa.',
          exampleNative: 'Je préfère rester à la maison.',
          note: 'Sans pronom, il veut dire "se trouver" ou "convenir" '
              '(quedamos a las ocho = on se dit huit heures). Avec pronom, '
              '"rester quelque part".',
        ),
        VocabEntry(
          id: 'es-v-tener-que',
          target: 'tener que',
          native: 'devoir, être oblige de',
          pos: 'expression',
          example: 'Tengo que irme.',
          exampleNative: 'Je dois y aller.',
          note: 'Suivi de l\'infinitif. C\'est la facon normale de dire '
              '"devoir" ; "deber" existe mais sonne moral ou formel.',
        ),
        VocabEntry(
          id: 'es-v-acabar-de',
          target: 'acabar de',
          native: 'venir de (faire)',
          pos: 'expression',
          example: 'Acabo de llegar.',
          exampleNative: 'Je viens d\'arriver.',
          note: 'Traduit le passe recent français. Ne jamais traduire "je '
              'viens de" par "vengo de", qui veut dire "je viens de (ce lieu)".',
        ),
        VocabEntry(
          id: 'es-v-pero',
          target: 'pero / sino',
          native: 'mais',
          pos: 'connecteur',
          example: 'No es caro, sino barato.',
          exampleNative: 'Ce n\'est pas cher, mais bon marche.',
          note: 'Deux "mais" : pero oppose deux idées ; sino corrige une '
              'negation qui precede. Après une negation, c\'est presque '
              'toujours sino.',
        ),
        VocabEntry(
          id: 'es-v-tambien',
          target: 'también / tampoco',
          native: 'aussi / non plus',
          pos: 'adverbe',
          example: 'Yo tampoco lo sé.',
          exampleNative: 'Moi non plus je ne le sais pas.',
          note: 'Tampoco est la version negative de también. Il porte deja la '
              'negation : on ne rajoute pas "no" devant quand il est en tete.',
        ),
        VocabEntry(
          id: 'es-v-mismo',
          target: 'mismo',
          native: 'meme',
          pos: 'adjectif',
          example: 'Es el mismo problema.',
          exampleNative: 'C\'est le meme problème.',
          note: 'Devant le nom : "le meme". Après le nom ou le pronom, il '
              'insiste : "yo mismo" = moi-meme.',
        ),
        VocabEntry(
          id: 'es-v-ya',
          target: 'ya',
          native: 'deja, maintenant',
          pos: 'adverbe',
          example: 'Ya lo sé.',
          exampleNative: 'Je le sais deja.',
          note: 'Un des mots les plus frequents et les plus glissants : selon '
              'le contexte il veut dire deja, maintenant, ca y est, ou sert '
              'juste a marquer l\'impatience.',
        ),
        VocabEntry(
          id: 'es-v-vale',
          target: 'vale',
          native: 'd\'accord, OK',
          pos: 'expression',
          example: 'Vale, nos vemos mañana.',
          exampleNative: 'D\'accord, on se voit demain.',
          note: 'Omnipresent en Espagne, beaucoup moins en Amerique latine ou '
              'l\'on dira plutôt "bueno" ou "dale".',
        ),
        VocabEntry(
          id: 'es-v-gustar',
          target: 'gustar',
          native: 'plaire (aimer)',
          pos: 'verbe',
          example: 'Me gusta este barrio.',
          exampleNative: 'J\'aime ce quartier.',
          note: 'Se construit a l\'envers : la chose aimee est le sujet. Le '
              'verbe s\'accorde avec elle, pas avec la personne.',
        ),
      ],
    ),
    VocabTheme(
      id: 'es-t2',
      title: 'Faux amis',
      subtitle: 'Les mots qui ressemblent au français et ne veulent pas dire pareil',
      entries: [
        VocabEntry(
          id: 'es-v-embarazada',
          target: 'embarazada',
          native: 'enceinte',
          pos: 'adjectif',
          example: 'Mi hermana está embarazada.',
          exampleNative: 'Ma soeur est enceinte.',
          note: 'Le faux ami le plus couteux de l\'espagnol : ne veut PAS dire '
              'embarrassee. Pour cela on dit "avergonzada".',
        ),
        VocabEntry(
          id: 'es-v-constipado',
          target: 'constipado',
          native: 'enrhume',
          pos: 'adjectif',
          example: 'Estoy constipado.',
          exampleNative: 'Je suis enrhume.',
          note: 'Rien à voir avec la constipation. Dire "estoy constipado" a '
              'un pharmacien te vaudra du sirop pour le rhume.',
        ),
        VocabEntry(
          id: 'es-v-largo',
          target: 'largo',
          native: 'long',
          pos: 'adjectif',
          example: 'Es un camino muy largo.',
          exampleNative: 'C\'est un chemin tres long.',
          note: 'Ne veut pas dire "large". Large se dit "ancho".',
        ),
        VocabEntry(
          id: 'es-v-sensible',
          target: 'sensible',
          native: 'sensible (emotif)',
          pos: 'adjectif',
          example: 'Es una persona muy sensible.',
          exampleNative: 'C\'est une personne tres sensible.',
          note: 'Attention au retour : "sensible" en anglais veut dire '
              'raisonnable. En espagnol le sens est bien celui du français.',
        ),
        VocabEntry(
          id: 'es-v-ropa',
          target: 'ropa',
          native: 'vetements',
          pos: 'nom',
          example: 'Necesito comprar ropa.',
          exampleNative: 'J\'ai besoin d\'acheter des vetements.',
          note: 'Indenombrable et singulier : "la ropa", jamais "las ropas". '
              'Aucun rapport avec une corde.',
        ),
        VocabEntry(
          id: 'es-v-salir',
          target: 'salir',
          native: 'sortir',
          pos: 'verbe',
          example: 'Salgo a las ocho.',
          exampleNative: 'Je sors a huit heures.',
          note: 'Ne veut pas dire "salir". Sale se dit "sucio", et salir '
              '(rendre sale) se dit "ensuciar".',
        ),
        VocabEntry(
          id: 'es-v-entender',
          target: 'entender',
          native: 'comprendre',
          pos: 'verbe',
          example: 'No entiendo, lo siento.',
          exampleNative: 'Je ne comprends pas, désolé.',
          note: 'Ne veut pas dire "entendre" (= oir). Diphtongue au present : '
              'entiendo, entiendes, entiende.',
        ),
        VocabEntry(
          id: 'es-v-quitar',
          target: 'quitar',
          native: 'enlever, retirer',
          pos: 'verbe',
          example: 'Quita eso de la mesa.',
          exampleNative: 'Enleve ca de la table.',
          note: 'Ne veut pas dire "quitter". Quitter un lieu se dit "salir '
              'de", quitter quelqu\'un "dejar".',
        ),
        VocabEntry(
          id: 'es-v-atender',
          target: 'atender',
          native: 'servir, s\'occuper de',
          pos: 'verbe',
          example: '¿Le atienden?',
          exampleNative: 'On s\'occupe de vous ?',
          note: 'Ne veut pas dire "attendre" (= esperar). C\'est la phrase '
              'qu\'on entend en entrant dans une boutique.',
        ),
        VocabEntry(
          id: 'es-v-discutir',
          target: 'discutir',
          native: 'se disputer',
          pos: 'verbe',
          example: 'No quiero discutir contigo.',
          exampleNative: 'Je ne veux pas me disputer avec toi.',
          note: 'Plus conflictuel qu\'en français. Pour "discuter" au sens '
              'neutre, on dit "hablar" ou "charlar".',
        ),
        VocabEntry(
          id: 'es-v-actualmente',
          target: 'actualmente',
          native: 'actuellement',
          pos: 'adverbe',
          example: 'Actualmente vivo en Madrid.',
          exampleNative: 'Actuellement j\'habite a Madrid.',
          note: 'Celui-ci correspond bien au français — contrairement a '
              'l\'anglais "actually". Utile a noter justement pour ne pas '
              'sur-corriger.',
        ),
        VocabEntry(
          id: 'es-v-exito',
          target: 'éxito',
          native: 'succes',
          pos: 'nom',
          example: 'La fiesta fue un éxito.',
          exampleNative: 'La fete a ete un succes.',
          note: 'Ne veut pas dire "sortie" (= salida). Faux ami avec '
              'l\'anglais "exit" plus qu\'avec le français.',
        ),
      ],
    ),
    VocabTheme(
      id: 'es-t3',
      title: 'Le quotidien',
      subtitle: 'Ce dont on parle vraiment tous les jours',
      entries: [
        VocabEntry(
          id: 'es-v-desayunar',
          target: 'desayunar',
          native: 'prendre le petit-dejeuner',
          pos: 'verbe',
          example: 'Siempre desayuno antes de salir.',
          exampleNative: 'Je prends toujours mon petit-dejeuner avant de sortir.',
          note: 'Un seul verbe la ou le français a besoin de quatre mots. '
              'Meme logique pour comer (dejeuner) et cenar (diner).',
        ),
        VocabEntry(
          id: 'es-v-trabajo',
          target: 'trabajo',
          native: 'travail, emploi',
          pos: 'nom',
          example: 'Trabajo desde casa los lunes.',
          exampleNative: 'Je travaille de chez moi le lundi.',
          note: 'Le meme mot sert de nom et de forme verbale "je travaille". '
              'Le contexte tranche.',
        ),
        VocabEntry(
          id: 'es-v-tienda',
          target: 'tienda',
          native: 'magasin, boutique',
          pos: 'nom',
          example: 'Voy a la tienda.',
          exampleNative: 'Je vais au magasin.',
          note: 'Veut aussi dire "tente" (tienda de campana). Le contexte '
              'evite toute confusion.',
        ),
        VocabEntry(
          id: 'es-v-cuenta',
          target: 'cuenta',
          native: 'addition, compte',
          pos: 'nom',
          example: 'La cuenta, por favor.',
          exampleNative: 'L\'addition, s\'il vous plait.',
          note: 'Au restaurant c\'est l\'addition ; à la banque, le compte. '
              '"Darse cuenta" = se rendre compte, expression tres fréquente.',
        ),
        VocabEntry(
          id: 'es-v-barrio',
          target: 'barrio',
          native: 'quartier',
          pos: 'nom',
          example: 'Me gusta mucho este barrio.',
          exampleNative: 'J\'aime beaucoup ce quartier.',
          note: 'Mot tres charge culturellement en Espagne et en Amerique '
              'latine : le barrio, c\'est le voisinage vecu, pas juste une '
              'zone administrative.',
        ),
        VocabEntry(
          id: 'es-v-echar-de-menos',
          target: 'echar de menos',
          native: 'manquer (a quelqu\'un)',
          pos: 'expression',
          example: 'Te echo de menos.',
          exampleNative: 'Tu me manques.',
          note: 'Construction inverse du français : le sujet est celui qui '
              'ressent le manque. "Te echo de menos" = c\'est moi qui te '
              'regrette. En Amerique latine on dit plutôt "extranar".',
        ),
        VocabEntry(
          id: 'es-v-pedir',
          target: 'pedir',
          native: 'demander (quelque chose)',
          pos: 'verbe',
          example: 'Voy a pedir un café.',
          exampleNative: 'Je vais commander un cafe.',
          note: 'Pedir = demander pour obtenir (commander). Preguntar = poser '
              'une question. Le français "demander" couvre les deux, d\'ou '
              'l\'erreur fréquente.',
        ),
        VocabEntry(
          id: 'es-v-llevar',
          target: 'llevar',
          native: 'porter, emmener',
          pos: 'verbe',
          example: 'Llevo dos años aquí.',
          exampleNative: 'Cela fait deux ans que je suis ici.',
          note: 'Sert aussi a exprimer la duree ecoulee : "llevo + duree" est '
              'une alternative tres courante a "hace... que".',
        ),
        VocabEntry(
          id: 'es-v-tardar',
          target: 'tardar',
          native: 'mettre du temps',
          pos: 'verbe',
          example: 'Tarda veinte minutos.',
          exampleNative: 'Ca prend vingt minutes.',
          note: 'Pas de rapport avec "tard" au sens d\'être en retard, qui se '
              'dit "llegar tarde".',
        ),
        VocabEntry(
          id: 'es-v-probar',
          target: 'probar',
          native: 'essayer, gouter',
          pos: 'verbe',
          example: '¿Quieres probarlo?',
          exampleNative: 'Tu veux gouter ?',
          note: 'Gouter un plat ou essayer un vetement (probarse). Pour '
              '"essayer de faire", c\'est "intentar" ou "tratar de".',
        ),
        VocabEntry(
          id: 'es-v-parecer',
          target: 'parecer',
          native: 'sembler, paraître',
          pos: 'verbe',
          example: '¿Qué te parece?',
          exampleNative: 'Qu\'en penses-tu ?',
          note: '"¿Qué te parece?" est la facon normale de demander un avis, '
              'bien plus fréquente que "¿qué piensas?".',
        ),
        VocabEntry(
          id: 'es-v-hasta',
          target: 'hasta',
          native: 'jusqu\'a',
          pos: 'preposition',
          example: 'Hasta luego.',
          exampleNative: 'A tout a l\'heure.',
          note: 'Base de toutes les formules d\'au revoir : hasta luego, '
              'hasta mañana, hasta pronto. Retenir le moule, pas chaque '
              'formule.',
        ),
      ],
    ),
  ],
  phrases: [
    KeyPhrase(
      id: 'es-p-repeat',
      target: '¿Puede repetir, por favor?',
      native: 'Pouvez-vous repeter, s\'il vous plait ?',
      whenToUse: 'La première phrase a connaître par coeur : elle garde la '
          'conversation ouverte au lieu de la laisser s\'arrêter.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'es-p-slower',
      target: '¿Puede hablar más despacio?',
      native: 'Pouvez-vous parler plus lentement ?',
      whenToUse: 'L\'espagnol se parle vite. Cette demande est banale et ne '
          'gene personne.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'es-p-howsay',
      target: '¿Cómo se dice ... en español?',
      native: 'Comment dit-on ... en espagnol ?',
      whenToUse: 'Fait de ton interlocuteur un professeur. Le mot appris '
          'ainsi, en situation, se retient bien mieux qu\'en liste.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'es-p-mean',
      target: '¿Qué significa eso?',
      native: 'Qu\'est-ce que ca veut dire ?',
      whenToUse: 'Cible un mot précis plutôt que d\'avouer une incompréhension '
          'globale, ce qui bloque tout.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'es-p-notsure',
      target: 'No sé cómo se dice, pero...',
      native: 'Je ne sais pas comment on dit, mais...',
      whenToUse: 'Annonce une phrase maladroite et désamorce le jugement. '
          'Permet de continuer au lieu de se taire.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'es-p-order',
      target: 'Quisiera ..., por favor.',
      native: 'Je voudrais ..., s\'il vous plait.',
      whenToUse: 'Moule a remplir pour commander quoi que ce soit. Quisiera '
          'est nettement plus poli que quiero.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'es-p-thanks',
      target: 'Muchas gracias, muy amable.',
      native: 'Merci beaucoup, c\'est tres aimable.',
      whenToUse: 'Quand quelqu\'un s\'est donne du mal. "Muy amable" seul '
          'suffit souvent.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'es-p-perdone',
      target: 'Perdone, ¿me puede ayudar?',
      native: 'Excusez-moi, pouvez-vous m\'aider ?',
      whenToUse: 'Pour aborder quelqu\'un. "Perdone" (vouvoiement) ouvre ; '
          '"perdona" pour tutoyer.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'es-p-where',
      target: '¿Dónde está el/la ... más cercano?',
      native: 'Ou est le/la ... le plus proche ?',
      whenToUse: 'Un squelette qui donne des dizaines de questions : '
          'supermercado, farmacia, bano.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'es-p-howmuch',
      target: '¿Cuánto cuesta?',
      native: 'Combien ca coûte ?',
      whenToUse: 'Partout ou l\'on achete. Retenir aussi "¿cuánto es?" pour '
          'un total.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'es-p-card',
      target: '¿Puedo pagar con tarjeta?',
      native: 'Puis-je payer par carte ?',
      whenToUse: 'A demander avant de commander dans les petits '
          'etablissements, ou l\'espece reste courante.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'es-p-french',
      target: '¿Habla francés o inglés?',
      native: 'Parlez-vous français ou anglais ?',
      whenToUse: 'Le filet de secours, a garder pour quand la réparation a '
          'echoue.',
      category: 'survie',
    ),
  ],
);
