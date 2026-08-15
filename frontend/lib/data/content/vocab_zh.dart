import 'package:learning_app/data/models/vocabulary.dart';

/// Mandarin vocabulary for French speakers.
///
/// Chinese words are rarely hard to translate; they are hard to *use*. Almost
/// every note here is about a constraint that has no French equivalent — which
/// measure word a noun takes, where a word sits in the sentence, or which of
/// two apparent synonyms the situation actually calls for.
const vocabZh = VocabularyPack(
  languageCode: 'zh',
  themes: [
    VocabTheme(
      id: 'zh-t1',
      title: 'Les indispensables',
      subtitle: 'Les mots qui structurent toutes les phrases',
      entries: [
        VocabEntry(
          id: 'zh-v-de',
          target: '的',
          native: 'de (possession, qualification)',
          pos: 'particule',
          romanization: 'de',
          example: '我的书',
          exampleNative: 'mon livre',
          note: 'Le caractère le plus frequent du chinois. Il relie ce qui '
              'qualifie à ce qui est qualifie, toujours dans l\'ordre inverse '
              'du français : 我的书 = "moi-de-livre".',
        ),
        VocabEntry(
          id: 'zh-v-le',
          target: '了',
          native: 'marqueur d\'action accomplie',
          pos: 'particule',
          romanization: 'le',
          example: '我吃了。',
          exampleNative: 'J\'ai mange.',
          note: 'Ce n\'est pas un temps passe : c\'est un marqueur '
              'd\'achevement. "明天我吃了饭就走" parle du futur tout en '
              'utilisant 了.',
        ),
        VocabEntry(
          id: 'zh-v-ma',
          target: '吗',
          native: 'particule de question',
          pos: 'particule',
          romanization: 'ma',
          example: '你好吗？',
          exampleNative: 'Comment vas-tu ?',
          note: 'Se colle à la fin d\'une phrase affirmative pour en faire une '
              'question. Aucune inversion, aucun changement d\'ordre.',
        ),
        VocabEntry(
          id: 'zh-v-zai',
          target: '在',
          native: 'a, dans ; en train de',
          pos: 'verbe',
          romanization: 'zài',
          example: '我在找这个地址。',
          exampleNative: 'Je cherche cette adresse.',
          note: 'Deux emplois : localiser (在家 = à la maison) et marquer '
              'l\'action en cours devant un verbe. Le complément de lieu se '
              'place toujours AVANT le verbe.',
        ),
        VocabEntry(
          id: 'zh-v-hen',
          target: '很',
          native: 'tres',
          pos: 'adverbe',
          romanization: 'hěn',
          example: '我很累。',
          exampleNative: 'Je suis fatigue.',
          note: 'Souvent vide de sens : un adjectif seul sonne comme une '
              'comparaison, donc on met 很 pour neutraliser. "我累" sous-entend '
              '"je suis fatigue (mais pas toi)".',
        ),
        VocabEntry(
          id: 'zh-v-jiu',
          target: '就',
          native: 'alors, justement, des que',
          pos: 'adverbe',
          romanization: 'jiù',
          example: '我就来。',
          exampleNative: 'J\'arrive tout de suite.',
          note: 'Un des mots les plus difficiles a cerner : il resserre le '
              'lien entre deux choses (immediatete, consequence, insistance). '
              'A apprendre par exemples plutôt que par definition.',
        ),
        VocabEntry(
          id: 'zh-v-hai',
          target: '还',
          native: 'encore, en plus',
          pos: 'adverbe',
          romanization: 'hái',
          example: '我还没吃。',
          exampleNative: 'Je n\'ai pas encore mange.',
          note: 'Se lit aussi "huán" avec le sens de "rendre". Le meme '
              'caractère, deux prononciations, deux sens.',
        ),
        VocabEntry(
          id: 'zh-v-neng',
          target: '能 / 会 / 可以',
          native: 'pouvoir',
          pos: 'verbe',
          romanization: 'néng / huì / kěyǐ',
          example: '我会说中文。',
          exampleNative: 'Je sais parler chinois.',
          note: 'Trois "pouvoir" : 会 = savoir faire (appris), 能 = être '
              'physiquement capable, 可以 = avoir la permission. Le français '
              'confond les trois.',
        ),
        VocabEntry(
          id: 'zh-v-yao',
          target: '要',
          native: 'vouloir, devoir, aller',
          pos: 'verbe',
          romanization: 'yào',
          example: '我要一杯咖啡。',
          exampleNative: 'Je voudrais un cafe.',
          note: 'Vouloir quelque chose, mais aussi futur proche (要走了 = on va '
              'partir) et obligation. Le contexte tranche.',
        ),
        VocabEntry(
          id: 'zh-v-bu',
          target: '不 / 没',
          native: 'ne... pas',
          pos: 'adverbe',
          romanization: 'bù / méi',
          example: '我没吃过。',
          exampleNative: 'Je n\'ai jamais mange ca.',
          note: '不 nie une habitude, un présent ou une intention. 没 nie '
              'exclusivement le passe accompli et 有. Se tromper de negation '
              'est l\'erreur la plus reperable.',
        ),
        VocabEntry(
          id: 'zh-v-yidian',
          target: '一点儿',
          native: 'un peu',
          pos: 'expression',
          romanization: 'yìdiǎnr',
          example: '说慢一点儿。',
          exampleNative: 'Parle un peu plus lentement.',
          note: 'Se place APRÈS l\'adjectif pour attenuer. A ne pas confondre '
              'avec 有点儿, qui se met avant et sous-entend un reproche '
              '(有点儿贵 = un peu trop cher).',
        ),
        VocabEntry(
          id: 'zh-v-ba',
          target: '吧',
          native: 'suggestion, supposition',
          pos: 'particule',
          romanization: 'ba',
          example: '我们走吧。',
          exampleNative: 'Allons-y.',
          note: 'Adoucit une phrase en proposition plutôt qu\'en ordre. '
              'Sans 吧, "我们走" sonne comme un commandement.',
        ),
      ],
    ),
    VocabTheme(
      id: 'zh-t2',
      title: 'Compter et mesurer',
      subtitle: 'Les classificateurs, sans lesquels rien ne se compte',
      entries: [
        VocabEntry(
          id: 'zh-v-ge',
          target: '个',
          native: 'classificateur general',
          pos: 'classificateur',
          romanization: 'gè',
          example: '一个人',
          exampleNative: 'une personne',
          note: 'Le passe-partout. En cas de doute, 个 passe presque partout — '
              'ce sera parfois maladroit, jamais incomprehensible.',
        ),
        VocabEntry(
          id: 'zh-v-bei',
          target: '杯',
          native: 'classificateur des boissons',
          pos: 'classificateur',
          romanization: 'bēi',
          example: '一杯咖啡',
          exampleNative: 'un cafe',
          note: 'Litteralement "verre/tasse". On compte le contenant, pas le '
              'liquide, exactement comme "un verre d\'eau" en français.',
        ),
        VocabEntry(
          id: 'zh-v-zhang',
          target: '张',
          native: 'classificateur des objets plats',
          pos: 'classificateur',
          romanization: 'zhāng',
          example: '一张票',
          exampleNative: 'un billet',
          note: 'Pour tout ce qui est plat et etendu : feuille, ticket, '
              'table, lit, photo.',
        ),
        VocabEntry(
          id: 'zh-v-ben',
          target: '本',
          native: 'classificateur des livres',
          pos: 'classificateur',
          romanization: 'běn',
          example: '一本书',
          exampleNative: 'un livre',
          note: 'Pour tout ce qui est relie : livre, cahier, magazine, '
              'passeport.',
        ),
        VocabEntry(
          id: 'zh-v-kuai',
          target: '块',
          native: 'yuan ; morceau',
          pos: 'classificateur',
          romanization: 'kuài',
          example: '十块钱',
          exampleNative: 'dix yuans',
          note: 'La facon orale de dire la monnaie. 元 (yuán) est la forme '
              'ecrite, sur les prix affiches et les documents.',
        ),
        VocabEntry(
          id: 'zh-v-ci',
          target: '次',
          native: 'fois',
          pos: 'classificateur',
          romanization: 'cì',
          example: '我去过两次。',
          exampleNative: 'J\'y suis allé deux fois.',
          note: 'Se place après le verbe, avec le nombre : 去过两次. Le compte '
              'de fois suit toujours l\'action.',
        ),
        VocabEntry(
          id: 'zh-v-duoshao',
          target: '多少 / 几',
          native: 'combien',
          pos: 'interrogatif',
          romanization: 'duōshao / jǐ',
          example: '多少钱？',
          exampleNative: 'Combien ca coûte ?',
          note: '几 pour un petit nombre attendu (moins de dix) et toujours '
              'suivi d\'un classificateur. 多少 pour un nombre indetermine ou '
              'grand, comme un prix.',
        ),
        VocabEntry(
          id: 'zh-v-dian',
          target: '点',
          native: 'heure (sur l\'horloge)',
          pos: 'nom',
          romanization: 'diǎn',
          example: '六点半',
          exampleNative: 'six heures et demie',
          note: 'Pour l\'heure qu\'il est. Une durée en heures, c\'est '
              '小时 (xiǎoshí) : deux mots differents la ou le français dit '
              '"heure" pour les deux.',
        ),
      ],
    ),
  ],
  phrases: [
    KeyPhrase(
      id: 'zh-p-repeat',
      target: '请再说一遍。',
      native: 'Pouvez-vous repeter, s\'il vous plait ?',
      whenToUse: 'A memoriser avant tout le reste : elle relance la '
          'conversation au lieu de la laisser mourir.',
      romanization: 'Qǐng zài shuō yí biàn.',
      literal: 'Prier / encore / dire / une fois.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'zh-p-slower',
      target: '请说慢一点儿。',
      native: 'Parlez un peu plus lentement, s\'il vous plait.',
      whenToUse: 'Quand tu reconnais les mots isoles mais pas le flux.',
      romanization: 'Qǐng shuō màn yìdiǎnr.',
      literal: 'Prier / dire / lent / un peu.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'zh-p-howsay',
      target: '这个用中文怎么说？',
      native: 'Comment dit-on ca en chinois ?',
      whenToUse: 'En montrant l\'objet. Transforme n\'importe qui en '
          'professeur, et le mot appris ainsi se retient.',
      romanization: 'Zhège yòng Zhōngwén zěnme shuō?',
      literal: 'Ceci / utiliser / chinois / comment / dire ?',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'zh-p-nounderstand',
      target: '对不起，我听不懂。',
      native: 'Désolé, je ne comprends pas.',
      whenToUse: '听不懂 dit precisement "j\'entends mais je ne saisis pas", '
          'ce qui est plus utile que "je ne comprends pas".',
      romanization: 'Duìbuqǐ, wǒ tīng bu dǒng.',
      literal: 'Désolé / je / écouter-pas-comprendre.',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'zh-p-write',
      target: '请写下来，好吗？',
      native: 'Pouvez-vous l\'écrire, s\'il vous plait ?',
      whenToUse: 'Tres efficace en chinois : l\'ecrit leve les ambiguites de '
          'tons que l\'oral laisse passer.',
      romanization: 'Qǐng xiě xiàlái, hǎo ma?',
      category: 'reparation',
    ),
    KeyPhrase(
      id: 'zh-p-order',
      target: '我要一个这个。',
      native: 'Je voudrais un de ceux-la.',
      whenToUse: 'En pointant du doigt. Resout n\'importe quelle commande '
          'sans connaître le nom du plat.',
      romanization: 'Wǒ yào yí ge zhège.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'zh-p-howmuch',
      target: '多少钱？',
      native: 'Combien ca coûte ?',
      whenToUse: 'Partout. Prevoir que la réponse arrive vite et en 块.',
      romanization: 'Duōshao qián?',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'zh-p-where',
      target: '请问，洗手间在哪儿？',
      native: 'Excusez-moi, ou sont les toilettes ?',
      whenToUse: '请问 ouvre poliment n\'importe quelle question à un '
          'inconnu. Le moule se reutilise avec n\'importe quel lieu.',
      romanization: 'Qǐngwèn, xǐshǒujiān zài nǎr?',
      literal: 'Prier-demander / toilettes / se-trouver / ou ?',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'zh-p-nospicy',
      target: '请不要辣的。',
      native: 'Sans piment, s\'il vous plait.',
      whenToUse: 'Souvent indispensable. "不要太辣" (pas trop pimente) est '
          'l\'alternative negociee.',
      romanization: 'Qǐng bú yào là de.',
      category: 'survie',
    ),
    KeyPhrase(
      id: 'zh-p-thanks',
      target: '谢谢，太麻烦你了。',
      native: 'Merci, je vous ai bien derange.',
      whenToUse: 'Formule de politesse tres appreciee quand quelqu\'un s\'est '
          'donne du mal. Bien plus chaleureux qu\'un 谢谢 seul.',
      romanization: 'Xièxie, tài máfan nǐ le.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'zh-p-noneed',
      target: '不用了，谢谢。',
      native: 'Ce n\'est pas la peine, merci.',
      whenToUse: 'Refuser poliment. Refuser une première offre est normal en '
          'Chine ; l\'insistance de l\'autre fait partie du rituel.',
      romanization: 'Bú yòng le, xièxie.',
      category: 'politesse',
    ),
    KeyPhrase(
      id: 'zh-p-beginner',
      target: '我的中文不太好。',
      native: 'Mon chinois n\'est pas tres bon.',
      whenToUse: 'Désamorce d\'emblee. Les interlocuteurs ralentissent '
          'spontanement après cette phrase.',
      romanization: 'Wǒ de Zhōngwén bú tài hǎo.',
      category: 'politesse',
    ),
  ],
);
