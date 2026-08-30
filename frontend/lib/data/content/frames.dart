import 'package:learning_app/data/models/sentence_frame.dart';

const _es = <SentenceFrame>[
  SentenceFrame(
    id: 'es-frame-necesito',
    languageCode: 'es',
    label: 'Dire ce dont tu as besoin',
    why: 'La structure la plus rentable en voyage : elle ouvre un guichet, '
        'un hôtel, une pharmacie.',
    nativePattern: 'J\'ai besoin {objeto} pour {momento}.',
    grammarNote:
        '"Necesitar" se construit directement, sans préposition : necesito '
        'ayuda, et non "necesito de ayuda".',
    parts: [
      FrameText('Necesito '),
      FrameSlot(id: 'objeto', label: 'ce dont tu as besoin', options: [
        SlotOption(target: 'una habitación', native: 'd\'une chambre'),
        SlotOption(target: 'un billete', native: 'd\'un billet'),
        SlotOption(target: 'ayuda', native: 'd\'aide'),
        SlotOption(target: 'un médico', native: 'd\'un médecin'),
        SlotOption(target: 'más tiempo', native: 'de plus de temps'),
      ]),
      FrameText(' para '),
      FrameSlot(id: 'momento', label: 'quand', options: [
        SlotOption(target: 'esta noche', native: 'ce soir'),
        SlotOption(target: 'mañana', native: 'demain'),
        SlotOption(target: 'el lunes', native: 'lundi'),
        SlotOption(target: 'dos días', native: 'deux jours'),
      ]),
      FrameText('.'),
    ],
  ),
  SentenceFrame(
    id: 'es-frame-podria',
    languageCode: 'es',
    label: 'Demander poliment',
    why: 'Le conditionnel "podría" transforme une exigence en demande. '
        'C\'est la différence entre passer pour brusque et pour poli.',
    nativePattern: 'Pourriez-vous {accion}, s\'il vous plaît ?',
    grammarNote:
        '"¿Puede...?" est correct mais direct. "¿Podría...?" est la forme '
        'polie, et coûte une syllabe de plus.',
    parts: [
      FrameText('¿Podría '),
      FrameSlot(id: 'accion', label: 'l\'action demandée', options: [
        SlotOption(target: 'repetir', native: 'répéter'),
        SlotOption(
            target: 'hablar más despacio', native: 'parler plus lentement'),
        SlotOption(target: 'ayudarme', native: 'm\'aider'),
        SlotOption(target: 'escribirlo', native: 'l\'écrire'),
        SlotOption(target: 'esperar un momento', native: 'attendre un instant'),
      ]),
      FrameText(', por favor?'),
    ],
  ),
  SentenceFrame(
    id: 'es-frame-me-parece',
    languageCode: 'es',
    label: 'Donner ton avis',
    why: 'Une opinion sans justification tue la conversation. Cette '
        'structure force la relance.',
    nativePattern: 'Je trouve ça {opinion} parce que {razon}.',
    grammarNote:
        '"Me parece" fonctionne comme "gustar" : c\'est la chose qui te '
        'semble, pas toi qui sembles.',
    parts: [
      FrameText('Me parece '),
      FrameSlot(id: 'opinion', label: 'ton avis', options: [
        SlotOption(target: 'interesante', native: 'intéressant'),
        SlotOption(target: 'difícil', native: 'difficile'),
        SlotOption(target: 'caro', native: 'cher'),
        SlotOption(target: 'perfecto', native: 'parfait'),
      ]),
      FrameText(' porque '),
      FrameSlot(id: 'razon', label: 'la raison', options: [
        SlotOption(target: 'no tengo tiempo', native: 'je n\'ai pas le temps'),
        SlotOption(target: 'es mi primera vez', native: 'c\'est ma première fois'),
        SlotOption(target: 'no lo conozco', native: 'je ne connais pas'),
        SlotOption(target: 'me gusta mucho', native: 'ça me plaît beaucoup'),
      ]),
      FrameText('.'),
    ],
  ),
  SentenceFrame(
    id: 'es-frame-pasado',
    languageCode: 'es',
    label: 'Raconter au passé',
    why: 'On te demandera toujours ce que tu as fait le week-end. '
        'Avoir la structure prête évite le blanc.',
    nativePattern: '{momento} je suis allé {lugar} avec {persona}.',
    grammarNote:
        '"Fui" est le passé simple de ir ET de ser. Le contexte tranche : '
        'fui a la playa (aller), fui profesor (être).',
    parts: [
      FrameSlot(id: 'momento', label: 'quand', options: [
        SlotOption(target: 'Ayer', native: 'Hier'),
        SlotOption(target: 'El fin de semana', native: 'Le week-end'),
        SlotOption(target: 'El año pasado', native: 'L\'an dernier'),
        SlotOption(target: 'Esta mañana', native: 'Ce matin'),
      ]),
      FrameText(' fui a '),
      FrameSlot(id: 'lugar', label: 'où', options: [
        SlotOption(target: 'la playa', native: 'à la plage'),
        SlotOption(target: 'casa de un amigo', native: 'chez un ami'),
        SlotOption(target: 'el mercado', native: 'au marché'),
        SlotOption(target: 'Madrid', native: 'à Madrid'),
      ]),
      FrameText(' con '),
      FrameSlot(id: 'persona', label: 'avec qui', options: [
        SlotOption(target: 'mi hermana', native: 'ma sœur'),
        SlotOption(target: 'unos amigos', native: 'des amis'),
        SlotOption(target: 'mi pareja', native: 'mon/ma partenaire'),
        SlotOption(target: 'mi familia', native: 'ma famille'),
      ]),
      FrameText('.'),
    ],
  ),
];

