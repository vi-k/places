import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/sight.dart';
import '../../mocks.dart';
import '../res/svg.dart';
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
    required this.sightId,
    required this.type,
  }) : super(key: key);

  final int sightId;
  final SightCardType type;

  @override
  _SightCardState createState() => _SightCardState();
}

class _SightCardState extends State<SightCard> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    final sight = context.watch<Mocks>()[widget.sightId];

    return AspectRatio(
      aspectRatio: 3 / 2,
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
    final textColor = textStyle.color;

    return Container(
      alignment: Alignment.topLeft,
      padding: cardSignaturesPadding,
      child: Row(
        children: [
          SmallButton(
            highlightColor: highlightColorDark2,
            splashColor: splashColorDark2,
            label: sight.category.text.toLowerCase(),
            style: textStyle,
            onPressed: () {
              print('Filter by category');
            },
          ),
          const Spacer(),
          if (widget.type == SightCardType.list) ...[
            SignatureButton(
              svg: sight.state == SightState.none
                  ? Svg24.heart
                  : Svg24.heartFull,
              color: textColor,
              onPressed: () {
                context.read<Mocks>().replace(
                    sight.id,
                    sight.copyWith(
                        state: sight.state == SightState.none
                            ? SightState.favorite
                            : SightState.none));
              },
            ),
          ],
          if (widget.type == SightCardType.wishlist) ...[
            SignatureButton(
              svg: Svg24.calendar,
              color: textColor,
              onPressed: () {
                print('Schedule');
              },
            ),
            SignatureButton(
              svg: Svg24.close,
              color: textColor,
              onPressed: () {
                context
                    .read<Mocks>()
                    .replace(sight.id, sight.copyWith(state: SightState.none));
              },
            ),
          ],
          if (widget.type == SightCardType.visited) ...[
            SignatureButton(
              svg: Svg24.share,
              color: textColor,
              onPressed: () {
                print('Share');
              },
            ),
            SignatureButton(
              svg: Svg24.close,
              color: textColor,
              onPressed: () {
                context
                    .read<Mocks>()
                    .replace(sight.id, sight.copyWith(state: SightState.none));
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
