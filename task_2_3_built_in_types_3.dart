void main() {
  // Задание 3

  // a. Создать список var list = [1,2,3,4,5,6,7,8];
  final list = [1, 2, 3, 4, 5, 6, 7, 8];

  // b. Вывести длину этого списка;
  print(list.length);

  // c. Вывести отсортированный список list в порядке убывания, используя sort;
  print(list..sort((a, b) => b - a));

  // d. Выделить подсписок newList при помощи sublist (взять первые 3 элемента
  // от исходного списка) и вывести на консоль;
  final newList = list.sublist(0, 3);
  print(newList);

  // e. Вывести индекс элемента со значением “5” в списке list;
  print(list.indexOf(5));

  // f. Удалить значения с 8 до 5 из списка list и вывести в консоль.
  list.removeWhere((element) => element <= 8 && element >= 5);
  print(list);
}
