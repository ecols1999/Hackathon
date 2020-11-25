class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "🇺🇸", "English", "en"),
      Language(2, "🇾🇪", "اَلْعَرَبِيَّةُ‎", "ar"),
      Language(3, "🇮🇷", "فارسی", "fa"),
      Language(4, "🇹🇷", "Türkçe", "tr"),
    ];
  }
}
