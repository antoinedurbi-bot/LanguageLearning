import 'package:learning_app/data/models/vocabulary.dart';

/// Turkish vocabulary for French speakers.
///
/// In Turkish the dictionary form of a word is rarely what you will say: the
/// meaning is finished by suffixes, and the suffix chosen depends on the
/// vowels already in the word. Notes here give the stem and say what it
/// attaches to, because a Turkish word learned without that is unusable.
const vocabTr = VocabularyPack(
  languageCode: 'tr',
  themes: [
    VocabTheme(
      id: 'tr-t1',
      title: 'Les indispensables',
      subtitle: 'Les briques de base et leurs suffixes',
      entries: [
        VocabEntry(
          id: 'tr-v-var',
          target: 'var / yok',
          native: 'il y a / il n\'y a pas',
          pos: 'expression',
          example: 'Etsiz bir şey var mı?',
          exampleNative: 'Y a-t-il quelque chose sans viande ?',
          note: 'Deux mots qui remplacent tout le verbe "avoir". Ils ne se '
              'conjuguent pas : on les place en fin de phrase. yok est la '
              'negation complete de var.',
        ),
        VocabEntry(
          id: 'tr-v-degil',
          target: 'değil',
          native: 'ne... pas (avec un nom ou adjectif)',
          pos: 'particule',
          example: 'Bu pahalı değil.',
          exampleNative: 'Ce n\'est pas cher.',
          note: 'Nie un nom ou un adjectif, jamais un verbe. Un verbe se nie '
              'par le suffixe -me/-ma insere dedans.',
        ),
        VocabEntry(
          id: 'tr-v-ama',
          target: 'ama',
          native: 'mais',
          pos: 'connecteur',
          example: 'Güzel ama pahalı.',
          exampleNative: 'C\'est joli mais cher.',
          note: 'Se place entre les deux idees, comme en francais — ce qui est '
              'rare en turc, ou la plupart des liens se font par suffixe.',
        ),
        VocabEntry(
          id: 'tr-v-cok',
          target: 'çok',
          native: 'tres, beaucoup',
          pos: 'adverbe',
          example: 'Çok teşekkür ederim.',
          exampleNative: 'Merci beaucoup.',
          note: 'Sert pour "tres" (devant un adjectif) et "beaucoup" (avec un '
              'verbe ou un nom). Se prononce "tchok".',
        ),
        VocabEntry(
          id: 'tr-v-biraz',
          target: 'biraz',
          native: 'un peu',
          pos: 'adverbe',
          example: 'Biraz Türkçe biliyorum.',
          exampleNative: 'Je parle un peu turc.',
          note: 'Litteralement "bir az" = "un peu". Tres utile pour attenuer '
              'une affirmation trop ambitieuse.',
        ),
        VocabEntry(
          id: 'tr-v-icin',
          target: 'için',
          native: 'pour',
          pos: 'postposition',
          example: 'Senin için.',
          exampleNative: 'Pour toi.',
          note: 'Postposition : elle se place APRES le mot, contrairement aux '
              'prepositions francaises. Le turc met presque tout apres.',
        ),
        VocabEntry(
          id: 'tr-v-ile',
          target: 'ile / -la, -le',
          native: 'avec, par',
          pos: 'postposition',
          example: 'Kartla ödeyebilir miyim?',
          exampleNative: 'Puis-je payer par carte ?',
          note: 'Souvent contracte en suffixe : kart + la = kartla. La voyelle '
              'choisie (-la ou -le) depend de la derniere voyelle du mot.',
        ),
        VocabEntry(
          id: 'tr-v-gibi',
          target: 'gibi',
          native: 'comme',
          pos: 'postposition',
          example: 'Senin gibi.',
          exampleNative: 'Comme toi.',
          note: 'Encore une postposition. Sert aussi a attenuer : "gibi" en '
              'fin de phrase veut dire "on dirait, en quelque sorte".',
        ),
        VocabEntry(
          id: 'tr-v-lazim',
          target: 'lazım',
          native: 'il faut, necessaire',
          pos: 'adjectif',
          example: 'Bana yardım lazım.',
          exampleNative: 'J\'ai besoin d\'aide.',
          note: 'Construction sans verbe : "quelque chose + lazım". La '
              'personne qui a besoin se met au datif (bana = a moi).',
        ),
        VocabEntry(
          id: 'tr-v-var-mi',
          target: 'mı / mi / mu / mü',
          native: 'particule de question',
          pos: 'particule',
          example: 'Buradan uzak mı?',
          exampleNative: 'Est-ce loin d\'ici ?',
          note: 'Quatre formes de la meme particule : on choisit celle qui '
              'harmonise avec la derniere voyelle du mot precedent. Elle '
              's\'ecrit separement mais se prononce collee.',
        ),
        VocabEntry(
          id: 'tr-v-tesekkur',
          target: 'teşekkür ederim',
          native: 'merci',
          pos: 'expression',
          example: 'Çok teşekkür ederim.',
          exampleNative: 'Merci beaucoup.',
          note: 'Le merci standard. "Sağ ol" est l\'equivalent familier, entre '
              'proches ou avec quelqu\'un de plus jeune.',
        ),
        VocabEntry(
          id: 'tr-v-buyurun',
          target: 'buyurun',
          native: 'je vous en prie, tenez',
          pos: 'expression',
          example: 'Buyurun, oturun.',
          exampleNative: 'Je vous en prie, asseyez-vous.',
          note: 'Mot d\'accueil omnipresent : en tendant quelque chose, en '
              'invitant a entrer, ou pour dire "je vous ecoute". Aucun '
              'equivalent unique en francais.',
        ),
      ],
    ),
    VocabTheme(
      id: 'tr-t2',
      title: 'Les suffixes qui changent tout',
      subtitle: 'Ce qui se colle aux mots et fait la phrase',
      entries: [
        VocabEntry(
          id: 'tr-v-de',
          target: '-de / -da',
          native: 'a, dans (lieu ou l\'on est)',
          pos: 'suffixe',
          example: 'Solda.',
          exampleNative: 'C\'est a gauche.',
          note: 'Locatif. Devient -te/-ta apres une consonne sourde : '
              '"Paris\'te", pas "Paris\'de".',
        ),
        VocabEntry(
          id: 'tr-v-e',
          target: '-e / -a',
          native: 'vers, a (direction)',
          pos: 'suffixe',
          example: 'Havaalanına nasıl giderim?',
          exampleNative: 'Comment aller a l\'aeroport ?',
          note: 'Directif : la ou l\'on va. Le francais utilise "a" pour la '
              'direction ET la position ; le turc distingue les deux.',
        ),
        VocabEntry(
          id: 'tr-v-den',
          target: '-den / -dan',
          native: 'de, depuis',
          pos: 'suffixe',
          example: 'Buradan uzak mı?',
          exampleNative: 'Est-ce loin d\'ici ?',
          note: 'Ablatif : le point de depart. Sert aussi au comparatif : '
              '"benden büyük" = plus grand que moi.',
        ),
        VocabEntry(
          id: 'tr-v-siz',
          target: '-siz / -sız',
          native: 'sans',
          pos: 'suffixe',
          example: 'Etsiz bir şey var mı?',
          exampleNative: 'Y a-t-il quelque chose sans viande ?',
          note: 'Se colle au nom : et (viande) + siz = sans viande. Son '
              'contraire est -li/-lı (avec).',
        ),
        VocabEntry(
          id: 'tr-v-li',
          target: '-li / -lı',
          native: 'avec, originaire de',
          pos: 'suffixe',
          example: 'Fransızım, Parisliyim.',
          exampleNative: 'Je suis francais, je suis parisien.',
          note: 'Deux usages : "avec" (sütlü = avec du lait) et "originaire '
              'de" (Parisli = parisien).',
        ),
        VocabEntry(
          id: 'tr-v-im',
          target: '-im / -ım',
          native: 'mon, ma',
          pos: 'suffixe',
          example: 'Benim adım Ayşe.',
          exampleNative: 'Je m\'appelle Ayse.',
          note: 'Possessif colle au nom : ad (nom) + ım = mon nom. Le "benim" '
              'devant n\'est qu\'une insistance facultative.',
        ),
        VocabEntry(
          id: 'tr-v-abil',
          target: '-abil / -ebil',
          native: 'pouvoir',
          pos: 'suffixe',
          example: 'Konuşabilir misiniz?',
          exampleNative: 'Pouvez-vous parler ?',
          note: 'S\'insere DANS le verbe, entre le radical et la terminaison. '
              'Le francais met un verbe separe ; le turc empile.',
        ),
        VocabEntry(
          id: 'tr-v-me',
          target: '-me / -ma',
          native: 'negation du verbe',
          pos: 'suffixe',
          example: 'Anlamıyorum.',
          exampleNative: 'Je ne comprends pas.',
          note: 'S\'insere apres le radical : anla (comprendre) + m + ıyorum. '
              'Il n\'y a jamais de mot separe pour "ne... pas" avec un verbe.',
        ),
      ],
    ),
  ],
  phrases: [
    KeyPhrase(
      id: 'tr-p-repeat',
      target: 'Tekrar eder misiniz?',
      native: 'Pouvez-vous repeter ?',
      whenToUse: 'La phrase a connaitre avant toutes les autres : elle garde '
          'la conversation ouverte.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'tr-p-slower',
      target: 'Daha yavaş konuşabilir misiniz?',
      native: 'Pouvez-vous parler plus lentement ?',
      whenToUse: 'Le turc s\'enchaine en longues chaines de suffixes, tres '
          'dur a decouper au debut.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'tr-p-howsay',
      target: 'Bu Türkçe nasıl denir?',
      native: 'Comment dit-on ca en turc ?',
      whenToUse: 'En montrant l\'objet. Les Turcs sont en general ravis '
          'd\'aider quelqu\'un qui essaie leur langue.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'tr-p-nounderstand',
      target: 'Anlamıyorum, özür dilerim.',
      native: 'Je ne comprends pas, desole.',
      whenToUse: 'Honnete et poli. Mieux vaut le dire que de hocher la tete '
          'dans le vide.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'tr-p-beginner',
      target: 'Türkçem çok iyi değil.',
      native: 'Mon turc n\'est pas tres bon.',
      whenToUse: 'Desamorce d\'entree. L\'interlocuteur ralentit et simplifie '
          'spontanement ensuite.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'tr-p-order',
      target: 'Bir ... istiyorum, lütfen.',
      native: 'Je voudrais un ..., s\'il vous plait.',
      whenToUse: 'Moule a remplir pour commander. Le verbe ferme toujours la '
          'phrase en turc.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'tr-p-howmuch',
      target: 'Ne kadar?',
      native: 'Combien ca coute ?',
      whenToUse: 'Court et universel. "Kaç para?" est l\'equivalent plus '
          'familier.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'tr-p-where',
      target: 'Affedersiniz, ... nerede?',
      native: 'Excusez-moi, ou est ... ?',
      whenToUse: 'Un squelette reutilisable : tuvalet, istasyon, eczane. '
          'Affedersiniz ouvre poliment.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'tr-p-help',
      target: 'Bana yardım eder misiniz?',
      native: 'Pouvez-vous m\'aider ?',
      whenToUse: 'La forme "-er misiniz" est le moule de la demande polie : '
          'il se recycle avec n\'importe quel verbe.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'tr-p-card',
      target: 'Kartla ödeyebilir miyim?',
      native: 'Puis-je payer par carte ?',
      whenToUse: 'A demander avant de commander hors des grandes villes.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'tr-p-thanks',
      target: 'Çok teşekkür ederim, elinize sağlık.',
      native: 'Merci beaucoup, c\'etait delicieux.',
      whenToUse: 'Apres un repas : "elinize sağlık" (sante a vos mains) se '
          'dit a qui a cuisine. Formule tres appreciee et intraduisible.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'tr-p-welcome',
      target: 'Hoş bulduk.',
      native: '(reponse a la bienvenue)',
      whenToUse: 'La reponse rituelle a "hoş geldiniz" (bienvenue). Ne pas '
          'repondre marque immediatement l\'etranger ; repondre fait '
          'excellente impression.',
      category: 'politesse',
    ),
  ],
);
