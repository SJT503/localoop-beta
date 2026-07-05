class SupportedLocale {
  const SupportedLocale({required this.code, required this.label});

  final String code;
  final String label;
}

const supportedLocales = <SupportedLocale>[
  SupportedLocale(code: 'en', label: 'English'),
  SupportedLocale(code: 'zh', label: '中文'),
  SupportedLocale(code: 'ja', label: '日本語'),
  SupportedLocale(code: 'ko', label: '한국어'),
  SupportedLocale(code: 'fr', label: 'Français'),
  SupportedLocale(code: 'de', label: 'Deutsch'),
  SupportedLocale(code: 'es', label: 'Español'),
  SupportedLocale(code: 'pt', label: 'Português'),
];

String normalizeLocaleCode(String? code) {
  final raw = (code ?? 'en').toLowerCase();
  for (final locale in supportedLocales) {
    if (raw == locale.code || raw.startsWith('${locale.code}_')) {
      return locale.code;
    }
  }
  return 'en';
}
