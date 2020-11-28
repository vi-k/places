// Задание 2
// Создайте и проинициализируйте массив чисел с произвольным размером.
// Напишите функцию, которая вычисляет среднее арифметическое число массива
// и возвращает double результат. Распечатайте результат в консоли.

import 'dart:math';

double avg(List<num> list) =>
    list.fold<double>(0, (prev, element) => prev + element) / list.length;

void main() {
  final list = List<num>.generate(
      Random().nextInt(10), (index) => Random().nextInt(100));

  print(list);
  print(avg(list));
}
