import 'package:learning_app/data/models/story.dart';

const _lex = {
  'bir': 'un, une',
  've': 'et',
  'ama': 'mais',
  'çok': 'très, beaucoup',
  'az': 'peu',
  'daha': 'encore, plus',
  'ne': 'quoi',
  'mi': '(particule de question)',
  'mı': '(particule de question)',
  'mu': '(particule de question)',
  'değil': 'ne… pas (avec un nom, un adjectif)',
  'için': 'pour',
  'ile': 'avec',
  'de': 'aussi',
  'da': 'aussi',
  'o': 'il, elle, ça',
  'ben': 'je',
  'sen': 'tu',
  'biz': 'nous',
  'siz': 'vous',
  'bu': 'ce, ceci',
  'şu': 'celui-là',
  'var': 'il y a',
  'yok': 'il n\'y a pas',
  'evet': 'oui',
  'hayır': 'non',
  'lütfen': 's\'il vous plaît',
  'iyi': 'bon, bien',
  'güzel': 'beau, joli',
  'zor': 'difficile',
  'kolay': 'facile',
  'şimdi': 'maintenant',
  'yarın': 'demain',
  'bugün': 'aujourd\'hui',
};

StoryLine _l(
  String source, {
  required String native,
  String? speaker,
  String? note,
}) =>
    StoryLine.parse(source,
        native: native, speaker: speaker, note: note, lexicon: _lex);

