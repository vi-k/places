part of 'app_bloc.dart';

/// Основное состояние приложения.
class AppState extends Equatable with BlocValues {
  const AppState._({
    required this.settings,
  });

  const AppState.init() : settings = const BlocValue.undefined();

  AppState.from(AppState state) : settings = state.settings;

  final BlocValue<AppSettings> settings;

  @override
  List<BlocValue> get values => [settings];

  @override
  List<Object?> get props => [values];

  AppState copyWith({
    BlocValue<AppSettings>? settings,
  }) =>
      AppState._(
        settings: settings ?? this.settings,
      );

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType(settings: $settings)';
}
