// Переводы
final Map<String, String> _translationMap = {
  'SightType.museum': 'музей',
  'SightType.particular': 'особое место',
  'SightType.park': 'парк',
  'SightType.restaurant': 'ресторан',
  'SightType.cafe': 'кафе',
  'SightType.hotel': 'гостиница',
};

String translate(String code) =>
    _translationMap[code] ?? code.replaceFirst(RegExp(r'.*\.'), '');
