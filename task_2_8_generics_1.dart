// Задание 1
// Написать класс с методом, приводящим полученное значение в строку.

class A {
  String valueToString<T>(T value) => '$value $T';
}

void main() {
  final a = A();

  print(a.valueToString(123));
  print(a.valueToString('abc'));
  print(a.valueToString<int>(123));
  print(a.valueToString<String>('abc'));
}
