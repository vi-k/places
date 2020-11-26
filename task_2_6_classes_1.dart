// Задание 1
// Реализуйте класс Student (Студент), который будет наследоваться от класса
// User. Класс должен иметь следующие свойства:
// yearOfAdmission (год поступления в вуз): инициализируется в конструкторе
// currentCourse (текущий курс): DateTime.now - yearOfAdmission
// Класс должен иметь метод toString(), с помощью которого можно вывести:
// имя и фамилию студента - используя родительскую реализацию toString
// год поступления
// текущий курс

// ignore: avoid_classes_with_only_static_members
class MyDateTime {
  static DateTime? nowMock;
  static DateTime now() => nowMock ?? DateTime.now();
}

class User {
  User(this.firstName, this.secondName);

  final String firstName;
  final String secondName;

  @override
  String toString() {
    return '$firstName $secondName';
  }
}

class Student extends User {
  Student(String firstName, String secondName, this.yearOfAdmission)
      : super(firstName, secondName);

  final int yearOfAdmission;

  int get currentCourse {
    final now = MyDateTime.now();
    return now.year - yearOfAdmission + (now.month >= 9 ? 1 : 0);
  }

  @override
  String toString() =>
      '${super.toString()}${'\nГод поступления: $yearOfAdmission\nТекущий курс: $currentCourse'}';
}

void main() {
  final student1 = Student('Петя', 'Васечкин', 2020);
  final student2 = Student('Вася', 'Петечкин', 2018);

  print(MyDateTime.now());
  print(student1);
  print(student2);

  MyDateTime.nowMock = DateTime(2021, 1, 1);
  print('');
  print(MyDateTime.now());
  print(student1);
  print(student2);

  MyDateTime.nowMock = DateTime(2021, 9, 1);
  print('');
  print(MyDateTime.now());
  print(student1);
  print(student2);
}
