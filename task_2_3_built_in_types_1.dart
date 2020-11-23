import 'dart:math';

class Parent {}
class Child extends Parent {}

void main() {
  // Задание 1
  // Создайте целочисленную переменную с именем a проверить является ли число
  // четным.
  final a = Random().nextInt(1000);
  print('$a is ${a.isEven ? 'even' : 'odd'}');

  final child = Child();
  print(child is Parent);
  print(child.runtimeType == Parent);
}
