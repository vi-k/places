import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/model/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC для настроек.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsLoading());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsLoad) {
      yield* _load();
    } else if (event is SettingsChange) {
      yield* _change(event);
    }
  }

  Stream<SettingsState> _load() async* {
    const settings = Settings(isDark: true, showTutorial: true);
    await Future<void>.delayed(const Duration(seconds: 2));
    yield const SettingsReady(settings);
  }

  Stream<SettingsState> _change(SettingsChange event) async* {
    yield SettingsReady(event.settings);
  }
}
