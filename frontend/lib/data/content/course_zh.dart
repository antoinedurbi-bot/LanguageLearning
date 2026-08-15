import 'package:learning_app/data/models/card_item.dart';
import 'package:learning_app/data/models/grammar_lesson.dart';

const _zh1Grammar = GrammarLesson(
  title: 'Les quatre tons, et deux ou trois caracteres cles',
  hook: 'En mandarin, la hauteur de la voix fait partie du mot au meme titre '
      'qu\'une consonne : changer le ton change le sens, pas seulement '
      'l\'intonation.',
  blocks: [
    ExplanationBlock(
      heading: 'Une syllabe, quatre sens possibles',
      body: 'La syllabe "ma" prend un sens different selon son ton : mère '
          '(1er ton, plat), chanvre (2e, montant), cheval (3e, qui '
          'descend puis remonte), gronder (4e, qui tombe net). Le ton '
          'n\'est pas une nuance de prononciation : c\'est une partie du mot, '
          'aussi essentielle qu\'une lettre.',
    ),
    ToneBlock(
      heading: 'Les quatre tons sur "ma"',
      entries: [
        ToneExample(
          syllable: '妈',
          pinyin: 'mā',
          tone: 1,
          contour: 'haut et plat, comme tenu sur une seule note',
          meaning: 'maman',
        ),
        ToneExample(
          syllable: '麻',
          pinyin: 'má',
          tone: 2,
          contour: 'montant, comme une question courte "hein ?"',
          meaning: 'chanvre',
        ),
        ToneExample(
          syllable: '马',
          pinyin: 'mǎ',
          tone: 3,
          contour: 'descend puis remonte, comme un creux',
          meaning: 'cheval',
        ),
        ToneExample(
          syllable: '骂',
          pinyin: 'mà',
          tone: 4,
          contour: 'tombe brusquement, comme un ordre sec',
          meaning: 'gronder',
        ),
        ToneExample(
          syllable: '吗',
          pinyin: 'ma',
          tone: 0,
          contour: 'neutre, court et faible, sans hauteur marquee',
          meaning: 'particule de question',
        ),
      ],
    ),
    CharacterBreakdownBlock(
      heading: 'Decomposer les premiers caractères',
      entries: [
        CharacterBreakdown(
          character: '你',
          pinyin: 'nǐ',
          meaning: 'tu / toi',
          radical: '亻',
          radicalMeaning: 'personne (forme debout d\'un humain)',
          mnemonic: 'Le radical personne a gauche : ce caractère parle '
              'toujours de quelqu\'un, ici la personne a qui l\'on s\'adresse.',
        ),
        CharacterBreakdown(
          character: '好',
          pinyin: 'hǎo',
          meaning: 'bien / bon',
          radical: '女',
          radicalMeaning: 'femme',
          mnemonic: '女 (femme) a côté de 子 (enfant) : une mère avec son '
              'enfant, image traditionnelle du bien-être — d\'ou "bon, bien".',
        ),
        CharacterBreakdown(
          character: '我',
          pinyin: 'wǒ',
          meaning: 'je / moi',
          radical: '戈',
          radicalMeaning: 'lance, arme',
          mnemonic: 'Forme ancienne d\'une arme tenue à la main : aucun lien '
              'de sens avec "je" aujourd\'hui, ce caractère se retient par '
              'sa forme plutôt que par son radical.',
        ),
        CharacterBreakdown(
          character: '是',
          pinyin: 'shì',
          meaning: 'être (identite)',
          radical: '日',
          radicalMeaning: 'soleil',
          mnemonic: 'Ce qui EST est aussi certain que le soleil qui se leve : '
              'un moyen mnemotechnique, pas une etymologie stricte.',
        ),
      ],
    ),
    ExplanationBlock(
      heading: '吗 transforme une phrase en question',
      body: 'Pas d\'inversion sujet-verbe en chinois : on ajoute simplement '
          '"吗" (ma) à la fin d\'une phrase affirmative pour en faire une '
          'question. "你是法国人" (tu es français) devient "你是法国人吗？" '
          '(es-tu français ?) sans rien changer d\'autre.',
    ),
    MistakeBlock(
      wrong: '你是那国人？ (confondre 那 et 哪)',
      right: '你是哪国人？',
      why: '哪 (nǎ, 3e ton) veut dire "quel", et sert a poser une question. '
          '那 (nà, 4e ton) veut dire "ce/cela", et ne pose jamais de '
          'question. Les deux caractères se ressemblent a l\'ecrit mais ont '
          'des tons et des sens differents.',
    ),
  ],
);

