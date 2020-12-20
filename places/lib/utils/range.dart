class Range<T> {
  const Range(this.start, this.end);

  final T start;
  final T end;


  @override
  String toString() => '[$start .. $end]';
}