import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';

class LoadableImage extends StatelessWidget {
  const LoadableImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) => Image.network(
        url,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, _) => frame == null
            ? Center(
                child: SvgPicture.asset(
                  assetImage,
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
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            ],
          );
        },
      );
}
