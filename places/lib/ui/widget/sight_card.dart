import 'package:flutter/material.dart';

import '../../domain/category.dart';
import '../../domain/mocks_data.dart';
import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../screen/sight_details.dart';
import 'failed.dart';
import 'loadable_image.dart';
import 'loader.dart';
import 'mocks.dart';
import 'small_button.dart';
import 'small_loader.dart';
import 'svg_button.dart';

enum SightCardType { list, favorites, visited }

/// Карточка места.
class SightCard extends StatefulWidget {
  const SightCard({
    Key? key,
    required this.sightId,
    required this.type,
    this.onLongPress,
  }) : super(key: key);

  /// Идентификатор места.
  final int sightId;

  /// Тип карточки: list, favorites, visited.
  final SightCardType type;

  /// Обратный вызов для реализации перемещения карточек.
  final void Function()? onLongPress;

  @override
  _SightCardState createState() => _SightCardState();
}

class _SightCardState extends State<SightCard> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width - commonPadding.horizontal,
      child: AspectRatio(
        aspectRatio: cardAspectRatio,
        child: Card(
          child: Loader<Sight>(
            load: () => Mocks.of(context).sightById(widget.sightId),
            error: (context, error) => Failed(
              error.toString(),
              onRepeat: () => Loader.of<Sight>(context).reload(),
            ),
            builder: (context, _, sight) => Stack(
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
                  onPressed: () async {
                    final modified = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SightDetails(sightId: widget.sightId),
                      ),
                    );

                    if (modified != null && modified) {
                      Loader.of<Sight>(context).reload();
                    }
                  },
                  child: _buildSignatures(theme, sight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTop(Sight? sight) => Expanded(
        child: Stack(
          children: [
            if (sight != null)
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

  Widget _buildSignatures(MyThemeData theme, Sight? sight) {
    final textStyle = theme.textBold14White;
    final color = textStyle.color!;
    final mocks = Mocks.of(context, listen: true);

    return Container(
      alignment: Alignment.topLeft,
      padding: cardSignaturesPadding,
      child: Row(
        children: [
          _buildSignatureCategory(textStyle, sight),
          const Spacer(),
          if (widget.type == SightCardType.list)
            _buildSignatureButton(
              mocks.isFavorite(widget.sightId) ? Svg24.heartFull : Svg24.heart,
              textStyle.color!,
              () => Mocks.of(context).toggleFavorite(widget.sightId),
            ),
          if (widget.type == SightCardType.favorites) ...[
            _buildSignatureButton(
              Svg24.calendar,
              color,
              () => print('Schedule'),
            ),
            _buildSignatureButton(
              Svg24.close,
              color,
              () => Mocks.of(context).removeFromFavorite(widget.sightId),
            ),
          ],
          if (widget.type == SightCardType.visited) ...[
            _buildSignatureButton(
              Svg24.share,
              color,
              () => print('Share'),
            ),
            _buildSignatureButton(
              Svg24.close,
              color,
              () => Mocks.of(context).removeFromVisited(widget.sightId),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSignatureCategory(TextStyle textStyle, Sight? sight) =>
      Loader<Category>(
        tag: sight?.categoryId,
        load: sight == null
            ? null
            : () => Mocks.of(context).categoryById(sight.categoryId),
        loader: (_) => Center(
          child: SmallLoader(color: textStyle.color),
        ),
        error: (context, error) => Padding(
          padding: cardSignaturesPadding2,
          child: SvgButton(
            Svg24.refresh,
            color: textStyle.color,
            highlightColor: highlightColorDark2,
            splashColor: splashColorDark2,
            onPressed: () => Loader.of<Category>(context).reload(),
          ),
        ),
        builder: (context, _, category) => category == null
            ? const Padding(
                padding: cardSignaturesPadding2,
                child: SizedBox(
                  height: smallButtonHeight,
                  width: smallButtonHeight,
                ),
              )
            : SmallButton(
                highlightColor: highlightColorDark2,
                splashColor: splashColorDark2,
                label: category.name.toLowerCase(),
                style: textStyle,
                onPressed: () {
                  Loader.of<Sight>(context).reload();
                  //print('Filter by category');
                },
              ),
      );

  Widget _buildSignatureButton(
          String svg, Color color, void Function() onPressed) =>
      SvgButton(
        svg,
        highlightColor: highlightColorDark2,
        splashColor: splashColorDark2,
        color: color,
        onPressed: onPressed,
      );

  Widget _buildBottom(MyThemeData theme, Sight? sight) => Expanded(
        child: Container(
          padding: commonPadding,
          child: sight == null
              ? null
              : RichText(
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
