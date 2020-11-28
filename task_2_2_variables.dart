// Задание 1

// 1. Создать глобальную переменную типа int с именем a;
int a = 1;

void main() {
  // 2. Создать локальную переменную типа double с именем b;
  // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
  double b = 1; // или double b;

  // 3. Создать строковую переменную с именем text при помощи var, попытаться
  // присвоить значение переменной a. Каков результат? (выведите его в консоль);
  //
  // ВОПРОС: Из задания видно, что надо переменной [a] присвоить значение
  // переменной [text], но в чате люди почему-то, как мне показалось, делали
  // наоборот. Ошибка в задании или люди неправильно поняли?
  var text = 'abc';
  text = a.toString();
  print(text);

  // 4. Создать целочисленную переменную с именем dyn при помощи dynamic,
  // попытаться присвоить переменной строковое значение переменной text. Каков
  // результат? (выведите его в консоль);
  dynamic dyn = 1;
  dyn = text;
  print(dyn); // abc

  // 5. Создать переменную с именем fin при помощи final и con при помощи const,
  // попытаться изменить переменные, посмотреть результат. В чем отличие final от const?
  final fin = [1, 2, 3];
  const con = [1, 2, 3];
  fin[0] = 999;
  print(fin);
  try {
    con[0] = 999;
  // ignore: avoid_catching_errors
  } on UnsupportedError catch (e) {
    print('Error: $e'); // Unsupported operation: Cannot modify an unmodifiable list
  }
}
