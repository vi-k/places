import 'package:flutter/material.dart';

import '../res/const.dart';

class NewLoadableData<T> extends StatefulWidget {
  const NewLoadableData({
    Key? key,
    this.future,
    this.load,
    required this.error,
    this.loader,
    required this.builder,
    this.background,
  })  : assert(future == null || load == null),
        assert(future != null || load != null),
        super(key: key);

  final Future<T>? future;
  final Future<T> Function()? load;
  final Widget Function(
      BuildContext context, Object error, void Function() onRepeat) error;
  final Widget Function(BuildContext context)? loader;
  final Widget? Function(BuildContext context, bool done, T? data) builder;
  final Widget? background;

  @override
  _NewLoadableDataState<T> createState() => _NewLoadableDataState<T>();
}

class _NewLoadableDataState<T> extends State<NewLoadableData<T>> {
  final _key = GlobalKey();
  late Future<T> _future;

  @override
  void initState() {
    super.initState();

    _future = widget.future ?? widget.load!();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: widget.future ?? _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasError
                ? widget.error(context, snapshot.error!, () {
                    setState(() {
                      if (widget.load != null) {
                        _future = widget.load!();
                      }
                    });
                  })
                : Container(
                    key: _key,
                    child: widget.builder(context, true, snapshot.data),
                  );
          }

          return Stack(
            children: [
              AbsorbPointer(
                child: Container(
                  key: _key,
                  child: widget.builder(context, false, null),
                ),
              ),
              Positioned.fill(
                child: widget.loader?.call(context) ??
                    const Center(
                      child: Padding(
                        padding: commonPadding,
                        child: CircularProgressIndicator(),
                      ),
                    ),
              ),
            ],
          );
        },
      );
}
