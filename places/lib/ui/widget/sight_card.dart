import 'package:flutter/material.dart';

import '../../domain/category.dart';
import '../../domain/mocks_data.dart';
import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../screen/sight_details.dart';
import 'failed.dart';
import 'loadable_data.dart';
import 'loadable_image.dart';
import 'mocks.dart';
import 'small_button.dart';
import 'small_loader.dart';
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
  late Future<Sight> _sight;
  var _category = Future<Category>.value(null);

  @override
  void initState() {
    super.initState();

    _loadSight();
  }

  // Загружает информацию о месте.
  void _loadSight() {
    _sight = Mocks.of(context).sightById(widget.sightId).then((sight) {
      _category = Mocks.of(context).categoryById(sight.categoryId);

      return sight;
    });

    _category = Future.value(null);
  }

  // Загружает информацию о категории.
  void _loadCategory(int categoryId) {
    _category = Mocks.of(context).categoryById(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width - commonPadding.horizontal,
      child: AspectRatio(
        aspectRatio: cardAspectRatio,
        child: Card(
          child: LoadableData<Sight>(
            future: _sight,
            error: (context, error) => Failed(
              error.toString(),
              onRepeat: () => setState(_loadSight),
            ),
            builder: (context, done, sight) => Stack(
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
                          builder: (context) =>
                              SightDetails(sightId: widget.sightId),
                        ));
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
                mocks.isFavorite(widget.sightId)
                    ? Svg24.heartFull
                    : Svg24.heart,
                textStyle.color!, () {
              Mocks.of(context).toggleFavorite(widget.sightId);
            }),
          if (widget.type == SightCardType.favorites) ...[
            _buildSignatureButton(Svg24.calendar, color, () {
              print('Schedule');
            }),
            _buildSignatureButton(Svg24.close, color, () {
              Mocks.of(context).removeFromFavorite(widget.sightId);
            }),
          ],
          if (widget.type == SightCardType.visited) ...[
            _buildSignatureButton(Svg24.share, color, () {
              print('Share');
            }),
            _buildSignatureButton(Svg24.close, color, () {
              Mocks.of(context).removeFromVisited(widget.sightId);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSignatureCategory(TextStyle textStyle, Sight? sight) =>
      LoadableData<Category>(
        future: _category,
        error: (context, error) => Padding(
          padding: cardSignaturesPadding2,
          child: SvgButton(
            Svg24.refresh,
            color: textStyle.color,
            highlightColor: highlightColorDark2,
            splashColor: splashColorDark2,
            onPressed: () => setState(() {
              _loadCategory(sight!.categoryId);
            }),
          ),
        ),
        loader: (_) => Padding(
          padding: cardSignaturesPadding2,
          child: Center(
            child: SmallLoader(color: textStyle.color),
          ),
        ),
        builder: (context, done, category) => category == null
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
                  print('Filter by category');
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
