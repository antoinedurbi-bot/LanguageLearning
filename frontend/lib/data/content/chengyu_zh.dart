import 'package:learning_app/data/models/chengyu.dart';

/// A curated set of well-known chéngyǔ, chosen for having a real, checkable
/// story rather than being an obscure literary reference — these are the
/// idioms an educated native speaker uses without thinking, and a Chinese
/// child meets in primary school.
const chengyuZh = <Chengyu>[
  Chengyu(
    id: 'cy-mamahuhu',
    characters: '马马虎虎',
    pinyin: 'mǎmǎhǔhǔ',
    literal: 'cheval cheval tigre tigre',
    meaning: 'Comme ci comme ça ; fait sans grand soin.',
    story: 'Un peintre dessinait un tigre quand on lui demanda un cheval : il '
        'ajouta juste des sabots a sa tete de tigre. Son fils, croyant voir '
        'un cheval, se fit tuer en chassant un vrai tigre avec cette '
        'confusion en tete — la legende punit severement la negligence.',
    usage: 'Tres courant a l\'oral, souvent sur soi-meme par modestie '
        '("mon chinois est mamahuhu") ou pour critiquer un travail bacle.',
    example: '他做事总是马马虎虎。',
    exampleNative: 'Il fait toujours les choses n\'importe comment.',
  ),
  Chengyu(
    id: 'cy-bantuerfei',
    characters: '半途而废',
    pinyin: 'bàntú\'érfèi',
    literal: 'a mi-chemin et abandonner',
    meaning: 'Abandonner en cours de route, ne pas aller jusqu\'au bout.',
    story: 'La mere du philosophe Yue Yangzi coupa le tissu qu\'elle etait '
        'en train de tisser pour lui montrer qu\'arreter ses etudes a '
        'mi-parcours detruisait tout le travail deja fait, comme un tissu '
        'inacheve.',
    usage: 'Reproche ou mise en garde, jamais un compliment. S\'emploie '
        'aussi bien pour un projet que pour une formation.',
    example: '学习不能半途而废。',
    exampleNative: 'On ne doit pas abandonner ses etudes a mi-chemin.',
  ),
  Chengyu(
    id: 'cy-huasheteinzu',
    characters: '画蛇添足',
    pinyin: 'huàshétiānzú',
    literal: 'dessiner un serpent et lui ajouter des pattes',
    meaning: 'En faire trop, gacher une chose reussie par un ajout inutile.',
    story: 'Des hommes se disputaient une jarre de vin, a gagner par celui '
        'qui dessinerait le plus vite un serpent. Le premier fini eut le '
        'temps de lui ajouter des pattes — et perdit : un serpent n\'a pas '
        'de pattes, son dessin n\'en etait plus un.',
    usage: 'Pour critiquer un ajout superflu qui gate un resultat deja bon.',
    example: '这个结尾是画蛇添足。',
    exampleNative: 'Cette fin est un ajout inutile qui gache le reste.',
  ),
  Chengyu(
    id: 'cy-shouzhudaitu',
    characters: '守株待兔',
    pinyin: 'shǒuzhūdàitù',
    literal: 'garder la souche et attendre le lievre',
    meaning: 'Compter sur la chance plutot que sur l\'effort.',
    story: 'Un paysan vit un lievre se briser le cou en heurtant une souche '
        'et l\'attrapa sans effort. Il abandonna alors sa charrue et '
        's\'assit pres de la souche a attendre le lievre suivant — qui ne '
        'vint jamais.',
    usage: 'Critique quelqu\'un qui n\'agit plus, esperant qu\'un coup de '
        'chance se repete.',
    example: '不能守株待兔，得主动去找机会。',
    exampleNative: 'On ne peut pas attendre la chance sans rien faire, il '
        'faut aller chercher les opportunites.',
  ),
  Chengyu(
    id: 'cy-jingdizhiwa',
    characters: '井底之蛙',
    pinyin: 'jǐngdǐzhīwā',
    literal: 'la grenouille au fond du puits',
    meaning: 'Quelqu\'un a la vision etroite, qui prend son petit monde pour '
        'le monde entier.',
    story: 'Une grenouille au fond d\'un puits croit que le morceau de ciel '
        'qu\'elle voit est tout le ciel, jusqu\'a ce qu\'une tortue de la '
        'mer de l\'Est lui decrive l\'ocean.',
    usage: 'Peut etre insultant en face a face ; s\'emploie plus souvent '
        'pour se decrire soi-meme avec humilite ("je ne suis qu\'une '
        'grenouille au fond du puits").',
    example: '别做井底之蛙，多出去看看世界。',
    exampleNative: 'Ne sois pas comme la grenouille au fond du puits, va '
        'voir le monde.',
  ),
  Chengyu(
    id: 'cy-yijuliangde',
    characters: '一举两得',
    pinyin: 'yījǔliǎngdé',
    literal: 'un geste, deux gains',
    meaning: 'Faire d\'une pierre deux coups.',
    story: 'Attribue a un conseiller des Royaumes combattants qui persuada '
        'son roi de laisser deux tigres se battre pour n\'avoir a en '
        'affronter qu\'un seul, epuise — obtenant ainsi deux victoires pour '
        'un seul effort.',
    usage: 'Neutre a positif, tres courant, sans connotation particuliere.',
    example: '骑车上班既省钱又锻炼身体，一举两得。',
    exampleNative: 'Aller au travail a velo economise de l\'argent et fait '
        'du sport, c\'est faire d\'une pierre deux coups.',
  ),
  Chengyu(
    id: 'cy-duiniutanqin',
    characters: '对牛弹琴',
    pinyin: 'duìniútánqín',
    literal: 'jouer du qin (cithare) face a un boeuf',
    meaning: 'Parler a quelqu\'un incapable de comprendre ; parler dans le '
        'vide.',
    story: 'Un musicien joua un morceau raffine devant un boeuf, qui '
        'continua simplement de paitre, indifferent a la beaute de la '
        'musique.',
    usage: 'Peut etre condescendant envers l\'auditeur ; s\'emploie aussi '
        'par autoderision pour dire qu\'on a mal choisi son public.',
    example: '跟他讲道理就是对牛弹琴。',
    exampleNative: 'Lui expliquer les choses raisonnablement, c\'est parler '
        'dans le vide.',
  ),
  Chengyu(
    id: 'cy-saiwengshima',
    characters: '塞翁失马',
    pinyin: 'sàiwēngshīmǎ',
    literal: 'le vieillard de la frontiere perd son cheval',
    meaning: 'A quelque chose malheur est bon ; on ne sait jamais si un '
        'evenement est une chance ou une malchance.',
    story: 'Le cheval d\'un vieil homme a la frontiere s\'enfuit — malchance, '
        'dirent ses voisins. Il revint avec un cheval sauvage — chance. Son '
        'fils se cassa la jambe en le montant — malchance. La guerre '
        'eclata et son fils, infirme, ne fut pas enrole — chance.',
    usage: 'Se dit pour relativiser un coup dur ("qui sait, 塞翁失马 焉知非 '
        '福") : souvent tronque en \'塞翁失马\' seul, la suite \'焉知非福\' '
        'etant sous-entendue.',
    example: '塞翁失马，焉知非福，这次失败也许是好事。',
    exampleNative: 'A quelque chose malheur est bon : cet echec est '
        'peut-etre une bonne chose.',
  ),
  Chengyu(
    id: 'cy-wangyangbulao',
    characters: '亡羊补牢',
    pinyin: 'wángyángbǔláo',
    literal: 'reparer l\'enclos apres la perte du mouton',
    meaning: 'Mieux vaut tard que jamais ; corriger une erreur des qu\'on la '
        'constate.',
    story: 'Un eleveur perdit un mouton par un trou dans son enclos. Un '
        'voisin lui conseilla de le reparer immediatement — ce qu\'il fit, '
        'evitant ainsi de nouvelles pertes.',
    usage: 'Toujours positif : encourage a agir maintenant plutot que de '
        'se lamenter sur l\'erreur passee.',
    example: '现在改正还不晚，亡羊补牢。',
    exampleNative: 'Il n\'est pas trop tard pour corriger, mieux vaut tard '
        'que jamais.',
  ),
  Chengyu(
    id: 'cy-hujiahuwei',
    characters: '狐假虎威',
    pinyin: 'hújiǎhǔwēi',
    literal: 'le renard emprunte la puissance du tigre',
    meaning: 'S\'appuyer sur le pouvoir d\'un autre pour intimider, sans '
        'avoir soi-meme d\'autorite reelle.',
    story: 'Attrape par un tigre, un renard pretendit etre le roi designe '
        'des animaux par le Ciel et defia le tigre de le suivre pour voir '
        'les autres fuir de peur — ce qu\'ils firent, mais par peur du '
        'tigre marchant juste derriere, non du renard.',
    usage: 'Toujours critique, pour designer quelqu\'un qui abuse de '
        'l\'autorite d\'un superieur ou d\'une institution.',
    example: '他不过是狐假虎威，仗着老板的权力吓唬人。',
    exampleNative: 'Il ne fait qu\'emprunter la puissance de son patron pour '
        'intimider les gens.',
  ),
  Chengyu(
    id: 'cy-yanerdaoling',
    characters: '掩耳盗铃',
    pinyin: 'yǎněrdàolíng',
    literal: 'se boucher les oreilles pour voler une cloche',
    meaning: 'Se mentir a soi-meme en ignorant une evidence que les autres '
        'voient tres bien.',
    story: 'Un voleur voulut emporter une cloche de bronze trop lourde a '
        'porter sans qu\'elle sonne ; il se boucha les oreilles, croyant '
        'ainsi que personne d\'autre ne l\'entendrait non plus.',
    usage: 'Critique pour une auto-tromperie flagrante et un peu ridicule.',
    example: '这种做法只是掩耳盗铃，问题并没有解决。',
    exampleNative: 'Cette methode ne fait que se voiler la face, le probleme '
        'n\'est pas resolu.',
  ),
  Chengyu(
    id: 'cy-kezhouqiujian',
    characters: '刻舟求剑',
    pinyin: 'kèzhōuqiújiàn',
    literal: 'graver le bateau pour chercher l\'epee',
    meaning: 'Rester rigidement fixe sur une methode perimee, en ignorant '
        'que la situation a change.',
    story: 'Un homme laissa tomber son epee de sa barque en mouvement. Il '
        'grava une marque sur le bord du bateau a l\'endroit ou elle etait '
        'tombee, pour la retrouver plus tard au meme endroit — sans '
        'comprendre que le bateau, lui, avait avance.',
    usage: 'Pour critiquer une approche mecanique qui ignore le contexte '
        'ayant change.',
    example: '市场变了，还用老办法就是刻舟求剑。',
    exampleNative: 'Le marche a change, continuer avec les vieilles methodes '
        'revient a chercher l\'epee la ou le bateau etait.',
  ),
  Chengyu(
    id: 'cy-hualongdianjing',
    characters: '画龙点睛',
    pinyin: 'huàlóngdiǎnjīng',
    literal: 'peindre le dragon et pointer les yeux',
    meaning: 'La touche finale qui rend une oeuvre vivante et acheve tout '
        'son sens.',
    story: 'Un peintre de la dynastie Liang avait peint quatre dragons sans '
        'leur donner de pupilles, disant qu\'ils s\'envoleraient s\'il le '
        'faisait. Force de le faire pour deux d\'entre eux, les dragons '
        'prirent vie et s\'envolerent dans le ciel dans un eclair.',
    usage: 'Toujours un compliment : designe le detail decisif qui rend un '
        'texte, un discours ou une oeuvre memorable.',
    example: '最后一句话是画龙点睛之笔。',
    exampleNative: 'La derniere phrase est la touche finale qui donne vie au '
        'texte.',
  ),
  Chengyu(
    id: 'cy-beigongsheying',
    characters: '杯弓蛇影',
    pinyin: 'bēigōngshéyǐng',
    literal: 'l\'ombre d\'un arc dans une coupe prise pour un serpent',
    meaning: 'Une peur imaginaire, née d\'un malentendu, qui empoisonne '
        'l\'esprit.',
    story: 'Un invite vit le reflet d\'un arc suspendu au mur dans sa coupe '
        'de vin et crut y voir un serpent. Il tomba malade d\'angoisse, '
        'jusqu\'a ce que son hote lui montre l\'arc et l\'explication.',
    usage: 'Pour decrire une inquietude excessive fondee sur un malentendu, '
        'une fois celui-ci dissipe.',
    example: '别杯弓蛇影了，其实没什么好担心的。',
    exampleNative: 'Ne te fais pas des frayeurs imaginaires, il n\'y a en '
        'fait rien a craindre.',
  ),
  Chengyu(
    id: 'cy-ruxiangsuisu',
    characters: '入乡随俗',
    pinyin: 'rùxiāngsuísú',
    literal: 'entrer au village, suivre ses coutumes',
    meaning: 'A Rome, faire comme les Romains ; s\'adapter aux usages '
        'locaux.',
    story: 'Deja cite sous cette forme dans des textes classiques comme '
        'principe de bon sens pour tout voyageur : chaque lieu a ses '
        'regles, et les respecter est la marque du savoir-vivre.',
    usage: 'Toujours positif, tres pratique pour un apprenant a l\'etranger '
        '— exactement la situation d\'un francophone en Chine.',
    example: '在中国吃饭要入乡随俗，学着用筷子。',
    exampleNative: 'En Chine, pour manger, il faut faire comme les locaux et '
        'apprendre a utiliser les baguettes.',
  ),
  Chengyu(
    id: 'cy-shunengshengqiao',
    characters: '熟能生巧',
    pinyin: 'shúnéngshēngqiǎo',
    literal: 'la maitrise fait naitre l\'habilete',
    meaning: 'C\'est en forgeant qu\'on devient forgeron ; la pratique rend '
        'expert.',
    story: 'Illustre par l\'anecdote d\'un archer imbattable qu\'un vendeur '
        'd\'huile remit a sa place en versant de l\'huile a travers le trou '
        'd\'une piece sans en toucher les bords — pas par don, dit-il, mais '
        'par habitude repetee.',
    usage: 'Encouragement tres courant, notamment pour motiver a continuer '
        'un entrainement qui semble lent.',
    example: '多练习汉字，熟能生巧。',
    exampleNative: 'Entraine-toi souvent aux caracteres, c\'est la pratique '
        'qui rend habile.',
  ),
  Chengyu(
    id: 'cy-zixiangmaodun',
    characters: '自相矛盾',
    pinyin: 'zìxiāngmáodùn',
    literal: 'lance et bouclier se contredisant eux-memes',
    meaning: 'Se contredire soi-meme.',
    story: 'Un marchand vantait sa lance capable de percer n\'importe quel '
        'bouclier, puis son bouclier capable d\'arreter n\'importe quelle '
        'lance. Un badaud lui demanda ce qui se passerait si l\'on '
        'utilisait sa lance contre son propre bouclier — il ne put '
        'repondre. C\'est aussi l\'origine du mot chinois pour '
        '"contradiction", 矛盾 (littéralement "lance-bouclier").',
    usage: 'S\'emploie pour pointer une incoherence dans un discours ou un '
        'argument.',
    example: '你的说法自相矛盾。',
    exampleNative: 'Ton propos se contredit lui-meme.',
  ),
  Chengyu(
    id: 'cy-wangmeizhike',
    characters: '望梅止渴',
    pinyin: 'wàngméizhǐkě',
    literal: 'regarder des prunes pour etancher sa soif',
    meaning: 'Se satisfaire d\'une consolation imaginaire plutot que de '
        'resoudre le probleme reel.',
    story: 'Le general Cao Cao, avec une armee epuisee de soif en marche, '
        'annonca qu\'une foret de pruniers acides se trouvait plus loin — '
        'l\'idee seule fit saliver les soldats et leur donna la force de '
        'continuer jusqu\'a un point d\'eau reel.',
    usage: 'Peut etre neutre (une astuce psychologique efficace) ou legerement '
        'critique (un faux-semblant qui ne resout rien de durable) selon le '
        'contexte.',
    example: '光想着未来的成功不能望梅止渴，还是要现在努力。',
    exampleNative: 'Se contenter de rever du succes futur ne suffit pas, il '
        'faut travailler des maintenant.',
  ),
  Chengyu(
    id: 'cy-woxinchangdan',
    characters: '卧薪尝胆',
    pinyin: 'wòxīnchángdǎn',
    literal: 'dormir sur des branchages, gouter le fiel',
    meaning: 'Endurer volontairement l\'inconfort pour rester motive et '
        'prendre sa revanche.',
    story: 'Vaincu et humilie, le roi Goujian de Yue dormit sur des '
        'branchages et gouta chaque jour un morceau de fiel amer pendant '
        'des annees pour ne jamais oublier sa defaite — jusqu\'a finalement '
        'vaincre son rival.',
    usage: 'Registre soutenu, plutot litteraire ou historique ; evoque une '
        'perseverance acharnee apres un echec cuisant.',
    example: '他卧薪尝胆十年，终于成功了。',
    exampleNative: 'Il a endure dix ans d\'efforts acharnes et a fini par '
        'reussir.',
  ),
  Chengyu(
    id: 'cy-pofuchenzhou',
    characters: '破釜沉舟',
    pinyin: 'pòfǔchénzhōu',
    literal: 'briser les marmites et couler les bateaux',
    meaning: 'Bruler ses vaisseaux ; s\'engager sans possibilite de retour '
        'en arriere.',
    story: 'Avant une bataille decisive, le general Xiang Yu fit briser '
        'toutes les marmites de cuisine et couler tous les bateaux de son '
        'armee, ne laissant a ses soldats d\'autre choix que la victoire.',
    usage: 'Positif et energique, pour decrire un engagement total sans '
        'retraite possible.',
    example: '这次考试他破釜沉舟，全力以赴。',
    exampleNative: 'Pour cet examen, il a brule ses vaisseaux et donne le '
        'maximum.',
  ),
  Chengyu(
    id: 'cy-qirenyoutian',
    characters: '杞人忧天',
    pinyin: 'qǐrényōutiān',
    literal: 'l\'homme de Qi s\'inquiete que le ciel tombe',
    meaning: 'S\'inquieter pour rien, d\'un danger imaginaire ou irrealiste.',
    story: 'Un homme du royaume de Qi ne dormait plus, obsede par la peur '
        'que le ciel lui tombe sur la tete et que la terre s\'effondre '
        'sous ses pieds.',
    usage: 'Un peu moqueur, pour une inquietude jugee excessive et sans '
        'fondement.',
    example: '别杞人忧天了，事情没那么严重。',
    exampleNative: 'Arrete de t\'inquieter pour rien, ce n\'est pas si '
        'grave.',
  ),
  Chengyu(
    id: 'cy-sanxinerhi',
    characters: '三心二意',
    pinyin: 'sānxīnèryì',
    literal: 'trois coeurs, deux intentions',
    meaning: 'Etre indecis, avoir l\'esprit ailleurs, manquer d\'engagement.',
    story: 'Image simple et ancienne de l\'esprit divise entre plusieurs '
        'envies contradictoires, incapable de se fixer sur une seule.',
    usage: 'Critique courant, souvent pour reprocher un manque de '
        'concentration ou de serieux dans un travail ou une relation.',
    example: '做事不要三心二意，要专心一点。',
    exampleNative: 'Ne fais pas les choses en dilettante, concentre-toi.',
  ),
  Chengyu(
    id: 'cy-banjinbaliang',
    characters: '半斤八两',
    pinyin: 'bànjīnbāliǎng',
    literal: 'une demi-livre, huit onces',
    meaning: 'Kif-kif, du pareil au meme.',
    story: 'Dans l\'ancien systeme de poids chinois, une livre (斤) valait '
        'seize onces (两) : une demi-livre et huit onces sont donc '
        'exactement la meme quantite, juste exprimee differemment.',
    usage: 'Pour dire que deux choses ou personnes qu\'on compare se valent '
        '— souvent avec une pointe d\'ironie quand aucune n\'est vraiment '
        'bonne.',
    example: '这两个方案半斤八两，都不太好。',
    exampleNative: 'Ces deux options se valent, aucune n\'est vraiment '
        'bonne.',
  ),
  Chengyu(
    id: 'cy-wuhuabamen',
    characters: '五花八门',
    pinyin: 'wǔhuābāmén',
    literal: 'cinq fleurs, huit portes',
    meaning: 'De toutes sortes, tres varie.',
    story: 'Le nom viendrait de deux formations tactiques anciennes aux '
        'multiples variantes — "cinq fleurs" et "huit portes" — devenues '
        'l\'image meme de la profusion et de la diversite.',
    usage: 'Neutre, tres frequent pour decrire un choix, un marche ou une '
        'offre riche et varie(e).',
    example: '市场上的手机五花八门，很难选择。',
    exampleNative: 'Il y a toutes sortes de telephones sur le marche, '
        'difficile de choisir.',
  ),
];
