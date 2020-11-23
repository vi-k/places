// Задание 3
// Модернизируйте предыдущие функции так, чтобы на вход они принимали
// необходимые данные для работы. Параметр должен быть опциональным.

import 'dart:math';

void main() {
  String reverse([String a = '']) => a.split(' ').reversed.join(' ');

  double avg([List<num> list]) => list == null
      ? null
      : list.fold<double>(0, (prev, element) => prev + element) / list.length;

  const a = 'hello world';
  print('$a -> ${reverse(a)}');

  final list = List<num>.generate(
      Random().nextInt(10), (index) => Random().nextInt(100));
  print('$list avg: ${avg(list)}');
}
