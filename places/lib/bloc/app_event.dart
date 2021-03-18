part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// Инициализировать приложение.
class AppInit extends AppEvent {
  const AppInit();
}

/// Изменить настройки.
class AppChangeSettings extends AppEvent {
  const AppChangeSettings(this.settings);

  final Settings settings;

  @override
  List<Object?> get props => [settings];
}