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
    VocabTheme(
      id: 'zh-t3',
      title: 'Compter et décrire',
      subtitle: 'Nombres, jours et couleurs qui manquaient à l\'appel',
      entries: [
        VocabEntry(
          id: 'zh-v-numbers-1-10',
          target: '一，二，三...十',
          native: 'un, deux, trois... dix',
          pos: 'nombres',
          romanization: 'yī, èr, sān... shí',
          example: '我有三个哥哥。',
          exampleNative: 'J\'ai trois grands frères.',
          note: 'Système décimal parfaitement régulier : onze se dit 十一 '
              '(dix-un), vingt se dit 二十 (deux-dix). Aucune irrégularité à '
              'apprendre, contrairement au français ou à l\'anglais.',
        ),
        VocabEntry(
          id: 'zh-v-days',
          target: '星期一，星期二，星期三...',
          native: 'lundi, mardi, mercredi...',
          pos: 'noms',
          romanization: 'xīngqīyī, xīngqī\'èr, xīngqīsān...',
          example: '星期一见！',
          exampleNative: 'A lundi !',
          note: 'Les jours se construisent avec 星期 (semaine) + un chiffre : '
              'lundi = semaine-un, mardi = semaine-deux... dimanche est '
              'l\'exception, 星期天 ou 星期日, jamais 星期七.',
        ),
        VocabEntry(
          id: 'zh-v-colors',
          target: '红色，蓝色，绿色，黄色，黑色，白色',
          native: 'rouge, bleu, vert, jaune, noir, blanc',
          pos: 'adjectifs',
          romanization: 'hóngsè, lánsè, lǜsè, huángsè, hēisè, báisè',
          example: '她穿红色的衣服。',
          exampleNative: 'Elle porte des vêtements rouges.',
          note: '色 (sè) veut dire "couleur" et se rattache au nom de la '
              'teinte. Devant un nom, la couleur est suivie de 的 : 红色的衣服 '
              '(des vêtements de couleur rouge).',
        ),
        VocabEntry(
          id: 'zh-v-da-xiao',
          target: '大 / 小',
          native: 'grand / petit',
          pos: 'adjectifs',
          romanization: 'dà / xiǎo',
          example: '房子很大，厨房很小。',
          exampleNative: 'La maison est grande, la cuisine est petite.',
          note: 'Un adjectif seul devant 很 (très) même sans intensité '
              'particulière : 很大 se traduit souvent juste par "grand", pas '
              'forcément "très grand". Sans 很, la phrase sonne comme une '
              'comparaison implicite.',
        ),
        VocabEntry(
          id: 'zh-v-hao-huai',
          target: '好 / 不好',
          native: 'bon / mauvais',
          pos: 'adjectifs',
          romanization: 'hǎo / bù hǎo',
          example: '这家饭馆很好。',
          exampleNative: 'Ce restaurant est bon.',
          note: '好 sert aussi de particule d\'accord ("d\'accord, bien") et '
              'entre dans des dizaines de mots composés : 你好 (bonjour), '
              '好吃 (bon au goût), 好看 (beau à regarder).',
        ),
        VocabEntry(
          id: 'zh-v-xiang-yao',
          target: '想 / 要',
          native: 'avoir envie de / vouloir',
          pos: 'verbes',
          romanization: 'xiǎng / yào',
          example: '我想喝咖啡，但是我要走了。',
          exampleNative: 'J\'ai envie d\'un café, mais je dois partir.',
          note: '想 exprime un souhait plus doux ("j\'aimerais bien"), 要 est '
              'plus direct et ferme ("je veux", "j\'ai besoin de"). Les deux '
              'se placent directement devant le verbe, sans particule '
              'intermédiaire.',
        ),
        VocabEntry(
          id: 'zh-v-keyi-bixu',
          target: '可以 / 必须',
          native: 'pouvoir (permission) / devoir (obligation)',
          pos: 'verbes',
          romanization: 'kěyǐ / bìxū',
          example: '你可以在这儿等，但是必须出示票。',
          exampleNative: 'Tu peux attendre ici, mais tu dois montrer ton '
              'billet.',
          note: '可以 pour une permission ("c\'est possible/autorisé"), 能 '
              '(néng) pour une capacité physique, 必须 pour une obligation '
              'stricte — trois nuances que le français regroupe souvent sous '
              '"pouvoir/devoir".',
        ),
      ],
    ),
    VocabTheme(
      id: 'zh-t4',
      title: '家人 - La famille',
      subtitle: 'Le chinois distingue l\'aîné du cadet, et le côté paternel du maternel',
      entries: [
        VocabEntry(
          id: 'zh-v-jiaren',
          target: '家人',
          native: 'famille, proches',
          pos: 'nom',
          romanization: 'jiārén',
          example: '我家人都住在北京。',
          exampleNative: 'Toute ma famille vit à Pékin.',
          note: 'Désigne le cercle des proches vivant sous le même toit, à '
              'distinguer de 家庭 (jiātíng), la "famille" comme institution '
              'ou cellule sociale.',
        ),
        VocabEntry(
          id: 'zh-v-fumu',
          target: '父母',
          native: 'parents (père et mère)',
          pos: 'nom',
          romanization: 'fùmǔ',
          example: '我父母不住在这儿。',
          exampleNative: 'Mes parents ne vivent pas ici.',
          note: 'Registre plutôt écrit/formel. À l\'oral on dit souvent '
              '爸爸妈妈 (bàba māma), "papa et maman", même entre adultes.',
        ),
        VocabEntry(
          id: 'zh-v-gege-didi',
          target: '哥哥 / 弟弟',
          native: 'frère aîné / frère cadet',
          pos: 'nom',
          romanization: 'gēge / dìdi',
          example: '我有一个哥哥和一个弟弟。',
          exampleNative: 'J\'ai un frère aîné et un frère cadet.',
          note: 'Le chinois n\'a pas de mot générique pour "frère" : il '
              'faut toujours préciser s\'il est plus âgé ou plus jeune que '
              'soi. Même logique pour 姐姐/妹妹.',
        ),
        VocabEntry(
          id: 'zh-v-jiejie-meimei',
          target: '姐姐 / 妹妹',
          native: 'sœur aînée / sœur cadette',
          pos: 'nom',
          romanization: 'jiějie / mèimei',
          example: '我姐姐比我大三岁。',
          exampleNative: 'Ma sœur aînée a trois ans de plus que moi.',
          note: 'Terme aussi utilisé, en registre familier, pour s\'adresser '
              'poliment à une jeune femme un peu plus âgée que soi, même '
              'sans lien de parenté.',
        ),
        VocabEntry(
          id: 'zh-v-yeye-nainai',
          target: '爷爷 / 奶奶',
          native: 'grand-père / grand-mère paternels',
          pos: 'nom',
          romanization: 'yéye / nǎinai',
          example: '我爷爷奶奶住在乡下。',
          exampleNative: 'Mes grands-parents paternels vivent à la '
              'campagne.',
          note: 'Uniquement le côté du père. Pour le côté de la mère, on '
              'utilise des mots différents : 外公/外婆.',
        ),
        VocabEntry(
          id: 'zh-v-waigong-waipo',
          target: '外公 / 外婆',
          native: 'grand-père / grand-mère maternels',
          pos: 'nom',
          romanization: 'wàigōng / wàipó',
          example: '我外婆做的菜很好吃。',
          exampleNative: 'La cuisine de ma grand-mère maternelle est '
              'délicieuse.',
          note: 'Le caractère 外 ("extérieur") marque le côté maternel — un '
              'vestige de la tradition où la fille mariée "sortait" de sa '
              'famille d\'origine. Une distinction que le français ne fait '
              'pas du tout.',
        ),
        VocabEntry(
          id: 'zh-v-haizi',
          target: '孩子',
          native: 'enfant',
          pos: 'nom',
          romanization: 'háizi',
          example: '他们有两个孩子。',
          exampleNative: 'Ils ont deux enfants.',
          note: 'Mot neutre et générique. 小孩 (xiǎohái) est un synonyme '
              'plus oral et affectueux.',
        ),
        VocabEntry(
          id: 'zh-v-dushengzinu',
          target: '独生子女',
          native: 'enfant unique',
          pos: 'nom',
          romanization: 'dúshēngzǐnǚ',
          example: '我是独生子女，没有兄弟姐妹。',
          exampleNative: 'Je suis enfant unique, je n\'ai pas de frères et '
              'sœurs.',
          note: 'Terme lié historiquement à la politique de l\'enfant '
              'unique (1979-2015) ; toute une génération de Chinois se '
              'décrit encore avec ce mot.',
        ),
        VocabEntry(
          id: 'zh-v-yang',
          target: '养',
          native: 'élever (un enfant, un animal)',
          pos: 'verbe',
          romanization: 'yǎng',
          example: '她一个人养大了三个孩子。',
          exampleNative: 'Elle a élevé seule trois enfants.',
          note: 'Le même verbe sert pour élever des enfants et des '
              'animaux, comme en français, contrairement à 教育 (jiàoyù) '
              'qui porte sur l\'éducation intellectuelle et morale.',
        ),
        VocabEntry(
          id: 'zh-v-xiang',
          target: '像',
          native: 'ressembler à',
          pos: 'verbe',
          romanization: 'xiàng',
          example: '你长得很像你妈妈。',
          exampleNative: 'Tu ressembles beaucoup à ta mère.',
          note: 'Construction fixe avec 长得 (zhǎng de) devant : "长得像" pour '
              'la ressemblance physique.',
        ),
        VocabEntry(
          id: 'zh-v-chudelai',
          target: '处得来',
          native: 's\'entendre bien (avec qqn)',
          pos: 'expression',
          romanization: 'chǔ de lái',
          example: '我跟我嫂子处得来。',
          exampleNative: 'Je m\'entends bien avec ma belle-sœur.',
          note: 'Expression orale et familière ; à l\'écrit on préférera '
              '相处融洽 (xiāngchǔ róngqià), plus formel.',
        ),
      ],
    ),
    VocabTheme(
      id: 'zh-t5',
      title: '感觉 - Les émotions',
      subtitle: 'Nuancer ce qu\'on ressent au-delà de 高兴/不高兴',
      entries: [
        VocabEntry(
          id: 'zh-v-juede',
          target: '觉得',
          native: 'trouver que, avoir l\'impression que',
          pos: 'verbe',
          romanization: 'juéde',
          example: '我觉得有点累。',
          exampleNative: 'J\'ai l\'impression d\'être un peu fatigué.',
          note: 'Verbe d\'opinion et de ressenti à la fois, l\'un des plus '
              'utilisés en chinois pour introduire un état ou un jugement '
              'personnel.',
        ),
        VocabEntry(
          id: 'zh-v-gaoxing',
          target: '高兴',
          native: 'content, heureux',
          pos: 'adjectif',
          romanization: 'gāoxìng',
          example: '认识你很高兴。',
          exampleNative: 'Ravi de faire ta connaissance.',
          note: 'Décrit une joie ponctuelle liée à une situation, à la '
              'différence de 幸福 (xìngfú), un bonheur plus profond et '
              'durable (la vie, un mariage).',
        ),
        VocabEntry(
          id: 'zh-v-nanguo',
          target: '难过',
          native: 'triste',
          pos: 'adjectif',
          romanization: 'nánguò',
          example: '听到这个消息我很难过。',
          exampleNative: 'J\'ai été très triste en apprenant cette '
              'nouvelle.',
          note: 'Littéralement "difficile à passer/traverser", une image '
              'qui rend bien l\'idée d\'un moment pénible à surmonter.',
        ),
        VocabEntry(
          id: 'zh-v-danxin',
          target: '担心',
          native: 'inquiet, s\'inquiéter',
          pos: 'verbe',
          romanization: 'dānxīn',
          example: '别担心，一切都会好的。',
          exampleNative: 'Ne t\'inquiète pas, tout ira bien.',
          note: 'Se comporte comme un verbe : 担心某事 ("s\'inquiéter de '
              'quelque chose"), pas besoin de mot de liaison type "de".',
        ),
        VocabEntry(
          id: 'zh-v-shengqi',
          target: '生气',
          native: 'en colère, fâché',
          pos: 'adjectif, verbe',
          romanization: 'shēngqì',
          example: '他为什么生气了？',
          exampleNative: 'Pourquoi est-il en colère ?',
          note: 'Littéralement "faire naître un souffle/une énergie" — '
              'l\'image chinoise classique de la colère comme un excès de '
              'qi.',
        ),
        VocabEntry(
          id: 'zh-v-jinzhang',
          target: '紧张',
          native: 'nerveux, stressé',
          pos: 'adjectif',
          romanization: 'jǐnzhāng',
          example: '面试前我很紧张。',
          exampleNative: 'Je suis très nerveux avant l\'entretien.',
          note: 'S\'emploie aussi pour une situation elle-même tendue '
              '(政治紧张, tensions politiques), pas seulement pour une '
              'personne.',
        ),
        VocabEntry(
          id: 'zh-v-fangxin',
          target: '放心',
          native: 'être rassuré, tranquille',
          pos: 'verbe',
          romanization: 'fàngxīn',
          example: '你放心，我会照顾好她的。',
          exampleNative: 'Rassure-toi, je prendrai bien soin d\'elle.',
          note: 'Littéralement "poser/relâcher le cœur" — l\'antonyme '
              'exact de 担心 (s\'inquiéter).',
        ),
        VocabEntry(
          id: 'zh-v-buhaoyisi',
          target: '不好意思',
          native: 'gêné ; aussi "excusez-moi", "désolé"',
          pos: 'expression',
          romanization: 'bù hǎoyìsi',
          example: '不好意思，我迟到了。',
          exampleNative: 'Désolé, je suis en retard.',
          note: 'Double usage très fréquent : décrit la gêne ressentie ET '
              'sert de formule d\'excuse polie légère, plus douce que 对不起.',
        ),
        VocabEntry(
          id: 'zh-v-shiwang',
          target: '失望',
          native: 'déçu',
          pos: 'adjectif',
          romanization: 'shīwàng',
          example: '考试结果让我很失望。',
          exampleNative: 'Le résultat de l\'examen m\'a beaucoup déçu.',
          note: 'Littéralement "perdre l\'espoir" ; s\'utilise aussi bien '
              'pour une personne ("il m\'a déçu") que pour une situation.',
        ),
        VocabEntry(
          id: 'zh-v-jiaoao',
          target: '骄傲',
          native: 'fier',
          pos: 'adjectif',
          romanization: 'jiāo\'ào',
          example: '我为你感到骄傲。',
          exampleNative: 'Je suis fier de toi.',
          note: 'Peut aussi vouloir dire "arrogant" selon le contexte — '
              'nuance qu\'il faut deviner au ton, exactement comme "fier" '
              'peut aussi sonner négatif en français.',
        ),
        VocabEntry(
          id: 'zh-v-xianmu-jidu',
          target: '羡慕 / 嫉妒',
          native: 'envieux (positif) / jaloux (négatif)',
          pos: 'verbe, adjectif',
          romanization: 'xiànmù / jídù',
          example: '我很羡慕你的生活，但我不嫉妒你。',
          exampleNative: 'J\'envie ta vie (admiration), mais je ne suis pas '
              'jaloux de toi.',
          note: 'Distinction nette que le français gomme souvent : 羡慕 est '
              'une envie admirative sans rancœur, 嫉妒 est la jalousie au '
              'sens négatif et possessif.',
        ),
        VocabEntry(
          id: 'zh-v-xiang-miss',
          target: '想',
          native: 'avoir envie de ; penser à ; manquer à (qqn)',
          pos: 'verbe',
          romanization: 'xiǎng',
          example: '我很想你。',
          exampleNative: 'Tu me manques beaucoup.',
          note: 'Verbe extrêmement polyvalent : 想 + verbe = "avoir envie '
              'de faire", 想 + personne = "penser à / avoir cette personne '
              'qui manque" — le sens exact dépend de ce qui suit.',
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
