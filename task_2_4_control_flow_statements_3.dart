import 'dart:io';

void main() {
  // Задание 2
  // Написать программу, которая слушает ввод в консоли, складывает вводимые
  // пользователем числа. Если пользователь ввел stop, завершить приложение.
  // Если пользователь вводит некорректные данные - прервать текущую итерацию,
  // начать заново.

  num sum = 0;

  while (true) {
    print('Введите число:');

    final input = stdin.readLineSync();
    if (input == 'stop') break;

    final n = num.tryParse(input);
    if (n == null) {
      print('--------------');
      sum = 0;
      continue;
    }

    sum += n;
    print('Сумма: $sum');
  }
}
