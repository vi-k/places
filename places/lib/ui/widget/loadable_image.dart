import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';

/// Виджет загружаемой из сети картинки с индикатором прогресса внизу виджета.
class LoadableImage extends StatelessWidget {
  const LoadableImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  /// Url картинки.
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Image.network(
      url,
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, _) => AnimatedCrossFade(
        secondCurve: Curves.easeOutCubic,
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
      ),
      loadingBuilder: (context, child, progress) => Stack(
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
      ),
      errorBuilder: (context, error, stackTrace) => Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: commonPadding,
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: theme.textRegular16Light56,
          ),
        ),
      ),
    );
  }
}
