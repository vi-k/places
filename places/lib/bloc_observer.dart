import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import 'bloc/place/place_bloc.dart';

class MyBlocObserver extends BlocObserver {
  MyBlocObserver(this.logger);

  final Logger logger;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (bloc is! PlaceBloc) {
      logger.d('${bloc.runtimeType}.onCreate: ${bloc.state}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.d('${bloc.runtimeType}.onEvent: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.d('${bloc.runtimeType}.onChange:\n'
        '     previous: ${change.currentState}\n'
        '     current:  ${change.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.d('${bloc.runtimeType}.onError: $error\n'
        '     $stackTrace');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (bloc is! PlaceBloc) {
      logger.d('${bloc.runtimeType}.onClose: ${bloc.state}');
    }
  }
}