const _zh2Grammar = GrammarLesson(
  title: 'Les mots classificateurs (量词)',
  hook: 'En chinois, on ne peut jamais mettre un nombre directement devant '
      'un nom : il faut toujours un mot intercalaire choisi selon la forme '
      'ou la categorie de l\'objet compte.',
  blocks: [
    ExplanationBlock(
      heading: 'Pourquoi un mot entre le nombre et le nom',
      body: 'La ou le français dit "un cafe", le chinois dit litteralement '
          '"un [classificateur] cafe" : 一杯咖啡 (yì bēi kāfēi), ou 杯 (bēi) '
          'precise qu\'on compte des verres/tasses de quelque chose. Chaque '
          'categorie d\'objet a son propre classificateur, un peu comme '
          'le français dit "une feuille de papier" plutôt que "un papier".',
    ),
    MeasureWordBlock(
      heading: 'Classificateurs frequents',
      entries: [
        MeasureWordEntry(
          word: '杯',
          pinyin: 'bēi',
          usedFor: 'boissons (verre, tasse)',
          example: '一杯咖啡',
          exampleNative: 'un cafe',
        ),
        MeasureWordEntry(
          word: '个',
          pinyin: 'gè',
          usedFor:
              'le classificateur passe-partout, pour la plupart des objets et personnes',
          example: '一个人',
          exampleNative: 'une personne',
        ),
        MeasureWordEntry(
          word: '份',
          pinyin: 'fèn',
          usedFor: 'une portion, un plat commande',
          example: '一份菜',
          exampleNative: 'un plat',
        ),
        MeasureWordEntry(
          word: '张',
          pinyin: 'zhāng',
          usedFor: 'objets plats (feuille, ticket, table)',
          example: '一张票',
          exampleNative: 'un billet',
        ),
      ],
    ),
    ExplanationBlock(
      heading: 'Question sans 吗 : verbe-不/没-verbe',
      body: 'Une autre facon tres fréquente de poser une question est de '
          'repeter le verbe avec sa negation entre les deux : 有没有 (yǒu '
          'méiyǒu, litt. "avoir pas-avoir") demande "y en a-t-il ?" sans '
          'avoir besoin de 吗 à la fin.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: '有没有素的？',
          native: 'Avez-vous quelque chose de vegetarien ?',
          romanization: 'Yǒu méiyǒu sù de?',
          note: 'V + 没 + V remplace 吗',
        ),
      ],
    ),
    MistakeBlock(
      wrong: '多少人在这儿？ (pour un petit nombre attendu)',
      right: '几个人在这儿？',
      why: '几 (jǐ) s\'utilise pour un nombre qu\'on imagine petit et '
          'précis (moins d\'une dizaine), toujours suivi d\'un '
          'classificateur. 多少 (duōshao) s\'utilise pour un nombre '
          'indetermine ou potentiellement grand, comme un prix.',
    ),
  ],
);

