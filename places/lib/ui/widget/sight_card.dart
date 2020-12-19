import 'package:flutter/material.dart';

import '../../domain/sight.dart';
import '../../mocks.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../screen/sight_details.dart';
import 'loadable_image.dart';
import 'my_theme.dart';
import 'small_button.dart';
import 'svg_button.dart';

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
                  _buildTop(),
                  _buildBottom(context),
                ],
              ),
              // Поверх карточки невдимая кнопка
              MaterialButton(
                padding: EdgeInsets.zero,
                highlightColor: MyTheme.of(context).tapHighlightColor,
                splashColor: MyTheme.of(context).tapSplashColor,
                onPressed: () {
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SightDetails(sight: sight),
                      ));
                },
                child: _buildSignatures(context),
              ),
            ],
          ),
        ),
      );

  // Верхняя часть карточки (фотография).
  Expanded _buildTop() => Expanded(
        child: LoadableImage(
          url: sight.url,
        ),
      );

  // Строка кнопок поверх картинки.
  Widget _buildSignatures(BuildContext context) {
    final textStyle = MyTheme.of(context).cardSignaturesTextStyle;
    final textColor = textStyle.color;

    return Container(
      alignment: Alignment.topLeft,
      padding: MyThemeData.cardSignaturesPadding,
      child: Row(
        children: [
          SmallButton(
            highlightColor: MyThemeData.tapOnImageHighlightColor,
            splashColor: MyThemeData.tapOnImageSplashColor,
            label: sight.typeAsText,
            style: textStyle,
            onPressed: () {
              print('Filter by category');
            },
          ),
          const Spacer(),
          if (type == SightCardType.list) ...[
            SvgButton(
              svg: assetFavorite,
              color: textColor,
              onPressed: () {
                print('Add to wishlist');
              },
            ),
          ],
          if (type == SightCardType.wishlist) ...[
            SvgButton(
              svg: assetCalendar,
              color: textColor,
              onPressed: () {
                print('Schedule');
              },
            ),
            SvgButton(
              svg: assetClose,
              color: textColor,
              onPressed: () {
                print('Remove from wishlist');
              },
            ),
          ],
          if (type == SightCardType.visited) ...[
            SvgButton(
              svg: assetShare,
              color: textColor,
              onPressed: () {
                print('Share');
              },
            ),
            SvgButton(
              svg: assetClose,
              color: textColor,
              onPressed: () {
                print('Remove from visited');
              },
            ),
          ],
        ],
      ),
    );
  }

  // Нижняя (текстовая) часть карточки.
  Widget _buildBottom(BuildContext context) => Expanded(
        child: Container(
          padding: MyThemeData.commonPadding,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            text: TextSpan(
              text: '${sight.name}\n',
              style: Theme.of(context).primaryTextTheme.headline4,
              children: [
                TextSpan(
                  //text: sight.details,
                  text: '${myMockCoord.distance(sight.coord)}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      );
}