const _en = <SentenceFrame>[
  SentenceFrame(
    id: 'en-frame-would-like',
    languageCode: 'en',
    label: 'Demander sans brusquer',
    why: '"I want" est compris mais sonne enfantin ou agressif. '
        '"I\'d like" est ce que disent les adultes.',
    nativePattern: 'Je voudrais {action}, s\'il vous plaît.',
    grammarNote:
        '"I\'d like" = I would like. La contraction est la norme à l\'oral ; '
        'la forme pleine sonne solennelle.',
    parts: [
      FrameText('I\'d like to '),
      FrameSlot(id: 'action', label: 'l\'action', options: [
        SlotOption(target: 'book a table', native: 'réserver une table'),
        SlotOption(target: 'change my ticket', native: 'changer mon billet'),
        SlotOption(target: 'pay by card', native: 'payer par carte'),
        SlotOption(target: 'speak to someone', native: 'parler à quelqu\'un'),
        SlotOption(target: 'have a look', native: 'jeter un œil'),
      ]),
      FrameText(', please.'),
    ],
  ),
  SentenceFrame(
    id: 'en-frame-could-you',
    languageCode: 'en',
    label: 'Réparer la conversation',
    why: 'Les phrases qui te permettent de continuer quand tu n\'as pas '
        'compris. Les plus rentables de toutes.',
    nativePattern: 'Pourriez-vous {favour}, s\'il vous plaît ?',
    parts: [
      FrameText('Could you '),
      FrameSlot(id: 'favour', label: 'ce que tu demandes', options: [
        SlotOption(target: 'say that again', native: 'répéter'),
        SlotOption(target: 'speak more slowly', native: 'parler plus lentement'),
        SlotOption(target: 'write it down', native: 'l\'écrire'),
        SlotOption(target: 'spell that', native: 'l\'épeler'),
        SlotOption(target: 'help me with this', native: 'm\'aider avec ça'),
      ]),
      FrameText(', please?'),
    ],
  ),
  SentenceFrame(
    id: 'en-frame-been-for',
    languageCode: 'en',
    label: 'Dire depuis combien de temps',
    why: 'Le present perfect continu est la structure que les francophones '
        'ratent le plus souvent — et on te posera la question tout le temps.',
    nativePattern: 'Je {activity} depuis {duration}.',
    grammarNote:
        'Piège classique : le français dit "je vis ici depuis trois ans" au '
        'présent, l\'anglais exige "I have been living". Dire "I live here '
        'since" est la faute la plus reconnaissable d\'un francophone.',
    parts: [
      FrameText('I\'ve been '),
      FrameSlot(id: 'activity', label: 'l\'activité', options: [
        SlotOption(target: 'living here', native: 'vis ici'),
        SlotOption(target: 'learning English', native: 'apprends l\'anglais'),
        SlotOption(target: 'working there', native: 'travaille là-bas'),
        SlotOption(target: 'waiting', native: 'attends'),
      ]),
      FrameText(' for '),
      FrameSlot(id: 'duration', label: 'la durée', options: [
        SlotOption(target: 'two weeks', native: 'deux semaines'),
        SlotOption(target: 'three years', native: 'trois ans'),
        SlotOption(target: 'a while', native: 'un moment'),
        SlotOption(target: 'ages', native: 'une éternité'),
      ]),
      FrameText('.'),
    ],
  ),
];

