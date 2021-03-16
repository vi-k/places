part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузить настройки
class SettingsLoad extends SettingsEvent {
  const SettingsLoad();
}

class SettingsChange extends SettingsEvent {
  const SettingsChange(this.settings);

  final Settings settings;

  @override
  List<Object?> get props => [settings];
}