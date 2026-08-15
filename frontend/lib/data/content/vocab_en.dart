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
