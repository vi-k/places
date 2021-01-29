import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/svg.dart';
import '../res/themes.dart';

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
    final theme = MyTheme.of(context);

    return Image.network(
      url,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, _) => frame == null
          ? Container(
              color: Colors.black12,
              child: Center(
                child: SvgPicture.asset(
                  Svg24.photo,
                  color: Colors.white30,
                ),
              ),
            )
          : child,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Stack(
          children: [
            child,
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
      },
      errorBuilder: (context, error, stackTrace) {
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
      },
    );
  }
}
