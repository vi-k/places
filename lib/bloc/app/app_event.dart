part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// Восстановить прошлое состояние или инициализировать.
class AppRestoreOrInit extends AppEvent {
  const AppRestoreOrInit();
}

/// Изменить настройки.
class AppChangeSettings extends AppEvent {
  const AppChangeSettings({
    this.isDark,
    this.showTutorial,
    this.animationDuration,
    this.filter,
  });

  final bool? isDark;
  final bool? showTutorial;
  final int? animationDuration;
  final Filter? filter;

  @override
  List<Object?> get props =>
      [isDark, showTutorial, animationDuration, filter];
}