const _zh3Grammar = GrammarLesson(
  title: 'L\'ordre des mots : le temps et le lieu avant le verbe',
  hook: 'Le chinois place systematiquement le "quand" et le "ou" avant le '
      'verbe, jamais après comme en français — c\'est la règle qui '
      'structure la moitié des phrases de la langue.',
  blocks: [
    ExplanationBlock(
      heading: 'La règle : temps, puis lieu, puis verbe',
      body: 'Une phrase chinoise s\'organise dans cet ordre : sujet, puis '
          'complément de temps, puis complément de lieu (introduit par 在), '
          'puis enfin le verbe et son objet. Le français fait l\'inverse '
          '("Le train part A SIX HEURES"), ce qui rend cette règle '
          'contre-intuitive au début.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: '火车六点半开。',
          native: 'Le train part a six heures et demie.',
          romanization: 'Huǒchē liù diǎn bàn kāi.',
          note: 'le train, [six-heures-demi], part — le temps precede le verbe',
        ),
        GrammarExample(
          target: '我在找这个地址。',
          native: 'Je cherche cette adresse.',
          romanization: 'Wǒ zài zhǎo zhège dìzhǐ.',
          note:
              '在 devant un verbe marque une action en cours, comme "be + -ing"',
        ),
      ],
    ),
    ExplanationBlock(
      heading: '在 (localiser) contre 是 (identifier)',
      body: '在 (zài) situe quelque chose quelque part : "X 在 Y" = X se '
          'trouve a Y. 是 (shì) identifie ou definit : "X 是 Y" = X est Y. '
          'Les deux se traduisent par "est" en français, mais ne sont '
          'jamais interchangeables en chinois.',
    ),
    MistakeBlock(
      wrong: '地铁站是哪儿？ (pour demander un emplacement)',
      right: '地铁站在哪儿？',
      why: 'Demander OU se trouve quelque chose utilise toujours 在, jamais '
          '是 : 是 sert a identifier ce qu\'une chose est, pas à la '
          'localiser.',
    ),
  ],
);

const _zh4Grammar = GrammarLesson(
  title: 'Pas de conjugaison, mais deux negations differentes',
  hook: 'Le chinois n\'a aucune conjugaison de verbe — ni personne, ni '
      'temps — mais compense en choisissant soigneusement entre deux mots '
      'pour dire "ne pas".',
  blocks: [
    ExplanationBlock(
      heading: 'Le verbe ne change jamais de forme',
      body: '工作 (travailler) s\'ecrit et se prononce exactement pareil que '
          'le sujet soit "je", "il" ou "ils", et que l\'action soit '
          'habituelle, passée ou future. Le temps et l\'aspect se marquent '
          'par d\'autres mots (comme 了 ou 正在), jamais par le verbe '
          'lui-meme.',
    ),
    ExplanationBlock(
      heading: '不 pour une habitude ou un état, 没 pour le passe',
      body: '不 (bù) nie une action habituelle, une intention ou un état '
          'présent : "nous ne travaillons pas le dimanche" (habitude). 没 '
          '(méi) nie exclusivement une action passée ou un fait accompli : '
          'il n\'existe pas de "没" au futur ou pour une habitude.',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: '我们周末不上班。',
          native: 'Nous ne travaillons pas le week-end.',
          romanization: 'Wǒmen zhōumò bú shàngbān.',
          note: 'habitude répétée -> 不',
        ),
        GrammarExample(
          target: '昨天没睡好。',
          native: '(Je n\'ai) pas bien dormi hier.',
          romanization: 'Zuótiān méi shuì hǎo.',
          note: 'fait accompli au passe -> 没',
        ),
      ],
    ),
    ExplanationBlock(
      heading: '正在 : insister sur l\'action en cours',
      body: '正在 (zhèngzài) devant un verbe insiste sur le fait qu\'une '
          'action se deroule exactement au moment ou l\'on parle — la '
          'version renforcee du simple 在 vu dans l\'unité precedente.',
    ),
    MistakeBlock(
      wrong: '我们没上班周末。 (pour une habitude)',
      right: '我们周末不上班。',
      why: '"Ne pas travailler le week-end" est une habitude répétée, pas '
          'un fait accompli isole : elle se nie avec 不, jamais avec 没.',
    ),
  ],
);

