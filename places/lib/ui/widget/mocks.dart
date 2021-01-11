import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import '../../domain/mocks_data.dart';

/// Виджет для предоставления моковых данных вниз по дереву.
///
/// Доступ: `Mocks.of(context)`. Возвращает [MocksData].
///
/// Для подписки на изменения: `Mocks.of(context, listen: true)`. В отличие от
/// аналогичных вызовов в SDK прослушивание по умолчанию отключено!
@immutable
class Mocks extends StatefulWidget {
  const Mocks({
    Key? key,
    required this.create,
    required this.child,
  }) : super(key: key);

  final MocksData Function() create;
  final Widget child;

  static MocksData of(BuildContext context, {bool listen = false}) =>
      _MocksScope.of(context, listen: listen).state.data;

  @override
  State<Mocks> createState() => _MocksState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'Mocks StatefulWidget',
            ),
          ),
      );
}

class _MocksState extends State<Mocks> {
  var _needUpdate = false;
  late MocksData data;

  // Первичная инициализация виджета.
  @override
  void initState() {
    super.initState();

    data = widget.create();
    data.addListener(() {
      setState(() {
        _needUpdate = true;
      });
    });
  }

  // Удаление стейта из дерева.
  @override
  void dispose() {
    data.dispose();

    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              '_MocksState State<Mocks>',
            ),
          )
          ..add(
            StringProperty(
              'data',
              '$data',
            ),
          ),
      );

  @override
  Widget build(BuildContext context) => _MocksScope(
        state: this,
        child: widget.child,
      );
}

@immutable
class _MocksScope extends InheritedWidget {
  const _MocksScope({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final _MocksState state;

  /// Ищет _MocksScope в дереве. При необходимости ([listen]) подписываемся.
  static _MocksScope of(BuildContext context, {required bool listen}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_MocksScope>()!
      : context.getElementForInheritedWidgetOfExactType<_MocksScope>()!.widget
          as _MocksScope;

  @override
  bool updateShouldNotify(_MocksScope oldWidget) {
    final update = state._needUpdate;
    state._needUpdate = false;
    return update;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'Scope of Mocks',
            ),
          )
          ..add(
            ObjectFlagProperty<_MocksState>(
              '_MocksState',
              state,
              ifNull: 'none',
            ),
          )
          ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.offstage,
      );
}
