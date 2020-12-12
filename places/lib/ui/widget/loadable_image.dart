import 'package:flutter/material.dart';

import '../res/colors.dart';

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
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              backgroundColor: imageBackground,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
}
