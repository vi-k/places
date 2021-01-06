import 'package:flutter/material.dart';

import '../res/const.dart';

class LoadableData<T> extends StatefulWidget {
  const LoadableData({
    Key? key,
    required this.future,
    required this.error,
    this.loader,
    required this.builder,
    this.background,
  }) : super(key: key);

  final Future<T> future;
  final Widget Function(BuildContext context, Object error) error;
  final Widget Function(BuildContext context)? loader;
  final Widget? Function(BuildContext context, bool done, T? data) builder;
  final Widget? background;

  @override
  _LoadableDataState<T> createState() => _LoadableDataState<T>();
}

class _LoadableDataState<T> extends State<LoadableData<T>> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return widget.error(context, snapshot.error!);
            } else {//if (snapshot.hasData) {
              return Container(
                key: _key,
                child: widget.builder(context, true, snapshot.data),
              );
            }
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