final storiesTr = <Story>[
  Story(
    id: 'tr-story-cay',
    languageCode: 'tr',
    title: 'Bizden olsun',
    titleNative: 'C\'est offert',
    blurb:
        'Un dialogue de dix lignes autour d\'un thé. Il contient le rituel '
        'd\'accueil turc au complet, formules de réponse comprises.',
    level: StoryLevel.first,
    takeaway:
        'Le turc fonctionne par paires rituelles : à « hoş geldiniz » on '
        'répond « hoş bulduk ». Connaître la réponse compte autant que '
        'connaître la formule.',
    lines: [
      _l('[Hoş geldiniz|Soyez le bienvenu]! [Buyurun|Je vous en prie].',
          speaker: 'Çaycı',
          native: 'Bienvenue ! Je vous en prie.',
          note:
              '« Buyurun » n\'a pas d\'équivalent unique : je vous en prie, tenez, entrez, allez-y. Le contexte fait le sens.'),
      _l('[Hoş bulduk|Nous avons trouvé bon accueil]. Bir [çay|thé] [alabilir miyim|puis-je avoir]?',
          speaker: 'Müşteri',
          native: 'Merci de l\'accueil. Puis-je avoir un thé ?',
          note:
              'La réponse à « hoş geldiniz » est fixe. Ne pas la connaître se remarque immédiatement.'),
      _l('[Tabii|Bien sûr]. [Şekerli mi|Avec du sucre]?',
          speaker: 'Çaycı', native: 'Bien sûr. Avec du sucre ?'),
      _l('[Az şekerli|Peu sucré], lütfen.',
          speaker: 'Müşteri',
          native: 'Peu sucré, s\'il vous plaît.',
          note:
              'Le suffixe -li signifie « pourvu de » : şeker (sucre) → şekerli (sucré).'),
      _l('Buyurun, [çayınız|votre thé].',
          speaker: 'Çaycı', native: 'Voilà, votre thé.'),
      _l('Çok [teşekkür ederim|merci]. [Ne kadar|Combien]?',
          speaker: 'Müşteri', native: 'Merci beaucoup. Combien ça fait ?'),
      _l('[Bizden olsun|Que ce soit de notre part].',
          speaker: 'Çaycı',
          native: 'C\'est offert.',
          note:
              'Littéralement « que ce soit de nous ». La façon standard d\'offrir quelque chose.'),
      _l('[Olmaz|Ce n\'est pas possible], çok [ayıp|gênant].',
          speaker: 'Müşteri', native: 'Non, ce serait vraiment gênant.'),
      _l('[Israr etmeyin|N\'insistez pas]. [İlk defa|La première fois] [geldiniz|vous êtes venu].',
          speaker: 'Çaycı',
          native: 'N\'insistez pas. C\'est la première fois que vous venez.'),
      _l('[O zaman|Alors] yarın [yine|encore] [gelirim|je reviendrai].',
          speaker: 'Müşteri',
          native: 'Alors je reviendrai demain.',
          note:
              'Le présent large en -ir sert aux intentions et aux habitudes : gelirim = je viens / je viendrai.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Que répond-on à « hoş geldiniz » ?',
        options: ['Teşekkürler', 'Hoş bulduk', 'Buyurun'],
        answerIndex: 1,
        explanation: 'C\'est une paire figée, la réponse ne varie pas.',
      ),
      const StoryQuestion(
        question: 'Le client paie-t-il son thé ?',
        options: ['Oui', 'Non, il est offert', 'Il paie la moitié'],
        answerIndex: 1,
        explanation: '« Bizden olsun » = c\'est offert.',
      ),
    ],
  ),
  Story(
    id: 'tr-story-nerelisin',
    languageCode: 'tr',
    title: 'Nerelisin?',
    titleNative: 'Tu viens d\'où ?',
    blurb:
        'Court, mais il contient les trois questions qu\'on te posera '
        'systématiquement — et les suffixes qui les portent.',
    level: StoryLevel.first,
    takeaway:
        'Le turc empile les suffixes là où le français ajoute des mots : '
        'Fransa-dan = de France, altı ay-dır = depuis six mois.',
    lines: [
      _l('[Merhaba|Bonjour]. [Türkçen|Ton turc] çok güzel.',
          speaker: 'Deniz', native: 'Bonjour. Ton turc est très bon.'),
      _l('[Teşekkürler|Merci], [daha yeni|tout juste] [başladım|j\'ai commencé].',
          speaker: 'Claire', native: 'Merci, je viens tout juste de commencer.'),
      _l('[Nerelisin|Tu viens d\'où]?',
          speaker: 'Deniz',
          native: 'Tu viens d\'où ?',
          note:
              'nere (où) + -li (originaire de) + -sin (tu). Un seul mot pour toute la question.'),
      _l('[Fransa\'dan|De France] [geliyorum|je viens].',
          speaker: 'Claire',
          native: 'Je viens de France.',
          note:
              'Le suffixe ablatif -dan/-den marque la provenance. L\'apostrophe sépare le nom propre du suffixe.'),
      _l('[Ne kadar zamandır|Depuis combien de temps] [buradasın|es-tu ici]?',
          speaker: 'Deniz', native: 'Tu es ici depuis combien de temps ?'),
      _l('[Altı aydır|Depuis six mois] [buradayım|je suis ici].',
          speaker: 'Claire',
          native: 'Je suis ici depuis six mois.',
          note:
              '-dır sur une durée donne « depuis ». Pas de préposition séparée, contrairement au français.'),
      _l('[Türkçe|Le turc] zor mu?',
          speaker: 'Deniz', native: 'Le turc est difficile ?'),
      _l('Zor değil, ama [farklı|différent].',
          speaker: 'Claire', native: 'Pas difficile, mais différent.'),
      _l('[Alışırsın|Tu t\'y habitueras].',
          speaker: 'Deniz',
          native: 'Tu t\'y habitueras.',
          note:
              'alışmak (s\'habituer) au présent large : le temps de ce qui est vrai en général ou promis.'),
    ],
    questions: [
      const StoryQuestion(
        question: 'Depuis combien de temps Claire est-elle en Turquie ?',
        options: ['Six semaines', 'Six mois', 'Six ans'],
        answerIndex: 1,
        explanation: '« Altı aydır » — ay = mois.',
      ),
      const StoryQuestion(
        question: 'Que porte le suffixe -dan dans « Fransa\'dan » ?',
        options: ['La destination', 'La provenance', 'La possession'],
        answerIndex: 1,
        explanation: 'Ablatif : le point de départ.',
      ),
    ],
  ),
];
