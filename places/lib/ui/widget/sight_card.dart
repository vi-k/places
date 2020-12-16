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
        child: Card(
          elevation: 2,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTop(context),
                  _buildBottom(context),
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

  Widget _buildTop(BuildContext context) {
    final textStyle = Theme.of(context).accentTextTheme.bodyText1;
    final textColor = textStyle?.color;

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          LoadableImage(
            url: sight.url,
          ),
          Positioned(
            left: cardSpacing,
            top: cardSpacing,
            child: Text(
              sight.typeAsText,
              style: textStyle,
            ),
          ),
          Positioned(
            right: cardSpacing,
            top: cardSpacing,
            child: type == SightCardType.list
                ? SvgPicture.asset(
                    assetFavorite,
                    color: textColor,
                  )
                : Row(
                    children: type == SightCardType.wishlist
                        ? [
                            SvgPicture.asset(
                              assetCalendar,
                              color: textColor,
                            ),
                            const SizedBox(
                              width: cardSpacing,
                            ),
                            SvgPicture.asset(
                              assetClose,
                              color: textColor,
                            ),
                          ]
                        : [
                            SvgPicture.asset(
                              assetShare,
                              color: textColor,
                            ),
                            const SizedBox(
                              width: cardSpacing,
                            ),
                            SvgPicture.asset(
                              assetClose,
                              color: textColor,
                            ),
                          ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) => Expanded(
        child: Container(
          padding: cardPadding,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            text: TextSpan(
              text: '${sight.name}\n',
              style: Theme.of(context).primaryTextTheme.headline6,
              children: [
                TextSpan(
                  text: sight.details,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      );
}
