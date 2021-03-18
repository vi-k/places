part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsReady extends SettingsState {
  const SettingsReady(this.settings);

  final Settings settings;

  @override
  List<Object?> get props => [settings];
}
