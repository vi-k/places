part of 'app_bloc.dart';

abstract class AppState {
  const AppState();
}

/// Инициализация приложения.
class AppIniting extends AppState {
  const AppIniting();
}

/// Приложение готово.
///
/// Принципиально без константного конструктора!
/// При каждом создании должен быть новый объект!
class AppReady extends AppState {}
