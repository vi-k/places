// Задание 1
// Есть классы геометрических фигур - наследники Shape и класс страны - Country.
// Эти классы хранят массив borders - в контексте фигур это количество граней
// фигуры,а в контексте стран - это количество границ.
//
// Требуется:
// Реализовать миксин BorderHelper, который подмешивает в класс возможность
// вычисления количества граней/границ. Вызов должен происходить следующим
// образом

mixin BorderHelper<T> {
  List<T> get borders;

  int getBorderCount() => borders.length;
}

class Shape with BorderHelper<double> {
  Shape([this.borders = const []]);

  @override
  final List<double> borders;
}

class Trapezoid extends Shape {
  Trapezoid() : super([8.0, 5.0, 10.0, 5.0]);
}

class CountryBorder {}

class Country with BorderHelper<CountryBorder> {
  Country(this.borders);

  @override
  final List<CountryBorder> borders;
}

void main() {
  print(Shape([1,2,3]).getBorderCount());
  print(Trapezoid().getBorderCount());
  print(Country([CountryBorder(),CountryBorder()]).getBorderCount());
}
