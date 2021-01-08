import 'package:flutter/material.dart';

import '../../domain/mocks_data.dart';
import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../screen/sight_details.dart';
import 'loadable_image.dart';
import 'mocks.dart';
import 'small_button.dart';
import 'svg_button.dart';

enum SightCardType { list, favorites, visited }

/// Виджет: Карточка интересного места.
class SightCard extends StatefulWidget {
  const SightCard({
    Key? key,
    required this.sightId,
    required this.type,
    this.onLongPress,
  }) : super(key: key);

  final int sightId;
  final SightCardType type;
  final void Function()? onLongPress;

  @override
  _SightCardState createState() => _SightCardState();
}

class _SightCardState extends State<SightCard> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final sight = Mocks.of(context, listen: true).sightById(widget.sightId);

    return SizedBox(
      width: MediaQuery.of(context).size.width - commonPadding.horizontal,
      child: AspectRatio(
        aspectRatio: cardAspectRatio,
        child: Card(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTop(sight),
                  _buildBottom(theme, sight),
                ],
              ),
              // Поверх карточки невидимая кнопка
              MaterialButton(
                padding: EdgeInsets.zero,
                highlightColor: theme.app.highlightColor,
                splashColor: theme.app.splashColor,
                onLongPress: widget.onLongPress,
                onPressed: () {
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SightDetails(sightId: sight.id),
                      ));
                },
                child: _buildSignatures(theme, sight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop(Sight sight) => Expanded(
        child: Stack(
          children: [
            Positioned.fill(
              child: LoadableImage(
                url: sight.photos.isEmpty ? '' : sight.photos[0],
              ),
            ),
            Positioned.fill(
              child: Container(
                color: highlightColorDark2,
              ),
            ),
          ],
        ),
      );

  Widget _buildSignatures(MyThemeData theme, Sight sight) {
    final textStyle = theme.textBold14White;
    final mocks = Mocks.of(context, listen: true);
    final category =
        Mocks.of(context, listen: true).categoryById(sight.categoryId);

    return Container(
      alignment: Alignment.topLeft,
      padding: cardSignaturesPadding,
      child: Row(
        children: [
          SmallButton(
            highlightColor: highlightColorDark2,
            splashColor: splashColorDark2,
            label: category.name.toLowerCase(),
            style: textStyle,
            onPressed: () {
              print('Filter by category');
            },
          ),
          const Spacer(),
          if (widget.type == SightCardType.list) ...[
            SignatureButton(
              svg: mocks.isFavorite(sight.id) ? Svg24.heartFull : Svg24.heart,
              color: textStyle.color,
              onPressed: () {
                Mocks.of(context).toggleFavorite(sight.id);
              },
            ),
          ],
          if (widget.type == SightCardType.favorites) ...[
            SignatureButton(
              svg: Svg24.calendar,
              color: textStyle.color,
              onPressed: () {
                print('Schedule');
              },
            ),
            SignatureButton(
              svg: Svg24.close,
              color: textStyle.color,
              onPressed: () {
                Mocks.of(context).removeFromFavorite(sight.id);
              },
            ),
          ],
          if (widget.type == SightCardType.visited) ...[
            SignatureButton(
              svg: Svg24.share,
              color: textStyle.color,
              onPressed: () {
                print('Share');
              },
            ),
            SignatureButton(
              svg: Svg24.close,
              color: textStyle.color,
              onPressed: () {
                Mocks.of(context).removeFromVisited(sight.id);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottom(MyThemeData theme, Sight sight) => Expanded(
        child: Container(
          padding: commonPadding,
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
  Widget build(BuildContext context) => SvgButton(
        svg,
        highlightColor: highlightColorDark2,
        splashColor: splashColorDark2,
        color: color,
        onPressed: onPressed,
      );
}