const _zh = <SentenceFrame>[
  SentenceFrame(
    id: 'zh-frame-time-place-verb',
    languageCode: 'zh',
    label: 'L\'ordre des mots chinois',
    why: 'La structure fondamentale : sujet, puis QUAND, puis OÙ, puis ce '
        'qu\'on fait. Exactement l\'inverse du français.',
    nativePattern: 'Je {动作} {地方} {时间}.',
    grammarNote:
        'Le français place le temps et le lieu à la fin ("je travaille au '
        'bureau demain") ; le chinois les place AVANT le verbe. Cette '
        'structure est la plus importante de toute la langue — c\'est elle '
        'qui fait qu\'une phrase "sonne chinois" ou pas.',
    parts: [
      FrameText('我', romanization: 'wǒ'),
      FrameSlot(id: '时间', label: 'quand', options: [
        SlotOption(target: '明天', native: 'demain', romanization: 'míngtiān'),
        SlotOption(
            target: '今天晚上', native: 'ce soir', romanization: 'jīntiān wǎnshang'),
        SlotOption(target: '星期一', native: 'lundi', romanization: 'xīngqīyī'),
        SlotOption(target: '每天', native: 'tous les jours', romanization: 'měitiān'),
      ]),
      FrameText('在', romanization: 'zài'),
      FrameSlot(id: '地方', label: 'où', options: [
        SlotOption(target: '公司', native: 'au bureau', romanization: 'gōngsī'),
        SlotOption(target: '家', native: 'à la maison', romanization: 'jiā'),
        SlotOption(target: '学校', native: 'à l\'école', romanization: 'xuéxiào'),
        SlotOption(target: '咖啡店', native: 'au café', romanization: 'kāfēidiàn'),
      ]),
      FrameSlot(id: '动作', label: 'ce que tu fais', options: [
        SlotOption(target: '工作', native: 'travaille', romanization: 'gōngzuò'),
        SlotOption(target: '开会', native: 'suis en réunion', romanization: 'kāihuì'),
        SlotOption(
            target: '学中文', native: 'apprends le chinois', romanization: 'xué Zhōngwén'),
        SlotOption(target: '等你', native: 't\'attends', romanization: 'děng nǐ'),
      ]),
      FrameText('。'),
    ],
  ),
  SentenceFrame(
    id: 'zh-frame-neng-ma',
    languageCode: 'zh',
    label: 'Demander un service',
    why: 'La question polie de base. 能…吗 encadre la demande.',
    nativePattern: 'Peux-tu {动作} ?',
    grammarNote:
        'Le chinois n\'a pas de mot pour "oui" : on répond en reprenant le '
        'verbe. À "你能帮我吗？" on répond "能" ou "不能".',
    parts: [
      FrameText('你能', romanization: 'nǐ néng'),
      FrameSlot(id: '动作', label: 'le service', options: [
        SlotOption(
            target: '说慢一点', native: 'parler plus lentement', romanization: 'shuō màn yìdiǎn'),
        SlotOption(
            target: '再说一遍', native: 'répéter', romanization: 'zài shuō yí biàn'),
        SlotOption(target: '帮我', native: 'm\'aider', romanization: 'bāng wǒ'),
        SlotOption(target: '等一下', native: 'attendre un instant', romanization: 'děng yíxià'),
      ]),
      FrameText('吗？', romanization: 'ma?'),
    ],
  ),
  SentenceFrame(
    id: 'zh-frame-liangci',
    languageCode: 'zh',
    label: 'Commander avec le bon classificateur',
    why: 'En chinois on ne compte jamais un nom directement : il faut un '
        'classificateur entre le nombre et l\'objet.',
    nativePattern: 'Je voudrais {数量}, merci.',
    grammarNote:
        'Chaque nom a son classificateur : 个 (général), 杯 (récipients), '
        '件 (vêtements), 碗 (bols). Les apprendre par paire nom+classificateur '
        'est beaucoup plus efficace que de mémoriser une liste.',
    parts: [
      FrameText('我要', romanization: 'wǒ yào'),
      FrameSlot(id: '数量', label: 'quantité et objet', options: [
        SlotOption(
            target: '两个苹果',
            native: 'deux pommes',
            romanization: 'liǎng ge píngguǒ',
            note: '个 est le classificateur passe-partout.'),
        SlotOption(
            target: '三杯茶',
            native: 'trois thés',
            romanization: 'sān bēi chá',
            note: '杯 = "tasse de", pour tout ce qui se boit.'),
        SlotOption(
            target: '一件衣服',
            native: 'un vêtement',
            romanization: 'yí jiàn yīfu',
            note: '件 sert aux vêtements et aux affaires abstraites.'),
        SlotOption(
            target: '一碗面',
            native: 'un bol de nouilles',
            romanization: 'yì wǎn miàn',
            note: '碗 = "bol de".'),
      ]),
      FrameText('，谢谢。', romanization: ', xièxie.'),
    ],
  ),
];

