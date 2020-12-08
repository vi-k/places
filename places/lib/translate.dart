// Переводы
final Map<String, String> _translationMap = {
  'SightType.museum': 'музей',
  'SightType.theatre': 'театр',
  'SightType.memorial': 'памятник',
  'SightType.park': 'парк',
};

String translate(String code) =>
    _translationMap[code] ?? code.replaceAll(RegExp(r'.*\.'), '');
