import 'package:learning_app/data/models/island.dart';

/// The island scaffolds.
///
/// The prompts are the same across languages on purpose: the first minutes of
/// a conversation are the same everywhere, and reusing the structure means a
/// learner who has built their islands once can rebuild them fast in the next
/// language. Only the ready-made chunks are language-specific.
const _prompts = <String, List<IslandPrompt>>{
  'self': [
    IslandPrompt(
      id: 'name',
      question: 'Comment tu t\'appelles, et d\'ou viens-tu ?',
      hint: 'Deux phrases suffisent. Ajoute la ville, pas seulement le pays : '
          'ca donne une prise a ton interlocuteur pour rebondir.',
    ),
    IslandPrompt(
      id: 'live',
      question: 'Ou habites-tu maintenant, et depuis quand ?',
      hint: 'C\'est l\'occasion de placer une durée. Prepare le chiffre : '
          'hesiter sur "depuis trois ans" casse le rythme.',
    ),
    IslandPrompt(
      id: 'family',
      question: 'Avec qui vis-tu ? As-tu des freres et soeurs ?',
      hint: 'Reste simple. Une phrase par personne, pas un arbre genealogique.',
    ),
    IslandPrompt(
      id: 'hook',
      question: 'Une chose inhabituelle ou amusante sur toi ?',
      hint: 'La phrase qui fait poser une question. C\'est elle qui transforme '
          'une presentation en conversation.',
    ),
  ],
  'work': [
    IslandPrompt(
      id: 'what',
      question: 'Que fais-tu dans la vie ?',
      hint: 'Si ton metier est technique, prepare aussi une version simple : '
          'la version exacte ne servira presque jamais.',
    ),
    IslandPrompt(
      id: 'daily',
      question: 'A quoi ressemble une journée typique ?',
      hint: 'Trois ou quatre actions au présent suffisent. C\'est aussi un '
          'excellent entrainement aux verbes du quotidien.',
    ),
    IslandPrompt(
      id: 'like',
      question: 'Qu\'est-ce que tu aimes ou n\'aimes pas dans ce travail ?',
      hint: 'Prepare une opinion et une raison. "Parce que" est le mot qui '
          'fait passer d\'un niveau debutant à un niveau conversationnel.',
    ),
    IslandPrompt(
      id: 'before',
      question: 'Que faisais-tu avant ?',
      hint: 'Force a utiliser le passe. Meme une seule phrase te fait '
          'travailler le temps le plus utile après le présent.',
    ),
  ],
  'language': [
    IslandPrompt(
      id: 'why',
      question: 'Pourquoi apprends-tu cette langue ?',
      hint: 'La question qu\'on te posera le plus souvent. Une raison '
          'personnelle marque plus qu\'une raison utilitaire.',
    ),
    IslandPrompt(
      id: 'howlong',
      question: 'Depuis combien de temps ? Comment apprends-tu ?',
      hint: 'Occasion de placer une durée et une frequence : "tous les jours", '
          '"depuis six mois".',
    ),
    IslandPrompt(
      id: 'hard',
      question: 'Qu\'est-ce qui est le plus difficile pour toi ?',
      hint: 'Réponse tres utile : elle invite l\'autre a t\'aider, et elle '
          'explique tes hesitations a venir.',
    ),
    IslandPrompt(
      id: 'goal',
      question: 'Que veux-tu pouvoir faire dans cette langue ?',
      hint: 'Un objectif concret vaut mieux que "parler couramment". '
          'Travaille le futur ou le conditionnel ici.',
    ),
  ],
  'plans': [
    IslandPrompt(
      id: 'today',
      question: 'Que fais-tu aujourd\'hui ou cette semaine ?',
      hint: 'Le futur proche. C\'est la réponse a "quoi de neuf ?", qui '
          'revient dans toutes les conversations.',
    ),
    IslandPrompt(
      id: 'weekend',
      question: 'Qu\'as-tu prevu ce week-end ?',
      hint: 'Prepare deux options : ce qui est prevu, et ce que tu aimerais '
          'faire. Cela te fait travailler deux structures.',
    ),
    IslandPrompt(
      id: 'travel',
      question: 'Un voyage que tu as fait, ou que tu veux faire ?',
      hint: 'Sujet universel et sans risque. Un passe et un futur dans la '
          'meme réponse.',
    ),
    IslandPrompt(
      id: 'opinion',
      question: 'Ton avis sur cette ville, ce plat, ce pays ?',
      hint: 'Prepare un moule d\'opinion et une raison. Tu le rempliras avec '
          'n\'importe quel sujet.',
    ),
  ],
};

