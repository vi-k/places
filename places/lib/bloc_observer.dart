import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType}: '
        '${change.currentState.runtimeType} -> '
        '${change.nextState.runtimeType} '
        '(${change.currentState == change.nextState ? '==' : '!='})');
  }
}
