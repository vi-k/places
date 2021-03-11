// ignore: import_of_legacy_library_into_null_safe
import 'package:mwwm/mwwm.dart';

class StandartErrorHandler extends ErrorHandler {
  @override
  void handleError(Object e) {
    print('Handled error: $e');
  }
}