import 'dart:math';

void main() {
  // Задание 1
  // Создайте целочисленную переменную с именем a проверить является ли число
  // четным.
  final a = Random().nextInt(1000);
  print('$a is ${a % 2 == 0 ? 'even' : 'odd'}');
  print('$a is ${a & 1 == 0 ? 'even' : 'odd'}');
}
