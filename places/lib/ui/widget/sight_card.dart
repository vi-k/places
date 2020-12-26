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

/// Виджет: Карточка интересного места.
class SightCard extends StatefulWidget {
  const SightCard({
    Key? key,
    required this.sight,
    required this.type,
  }) : super(key: key);

  final Sight sight;
  final SightCardType type;

  @override
  _SightCardState createState() => _SightCardState();
}

class _SightCardState extends State<SightCard> {
  late Sight _sight;

  @override
  void initState() {
    super.initState();
    _sight = widget.sight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Card(
        margin: EdgeInsets.zero,
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
                Navigator.push<Sight>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SightDetails(sight: _sight),
                    )).then((value) => setState(() {
                      if (value != null) {
                        setState(() {
                          _sight = value;
                        });
                      }
                    }));
              },
              child: _buildSignatures(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() => Expanded(
        child: LoadableImage(
          url: _sight.photos.isEmpty ? '' : _sight.photos[0],
        ),
      );

  Widget _buildSignatures(MyThemeData theme) {
    final textStyle = theme.textBold14White;
    final textColor = textStyle.color;

    return Container(
      alignment: Alignment.topLeft,
      padding: cardSignaturesPadding,
      child: Row(
        children: [
          SmallButton(
            highlightColor: theme.highlightColorOnImage,
            splashColor: theme.splashColorOnImage,
            label: _sight.category.text.toLowerCase(),
            style: textStyle,
            onPressed: () {
              print('Filter by category');
            },
          ),
          const Spacer(),
          if (widget.type == SightCardType.list) ...[
            SignatureButton(
              svg: assetFavorite,
              color: textColor,
              onPressed: () {
                print('Favorite');
              },
            ),
          ],
          if (widget.type == SightCardType.wishlist) ...[
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
          if (widget.type == SightCardType.visited) ...[
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

  Widget _buildBottom(MyThemeData theme) => Expanded(
        child: Container(
          padding: commonPadding,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            text: TextSpan(
              text: '${_sight.name}\n',
              style: theme.textMiddle16Main,
              children: [
                TextSpan(
                  //text: sight.details,
                  text: '${myMockCoord.distance(_sight.coord)}',
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
