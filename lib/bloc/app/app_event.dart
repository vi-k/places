part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {
  const AppStarted();
}

class AppSettingsChanged extends AppEvent {
  const AppSettingsChanged({
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
  List<Object?> get props => [isDark, showTutorial, animationDuration, filter];
}
