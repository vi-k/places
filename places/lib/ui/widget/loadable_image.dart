import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';

/// Виджет загружаемой из сети картинки с индикатором прогресса внизу виджета.
class LoadableImage extends StatelessWidget {
  const LoadableImage({
    Key? key,
    this.url,
    this.path,
  })  : assert(url != null && path == null || url == null && path != null),
        super(key: key);

  /// Url картинки.
  final String? url;

  /// Путь к картинке.
  final String? path;

  @override
  Widget build(BuildContext context) => url != null
      ? Image.network(
          url!,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
          frameBuilder: _frameBuilder,
          loadingBuilder: _loadingBuilder,
          errorBuilder: _errorBuilder,
        )
      : Stack(children: [
          Image.file(
            File(path!),
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            frameBuilder: _frameBuilder,
            errorBuilder: _errorBuilder,
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ]);

  Widget _frameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) =>
      AnimatedCrossFade(
        secondCurve: Curves.fastOutSlowIn,
        duration: standartAnimationDuration,
        layoutBuilder: (topChild, _, bottomChild, __) => Stack(
          children: <Widget>[
            Positioned.fill(child: topChild),
            Positioned.fill(child: bottomChild),
          ],
        ),
        firstChild: Container(
          color: Colors.black12,
          child: Center(
            child: SvgPicture.asset(
              Svg24.photo,
              color: Colors.white30,
            ),
          ),
        ),
        secondChild: child,
        crossFadeState: frame == null
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      );

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? progress,
  ) =>
      Stack(
        children: [
          child,
          if (progress != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
              ),
            ),
        ],
      );

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final theme = context.watch<AppBloc>().theme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: commonPadding,
        child: Text(
          error.toString(),
          textAlign: TextAlign.center,
          style: theme.textRegular16Light56,
        ),
      ),
    );
  }
}
