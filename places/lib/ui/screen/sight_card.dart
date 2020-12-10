import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/colors.dart';
import '../res/const.dart';
import '../res/edge_insets.dart';
import '../res/text_styles.dart';
import 'sight_details.dart';

class SightCard extends StatelessWidget {
  final Sight sight;

  const SightCard({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 3 / 2,
        child: Material(
          elevation: 2,
          textStyle: textRegular.copyWith(color: textColorPrimary),
          color: cardBackground,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTop(),
                  _buildBottom(),
                ],
              ),
              Positioned.fill(
                child: MaterialButton(
                  highlightColor: Colors.black12,
                  splashColor: Colors.black12,
                  onPressed: () {
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SightDetails(sight: sight),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTop() => Expanded(
        child: Container(
          color: imageBackground,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                sight.url,
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
              ),
              Positioned(
                left: cardSpacing,
                top: cardSpacing,
                child: Text(
                  sight.typeAsText,
                  style: textBold.copyWith(color: cardSignaturesColor),
                ),
              ),
              Positioned(
                right: cardSpacing,
                top: cardSpacing,
                child: SvgPicture.asset(
                  'res/favorite.svg',
                  color: cardSignaturesColor,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBottom() => Expanded(
        child: Container(
          padding: cardPadding,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            text: TextSpan(
              text: '${sight.name}\n',
              style: textMiddle16,
              children: [
                TextSpan(
                  text: sight.details,
                  style: textRegular,//.copyWith(color: textColorSecondary),
                ),
              ],
            ),
          ),
        ),
      );
}
