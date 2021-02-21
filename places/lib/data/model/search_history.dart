/// Элемент истории поиска.
class SearchHistory {
  const SearchHistory({
    this.text = '',
    required this.timestamp,
    required this.count,
  });

  final String text;
  final DateTime timestamp;
  final int count;

  SearchHistory copyWith({String? text, DateTime? timestamp, int? count}) =>
      SearchHistory(
        text: text ?? this.text,
        timestamp: timestamp ?? this.timestamp,
        count: count ?? this.count,
      );
}