const _islandMeta = [
  (
    id: 'self',
    title: 'Qui je suis',
    situation: 'Les deux premières minutes de toute rencontre.',
    why: 'C\'est la seule chose qu\'on te demandera a coup sur, dans toutes '
        'les conversations, toute ta vie. La preparer une fois sert mille fois.',
  ),
  (
    id: 'work',
    title: 'Ce que je fais',
    situation: 'Juste après les presentations, sans exception.',
    why: 'Deuxième question universelle. Sans réponse prete, la conversation '
        'cale exactement au moment ou elle demarrait.',
  ),
  (
    id: 'language',
    title: 'Pourquoi j\'apprends',
    situation: 'Des qu\'on remarque que tu n\'es pas natif.',
    why: 'Répondre avec aisance change le regard de l\'autre : tu passes de '
        '"touriste qui bafouille" a "quelqu\'un qui apprend", et on t\'aide.',
  ),
  (
    id: 'plans',
    title: 'Mes projets et mes avis',
    situation: 'La partie ou la conversation devient une vraie conversation.',
    why: 'Fait travailler le futur et l\'opinion — les deux choses qui '
        'permettent de tenir un echange au-dela des presentations.',
  ),
];

/// Language-specific ready-made fragments, per island.
const _chunks = <String, Map<String, List<IslandChunk>>>{
  'en': {
    'self': [
      IslandChunk(target: 'My name is ...', native: 'Je m\'appelle ...'),
      IslandChunk(target: 'I am from ...', native: 'Je viens de ...'),
      IslandChunk(
          target: 'I have been living in ... for ... years',
          native: 'J\'habite à ... depuis ... ans'),
      IslandChunk(
          target: 'I have one brother and two sisters',
          native: 'J\'ai un frère et deux soeurs'),
    ],
    'work': [
      IslandChunk(target: 'I work as a ...', native: 'Je travaille comme ...'),
      IslandChunk(
          target: 'I usually start around ...',
          native: 'Je commence généralement vers ...'),
      IslandChunk(
          target: 'What I like most is ...',
          native: 'Ce que je préfère, c\'est ...'),
      IslandChunk(target: 'I used to work in ...', native: 'Avant je travaillais dans ...'),
    ],
    'language': [
      IslandChunk(
          target: 'I am learning English because ...',
          native: 'J\'apprends l\'anglais parce que ...'),
      IslandChunk(
          target: 'I have been studying for about ...',
          native: 'J\'étudie depuis environ ...'),
      IslandChunk(
          target: 'The hardest part for me is ...',
          native: 'Le plus dur pour moi, c\'est ...'),
      IslandChunk(
          target: 'I would like to be able to ...',
          native: 'J\'aimerais pouvoir ...'),
    ],
    'plans': [
      IslandChunk(target: 'I am going to ...', native: 'Je vais ...'),
      IslandChunk(target: 'I am planning to ...', native: 'J\'ai prevu de ...'),
      IslandChunk(target: 'I went to ... last year', native: 'Je suis allé à ... l\'année dernière'),
      IslandChunk(target: 'I think it is ... because ...', native: 'Je trouve que c\'est ... parce que ...'),
    ],
  },
  'es': {
    'self': [
      IslandChunk(target: 'Me llamo ...', native: 'Je m\'appelle ...'),
      IslandChunk(target: 'Soy de ...', native: 'Je viens de ...'),
      IslandChunk(
          target: 'Hace ... años que vivo en ...',
          native: 'Cela fait ... ans que j\'habite à ...'),
      IslandChunk(
          target: 'Tengo un hermano y dos hermanas',
          native: 'J\'ai un frère et deux soeurs'),
    ],
    'work': [
      IslandChunk(target: 'Trabajo como ...', native: 'Je travaille comme ...'),
      IslandChunk(target: 'Suelo empezar a las ...', native: 'Je commence généralement à ...'),
      IslandChunk(target: 'Lo que más me gusta es ...', native: 'Ce que je préfère, c\'est ...'),
      IslandChunk(target: 'Antes trabajaba en ...', native: 'Avant je travaillais dans ...'),
    ],
    'language': [
      IslandChunk(
          target: 'Estoy aprendiendo español porque ...',
          native: 'J\'apprends l\'espagnol parce que ...'),
      IslandChunk(target: 'Llevo ... estudiando', native: 'J\'étudie depuis ...'),
      IslandChunk(target: 'Lo más difícil para mí es ...', native: 'Le plus dur pour moi, c\'est ...'),
      IslandChunk(target: 'Me gustaría poder ...', native: 'J\'aimerais pouvoir ...'),
    ],
    'plans': [
      IslandChunk(target: 'Voy a ...', native: 'Je vais ...'),
      IslandChunk(target: 'Tengo pensado ...', native: 'J\'ai prevu de ...'),
      IslandChunk(target: 'El año pasado fui a ...', native: 'L\'année dernière je suis allé à ...'),
      IslandChunk(target: 'Me parece ... porque ...', native: 'Je trouve ca ... parce que ...'),
    ],
  },
  'zh': {
    'self': [
      IslandChunk(target: '我叫 ...', native: 'Je m\'appelle ...', romanization: 'Wǒ jiào ...'),
      IslandChunk(target: '我是法国人。', native: 'Je suis français.', romanization: 'Wǒ shì Fǎguó rén.'),
      IslandChunk(
          target: '我在 ... 住了 ... 年了。',
          native: 'J\'habite à ... depuis ... ans.',
          romanization: 'Wǒ zài ... zhùle ... nián le.'),
      IslandChunk(target: '我有一个哥哥。', native: 'J\'ai un grand frère.', romanization: 'Wǒ yǒu yí ge gēge.'),
    ],
    'work': [
      IslandChunk(target: '我是 ...', native: 'Je suis (metier) ...', romanization: 'Wǒ shì ...'),
      IslandChunk(target: '我每天 ... 点上班。', native: 'Je commence à ... heures.', romanization: 'Wǒ měitiān ... diǎn shàngbān.'),
      IslandChunk(target: '我最喜欢的是 ...', native: 'Ce que je préfère, c\'est ...', romanization: 'Wǒ zuì xǐhuan de shì ...'),
      IslandChunk(target: '以前我做过 ...', native: 'Avant, j\'ai fait ...', romanization: 'Yǐqián wǒ zuòguo ...'),
    ],
    'language': [
      IslandChunk(target: '我学中文因为 ...', native: 'J\'apprends le chinois parce que ...', romanization: 'Wǒ xué Zhōngwén yīnwèi ...'),
      IslandChunk(target: '我学了 ... 了。', native: 'J\'étudie depuis ...', romanization: 'Wǒ xuéle ... le.'),
      IslandChunk(target: '对我来说，最难的是声调。', native: 'Pour moi, le plus dur ce sont les tons.', romanization: 'Duì wǒ lái shuō, zuì nán de shì shēngdiào.'),
      IslandChunk(target: '我希望可以 ...', native: 'J\'espère pouvoir ...', romanization: 'Wǒ xīwàng kěyǐ ...'),
    ],
    'plans': [
      IslandChunk(target: '我要去 ...', native: 'Je vais aller à ...', romanization: 'Wǒ yào qù ...'),
      IslandChunk(target: '这个周末我打算 ...', native: 'Ce week-end je compte ...', romanization: 'Zhège zhōumò wǒ dǎsuàn ...'),
      IslandChunk(target: '我去年去过 ...', native: 'L\'année dernière je suis allé à ...', romanization: 'Wǒ qùnián qùguo ...'),
      IslandChunk(target: '我觉得 ... 因为 ...', native: 'Je trouve que ... parce que ...', romanization: 'Wǒ juéde ... yīnwèi ...'),
    ],
  },
  'tr': {
    'self': [
      IslandChunk(target: 'Benim adım ...', native: 'Je m\'appelle ...'),
      IslandChunk(target: 'Fransızım.', native: 'Je suis français.'),
      IslandChunk(target: '... yıldır ...\'da yaşıyorum.', native: 'J\'habite à ... depuis ... ans.'),
      IslandChunk(target: 'Bir erkek kardeşim var.', native: 'J\'ai un frère.'),
    ],
    'work': [
      IslandChunk(target: '... olarak çalışıyorum.', native: 'Je travaille comme ...'),
      IslandChunk(target: 'Genelde ...\'da başlıyorum.', native: 'Je commence généralement à ...'),
      IslandChunk(target: 'En sevdiğim şey ...', native: 'Ce que je préfère, c\'est ...'),
      IslandChunk(target: 'Önceden ...\'da çalışıyordum.', native: 'Avant je travaillais à ...'),
    ],
    'language': [
      IslandChunk(target: 'Türkçe öğreniyorum çünkü ...', native: 'J\'apprends le turc parce que ...'),
      IslandChunk(target: '... aydır öğreniyorum.', native: 'J\'apprends depuis ... mois.'),
      IslandChunk(target: 'Benim için en zor şey ...', native: 'Pour moi le plus dur, c\'est ...'),
      IslandChunk(target: '... yapabilmek istiyorum.', native: 'Je veux pouvoir ...'),
    ],
    'plans': [
      IslandChunk(target: '... gideceğim.', native: 'Je vais aller ...'),
      IslandChunk(target: 'Bu hafta sonu ... düşünüyorum.', native: 'Ce week-end je pense ...'),
      IslandChunk(target: 'Geçen yıl ...\'a gittim.', native: 'L\'année dernière je suis allé à ...'),
      IslandChunk(target: 'Bence ... çünkü ...', native: 'Je pense que ... parce que ...'),
    ],
  },
};

/// Islands for one language, or an empty list if none are defined.
List<Island> islandsFor(String languageCode) {
  final byIsland = _chunks[languageCode];
  if (byIsland == null) return const [];

  return [
    for (final meta in _islandMeta)
      Island(
        id: meta.id,
        title: meta.title,
        situation: meta.situation,
        why: meta.why,
        prompts: _prompts[meta.id] ?? const [],
        chunks: byIsland[meta.id] ?? const [],
      ),
  ];
}
