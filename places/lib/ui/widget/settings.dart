import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../domain/settings_data.dart';

/// Виджет для предоставления настроек приложения вниз по дереву.
///
/// Доступ: `Settings.of(context)`. Возвращает [SettingsData].
///
/// Для подписки на изменения: `Settings.of(context, listen: true)`. В отличие от
/// аналогичных вызовов в SDK прослушивание по умолчанию отключено!
@immutable
class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    required this.create,
    required this.child,
  }) : super(key: key);

  final SettingsData Function() create;
  final Widget child;

  static SettingsData of(BuildContext context, {bool listen = false}) =>
      _SettingsScope.of(context, listen: listen).state.data;

  @override
  State<Settings> createState() => _SettingsState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'Settings StatefulWidget',
            ),
          ),
      );
}

class _SettingsState extends State<Settings> {
  var _needUpdate = false;
  late SettingsData data;

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
              '_SettingsState State<Settings>',
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
  Widget build(BuildContext context) => _SettingsScope(
        state: this,
        child: widget.child,
      );
}

@immutable
class _SettingsScope extends InheritedWidget {
  const _SettingsScope({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final _SettingsState state;

  /// Ищет _SettingsScope в дереве. При необходимости ([listen]) подписываемся.
  static _SettingsScope of(BuildContext context, {required bool listen}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_SettingsScope>()!
      : context.getElementForInheritedWidgetOfExactType<_SettingsScope>()!.widget
          as _SettingsScope;

  @override
  bool updateShouldNotify(_SettingsScope oldWidget) {
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
              'Scope of Settings',
            ),
          )
          ..add(
            ObjectFlagProperty<_SettingsState>(
              '_SettingsState',
              state,
              ifNull: 'none',
            ),
          )
          ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.offstage,
      );
}
