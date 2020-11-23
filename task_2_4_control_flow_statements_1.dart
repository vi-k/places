import 'dart:io';

void main() {
  // Задание 1
  // Используя switch, напишите программу в методе main(), которая выводит
  // название месяца по номеру от 1 до 12.
  print('Введите номер месяца:');

  final input = stdin.readLineSync();
  final month = int.parse(input);

  switch (month) {
    case 1: print('Январь'); break;
    case 2: print('Февраль'); break;
    case 3: print('Март'); break;
    case 4: print('Апрель'); break;
    case 5: print('Май'); break;
    case 6: print('Июнь'); break;
    case 7: print('Июль'); break;
    case 8: print('Август'); break;
    case 9: print('Сентябрь'); break;
    case 10: print('Октябрь'); break;
    case 11: print('Ноябрь'); break;
    case 12: print('Декабрь'); break;
    default: print('Неверно указано номер месяца');
  }
}
