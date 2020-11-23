// Задание 2.
// Велосипед

class Wheel {
  Wheel(this._name);

  final String _name;
  String get name => _name;

  void rotate() => print('$_name колесо начало движение');
  void stop() => print('$_name колесо остановилось');
}

class Controller {
  Controller();

  static String _translate(String side) {
    switch (side) {
      case 'left': return 'влево';
      case 'right': return 'вправо';
      case 'up': return 'вверх';
      default: throw ArgumentError('Неизвестная команда $side');
    }
  }

  void turn(String side) {
    print('Руль ${_translate(side)}');
  }
}

class Bike {
  Bike({
    Wheel wheel1,
    Wheel wheel2,
    Controller controller,
  })  : _wheel1 = wheel1 ?? Wheel('Переднее'),
        _wheel2 = wheel2 ?? Wheel('Заднее'),
        _controller = controller ?? Controller();

  final Wheel _wheel1;
  Wheel get wheel1 => _wheel1;

  final Wheel _wheel2;
  Wheel get wheel2 => _wheel2;

  final Controller _controller;
  Controller get controller => _controller;

  void run() {
    _wheel1.rotate();
    _wheel2.rotate();
    print('Велосипед пришёл в движение');
  }

  void stop() {
    _wheel1.stop();
    _wheel2.stop();
    print('Велосипед остановлен');
  }

  static String _translate(String side) {
    switch (side) {
      case 'left': return 'поворачивает влево';
      case 'right': return 'поворачивает вправо';
      case 'up': return 'подпрыгивает вверх';
      default: throw ArgumentError('Неизвестная команда $side');
    }
  }

  void turn(String side) {
    _controller.turn(side);
    print('Велосипед ${_translate(side)}');
  }
}

void main() {
  final bike = Bike();

  print('Начинаем:');
  bike
    ..run()
    ..turn('left')
    ..turn('right')
    ..turn('up')
    ..stop();
}