const _zh5Grammar = GrammarLesson(
  title: 'Parler du passe : 了 (accompli) et 过 (experience)',
  hook: 'Le chinois marque le passe avec deux particules qui ne veulent pas '
      'dire la meme chose : l\'une acheve une action, l\'autre affirme '
      'qu\'on l\'a deja vecue au moins une fois.',
  blocks: [
    ExplanationBlock(
      heading: '了 : une action terminee',
      body: '了 (le) place juste après le verbe marque qu\'une action est '
          'achevee : "去了" (allai) signale que l\'action de "aller" est '
          'terminee, en general dans un contexte précis (une date, un '
          'evenement).',
    ),
    ExplanationBlock(
      heading: '过 : au moins une fois dans sa vie',
      body: '过 (guo) place après le verbe marque une experience deja vecue, '
          'sans se soucier du moment : "去过" (deja allé) repond a "est-ce '
          'que cela t\'est deja arrive ?", exactement comme le présent '
          'perfect anglais (have been).',
    ),
    ExampleBlock(
      examples: [
        GrammarExample(
          target: '我去年去了北京。',
          native: 'Je suis allé a Pekin l\'année dernière.',
          romanization: 'Wǒ qùnián qùle Běijīng.',
          note: 'evenement date et acheve -> 了',
        ),
        GrammarExample(
          target: '你去过日本吗？',
          native: 'Es-tu deja allé au Japon ?',
          romanization: 'Nǐ qùguo Rìběn ma?',
          note: 'experience de vie, sans date -> 过',
        ),
      ],
    ),
    TableBlock(
      caption: 'Deux passes, deux negations',
      headers: ['Particule', 'Sens', 'Negation'],
      rows: [
        ['了 (le)', 'action terminee', '没 + verbe (jamais 没...了)'],
        ['过 (guo)', 'deja vecu au moins une fois', '没 + verbe + 过'],
      ],
    ),
    MistakeBlock(
      wrong: '我不吃过这个。',
      right: '我没吃过这个。',
      why: 'La negation de 过 est toujours 没, jamais 不 : 不 nie une '
          'habitude ou une intention, alors que 过 porte justement sur une '
          'experience passée, qui se nie comme un fait accompli.',
    ),
  ],
);

