import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';
import '../res/themes.dart';
import 'my_theme.dart';

/// Виджет: Загружаемая из сети картинка с индикатором прогресса внизу виджета.
class LoadableImage extends StatelessWidget {
  const LoadableImage({
    Key? key,
    required this.url,
  }) : super(key: key);

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
                  assetPhoto,
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
        print(error.runtimeType);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: MyThemeData.commonPadding,
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
