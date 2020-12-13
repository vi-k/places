import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/colors.dart';
import '../res/const.dart';
import '../res/edge_insets.dart';
import '../res/strings.dart';
import '../res/text_styles.dart';
import '../screen/sight_details.dart';
import 'loadable_image.dart';

enum SightCardType { list, wishlist, visited }

class SightCard extends StatelessWidget {
  const SightCard({
    Key? key,
    required this.sight,
    required this.type,
  }) : super(key: key);

  final Sight sight;
  final SightCardType type;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 3 / 2,
        child: Material(
          elevation: 2,
          textStyle: textRegular,
          color: cardBackground,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
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
              LoadableImage(url: sight.url),
              Positioned(
                left: cardSpacing,
                top: cardSpacing,
                child: Text(
                  sight.typeAsText,
                  style: textBoldWhite,
                ),
              ),
              Positioned(
                right: cardSpacing,
                top: cardSpacing,
                child: type == SightCardType.list
                    ? SvgPicture.asset(
                        assetFavorite,
                        color: cardSignaturesColor,
                      )
                    : Row(
                        children: type == SightCardType.wishlist
                            ? [
                                SvgPicture.asset(
                                  assetCalendar,
                                  color: cardSignaturesColor,
                                ),
                                const SizedBox(
                                  width: cardSpacing,
                                ),
                                SvgPicture.asset(
                                  assetClose,
                                  color: cardSignaturesColor,
                                ),
                              ]
                            : [
                                SvgPicture.asset(
                                  assetShare,
                                  color: cardSignaturesColor,
                                ),
                                const SizedBox(
                                  width: cardSpacing,
                                ),
                                SvgPicture.asset(
                                  assetClose,
                                  color: cardSignaturesColor,
                                ),
                              ],
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
                  style: textRegularSecondary,
                ),
              ],
            ),
          ),
        ),
      );
}
