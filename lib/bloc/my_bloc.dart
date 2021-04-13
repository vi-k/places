import 'dart:async';

import 'package:bloc/bloc.dart';

/// Ассинхронная инициализация для блока.
abstract class MyBloc<Event, State> extends Bloc<Event, State> {
  MyBloc(State initialState) : super(initialState) {
    _run();
  }

  final Completer<void> inited = Completer();
  Future<State> initBloc();

  Future<void> _run() async {
    emit(await initBloc());
    inited.complete();
  }
}
