// Задание 2
// Пещера гоблинов
// Представьте, что разрабатывайте фентезийную игру.
// В игре есть гоблины и орки. Они спавнятся в пещерах.
// Создайте классы:
// Goblin
// Hobogoblin extends Goblin
// Orc
// Lair - пещера гоблинов, которая может вмещать в себя только гоблинов и наследников
// Создайте экземпляр класса Lair. В качестве типа поставьте гоблина, хогоблина и орка. Результат опишите в комментариях

class Goblin {}
class Hobogoblin extends Goblin {}
class Orc {}
class Lair<T extends Goblin> {}

void main() {
  // ignore: unused_local_variable
  final lair1 = Lair<Goblin>();
  // ignore: unused_local_variable
  final lair2 = Lair<Hobogoblin>();
  // final lair3 = Lair<Orc>(); // Type argument 'Orc' doesn't conform to the bound 'Goblin' of the type variable 'T' on 'Lair'
}
