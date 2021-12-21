/// Расширения для DateTime.
extension Date on DateTime {
  static const int _millisecondsInDay = 86400000;

  DateTime dateOnly() =>
      isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

  static DateTime today() => DateTime.now().dateOnly();

  static DateTime yesterday() => DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().dateOnly().millisecondsSinceEpoch - _millisecondsInDay,
      );

  static DateTime tomorrow() => DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().dateOnly().millisecondsSinceEpoch + _millisecondsInDay,
      );
}
