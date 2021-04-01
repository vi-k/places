part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

/// Инициализация приложения.
class AppIniting extends AppState {
  const AppIniting();
}

class AppChanging extends AppState {
  const AppChanging();
}

/// Приложение готово.
///
/// Принципиально без константного конструктора!
/// При каждом создании должен быть новый объект!
class AppReady extends AppState {
  const AppReady();
}