/// Mandarin course for French speakers.
///
/// Every card carries pinyin with tone marks: for Mandarin the tone is part of
/// the word, so a romanization without tones would teach the wrong thing. The
/// word bank splits on word boundaries rather than single characters, because
/// Mandarin words are frequently two characters and splitting them apart would
/// train a false unit.
const courseZh = Course(
  languageCode: 'zh',
  ttsLocale: 'zh-CN',
  units: [
    Unit(
      id: 'zh-u1',
      title: '第一步',
      subtitle: 'Saluer et se presenter',
      level: 'A1',
      grammarLesson: _zh1Grammar,
      cards: [
        CardItem(
          id: 'zh-1-1',
          target: '你好，我叫马克。',
          native: 'Bonjour, je m\'appelle Marc.',
          gloss: 'Toi bien, je m\'appelle Marc.',
          romanization: 'Nǐ hǎo, wǒ jiào Mǎkè.',
          tokens: ['你好', '，', '我', '叫', '马克', '。'],
          distractors: ['是', '名字', '您'],
          focus: '叫 jiào sert directement a donner son nom',
        ),
        CardItem(
          id: 'zh-1-2',
          target: '很高兴认识你。',
          native: 'Enchante.',
          gloss: 'Tres content connaitre toi.',
          romanization: 'Hěn gāoxìng rènshi nǐ.',
          tokens: ['很', '高兴', '认识', '你', '。'],
          distractors: ['太', '知道', '见'],
          focus: '认识 = connaître une personne (pas 知道)',
        ),
        CardItem(
          id: 'zh-1-3',
          target: '你是哪国人？',
          native: 'De quel pays viens-tu ?',
          gloss: 'Toi es quel pays personne ?',
          romanization: 'Nǐ shì nǎ guó rén?',
          tokens: ['你', '是', '哪', '国', '人', '？'],
          distractors: ['什么', '那', '从'],
          focus: '哪 nǎ = quel, 那 nà = ce/cela',
        ),
        CardItem(
          id: 'zh-1-4',
          target: '我是法国人。',
          native: 'Je suis français.',
          gloss: 'Je suis France personne.',
          romanization: 'Wǒ shì Fǎguó rén.',
          tokens: ['我', '是', '法国', '人', '。'],
          distractors: ['在', '的', '来'],
          focus: 'Pays + 人 forme la nationalite',
        ),
        CardItem(
          id: 'zh-1-5',
          target: '对不起，我听不懂。',
          native: 'Désolé, je ne comprends pas.',
          gloss: 'Desole, je ecoute pas comprendre.',
          romanization: 'Duìbuqǐ, wǒ tīng bu dǒng.',
          tokens: ['对不起', '，', '我', '听不懂', '。'],
          distractors: ['不听懂', '没有', '知道'],
          focus: '听不懂 = entendre sans arriver a comprendre',
        ),
        CardItem(
          id: 'zh-1-6',
          target: '你可以说慢一点吗？',
          native: 'Peux-tu parler un peu plus lentement ?',
          gloss: 'Toi peux parler lent un-peu question ?',
          romanization: 'Nǐ kěyǐ shuō màn yìdiǎn ma?',
          tokens: ['你', '可以', '说', '慢', '一点', '吗', '？'],
          distractors: ['会', '话', '呢'],
          focus: '吗 transforme une affirmation en question',
        ),
      ],
    ),
    Unit(
      id: 'zh-u2',
      title: '点菜',
      subtitle: 'Commander et payer',
      level: 'A1',
      grammarLesson: _zh2Grammar,
      cards: [
        CardItem(
          id: 'zh-2-1',
          target: '我要一杯咖啡。',
          native: 'Je voudrais un cafe.',
          gloss: 'Je veux un verre cafe.',
          romanization: 'Wǒ yào yì bēi kāfēi.',
          tokens: ['我', '要', '一', '杯', '咖啡', '。'],
          distractors: ['个', '想要', '两'],
          focus: '杯 est le classificateur des boissons',
        ),
        CardItem(
          id: 'zh-2-2',
          target: '多少钱？',
          native: 'Combien ca coûte ?',
          gloss: 'Combien argent ?',
          romanization: 'Duōshao qián?',
          tokens: ['多少', '钱', '？'],
          distractors: ['几', '块', '价格'],
          focus: '多少 pour un nombre indetermine, 几 pour un petit nombre',
        ),
        CardItem(
          id: 'zh-2-3',
          target: '可以刷卡吗？',
          native: 'Puis-je payer par carte ?',
          gloss: 'Peux glisser carte question ?',
          romanization: 'Kěyǐ shuākǎ ma?',
          tokens: ['可以', '刷卡', '吗', '？'],
          distractors: ['会', '用卡', '呢'],
          focus: '刷卡 = passer la carte',
        ),
        CardItem(
          id: 'zh-2-4',
          target: '有没有素的？',
          native: 'Avez-vous quelque chose de vegetarien ?',
          gloss: 'Avoir pas-avoir vegetarien de ?',
          romanization: 'Yǒu méiyǒu sù de?',
          tokens: ['有', '没有', '素', '的', '？'],
          distractors: ['不有', '吗', '菜'],
          focus: 'V + 不/没 + V forme une question sans 吗',
        ),
        CardItem(
          id: 'zh-2-5',
          target: '服务员，买单。',
          native: 'Serveur, l\'addition.',
          gloss: 'Serveur, acheter note.',
          romanization: 'Fúwùyuán, mǎidān.',
          tokens: ['服务员', '，', '买单', '。'],
          distractors: ['老板', '账单', '给钱'],
          focus: '买单 est l\'expression courante pour l\'addition',
        ),
        CardItem(
          id: 'zh-2-6',
          target: '很好吃，谢谢。',
          native: 'C\'était tres bon, merci.',
          gloss: 'Tres bon-manger, merci.',
          romanization: 'Hěn hǎochī, xièxie.',
          tokens: ['很', '好吃', '，', '谢谢', '。'],
          distractors: ['好喝', '太', '好'],
          focus: '好吃 pour la nourriture, 好喝 pour les boissons',
        ),
      ],
    ),
    Unit(
      id: 'zh-u3',
      title: '问路',
      subtitle: 'S\'orienter en ville',
      level: 'A1',
      grammarLesson: _zh3Grammar,
      cards: [
        CardItem(
          id: 'zh-3-1',
          target: '请问，地铁站在哪儿？',
          native: 'Excusez-moi, ou est le metro ?',
          gloss: 'Prier-demander, metro station se-trouve ou ?',
          romanization: 'Qǐngwèn, dìtiězhàn zài nǎr?',
          tokens: ['请问', '，', '地铁站', '在', '哪儿', '？'],
          distractors: ['对不起', '是', '哪个'],
          focus: '在 localise, 是 identifie',
        ),
        CardItem(
          id: 'zh-3-2',
          target: '在左边。',
          native: 'C\'est a gauche.',
          gloss: 'Se-trouve gauche cote.',
          romanization: 'Zài zuǒbian.',
          tokens: ['在', '左边', '。'],
          distractors: ['右边', '是', '前面'],
          focus: '左边 / 右边 : le suffixe 边 marque le côté',
        ),
        CardItem(
          id: 'zh-3-3',
          target: '怎么去机场？',
          native: 'Comment aller a l\'aeroport ?',
          gloss: 'Comment aller aeroport ?',
          romanization: 'Zěnme qù jīchǎng?',
          tokens: ['怎么', '去', '机场', '？'],
          distractors: ['什么', '到', '车站'],
          focus: '怎么 + verbe = comment faire quelque chose',
        ),
        CardItem(
          id: 'zh-3-4',
          target: '离这儿远吗？',
          native: 'Est-ce loin d\'ici ?',
          gloss: 'Distant ici loin question ?',
          romanization: 'Lí zhèr yuǎn ma?',
          tokens: ['离', '这儿', '远', '吗', '？'],
          distractors: ['从', '那儿', '近'],
          focus: '离 exprime la distance entre deux points',
        ),
        CardItem(
          id: 'zh-3-5',
          target: '我在找这个地址。',
          native: 'Je cherche cette adresse.',
          gloss: 'Je en-train chercher ce adresse.',
          romanization: 'Wǒ zài zhǎo zhège dìzhǐ.',
          tokens: ['我', '在', '找', '这个', '地址', '。'],
          distractors: ['正', '看', '那个'],
          focus: '在 devant un verbe marque l\'action en cours',
        ),
        CardItem(
          id: 'zh-3-6',
          target: '火车六点半开。',
          native: 'Le train part a six heures et demie.',
          gloss: 'Train six heure demi partir.',
          romanization: 'Huǒchē liù diǎn bàn kāi.',
          tokens: ['火车', '六点', '半', '开', '。'],
          distractors: ['汽车', '点半六', '走'],
          focus: 'Le complément de temps precede toujours le verbe',
        ),
      ],
    ),
    Unit(
      id: 'zh-u4',
      title: '每天',
      subtitle: 'Habitudes quotidiennes',
      level: 'A2',
      grammarLesson: _zh4Grammar,
      cards: [
        CardItem(
          id: 'zh-4-1',
          target: '我每天七点起床。',
          native: 'Je me leve a sept heures tous les jours.',
          gloss: 'Je chaque-jour sept heure lever-lit.',
          romanization: 'Wǒ měitiān qī diǎn qǐchuáng.',
          tokens: ['我', '每天', '七点', '起床', '。'],
          distractors: ['天天的', '起来', '在七点'],
          focus: 'Pas de preposition devant l\'heure',
        ),
        CardItem(
          id: 'zh-4-2',
          target: '她在医院工作。',
          native: 'Elle travaille dans un hopital.',
          gloss: 'Elle a hopital travailler.',
          romanization: 'Tā zài yīyuàn gōngzuò.',
          tokens: ['她', '在', '医院', '工作', '。'],
          distractors: ['他', '工作在', '里面'],
          focus: 'Le lieu se place avant le verbe, pas après',
        ),
        CardItem(
          id: 'zh-4-3',
          target: '我们周末不上班。',
          native: 'Nous ne travaillons pas le week-end.',
          gloss: 'Nous week-end pas monter-travail.',
          romanization: 'Wǒmen zhōumò bú shàngbān.',
          tokens: ['我们', '周末', '不', '上班', '。'],
          distractors: ['没', '工作不', '星期'],
          focus: '不 nie une habitude, 没 nie le passe',
        ),
        CardItem(
          id: 'zh-4-4',
          target: '你几点下班？',
          native: 'A quelle heure finis-tu le travail ?',
          gloss: 'Toi quelle heure descendre-travail ?',
          romanization: 'Nǐ jǐ diǎn xiàbān?',
          tokens: ['你', '几点', '下班', '？'],
          distractors: ['多少点', '上班', '吗'],
          focus: '几点 suffit: pas besoin de 吗',
        ),
        CardItem(
          id: 'zh-4-5',
          target: '我很累，因为昨天没睡好。',
          native: 'Je suis fatigue parce que j\'ai mal dormi hier.',
          gloss: 'Je tres fatigue, parce-que hier pas dormir bien.',
          romanization: 'Wǒ hěn lèi, yīnwèi zuótiān méi shuì hǎo.',
          tokens: ['我', '很', '累', '，', '因为', '昨天', '没', '睡好', '。'],
          distractors: ['是累', '不', '所以'],
          focus: 'Un adjectif se passe de 是 mais prend 很',
        ),
        CardItem(
          id: 'zh-4-6',
          target: '他正在看电影。',
          native: 'Il est en train de regarder un film.',
          gloss: 'Il justement en-train regarder film.',
          romanization: 'Tā zhèngzài kàn diànyǐng.',
          tokens: ['他', '正在', '看', '电影', '。'],
          distractors: ['了', '看着', '电视'],
          focus: '正在 insiste sur l\'action en cours maintenant',
        ),
      ],
    ),
    Unit(
      id: 'zh-u5',
      title: '说过去',
      subtitle: 'Le passe avec 了 et 过',
      level: 'A2',
      grammarLesson: _zh5Grammar,
      cards: [
        CardItem(
          id: 'zh-5-1',
          target: '我去年去了北京。',
          native: 'Je suis allé a Pekin l\'année dernière.',
          gloss: 'Je derniere-annee aller acheve Pekin.',
          romanization: 'Wǒ qùnián qùle Běijīng.',
          tokens: ['我', '去年', '去', '了', '北京', '。'],
          distractors: ['过', '明年', '在'],
          focus: '了 marque une action achevee',
        ),
        CardItem(
          id: 'zh-5-2',
          target: '我们在那儿待了一个星期。',
          native: 'Nous y sommes restes une semaine.',
          gloss: 'Nous a la-bas rester acheve un semaine.',
          romanization: 'Wǒmen zài nàr dāile yí ge xīngqī.',
          tokens: ['我们', '在', '那儿', '待', '了', '一个', '星期', '。'],
          distractors: ['这儿', '过', '个一'],
          focus: 'La durée se place après le verbe',
        ),
        CardItem(
          id: 'zh-5-3',
          target: '你去过日本吗？',
          native: 'Es-tu deja allé au Japon ?',
          gloss: 'Toi aller deja-vecu Japon question ?',
          romanization: 'Nǐ qùguo Rìběn ma?',
          tokens: ['你', '去', '过', '日本', '吗', '？'],
          distractors: ['了', '中国', '呢'],
          focus: '过 marque une experience deja vecue',
        ),
        CardItem(
          id: 'zh-5-4',
          target: '我没吃过这个。',
          native: 'Je n\'ai jamais mange ca.',
          gloss: 'Je pas manger deja-vecu ceci.',
          romanization: 'Wǒ méi chīguo zhège.',
          tokens: ['我', '没', '吃', '过', '这个', '。'],
          distractors: ['不', '了', '那个'],
          focus: 'La negation de 过 est 没, jamais 不',
        ),
        CardItem(
          id: 'zh-5-5',
          target: '比我想的好。',
          native: 'C\'est mieux que ce que je pensais.',
          gloss: 'Compare-a je penser de bon.',
          romanization: 'Bǐ wǒ xiǎng de hǎo.',
          tokens: ['比', '我', '想', '的', '好', '。'],
          distractors: ['更', '跟', '很好'],
          focus: 'Avec 比 on ne met jamais 很 devant l\'adjectif',
        ),
        CardItem(
          id: 'zh-5-6',
          target: '下雨下了一天。',
          native: 'Il a plu toute la journée.',
          gloss: 'Tomber-pluie tomber acheve un jour.',
          romanization: 'Xià yǔ xiàle yì tiān.',
          tokens: ['下雨', '下', '了', '一天', '。'],
          distractors: ['雨下', '过', '全天'],
          focus: 'Le verbe se répète avant un complément de durée',
        ),
      ],
    ),
  ],
);
