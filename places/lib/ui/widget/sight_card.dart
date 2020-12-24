/// Виджет: Карточка интересного места.

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
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        elevation: 2,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTop(),
                _buildBottom(theme),
              ],
            ),
            // Поверх карточки невидимая кнопка
            MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: theme.app.highlightColor,
              splashColor: theme.app.splashColor,
              onPressed: () {
                Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SightDetails(sight: sight),
                    ));
              },
              child: _buildSignatures(theme),
            ),
          ],
        ),
      ),
    );
  }

  // Верхняя часть карточки (фотография).
  Expanded _buildTop() => Expanded(
        child: LoadableImage(
          url: sight.url,
        ),
      );

  // Строка кнопок поверх картинки.
  Widget _buildSignatures(MyThemeData theme) {
    final textStyle = theme.textBold14White;
    final textColor = textStyle.color;

    return Container(
      alignment: Alignment.topLeft,
      padding: MyThemeData.cardSignaturesPadding,
      child: Row(
        children: [
          SmallButton(
            highlightColor: theme.highlightColorOnImage,
            splashColor: theme.splashColorOnImage,
            label: sight.category.text.toLowerCase(),
            style: textStyle,
            onPressed: () {
              print('Filter by category');
            },
          ),
          const Spacer(),
          if (type == SightCardType.list) ...[
            SignatureButton(
              svg: assetFavorite,
              color: textColor,
              onPressed: () {
                print('Favorite');
              },
            ),
          ],
          if (type == SightCardType.wishlist) ...[
            SignatureButton(
              svg: assetCalendar,
              color: textColor,
              onPressed: () {
                print('Schedule');
              },
            ),
            SignatureButton(
              svg: assetClose,
              color: textColor,
              onPressed: () {
                print('Remove from wishlist');
              },
            ),
          ],
          if (type == SightCardType.visited) ...[
            SignatureButton(
              svg: assetShare,
              color: textColor,
              onPressed: () {
                print('Share');
              },
            ),
            SignatureButton(
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
  Widget _buildBottom(MyThemeData theme) => Expanded(
        child: Container(
          padding: MyThemeData.commonPadding,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            text: TextSpan(
              text: '${sight.name}\n',
              style: theme.textMiddle16Main,
              children: [
                TextSpan(
                  //text: sight.details,
                  text: '${myMockCoord.distance(sight.coord)}',
                  style: theme.textRegular14Light,
                ),
              ],
            ),
          ),
        ),
      );
}

class SignatureButton extends StatelessWidget {
  const SignatureButton({
    Key? key,
    required this.svg,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  final String svg;
  final Color? color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SvgButton(
      highlightColor: theme.highlightColorOnImage,
      splashColor: theme.splashColorOnImage,
      svg: svg,
      color: color,
      onPressed: onPressed,
    );
  }
}
