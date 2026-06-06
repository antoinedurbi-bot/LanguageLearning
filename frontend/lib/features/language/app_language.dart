class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.description,
    required this.samplePrompt,
  });

  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String description;
  final String samplePrompt;
}

const availableLanguages = [
  AppLanguage(
    code: 'en',
    name: 'Anglais',
    nativeName: 'English',
    flag: 'GB',
    description: 'Voyage, travail et conversations du quotidien.',
    samplePrompt: 'Traduis: Je voudrais un cafe, s\'il vous plait.',
  ),
  AppLanguage(
    code: 'zh',
    name: 'Chinois',
    nativeName: 'Mandarin',
    flag: 'CN',
    description: 'Bases utiles, tons simples et phrases courtes.',
    samplePrompt: 'Traduis: Bonjour, merci beaucoup.',
  ),
  AppLanguage(
    code: 'es',
    name: 'Espagnol',
    nativeName: 'Español',
    flag: 'ES',
    description: 'Salutations, cafe, voyage et vie quotidienne.',
    samplePrompt: 'Traduis: Bonjour, comment vas-tu ?',
  ),
  AppLanguage(
    code: 'tr',
    name: 'Turc',
    nativeName: 'Türkçe',
    flag: 'TR',
    description: 'Premieres phrases, politesse et situations simples.',
    samplePrompt: 'Traduis: Je veux apprendre le turc.',
  ),
];

