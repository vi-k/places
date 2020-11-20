void main() {
  // Задание 5
  // Вывести на экран количество уникальных слов в тексте.
  // “She sells sea shells on the sea shore
  // The shells that she sells are sea shells I'm sure
  // So if she sells sea shells on the sea shore
  // I'm sure that the shells are sea shore shells”
  //
  // Догадайтесь, какой из стандартных типов в Dart помогает решить эту задачу самым лаконичным образом (он упоминается в теоретическом блоке урока). 

  const text = '''
She sells sea shells on the sea shore
The shells that she sells are sea shells I'm sure
So if she sells sea shells on the sea shore
I'm sure that the shells are sea shore shells''';
  print(text);
  print(text.toLowerCase().split(RegExp(r"[^\w']+")).toSet().length); // Если I'm считать за одно слово
  print(text.toLowerCase().split(RegExp(r'\W+')).toSet().length); // Если считать I'm за два слова, хотя тут уже не так всё просто
}
