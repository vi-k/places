/// Запрос поиска.
class SearchRequest {
  const SearchRequest(
    this.text, {
    required this.timestamp,
    required this.count,
  });

  final String text;
  final DateTime timestamp;
  final int count;

  SearchRequest copyWith({String? text, DateTime? timestamp, int? count}) =>
      SearchRequest(
        text ?? this.text,
        timestamp: timestamp ?? this.timestamp,
        count: count ?? this.count,
      );

  @override
  String toString() => 'SearchHistory($text, time: $timestamp, count: $count)';
}
