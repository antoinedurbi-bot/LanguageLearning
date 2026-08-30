import 'package:learning_app/data/models/vocabulary.dart';

/// English vocabulary for French speakers.
///
/// Selection is biased toward words where French intuition misleads: false
/// friends, verbs that need a particle, and pairs the learner will otherwise
/// use interchangeably. A word that translates cleanly and behaves like its
/// French equivalent needs a dictionary, not a lesson.
const vocabEn = VocabularyPack(
  languageCode: 'en',
  themes: [
    VocabTheme(
      id: 'en-t1',
      title: 'Les indispensables',
      subtitle: 'Les mots qui reviennent dans une phrase sur deux',
      entries: [
        VocabEntry(
          id: 'en-v-get',
          target: 'to get',
          native: 'obtenir, devenir, arriver',
          pos: 'verbe',
          example: 'How do I get to the station?',
          exampleNative: 'Comment aller à la gare ?',
          note: 'Le verbe le plus polyvalent de l\'anglais. Seul il veut dire '
              '"obtenir" ; suivi d\'une preposition il change de sens : get up '
              '(se lever), get to (rejoindre), get on (monter dans).',
        ),
        VocabEntry(
          id: 'en-v-make',
          target: 'to make',
          native: 'faire (fabriquer)',
          pos: 'verbe',
          example: 'I made a mistake.',
          exampleNative: 'J\'ai fait une erreur.',
          note: 'Le français à un seul "faire", l\'anglais deux. "Make" = '
              'produire un résultat (make a cake, make a decision). "Do" = '
              'accomplir une activité (do the dishes, do your homework).',
        ),
        VocabEntry(
          id: 'en-v-do',
          target: 'to do',
          native: 'faire (accomplir)',
          pos: 'verbe',
          example: 'What do you do?',
          exampleNative: 'Que fais-tu dans la vie ?',
          note: 'Sert aussi d\'auxiliaire vide pour les questions et les '
              'negations : "Do you like it?", "I do not know". Dans ce role il '
              'ne se traduit pas du tout.',
        ),
        VocabEntry(
          id: 'en-v-actually',
          target: 'actually',
          native: 'en fait, en realite',
          pos: 'adverbe',
          example: 'Actually, I think you are right.',
          exampleNative: 'En fait, je pense que tu as raison.',
          note: 'Faux ami classique : ne veut PAS dire "actuellement". Pour '
              '"actuellement" il faut dire "currently" ou "at the moment".',
        ),
        VocabEntry(
          id: 'en-v-eventually',
          target: 'eventually',
          native: 'finalement, à la fin',
          pos: 'adverbe',
          example: 'He eventually agreed.',
          exampleNative: 'Il a fini par accepter.',
          note: 'Autre faux ami : ne veut pas dire "eventuellement". Pour '
              '"eventuellement" (= peut-être) on dit "possibly".',
        ),
        VocabEntry(
          id: 'en-v-quite',
          target: 'quite',
          native: 'assez, plutôt',
          pos: 'adverbe',
          example: 'It is quite good.',
          exampleNative: 'C\'est plutôt bien.',
          note: 'Attenue en anglais britannique ("assez bien"), mais renforce '
              'en anglais americain ("vraiment bien"). Le meme mot peut donc '
              'affaiblir ou renforcer selon l\'interlocuteur.',
        ),
        VocabEntry(
          id: 'en-v-people',
          target: 'people',
          native: 'les gens, les personnes',
          pos: 'nom',
          example: 'Many people speak English here.',
          exampleNative: 'Beaucoup de gens parlent anglais ici.',
          note: 'Deja pluriel : on dit "people are", jamais "people is", et '
              'jamais "peoples" pour parler de plusieurs personnes.',
        ),
        VocabEntry(
          id: 'en-v-advice',
          target: 'advice',
          native: 'conseil, conseils',
          pos: 'nom',
          example: 'Can you give me some advice?',
          exampleNative: 'Peux-tu me donner un conseil ?',
          note: 'Indenombrable : jamais "an advice" ni "advices". Pour un seul '
              'conseil on dit "a piece of advice".',
        ),
        VocabEntry(
          id: 'en-v-enough',
          target: 'enough',
          native: 'assez, suffisamment',
          pos: 'adverbe',
          example: 'It is not good enough.',
          exampleNative: 'Ce n\'est pas assez bien.',
          note: 'Se place APRÈS l\'adjectif ("good enough"), mais AVANT le nom '
              '("enough time"). L\'ordre inverse du français pour l\'adjectif.',
        ),
        VocabEntry(
          id: 'en-v-still',
          target: 'still',
          native: 'encore, toujours',
          pos: 'adverbe',
          example: 'I still live here.',
          exampleNative: 'J\'habite encore ici.',
          note: 'Pour une situation qui continue. A ne pas confondre avec '
              '"yet" (pas encore, dans une negation ou une question) ni '
              '"again" (une nouvelle fois).',
        ),
        VocabEntry(
          id: 'en-v-however',
          target: 'however',
          native: 'cependant, toutefois',
          pos: 'connecteur',
          example: 'However, we decided to stay.',
          exampleNative: 'Cependant, nous avons decide de rester.',
          note: 'Relie deux phrases separees, pas deux propositions : on ecrit '
              '"..., however, ..." avec des virgules. Pour relier a l\'interieur '
              'd\'une phrase, c\'est "but".',
        ),
        VocabEntry(
          id: 'en-v-though',
          target: 'though',
          native: 'quand meme, pourtant',
          pos: 'connecteur',
          example: 'It is expensive. I like it, though.',
          exampleNative: 'C\'est cher. Ca me plait quand meme.',
          note: 'Tres frequent a l\'oral, place en fin de phrase, ou il '
              'adoucit ce qui vient d\'être dit. C\'est un des marqueurs qui '
              'fait le plus "anglais naturel".',
        ),
      ],
    ),
    VocabTheme(
      id: 'en-t2',
      title: 'Les gens et soi',
      subtitle: 'Se decrire, decrire les autres',
      entries: [
        VocabEntry(
          id: 'en-v-nice',
          target: 'nice',
          native: 'sympa, agréable',
          pos: 'adjectif',
          example: 'She is really nice.',
          exampleNative: 'Elle est vraiment sympa.',
          note: 'Le mot passe-partout pour dire du bien de quelqu\'un. Plus '
              'chaleureux que "kind" (gentil, mais un peu formel) et moins fort '
              'que "lovely".',
        ),
        VocabEntry(
          id: 'en-v-busy',
          target: 'busy',
          native: 'occupe',
          pos: 'adjectif',
          example: 'I am busy this week.',
          exampleNative: 'Je suis occupe cette semaine.',
          note: 'Se dit aussi d\'un lieu bonde ou d\'une ligne telephonique '
              'occupee. Se prononce "bizi", pas comme il s\'ecrit.',
        ),
        VocabEntry(
          id: 'en-v-tired',
          target: 'tired',
          native: 'fatigue',
          pos: 'adjectif',
          example: 'I am tired because I did not sleep.',
          exampleNative: 'Je suis fatigue parce que je n\'ai pas dormi.',
          note: '"Tired of something" change le sens : cela veut dire "en avoir '
              'assez de quelque chose", pas être fatigue par elle.',
        ),
        VocabEntry(
          id: 'en-v-friend',
          target: 'friend',
          native: 'ami',
          pos: 'nom',
          example: 'He is a friend of mine.',
          exampleNative: 'C\'est un ami a moi.',
          note: 'On dit "a friend of mine", pas "a friend of me". Cette '
              'construction avec le possessif est obligatoire.',
        ),
        VocabEntry(
          id: 'en-v-boss',
          target: 'boss',
          native: 'patron, chef',
          pos: 'nom',
          example: 'I need to ask my boss.',
          exampleNative: 'Je dois demander a mon patron.',
          note: 'Neutre et courant en anglais, sans la connotation familiere '
              'que "patron" peut avoir. "Chef" en anglais veut dire cuisinier.',
        ),
        VocabEntry(
          id: 'en-v-borrow',
          target: 'to borrow',
          native: 'emprunter',
          pos: 'verbe',
          example: 'Can I borrow your pen?',
          exampleNative: 'Puis-je emprunter ton stylo ?',
          note: 'Borrow = prendre. "Lend" = donner. On emprunte DE quelqu\'un '
              '(borrow from) et on prete A quelqu\'un (lend to) : les deux sens '
              'sont opposes et souvent confondus.',
        ),
        VocabEntry(
          id: 'en-v-meet',
          target: 'to meet',
          native: 'rencontrer, retrouver',
          pos: 'verbe',
          example: 'Nice to meet you.',
          exampleNative: 'Enchante.',
          note: 'Pour une première rencontre. Revoir quelqu\'un qu\'on connait '
              'deja se dit "meet up with" ou simplement "see".',
        ),
        VocabEntry(
          id: 'en-v-mind',
          target: 'to mind',
          native: 'deranger, faire attention a',
          pos: 'verbe',
          example: 'Do you mind if I sit here?',
          exampleNative: 'Ca vous derange si je m\'assois ici ?',
          note: 'Piege de la réponse : "No, I don\'t mind" veut dire OUI, vas-y. '
              'Répondre "yes" a "do you mind" est un refus.',
        ),
        VocabEntry(
          id: 'en-v-look-like',
          target: 'to look like',
          native: 'ressembler a',
          pos: 'verbe',
          example: 'She looks like her mother.',
          exampleNative: 'Elle ressemble a sa mère.',
          note: 'Attention au trio : "look like" (ressembler physiquement), '
              '"look" seul + adjectif (avoir l\'air), "like" seul (aimer).',
        ),
        VocabEntry(
          id: 'en-v-used-to',
          target: 'used to',
          native: 'avant, autrefois (habitude passée)',
          pos: 'expression',
          example: 'I used to live in Paris.',
          exampleNative: 'J\'habitais a Paris avant.',
          note: 'Suivi de l\'infinitif, pour une habitude qui n\'existe plus. '
              'A ne pas confondre avec "to be used to + -ing" (être habitue a), '
              'qui est une autre structure.',
        ),
        VocabEntry(
          id: 'en-v-afford',
          target: 'to afford',
          native: 'avoir les moyens de',
          pos: 'verbe',
          example: 'I cannot afford it.',
          exampleNative: 'Je n\'en ai pas les moyens.',
          note: 'Presque toujours avec "can" ou "cannot". Il n\'y a pas de '
              'verbe français equivalent en un mot, d\'ou son utilite.',
        ),
        VocabEntry(
          id: 'en-v-worth',
          target: 'worth',
          native: 'qui vaut la peine',
          pos: 'adjectif',
          example: 'It is worth trying.',
          exampleNative: 'Ca vaut la peine d\'essayer.',
          note: 'Toujours suivi d\'un verbe en -ing, jamais de l\'infinitif : '
              '"worth doing", jamais "worth to do".',
        ),
      ],
    ),
    VocabTheme(
      id: 'en-t3',
      title: 'Le temps',
      subtitle: 'Dire quand, combien de temps, a quelle frequence',
      entries: [
        VocabEntry(
          id: 'en-v-since',
          target: 'since',
          native: 'depuis (un point de depart)',
          pos: 'preposition',
          example: 'I have lived here since 2020.',
          exampleNative: 'J\'habite ici depuis 2020.',
          note: 'Since introduit un MOMENT précis (since Monday, since I was '
              'ten). Pour une durée, c\'est "for". Le français utilise "depuis" '
              'pour les deux, d\'ou l\'erreur.',
        ),
        VocabEntry(
          id: 'en-v-for',
          target: 'for',
          native: 'pendant (une durée)',
          pos: 'preposition',
          example: 'We stayed there for a week.',
          exampleNative: 'Nous y sommes restes une semaine.',
          note: 'For introduit une DURÉE (for two hours, for a week). Ne jamais '
              'utiliser "during" pour une durée chiffree : during sert a situer '
              'dans un evenement (during the meeting).',
        ),
        VocabEntry(
          id: 'en-v-ago',
          target: 'ago',
          native: 'il y a (dans le passe)',
          pos: 'adverbe',
          example: 'I saw her two days ago.',
          exampleNative: 'Je l\'ai vue il y a deux jours.',
          note: 'Se place APRÈS la durée, jamais avant : "two days ago", jamais '
              '"ago two days". Impose le passé simple, jamais le présent perfect.',
        ),
        VocabEntry(
          id: 'en-v-yet',
          target: 'yet',
          native: 'deja, pas encore',
          pos: 'adverbe',
          example: 'Have you finished yet?',
          exampleNative: 'As-tu deja fini ?',
          note: 'Uniquement dans les questions et les negations, en fin de '
              'phrase. En affirmatif, c\'est "already", place avant le verbe.',
        ),
        VocabEntry(
          id: 'en-v-soon',
          target: 'soon',
          native: 'bientot',
          pos: 'adverbe',
          example: 'I will call you soon.',
          exampleNative: 'Je t\'appelle bientot.',
          note: '"As soon as" (des que) est une des conjonctions les plus '
              'utiles a memoriser en bloc.',
        ),
        VocabEntry(
          id: 'en-v-early',
          target: 'early',
          native: 'tot, en avance',
          pos: 'adverbe',
          example: 'We should leave earlier.',
          exampleNative: 'Nous devrions partir plus tôt.',
          note: 'Comparatif irregulier : "earlier", jamais "more early". Meme '
              'chose pour "late" qui donne "later".',
        ),
        VocabEntry(
          id: 'en-v-hardly',
          target: 'hardly',
          native: 'a peine, presque pas',
          pos: 'adverbe',
          example: 'I hardly know him.',
          exampleNative: 'Je le connais a peine.',
          note: 'Ne veut PAS dire "durement" (= "hard"). Hardly à un sens '
              'negatif : la phrase est deja negative sans "not".',
        ),
        VocabEntry(
          id: 'en-v-usually',
          target: 'usually',
          native: 'généralement, d\'habitude',
          pos: 'adverbe',
          example: 'I usually wake up at seven.',
          exampleNative: 'Je me reveille généralement a sept heures.',
          note: 'Les adverbes de frequence se placent avant le verbe principal '
              'mais après "be" : "I usually go", mais "I am usually late".',
        ),
        VocabEntry(
          id: 'en-v-once',
          target: 'once',
          native: 'une fois ; une fois que',
          pos: 'adverbe',
          example: 'Once you finish, call me.',
          exampleNative: 'Une fois que tu as fini, appelle-moi.',
          note: 'Deux emplois : compter (once a week) ou introduire une '
              'condition temporelle (once you finish). Le second est tres '
              'frequent et souvent ignore des apprenants.',
        ),
        VocabEntry(
          id: 'en-v-by',
          target: 'by',
          native: 'avant, au plus tard',
          pos: 'preposition',
          example: 'I need it by Friday.',
          exampleNative: 'Il me le faut pour vendredi au plus tard.',
          note: 'Marque une echeance. "By Friday" = a n\'importe quel moment '
              'jusqu\'a vendredi. "Until Friday" = de maintenant jusqu\'a '
              'vendredi, en continu.',
        ),
        VocabEntry(
          id: 'en-v-spend',
          target: 'to spend',
          native: 'passer (du temps), depenser',
          pos: 'verbe',
          example: 'I spent two hours on it.',
          exampleNative: 'J\'y ai passe deux heures.',
          note: 'Le meme verbe pour le temps et l\'argent. Passe irregulier : '
              'spent.',
        ),
        VocabEntry(
          id: 'en-v-take-time',
          target: 'to take (time)',
          native: 'prendre (du temps), durer',
          pos: 'verbe',
          example: 'It takes twenty minutes.',
          exampleNative: 'Ca prend vingt minutes.',
          note: 'Avec le sujet impersonnel "it" : "It takes...". Dire "That '
              'takes me twenty minutes" precise pour qui.',
        ),
      ],
    ),
    VocabTheme(
      id: 'en-t4',
      title: 'Compter et décrire',
      subtitle: 'Nombres, jours et adjectifs qui manquaient à l\'appel',
      entries: [
        VocabEntry(
          id: 'en-v-numbers-1-10',
          target: 'one, two, three... ten',
          native: 'un, deux, trois... dix',
          pos: 'nombres',
          example: 'I have three brothers and two sisters.',
          exampleNative: 'J\'ai trois frères et deux sœurs.',
          note: 'Un, deux, trois, quatre, cinq, six, sept, huit, neuf, dix se '
              'disent one, two, three, four, five, six, seven, eight, nine, '
              'ten. Aucune irrégularité avant "eleven" (onze) : le plus dur '
              'reste la prononciation de "three" et "thirteen".',
        ),
        VocabEntry(
          id: 'en-v-days',
          target: 'Monday, Tuesday, Wednesday...',
          native: 'lundi, mardi, mercredi...',
          pos: 'noms',
          example: 'See you on Monday!',
          exampleNative: 'A lundi !',
          note: 'Les jours prennent toujours une majuscule en anglais, '
              'contrairement au français. On dit "on Monday", jamais juste '
              '"Monday" tout seul pour situer une action dans le temps.',
        ),
        VocabEntry(
          id: 'en-v-colors',
          target: 'red, blue, green, yellow, black, white',
          native: 'rouge, bleu, vert, jaune, noir, blanc',
          pos: 'adjectifs',
          example: 'She is wearing a red coat.',
          exampleNative: 'Elle porte un manteau rouge.',
          note: 'L\'adjectif de couleur se place avant le nom, jamais après : '
              '"a red coat", jamais "a coat red". Contrairement au français, '
              'il ne s\'accorde ni en genre ni en nombre.',
        ),
        VocabEntry(
          id: 'en-v-big-small',
          target: 'big / small',
          native: 'grand / petit',
          pos: 'adjectifs',
          example: 'It is a small flat but a big kitchen.',
          exampleNative: 'C\'est un petit appartement mais une grande '
              'cuisine.',
          note: 'Pour les objets et les lieux, "big/small" plutôt que '
              '"large/little" au quotidien. "Large" convient pour une taille '
              'de vêtement ou une quantité formelle ("a large amount").',
        ),
        VocabEntry(
          id: 'en-v-good-bad',
          target: 'good / bad',
          native: 'bon / mauvais',
          pos: 'adjectifs',
          example: 'The food here is really good.',
          exampleNative: 'La nourriture ici est vraiment bonne.',
          note: 'Ne pas confondre avec l\'adverbe "well" : "I speak English '
              'well" (bien, adverbe) contre "My English is good" (bon, '
              'adjectif). "I am good" veut dire "je vais bien" familièrement.',
        ),
        VocabEntry(
          id: 'en-v-want-need',
          target: 'to want / to need',
          native: 'vouloir / avoir besoin de',
          pos: 'verbes',
          example: 'I want a coffee, but I need to leave now.',
          exampleNative: 'Je veux un café, mais je dois partir maintenant.',
          note: '"Need" est plus fort qu\'un simple souhait : c\'est une '
              'nécessité. Les deux se construisent directement avec un verbe '
              'à l\'infinitif précédé de "to" : "I need to go", jamais "I '
              'need go".',
        ),
        VocabEntry(
          id: 'en-v-can-must',
          target: 'can / must',
          native: 'pouvoir / devoir (obligation)',
          pos: 'verbes modaux',
          example: 'You can wait here, but you must show your ticket.',
          exampleNative: 'Tu peux attendre ici, mais tu dois montrer ton '
              'billet.',
          note: 'Verbes modaux : jamais de "to" après ("can go", pas "can to '
              'go"), pas de "-s" à la troisième personne ("she can", pas '
              '"she cans"). "Must" pour une obligation forte, "should" pour '
              'un conseil.',
        ),
        VocabEntry(
          id: 'en-v-how-many-much',
          target: 'how many / how much',
          native: 'combien de (dénombrable) / combien de (indénombrable)',
          pos: 'expression',
          example: 'How many people are coming? How much time do we have?',
          exampleNative: 'Combien de personnes viennent ? Combien de temps '
              'avons-nous ?',
          note: 'Le choix depend du nom qui suit : dénombrable au pluriel '
              '(people, books) prend "many"; indénombrable (time, money, '
              'water) prend "much". Une erreur très fréquente chez les '
              'francophones qui traduisent "combien" par un seul mot.',
        ),
      ],
    ),
    VocabTheme(
      id: 'en-t5',
      title: 'La famille',
      subtitle: 'Parler de ses proches sans se tromper de mot',
      entries: [
        VocabEntry(
          id: 'en-v-parents',
          target: 'parents',
          native: 'parents (père et mère uniquement)',
          pos: 'nom',
          example: 'My parents live in London.',
          exampleNative: 'Mes parents vivent à Londres.',
          note: 'Faux ami partiel : en anglais "parents" désigne seulement le '
              'père et la mère, jamais l\'ensemble de la famille. Pour "un '
              'parent" au sens large (un oncle, un cousin...), on dit "a '
              'relative".',
        ),
        VocabEntry(
          id: 'en-v-relative',
          target: 'relative',
          native: 'un parent (au sens large), un proche',
          pos: 'nom',
          example: 'She has relatives in Canada.',
          exampleNative: 'Elle a de la famille au Canada.',
          note: 'C\'est le mot qui couvre tante, cousin, grand-oncle... '
              'Ne jamais utiliser "parent" pour ce sens, l\'erreur est '
              'fréquente chez les francophones.',
        ),
        VocabEntry(
          id: 'en-v-sibling',
          target: 'sibling',
          native: 'frère ou sœur (mot générique)',
          pos: 'nom',
          example: 'Do you have any siblings?',
          exampleNative: 'Tu as des frères et sœurs ?',
          note: 'Mot épicène très utile à l\'écrit et en langage soutenu : '
              'pas besoin de dire "brothers and sisters" à chaque fois.',
        ),
        VocabEntry(
          id: 'en-v-stepmother',
          target: 'stepmother / stepfather',
          native: 'belle-mère / beau-père (remariage)',
          pos: 'noms',
          example: 'My stepfather raised me since I was five.',
          exampleNative: 'Mon beau-père m\'a élevé depuis mes cinq ans.',
          note: 'Le préfixe "step-" marque un lien par remariage, jamais par '
              'alliance : "mother-in-law" est la belle-mère du mariage '
              '(la mère du conjoint), un mot totalement différent.',
        ),
        VocabEntry(
          id: 'en-v-in-laws',
          target: 'in-laws',
          native: 'beaux-parents (famille du conjoint)',
          pos: 'nom',
          example: 'We are having dinner with my in-laws tonight.',
          exampleNative: 'On dîne avec mes beaux-parents ce soir.',
          note: 'Le suffixe "-in-law" s\'ajoute à tout lien familial créé par '
              'le mariage : brother-in-law (beau-frère), daughter-in-law '
              '(belle-fille).',
        ),
        VocabEntry(
          id: 'en-v-only-child',
          target: 'only child',
          native: 'enfant unique',
          pos: 'expression',
          example: 'I am an only child, so I never had to share a room.',
          exampleNative: 'Je suis enfant unique, je n\'ai jamais eu a '
              'partager une chambre.',
          note: 'Expression figee : jamais "unique child" ni "only kid" a '
              'l\'ecrit formel, meme si "kid" reste tres courant a l\'oral.',
        ),
        VocabEntry(
          id: 'en-v-twins',
          target: 'twins',
          native: 'jumeaux, jumelles',
          pos: 'nom',
          example: 'They are twins, but they don\'t look alike at all.',
          exampleNative: 'Ce sont des jumeaux, mais ils ne se ressemblent '
              'pas du tout.',
          note: 'Toujours au pluriel des qu\'il y en a deux : "a twin" '
              'designe une seule personne du duo.',
        ),
        VocabEntry(
          id: 'en-v-raise',
          target: 'to raise (a child)',
          native: 'élever (un enfant)',
          pos: 'verbe',
          example: 'They raised three kids in a small flat.',
          exampleNative: 'Ils ont eleve trois enfants dans un petit '
              'appartement.',
          note: '"To raise" pour les enfants ; "to grow" ne s\'emploie que '
              'pour les plantes. "To bring up" est un synonyme tres proche '
              'et tout aussi courant.',
        ),
        VocabEntry(
          id: 'en-v-get-along',
          target: 'to get along (with)',
          native: 's\'entendre (avec)',
          pos: 'verbe',
          example: 'I get along really well with my sister-in-law.',
          exampleNative: 'Je m\'entends tres bien avec ma belle-soeur.',
          note: 'Verbe a particule courant : "get along with someone", '
              'jamais "get along someone" tout court.',
        ),
        VocabEntry(
          id: 'en-v-take-after',
          target: 'to take after',
          native: 'tenir de, ressembler a (un parent)',
          pos: 'verbe',
          example: 'She takes after her mother, both stubborn as mules.',
          exampleNative: 'Elle tient de sa mere, toutes les deux tetues '
              'comme des mules.',
          note: 'Reserve a la ressemblance de caractere ou physique entre '
              'generations, contrairement a "look like" qui vaut pour '
              'n\'importe qui.',
        ),
        VocabEntry(
          id: 'en-v-close-knit',
          target: 'close-knit',
          native: 'très soudé, très uni (famille, groupe)',
          pos: 'adjectif',
          example: 'We are a close-knit family; we see each other every '
              'week.',
          exampleNative: 'Nous sommes une famille tres soudee, on se voit '
              'toutes les semaines.',
          note: 'S\'emploie surtout pour une famille ou une communaute, '
              'jamais pour un couple : la on dirait plutot "close".',
        ),
        VocabEntry(
          id: 'en-v-grown-up',
          target: 'grown-up',
          native: 'adulte',
          pos: 'nom, adjectif',
          example: 'My kids are all grown-up now.',
          exampleNative: 'Mes enfants sont tous adultes maintenant.',
          note: 'Registre familier et souvent affectueux, employe par les '
              'parents en parlant de leurs propres enfants devenus grands. '
              '"Adult" est le mot neutre et administratif.',
        ),
      ],
    ),
    VocabTheme(
      id: 'en-t6',
      title: 'Les émotions',
      subtitle: 'Dire ce qu\'on ressent, sans tout ramener a "sad" ou "happy"',
      entries: [
        VocabEntry(
          id: 'en-v-feel',
          target: 'to feel',
          native: 'se sentir, ressentir',
          pos: 'verbe',
          example: 'I feel really tired today.',
          exampleNative: 'Je me sens vraiment fatigue aujourd\'hui.',
          note: 'Directement suivi d\'un adjectif, sans "myself" : "I feel '
              'tired", jamais "I feel myself tired".',
        ),
        VocabEntry(
          id: 'en-v-upset',
          target: 'upset',
          native: 'contrarié, énervé, bouleversé',
          pos: 'adjectif',
          example: 'She was really upset when she heard the news.',
          exampleNative: 'Elle etait vraiment bouleversee en apprenant la '
              'nouvelle.',
          note: 'Couvre un large spectre, de "vexe" a "bouleverse" selon le '
              'contexte ; l\'intensite se lit dans le ton, pas dans le mot.',
        ),
        VocabEntry(
          id: 'en-v-worried',
          target: 'worried',
          native: 'inquiet',
          pos: 'adjectif',
          example: 'I\'m worried about my exam results.',
          exampleNative: 'Je suis inquiet pour mes resultats d\'examen.',
          note: 'Se construit avec "about" : "worried about something", '
              'jamais "worried for" dans ce sens.',
        ),
        VocabEntry(
          id: 'en-v-relieved',
          target: 'relieved',
          native: 'soulagé',
          pos: 'adjectif',
          example: 'I was so relieved when the test came back negative.',
          exampleNative: 'J\'ai ete tellement soulage quand le test est '
              'revenu negatif.',
          note: 'Ne pas confondre avec "relaxed" (detendu, sans tension '
              'prealable) : "relieved" suppose qu\'une inquietude vient de '
              'se dissiper.',
        ),
        VocabEntry(
          id: 'en-v-excited',
          target: 'excited',
          native: 'impatient, enthousiaste, ravi',
          pos: 'adjectif',
          example: 'I am so excited about the trip next week!',
          exampleNative: 'Je suis tellement impatient pour le voyage la '
              'semaine prochaine !',
          note: 'Sens neutre et tres frequent, sans connotation sexuelle en '
              'usage courant ; ne pas hesiter a l\'employer pour un simple '
              'enthousiasme, contrairement au francais "excite".',
        ),
        VocabEntry(
          id: 'en-v-embarrassed',
          target: 'embarrassed',
          native: 'gêné, honteux',
          pos: 'adjectif',
          example: 'I felt so embarrassed when I forgot his name.',
          exampleNative: 'Je me suis senti tellement gene quand j\'ai '
              'oublie son nom.',
          note: 'Faux ami avec le francais "embarrasse" (encombre, charge '
              'de quelque chose) : en anglais c\'est uniquement l\'emotion '
              'de la gene sociale.',
        ),
        VocabEntry(
          id: 'en-v-disappointed',
          target: 'disappointed',
          native: 'déçu',
          pos: 'adjectif',
          example: 'I was disappointed with the film, it was too slow.',
          exampleNative: 'J\'ai ete decu par le film, il etait trop lent.',
          note: 'Se construit avec "with" ou "in" (une personne) : '
              '"disappointed in you", jamais "disappointed of".',
        ),
        VocabEntry(
          id: 'en-v-overwhelmed',
          target: 'overwhelmed',
          native: 'débordé, submergé',
          pos: 'adjectif',
          example: 'I feel overwhelmed with all this work.',
          exampleNative: 'Je me sens submerge par tout ce travail.',
          note: 'Plus fort que "busy" (occupe) : suggere qu\'on n\'arrive '
              'plus a faire face, pas juste qu\'on a beaucoup a faire.',
        ),
        VocabEntry(
          id: 'en-v-proud',
          target: 'proud',
          native: 'fier',
          pos: 'adjectif',
          example: 'I am so proud of you.',
          exampleNative: 'Je suis tellement fier de toi.',
          note: 'Construction avec "of" : "proud of someone/something", '
              'jamais "proud for".',
        ),
        VocabEntry(
          id: 'en-v-jealous',
          target: 'jealous',
          native: 'jaloux',
          pos: 'adjectif',
          example: 'He got jealous when she talked to her ex.',
          exampleNative: 'Il est devenu jaloux quand elle a parle a son '
              'ex.',
          note: '"Jealous" couvre aussi bien la jalousie amoureuse que '
              'l\'envie ("jealous of your new car"), contrairement au '
              'francais qui distinguerait jaloux et envieux.',
        ),
        VocabEntry(
          id: 'en-v-cheer-up',
          target: 'to cheer (someone) up',
          native: 'remonter le moral (à qqn)',
          pos: 'verbe',
          example: 'I brought you some chocolate to cheer you up.',
          exampleNative: 'Je t\'ai apporte du chocolat pour te remonter le '
              'moral.',
          note: 'Verbe a particule separable : "cheer her up" et "cheer up '
              'her" (rare) sont possibles, mais avec un pronom l\'ordre '
              '"cheer her up" est obligatoire.',
        ),
        VocabEntry(
          id: 'en-v-feel-like',
          target: 'to feel like (doing something)',
          native: 'avoir envie de (faire quelque chose)',
          pos: 'expression',
          example: 'I don\'t feel like cooking tonight.',
          exampleNative: 'Je n\'ai pas envie de cuisiner ce soir.',
          note: 'Suivi d\'un verbe en "-ing", jamais de l\'infinitif : '
              '"feel like cooking", pas "feel like to cook".',
        ),
      ],
    ),
  ],
  phrases: [
    KeyPhrase(
      id: 'en-p-repeat',
      target: 'Sorry, could you say that again?',
      native: 'Désolé, pouvez-vous repeter ?',
      whenToUse: 'La phrase la plus utile de toutes : elle relance une '
          'conversation au lieu de la laisser mourir. A memoriser avant '
          'n\'importe quel vocabulaire.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'en-p-slower',
      target: 'Could you speak more slowly, please?',
      native: 'Pouvez-vous parler plus lentement ?',
      whenToUse: 'Quand tu comprends les mots un par un mais pas le flux. Plus '
          'efficace que de faire semblant d\'avoir compris.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'en-p-howsay',
      target: 'How do you say ... in English?',
      native: 'Comment dit-on ... en anglais ?',
      whenToUse: 'Transforme ton interlocuteur en professeur. Chaque usage te '
          'rapporte un mot que tu retiendras mieux que dans une liste.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'en-p-mean',
      target: 'What does that mean?',
      native: 'Qu\'est-ce que ca veut dire ?',
      whenToUse: 'Sur un mot précis que tu viens d\'entendre. Plus cible que '
          '"I don\'t understand", qui bloque toute la conversation.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'en-p-notsure',
      target: 'I am not sure how to say this, but...',
      native: 'Je ne sais pas trop comment le dire, mais...',
      whenToUse: 'Achete du temps et previent que la phrase qui suit sera '
          'maladroite. Les natifs deviennent nettement plus indulgents.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'en-p-please',
      target: 'Could I have ..., please?',
      native: 'Pourrais-je avoir ..., s\'il vous plait ?',
      whenToUse: 'La formule polie standard pour commander ou demander. '
          '"I want" passe pour brusque en anglais, bien plus qu\'en français.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'en-p-thanks',
      target: 'Thanks a lot, that is very kind of you.',
      native: 'Merci beaucoup, c\'est tres gentil.',
      whenToUse: 'Remercier au-dela du simple "thank you" quand quelqu\'un '
          's\'est donne du mal.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'en-p-excuse',
      target: 'Excuse me, sorry to bother you.',
      native: 'Excusez-moi de vous deranger.',
      whenToUse: 'Pour aborder un inconnu. "Excuse me" ouvre, "sorry" '
          's\'excuse : les deux ne sont pas interchangeables.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'en-p-help',
      target: 'Could you help me, please?',
      native: 'Pourriez-vous m\'aider ?',
      whenToUse: 'Fonctionne partout, du guichet à la rue. Se retient en bloc.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'en-p-where',
      target: 'Where is the nearest ...?',
      native: 'Ou est le/la ... le plus proche ?',
      whenToUse: 'Un moule a remplir : station, pharmacy, toilet. Un seul '
          'squelette memorise donne des dizaines de questions.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'en-p-howmuch',
      target: 'How much does it cost?',
      native: 'Combien ca coûte ?',
      whenToUse: 'Partout ou l\'on achete. Retenir aussi la réponse type : '
          '"It is ten pounds fifty".',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'en-p-english',
      target: 'Do you speak French, by any chance?',
      native: 'Parlez-vous français, par hasard ?',
      whenToUse: 'Le filet de secours. "By any chance" adoucit la demande et '
          'evite de donner l\'impression d\'abandonner l\'anglais.',
      category: 'survie',
    ),
  ],
);
