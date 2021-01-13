import 'package:flutter/material.dart';

enum LoadingState { waiting, loading, failed, done }

/// Виджет для загрузки данных и их предоставления вниз по дереву.
///
/// Доступ: `Load<T>.of(context)`.
///
/// Для подписки на изменения: `Load.of(context, listen: true)`. В отличие от
/// аналогичных вызовов в SDK прослушивание по умолчанию отключено!
@immutable
class Loader<T> extends StatefulWidget {
  const Loader({
    Key? key,
    this.tag,
    required this.load,
    this.loader,
    required this.error,
    required this.builder,
  }) : super(key: key);

  /// Тег для проверки, изменились ли данные.
  final int? tag;

  /// Загрузчик данных. Если `null`, состояние данных = `LoadingState.waiting`.
  final Future<T> Function()? load;

  /// Индикатор загрузки данных. Если `null`, то `CircularProgressIndicator`.
  ///
  /// Накладывается поверх виджета данных.
  final Widget Function(BuildContext context)? loader;

  // Виджет ошибки.
  final Widget Function(BuildContext context, Object error) error;

  /// Виджет данных. [state] не может быть `LoadingState.failed`.
  final Widget Function(BuildContext context, LoadingState state, T? data)
      builder;

  static _LoaderState<T> of<T>(BuildContext context, {bool listen = false}) =>
      _LoadScope.of<T>(context, listen: listen).state;

  @override
  _LoaderState<T> createState() => _LoaderState<T>();
}

class _LoaderState<T> extends State<Loader<T>> {
  // Флаг о необходимости оповестить зависимости об изменениях.
  var _updateShouldNotify = false;

  // Сохраняем дерево, созданное через builder, чтобы не пересоздавать каждый
  // раз заново. Пересоздаём только при изменении состояния.
  Widget? _child;

  // Оборачиваем результат работы builder'а в контейнер с глобальным ключом,
  // чтобы виджеты не пересоздавались.
  final _key = GlobalKey();

  var _state = LoadingState.waiting;
  T? _data;
  Object? _error;

  /// Состояние данных:
  /// - waiting - в ожидании загрузки, widget.load == null;
  /// - loading - идёт загрузка;
  /// - failed - ошибка;
  /// - done - загрузка завершена.
  LoadingState get state => _state;

  /// Данные. Очищаются только при получении новых данных или ошибке.
  /// Это позволяет во время загрузки новых данных выводить на экран старые.
  T? get data => _data;

  /// Ошибка. Очищается только при получении данных или новой ошибке.
  Object? get error => _error;

  /// Оповещает зависимости об изменении данных.
  void update() {
    setState(() {
      _updateShouldNotify = true;
    });
  }

  void _load() {
    if (widget.load != null) {
      _child = null;
      _state = LoadingState.loading;
      widget.load!().then((value) {
        if (mounted) {
          _error = null;
          _data = value;
          _state = LoadingState.done;
          _child = null;
          update();
        }
        return value;
      }, onError: (dynamic e) {
        if (mounted) {
          _error = e;
          _data = null;
          _state = LoadingState.failed;
          _child = null;
          update();
        }
      });
    }
  }

  /// Перезагружает данные.
  void reload() => setState(_load);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant Loader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.load == null || oldWidget.tag != widget.tag) {
      _load();
    }
  }

  @override
  Widget build(BuildContext context) => _LoadScope(
        state: this,
        // child: _child ?? (_child = Builder(builder: _buildChild)),
        child: _child = Builder(builder: _buildChild),
      );

  Widget _buildChild(BuildContext context) => _state == LoadingState.failed
      // Ошибка
      ? widget.error(context, _error!)
      // Данные загружены
      : _state == LoadingState.done
          ? _buildChildContainer(context)
          // Ожидание загрузки данных
          : Stack(
              children: [
                AbsorbPointer(
                  child: Opacity(
                    opacity: 0.3,
                    child: _buildChildContainer(context),
                  ),
                ),
                // Загрузка
                if (_state == LoadingState.loading)
                  Positioned.fill(
                    child: widget.loader?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                  ),
              ],
            );

  Widget _buildChildContainer(BuildContext context) => Container(
        key: _key,
        child: widget.builder(context, _state, _data),
      );
}

@immutable
class _LoadScope<T> extends InheritedWidget {
  const _LoadScope({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  final _LoaderState<T> state;

  /// Ищет _LoadScope в дереве. При необходимости ([listen]) подписываемся.
  static _LoadScope<T> of<T>(BuildContext context,
          {required bool listen}) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<_LoadScope<T>>()!
          : context
              .getElementForInheritedWidgetOfExactType<_LoadScope<T>>()!
              .widget as _LoadScope<T>;

  @override
  bool updateShouldNotify(_LoadScope oldWidget) {
    final update = state._updateShouldNotify;
    state._updateShouldNotify = false;
    return update;
  }
}