const _tr = <SentenceFrame>[
  SentenceFrame(
    id: 'tr-frame-istiyorum',
    languageCode: 'tr',
    label: 'Dire ce que tu veux faire',
    why: 'Le verbe passe à la fin, et "istiyorum" ferme la phrase. '
        'C\'est le moule turc de base.',
    nativePattern: 'Je veux aller {hedef}.',
    grammarNote:
        'Le turc met le verbe en dernier. Les compléments sont marqués par '
        'des suffixes, pas par des prépositions : eve = à la maison.',
    parts: [
      FrameSlot(id: 'hedef', label: 'la destination', options: [
        SlotOption(target: 'eve', native: 'à la maison'),
        SlotOption(target: 'otele', native: 'à l\'hôtel'),
        SlotOption(target: 'havaalanına', native: 'à l\'aéroport'),
        SlotOption(target: 'Ankara\'ya', native: 'à Ankara'),
      ]),
      FrameText(' gitmek istiyorum.'),
    ],
  ),
  SentenceFrame(
    id: 'tr-frame-alabilir',
    languageCode: 'tr',
    label: 'Commander poliment',
    why: 'La formule de commande standard, au café comme au guichet.',
    nativePattern: 'Puis-je avoir {şey} ?',
    parts: [
      FrameText('Bir '),
      FrameSlot(id: 'şey', label: 'ce que tu commandes', options: [
        SlotOption(target: 'çay', native: 'un thé'),
        SlotOption(target: 'kahve', native: 'un café'),
        SlotOption(target: 'su', native: 'une eau'),
        SlotOption(target: 'bilet', native: 'un billet'),
      ]),
      FrameText(' alabilir miyim?'),
    ],
  ),
];

const frames = <String, List<SentenceFrame>>{
  'es': _es,
  'en': _en,
  'zh': _zh,
  'tr': _tr,
};

List<SentenceFrame> framesFor(String languageCode) =>
    frames[languageCode] ?? const <SentenceFrame>[];
