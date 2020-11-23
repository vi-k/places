// Задание 1
// Создайте текстовую переменную a = ‘hello world’; Напишите функцию, без
// возвращаемого значения. Функция меняет порядок слов на обратный. Например
// было ‘hello world’, стало ‘world hello’.

void reverse(String a) {
  print(a.split(' ').reversed.join(' '));
}

void main() {
  const a = 'hello world';

  reverse(a);
}