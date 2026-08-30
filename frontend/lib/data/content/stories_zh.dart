import 'package:learning_app/data/models/story.dart';

/// Mandarin texts are bracketed exhaustively.
///
/// Chinese is written without spaces, so a reader who cannot yet segment a
/// sentence sees an undifferentiated wall. Every chunk here is cut by hand at
/// the word boundary and carries its pinyin — which means reading a text is
/// also a segmentation lesson, the single hardest early skill in the language.
StoryLine _l(
  String source, {
  required String native,
  required String romanization,
  String? speaker,
  String? note,
}) =>
    StoryLine.parse(source,
        native: native,
        romanization: romanization,
        speaker: speaker,
        note: note);

final storiesZh = <Story>[
  Story(
    id: 'zh-story-shichang',
    languageCode: 'zh',
    title: '在市场',
    titleNative: 'Au marché',
    blurb:
        'Le premier vrai dialogue : acheter, demander le prix, négocier. '
        'Chaque bloc est découpé au bon endroit, avec son pinyin.',
    level: StoryLevel.first,
    takeaway:
        'Trois structures à emporter : 多少钱 (combien), 便宜一点 (moins cher) '
        'et 一共 (au total). Elles suffisent pour acheter n\'importe quoi.',
    lines: [
      _l('[你|tu|nǐ][要|veux|yào][买|acheter|mǎi][什么|quoi|shénme]？',
          speaker: '老板 · le patron',
          native: 'Vous voulez acheter quoi ?',
          romanization: 'Nǐ yào mǎi shénme?'),
      _l('[这个|ce|zhège][苹果|pomme|píngguǒ][多少钱|combien|duōshao qián][一斤|la livre|yì jīn]？',
          speaker: '顾客 · le client',
          native: 'Ces pommes, c\'est combien la livre ?',
          romanization: 'Zhège píngguǒ duōshao qián yì jīn?',
          note:
              '斤 (jīn) = 500 g. C\'est l\'unité réelle des marchés chinois : on n\'achète presque jamais au kilo.'),
      _l('[八|huit|bā][块|yuan|kuài]。[很|très|hěn][甜|sucré|tián][的|(particule)|de]。',
          speaker: '老板 · le patron',
          native: 'Huit yuans. Elles sont très sucrées.',
          romanization: 'Bā kuài. Hěn tián de.',
          note:
              '块 est le mot parlé pour la monnaie ; 元 est la forme écrite, sur les étiquettes et les factures.'),
      _l('[太|trop|tài][贵|cher|guì][了|(particule)|le]。[便宜|moins cher|piányi][一点|un peu|yìdiǎn][吧|(suggestion)|ba]。',
          speaker: '顾客 · le client',
          native: 'C\'est trop cher. Un peu moins cher, allez.',
          romanization: 'Tài guì le. Piányi yìdiǎn ba.',
          note:
              '太…了 encadre l\'excès. 吧 en fin de phrase transforme un ordre en suggestion — c\'est ce qui rend la demande acceptable.'),
      _l('[那|alors|nà][七|sept|qī][块|yuan|kuài]。[不能|je ne peux pas|bù néng][再|encore|zài][少|baisser|shǎo][了|(particule)|le]。',
          speaker: '老板 · le patron',
          native: 'Alors sept yuans. Je ne peux pas descendre plus bas.',
          romanization: 'Nà qī kuài. Bù néng zài shǎo le.'),
      _l('[好|d\'accord|hǎo]，[我|je|wǒ][要|veux|yào][两|deux|liǎng][斤|livres|jīn]。',
          speaker: '顾客 · le client',
          native: 'D\'accord, j\'en veux deux livres.',
          romanization: 'Hǎo, wǒ yào liǎng jīn.',
          note:
              '两 et non 二 devant un classificateur. 二 sert à compter et à lire les nombres ; 两 sert à quantifier des choses.'),
      _l('[还|encore|hái][要|voulez|yào][别的|autre chose|biéde][吗|(question)|ma]？',
          speaker: '老板 · le patron',
          native: 'Vous voulez autre chose ?',
          romanization: 'Hái yào biéde ma?'),
      _l('[不用了|non merci|búyòng le]，[谢谢|merci|xièxie]。',
          speaker: '顾客 · le client',
          native: 'Non merci, ça ira.',
          romanization: 'Búyòng le, xièxie.',
          note:
              '不用了 est le refus poli standard : littéralement « pas besoin ». Plus naturel que 不, qui sonne sec.'),
      _l('[一共|au total|yígòng][十四|quatorze|shísì][块|yuan|kuài]。',
          speaker: '老板 · le patron',
          native: 'Quatorze yuans au total.',
          romanization: 'Yígòng shísì kuài.'),
      _l('[给|voici|gěi][你|vous|nǐ]。',
          speaker: '顾客 · le client',
          native: 'Tenez.',
          romanization: 'Gěi nǐ.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Combien coûtent les pommes au départ, et à l\'arrivée ?',
        options: ['8 puis 7 yuans', '7 puis 8 yuans', '8 puis 6 yuans'],
        answerIndex: 0,
        explanation: '八块 puis, après négociation, 七块.',
      ),
      const StoryQuestion(
        question: 'Pourquoi 两斤 et non 二斤 ?',
        options: [
          '二 est incorrect en chinois',
          '两 s\'emploie devant un classificateur',
          'Les deux se disent également',
        ],
        answerIndex: 1,
        explanation:
            '二 pour compter et lire les nombres, 两 pour quantifier devant un classificateur.',
      ),
      const StoryQuestion(
        question: 'Que veut dire 一共 ?',
        options: ['Ensemble, avec quelqu\'un', 'Au total', 'Encore une fois'],
        answerIndex: 1,
        explanation: 'C\'est le mot du total, à la caisse.',
      ),
    ],
  ),
  Story(
    id: 'zh-story-huishuo',
    languageCode: 'zh',
    title: '你会说中文吗？',
    titleNative: 'Tu parles chinois ?',
    blurb:
        'La conversation qu\'on te fera systématiquement. Elle suit un rituel '
        'précis — compliment, refus modeste, question sur la durée.',
    level: StoryLevel.first,
    takeaway:
        'Au compliment 你的中文说得真好, on ne répond pas 谢谢 mais 哪里哪里. '
        'Accepter un compliment frontalement passe pour de la vanité.',
    lines: [
      _l('[你|tu|nǐ][会|sais|huì][说|parler|shuō][中文|chinois|Zhōngwén][吗|(question)|ma]？',
          speaker: 'A',
          native: 'Tu sais parler chinois ?',
          romanization: 'Nǐ huì shuō Zhōngwén ma?',
          note:
              '会 = savoir faire, compétence apprise. 能 dirait « être en mesure de », 可以 « avoir la permission ».'),
      _l('[会|oui, un peu|huì][一点点|un tout petit peu|yìdiǎndiǎn]。',
          speaker: 'B',
          native: 'Un tout petit peu.',
          romanization: 'Huì yìdiǎndiǎn.',
          note:
              'Il n\'y a pas de mot pour « oui » en chinois : on répond en répétant le verbe de la question.'),
      _l('[你的|ton|nǐ de][中文|chinois|Zhōngwén][说得|se parle|shuō de][真|vraiment|zhēn][好|bien|hǎo]！',
          speaker: 'A',
          native: 'Tu parles vraiment bien chinois !',
          romanization: 'Nǐ de Zhōngwén shuō de zhēn hǎo!',
          note:
              '得 relie le verbe à l\'appréciation de la manière : 说得好 = parler d\'une façon qui est bonne.'),
      _l('[哪里哪里|mais non, voyons|nǎli nǎli]，[还|encore|hái][差得远|loin du compte|chà de yuǎn][呢|(adoucissant)|ne]。',
          speaker: 'B',
          native: 'Mais non, je suis encore loin du compte.',
          romanization: 'Nǎli nǎli, hái chà de yuǎn ne.'),
      _l('[你|tu|nǐ][学了|as étudié|xué le][多久|combien de temps|duō jiǔ][了|(depuis)|le]？',
          speaker: 'A',
          native: 'Tu apprends depuis combien de temps ?',
          romanization: 'Nǐ xué le duō jiǔ le?',
          note:
              'Le double 了 marque une action commencée dans le passé et toujours en cours — l\'équivalent de « depuis ».'),
      _l('[学了|j\'étudie depuis|xué le][两年了|deux ans|liǎng nián le]，[但是|mais|dànshì][还是|toujours|háishi][听不懂|je ne comprends pas|tīng bu dǒng][快的|ce qui est rapide|kuài de]。',
          speaker: 'B',
          native:
              'Ça fait deux ans, mais je ne comprends toujours pas quand ça va vite.',
          romanization: 'Xué le liǎng nián le, dànshì háishi tīng bu dǒng kuài de.',
          note:
              '听不懂 : « écouter sans parvenir à comprendre ». Le 不 inséré au milieu marque l\'impossibilité, pas la négation simple.'),
      _l('[慢慢来|prends ton temps|mànman lái]，[别|ne… pas|bié][着急|t\'inquiéter|zháojí]。',
          speaker: 'A',
          native: 'Prends ton temps, ne t\'en fais pas.',
          romanization: 'Mànman lái, bié zháojí.'),
      _l('[你|tu|nǐ][能|peux|néng][说|parler|shuō][慢|lentement|màn][一点|un peu|yìdiǎn][吗|(question)|ma]？',
          speaker: 'B',
          native: 'Tu peux parler un peu plus lentement ?',
          romanization: 'Nǐ néng shuō màn yìdiǎn ma?',
          note:
              'La phrase la plus rentable de toute la langue. À apprendre avant le vocabulaire.'),
      _l('[当然|bien sûr|dāngrán][可以|d\'accord|kěyǐ]。[我|je|wǒ][说得|parle|shuō de][太|trop|tài][快|vite|kuài][了|(particule)|le]。',
          speaker: 'A',
          native: 'Bien sûr. Je parle trop vite.',
          romanization: 'Dāngrán kěyǐ. Wǒ shuō de tài kuài le.'),
      _l('[谢谢|merci pour|xièxie][你的|ta|nǐ de][耐心|patience|nàixīn]。',
          speaker: 'B',
          native: 'Merci pour ta patience.',
          romanization: 'Xièxie nǐ de nàixīn.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Comment B répond-il au compliment ?',
        options: ['谢谢', '哪里哪里', '当然'],
        answerIndex: 1,
        explanation:
            '哪里哪里 : la déflexion modeste attendue. 谢谢 sonnerait présomptueux.',
      ),
      const StoryQuestion(
        question: 'Que signifie 听不懂 ?',
        options: [
          'Je n\'écoute pas',
          'Je n\'arrive pas à comprendre ce que j\'entends',
          'Je n\'entends rien',
        ],
        answerIndex: 1,
        explanation:
            'Complément potentiel négatif : l\'écoute a lieu, la compréhension n\'aboutit pas.',
      ),
      const StoryQuestion(
        question: 'Depuis combien de temps B apprend-il ?',
        options: ['Un an', 'Deux ans', 'Trois ans'],
        answerIndex: 1,
        explanation: '学了两年了.',
      ),
    ],
  ),
  Story(
    id: 'zh-story-kanfangzi',
    languageCode: 'zh',
    title: '看房子',
    titleNative: 'Visiter un appartement',
    blurb:
        'Un dialogue pour louer un appartement : le prix, les charges, la '
        'caution — le vocabulaire pratique dont personne ne parle en '
        'cours.',
    level: StoryLevel.first,
    takeaway:
        '押一付三 (une caution, trois mois payés d\'avance) est la formule '
        'de location la plus courante en Chine — la retenir évite bien des '
        'surprises au moment de signer.',
    lines: [
      _l('[你好|bonjour|nǐhǎo]，[你|vous|nǐ][是|êtes|shì][来|venu|lái][看|voir|kàn][房子|l\'appartement|fángzi][的|(lien)|de][吗|(question)|ma]？',
          speaker: '房东 · le propriétaire',
          native: 'Bonjour, vous venez pour visiter l\'appartement ?',
          romanization: 'Nǐhǎo, nǐ shì lái kàn fángzi de ma?'),
      _l('[是的|oui|shìde]，[这套|cet|zhè tào][房子|appartement|fángzi][多少钱|combien|duōshao qián][一个月|par mois|yí ge yuè]？',
          speaker: '租客 · le locataire',
          native: 'Oui, cet appartement coûte combien par mois ?',
          romanization: 'Shìde, zhè tào fángzi duōshao qián yí ge yuè?',
          note: '套 (tào) est le classificateur pour un logement complet, '
              'contrairement à 个 qui sert pour la plupart des autres '
              'objets.'),
      _l('[三千五|trois mille cinq cents|sānqiān wǔ][一个月|par mois|yí ge yuè]，[押一付三|une caution, trois mois d\'avance|yā yī fù sān]。',
          speaker: '房东 · le propriétaire',
          native: 'Trois mille cinq par mois, une caution et trois mois '
              'payés d\'avance.',
          romanization: 'Sānqiān wǔ yí ge yuè, yā yī fù sān.',
          note: '押一付三 est la formule standard de location en Chine : '
              'un mois de caution (押一), puis trois mois payés d\'avance '
              '(付三). La retenir mot pour mot évite les mauvaises '
              'surprises.'),
      _l('[包括|est-ce que ça inclut|bāokuò][水电费|eau et électricité|shuǐdiànfèi][吗|(question)|ma]？',
          speaker: '租客 · le locataire',
          native: 'Est-ce que ça inclut l\'eau et l\'électricité ?',
          romanization: 'Bāokuò shuǐdiànfèi ma?'),
      _l('[不|ne pas|bù][包括|inclure|bāokuò]，[水电费|eau et électricité|shuǐdiànfèi][自己|soi-même|zìjǐ][付|payer|fù]。',
          speaker: '房东 · le propriétaire',
          native: 'Non, l\'eau et l\'électricité sont à votre charge.',
          romanization: 'Bù bāokuò, shuǐdiànfèi zìjǐ fù.'),
      _l('[这|ici|zhè][附近|à proximité|fùjìn][有|y a-t-il|yǒu][地铁站|une station de métro|dìtiězhàn][吗|(question)|ma]？',
          speaker: '租客 · le locataire',
          native: 'Y a-t-il une station de métro à proximité ?',
          romanization: 'Zhè fùjìn yǒu dìtiězhàn ma?'),
      _l('[有|oui, il y a|yǒu]，[走路|à pied|zǒulù][五|cinq|wǔ][分钟|minutes|fēnzhōng][就|déjà|jiù][到|arriver|dào]。',
          speaker: '房东 · le propriétaire',
          native: 'Oui, cinq minutes à pied suffisent.',
          romanization: 'Yǒu, zǒulù wǔ fēnzhōng jiù dào.',
          note: '就 devant le verbe souligne la rapidité ou la facilité de '
              'l\'action : « il suffit de... et c\'est déjà fait ».'),
      _l('[可以|peut-on|kěyǐ][养|garder|yǎng][宠物|un animal|chǒngwù][吗|(question)|ma]？',
          speaker: '租客 · le locataire',
          native: 'Peut-on avoir un animal de compagnie ?',
          romanization: 'Kěyǐ yǎng chǒngwù ma?'),
      _l('[可以|oui|kěyǐ]，[但是|mais|dànshì][不能|ne peut pas|bù néng][养|garder|yǎng][狗|un chien|gǒu]。',
          speaker: '房东 · le propriétaire',
          native: 'Oui, mais pas de chien.',
          romanization: 'Kěyǐ, dànshì bù néng yǎng gǒu.'),
      _l('[好的|d\'accord|hǎode]，[我|je|wǒ][考虑|réfléchir|kǎolǜ][一下|un peu|yíxià]，[谢谢|merci|xièxie]。',
          speaker: '租客 · le locataire',
          native: 'D\'accord, je vais réfléchir un peu, merci.',
          romanization: 'Hǎode, wǒ kǎolǜ yíxià, xièxie.',
          note: '动词 + 一下 adoucit l\'action : 考虑一下 (réfléchir un peu) '
              'sonne moins engageant que 考虑 tout seul.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Que veut dire 押一付三 ?',
        options: [
          'Une caution et trois mois payés d\'avance',
          'Le loyer augmente de trois pour cent chaque année',
          'Il faut rester au moins trois ans',
        ],
        answerIndex: 0,
        explanation: '押一 (un mois de caution) 付三 (trois mois d\'avance).',
      ),
      const StoryQuestion(
        question: 'L\'eau et l\'électricité sont-elles incluses dans le loyer ?',
        options: ['Oui', 'Non, à la charge du locataire', 'Seulement l\'eau'],
        answerIndex: 1,
        explanation: '不包括，水电费自己付。',
      ),
      const StoryQuestion(
        question: 'Quelle condition pose le propriétaire pour les animaux ?',
        options: [
          'Aucun animal n\'est autorisé',
          'Les animaux sont autorisés, sauf les chiens',
          'Seuls les chiens sont autorisés',
        ],
        answerIndex: 1,
        explanation: '可以，但是不能养狗。',
      ),
    ],
  ),
  Story(
    id: 'zh-story-erduo',
    languageCode: 'zh',
    title: '我的耳朵变了',
    titleNative: 'Mes oreilles ont changé',
    blurb:
        'Un texte narratif, plus long, sur le moment exact où l\'écoute bascule. '
        'Beaucoup de structures utiles en dix lignes.',
    level: StoryLevel.building,
    takeaway:
        'Le chinois ne devient pas plus simple : c\'est l\'oreille qui change. '
        'Ce texte le dit, et te le fait vivre — tu viens de lire dix lignes '
        'sans traduction.',
    lines: [
      _l('[我|je|wǒ][学|apprendre|xué][中文|chinois|Zhōngwén][的|(lien)|de][第一年|la première année|dì-yī nián]，[什么都|absolument rien|shénme dōu][听不懂|je ne comprenais|tīng bu dǒng]。',
          native:
              'La première année où j\'ai appris le chinois, je ne comprenais absolument rien.',
          romanization: 'Wǒ xué Zhōngwén de dì-yī nián, shénme dōu tīng bu dǒng.',
          note:
              '什么都 + négation = « rien du tout ». Le 都 est obligatoire : il balaye toutes les possibilités.'),
      _l('[老师|le professeur|lǎoshī][说话|parlait|shuōhuà][的时候|quand|de shíhou]，[我|je|wǒ][只|seulement|zhǐ][听见|entendais|tīngjiàn][声音|des sons|shēngyīn]，[听不见|je n\'entendais pas|tīng bu jiàn][词|les mots|cí]。',
          native:
              'Quand le professeur parlait, je n\'entendais que des sons, pas des mots.',
          romanization:
              'Lǎoshī shuōhuà de shíhou, wǒ zhǐ tīngjiàn shēngyīn, tīng bu jiàn cí.',
          note:
              '…的时候 se place APRÈS la proposition, à l\'inverse du français « quand… ».'),
      _l('[我|je|wǒ][每天|chaque jour|měitiān][背|apprenais par cœur|bèi][五十|cinquante|wǔshí][个|(classificateur)|ge][词|mots|cí]，[第二天|le lendemain|dì-èr tiān][忘记|j\'en oubliais|wàngjì][四十|quarante|sìshí][个|(classificateur)|ge]。',
          native:
              'J\'apprenais cinquante mots par jour, et le lendemain j\'en oubliais quarante.',
          romanization:
              'Wǒ měitiān bèi wǔshí ge cí, dì-èr tiān wàngjì sìshí ge.'),
      _l('[有一次|une fois|yǒu yí cì]，[我|je|wǒ][在|dans|zài][地铁上|le métro|dìtiě shang][听见|j\'ai entendu|tīngjiàn][两个人|deux personnes|liǎng ge rén][说话|parler|shuōhuà]。',
          native: 'Une fois, dans le métro, j\'ai entendu deux personnes parler.',
          romanization: 'Yǒu yí cì, wǒ zài dìtiě shang tīngjiàn liǎng ge rén shuōhuà.'),
      _l('[我|je|wǒ][突然|soudain|tūrán][听懂了|j\'ai compris|tīngdǒng le][一句|une phrase|yí jù]：「[他|il|tā][还没|pas encore|hái méi][到|arrivé|dào]。」',
          native: 'Soudain, j\'ai compris une phrase : « Il n\'est pas encore arrivé. »',
          romanization: 'Wǒ tūrán tīngdǒng le yí jù: "Tā hái méi dào."',
          note:
              '听懂了 est le pendant positif de 听不懂 : cette fois la compréhension aboutit.'),
      _l('[就|seulement|jiù][这|cette|zhè][一句|phrase-là|yí jù]。',
          native: 'Cette phrase-là, et rien d\'autre.',
          romanization: 'Jiù zhè yí jù.'),
      _l('[但是|mais|dànshì][那天|ce jour-là|nà tiān]，[我|je|wǒ][坐过了|j\'ai raté (mon arrêt)|zuò guò le][三个|trois|sān ge][站|stations|zhàn]。',
          native: 'Mais ce jour-là, j\'ai raté trois stations.',
          romanization: 'Dànshì nà tiān, wǒ zuò guò le sān ge zhàn.',
          note:
              '过 après le verbe signale ici qu\'on a dépassé quelque chose : 坐过站 = rater son arrêt en restant assis.'),
      _l('[因为|parce que|yīnwèi][我|je|wǒ][一直|sans arrêt|yìzhí][在|en train de|zài][听|écouter|tīng]。',
          native: 'Parce que je n\'arrêtais pas d\'écouter.',
          romanization: 'Yīnwèi wǒ yìzhí zài tīng.'),
      _l('[中文|le chinois|Zhōngwén][没有|n\'a pas|méiyǒu][变|devenu|biàn][简单|plus simple|jiǎndān]。',
          native: 'Le chinois n\'est pas devenu plus simple.',
          romanization: 'Zhōngwén méiyǒu biàn jiǎndān.'),
      _l('[是|c\'est|shì][我的|mes|wǒ de][耳朵|oreilles|ěrduo][变了|qui ont changé|biàn le]。',
          native: 'Ce sont mes oreilles qui ont changé.',
          romanization: 'Shì wǒ de ěrduo biàn le.',
          note:
              '是…了 met en relief : c\'est bien X, et pas autre chose, qui a changé.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Qu\'entendait le narrateur la première année ?',
        options: ['Des mots isolés', 'Des sons, mais pas des mots', 'Rien du tout'],
        answerIndex: 1,
        explanation: '只听见声音，听不见词.',
      ),
      const StoryQuestion(
        question: 'Pourquoi a-t-il raté trois stations ?',
        options: [
          'Il s\'est endormi',
          'Il écoutait la conversation sans s\'arrêter',
          'Il s\'était trompé de ligne',
        ],
        answerIndex: 1,
        explanation: '因为我一直在听.',
      ),
      const StoryQuestion(
        question: 'Quelle est la conclusion du texte ?',
        options: [
          'Le chinois devient plus facile avec le temps',
          'Il faut apprendre cinquante mots par jour',
          'C\'est l\'oreille du narrateur qui a changé, pas la langue',
        ],
        answerIndex: 2,
        explanation: '中文没有变简单。是我的耳朵变了。',
      ),
    ],
  ),
];
