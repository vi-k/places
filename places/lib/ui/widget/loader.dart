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
    required this.load,
    this.loader,
    required this.error,
    required this.builder,
    this.tag,
  }) : super(key: key);

  final Future<T> Function()? load;
  final Widget Function(BuildContext context)? loader;
  final Widget Function(BuildContext context, Object error) error;
  final Widget Function(BuildContext context, LoadingState state, T? data)
      builder;
  final int? tag;

  static _LoaderState<T> of<T>(BuildContext context, {bool listen = false}) =>
      _LoadScope.of<T>(context, listen: listen).state;

  @override
  _LoaderState<T> createState() => _LoaderState<T>();
}

class _LoaderState<T> extends State<Loader<T>> {
  final _key = GlobalKey();
  var _needUpdate = false;
  var _state = LoadingState.waiting;
  T? _data;
  Object? _error;

  T? get data => _data;

  void _load() {
    if (widget.load != null) {
      _state = LoadingState.loading;
      widget.load!().then((value) {
        if (mounted) {
          setState(() {
            _error = null;
            _data = value;
            _state = LoadingState.done;
          });
        }
        return value;
      }, onError: (dynamic e) {
        if (mounted) {
          setState(() {
            _error = e;
            _data = null;
            _state = LoadingState.failed;
          });
        }
      });
    }
  }

  void reload() => setState(_load);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
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
        child: Builder(
          builder: (context) => _state == LoadingState.failed
              // Ошибка
              ? widget.error(context, _error!)
              // Данные загружены
              : _state == LoadingState.done
                  ? _buildContainer(context)
                  // Ожидание загрузки данных
                  : Stack(
                      children: [
                        AbsorbPointer(
                          child: Opacity(
                            opacity: 0.3,
                            child: _buildContainer(context),
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
                    ),
        ),
      );

  Widget _buildContainer(BuildContext context) => Container(
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
    final update = state._needUpdate;
    state._needUpdate = false;
    return update;
  }
}
