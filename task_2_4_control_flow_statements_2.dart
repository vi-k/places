void main() {
  // Задание 2
  // Используя циклы, напишите программу, которая выводит на консоль все четные
  // числа от 0 до 100.
  print('for');
  for (var i = 0; i <= 100; i += 2) {
    print(i);
  }

  print('\nwhile');
  var i = 0;
  while (i <= 100) {
    print(i);
    i += 2;
  }

  print('\ndo .. while');
  i = 0;
  do {
    print(i);
    i += 2;
  } while (i <= 100);

  print('\nfor .. in');
  for (final index in Iterable<int>.generate(101)) {
    if (index.isEven) print(index);
  }

  print('\nforEach');
  Iterable<int>.generate(101).where((element) => element.isEven).forEach(print);
}
