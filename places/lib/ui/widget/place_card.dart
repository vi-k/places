import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place.dart';
import 'package:places/main.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_details.dart';

import 'cupertino_date_select.dart';
import 'loadable_image.dart';
import 'loader.dart';
import 'small_button.dart';
import 'svg_button.dart';

/// Карточка места.
class PlaceCard extends StatefulWidget {
  const PlaceCard({
    Key? key,
    required this.place,
    required this.cardType,
    this.onLongPress,
  }) : super(key: key);

  /// Информация о месте.
  final Place place;

  /// Тип карточки.
  final Favorite cardType;

  /// Обратный вызов для реализации перемещения карточек.
  final void Function()? onLongPress;

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  late Place place;

  @override
  void initState() {
    super.initState();

    place = widget.place;
  }

  Future<void> _updatePlace(
    Future<Place> Function(PlaceBase place) action, {
    bool delete = false,
  }) async {
    final newPlace = await action(place);

    if (delete) {
      final list = Loader.of<List<Place>>(context).data;
      if (list != null) list.remove(place);
      place = newPlace;
      Loader.of<List<Place>>(context).update();
    } else {
      setState(() {
        place = newPlace;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return widget.cardType == Favorite.no
        ? _buildCard(theme)
        : Stack(
            children: [
              Container(),
              Center(
                child: Dismissible(
                  key: ValueKey(place.id),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (widget.cardType == Favorite.wishlist) {
                      _updatePlace(
                          direction == DismissDirection.startToEnd
                              ? (place) async {
                                  final removedPlace = await placeInteractor
                                      .removeFromWishlist(place);
                                  return await placeInteractor
                                      .addToVisited(removedPlace);
                                }
                              : placeInteractor.removeFromWishlist,
                          delete: true);
                    } else {
                      _updatePlace(
                          direction == DismissDirection.startToEnd
                              ? placeInteractor.removeFromVisited
                              : (place) async {
                                  final removedPlace = await placeInteractor
                                      .removeFromVisited(place);
                                  return await placeInteractor
                                      .addToWishlist(removedPlace);
                                },
                          delete: true);
                    }
                  },
                  background: widget.cardType == Favorite.wishlist
                      ? _buildBackground(theme,
                          color: theme.accentColor,
                          svg: Svg24.tick,
                          label: stringToVisited,
                          alignment: Alignment.centerLeft)
                      : _buildBackground(theme,
                          color: theme.attentionColor,
                          svg: Svg24.bucket,
                          label: stringDeleteFromVisited,
                          alignment: Alignment.centerLeft),
                  secondaryBackground: widget.cardType == Favorite.wishlist
                      ? _buildBackground(theme,
                          color: theme.attentionColor,
                          svg: Svg24.bucket,
                          label: stringDeleteFromWishlist,
                          alignment: Alignment.centerRight)
                      : _buildBackground(theme,
                          color: theme.accentColor,
                          svg: Svg24.heart,
                          label: stringToWishlist,
                          alignment: Alignment.centerRight),
                  child: _buildCard(theme),
                ),
              ),
            ],
          );
  }

  Widget _buildCard(MyThemeData theme) => Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardTop(),
                _buildCardBottom(theme),
              ],
            ),
            // Поверх карточки невидимая кнопка
            MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: theme.app.highlightColor,
              splashColor: theme.app.splashColor,
              onLongPress: widget.onLongPress,
              onPressed: () async {
                // Внутри showModalBottomSheet
                // MediaQuery.of(context).padding.top возвращает 0.
                // Поэтому рассчитываем здесь.
                final maxHeight = MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    appBarPadding.top;
                final newPlace = await showModalBottomSheet<Place>(
                  context: context,
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) => ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight,
                    ),
                    child: PlaceDetails(place: place),
                  ),
                );

                if (newPlace != null) {
                  setState(() {
                    place = newPlace;
                  });
                }
              },
              child: _buildSignatures(theme),
            ),
          ],
        ),
      );

  Widget _buildCardTop() => Expanded(
        child: Stack(
          children: [
            Positioned.fill(
              child: LoadableImage(
                url: place.photos.isEmpty ? '' : place.photos[0],
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

  Widget _buildSignatures(MyThemeData theme) {
    final textStyle = theme.textBold14White;
    final color = textStyle.color!;

    final signatures = <Widget>[];
    if (widget.cardType == Favorite.no) {
      signatures
        ..add(
          _buildSignatureButton(
            place.userInfo.favorite == Favorite.wishlist
                ? Svg24.heartFull
                : Svg24.heart,
            color,
            () => _updatePlace(placeInteractor.toggleWishlist),
          ),
        )
        ..add(
          _buildSignatureButton(
            Svg24.close,
            color,
            () => _updatePlace(
              (_) async {
                await placeInteractor.removePlace(place.id);
                return place;
              },
              delete: true,
            ),
          ),
        );
    }

    if (widget.cardType == Favorite.wishlist) {
      signatures
        ..add(
          _buildSignatureButton(
            Svg24.calendar,
            place.userInfo.planToVisit == null ? color : theme.accentColor,
            () async {
              final today = DateTime.now();
              var date = place.userInfo.planToVisit;

              date = Platform.isIOS
                  ? await showCupertinoDatePicker(
                      context: context,
                      initialDate: date ?? today,
                      firstDate:
                          date != null && date.isBefore(today) ? date : today,
                    )
                  : await showDatePicker(
                      context: context,
                      initialDate: date ?? today,
                      firstDate:
                          date != null && date.isBefore(today) ? date : today,
                      lastDate: DateTime(today.year + 10, 12, 31),
                    );

              if (date != null) {
                final userInfo = place.userInfo.copyWith(planToVisit: date);
                await _updatePlace(
                    (place) => placeInteractor.updateUserInfo(place, userInfo));
              }
            },
          ),
        )
        ..add(
          _buildSignatureButton(
            Svg24.close,
            color,
            () =>
                _updatePlace(placeInteractor.removeFromWishlist, delete: true),
          ),
        );
    }

    if (widget.cardType == Favorite.visited) {
      signatures
        ..add(
          _buildSignatureButton(
            Svg24.share,
            color,
            () => print('Share'),
          ),
        )
        ..add(
          _buildSignatureButton(
            Svg24.close,
            color,
            () => _updatePlace(placeInteractor.addToWishlist, delete: true),
          ),
        );
    }

    return Container(
      alignment: Alignment.topLeft,
      padding: cardSignaturesPadding,
      child: Row(
        children: [
          _buildSignaturePlaceType(textStyle),
          const Spacer(),
          ...signatures,
        ],
      ),
    );
  }

  Widget _buildSignaturePlaceType(TextStyle textStyle) => SmallButton(
        highlightColor: highlightColorDark2,
        splashColor: splashColorDark2,
        label: PlaceTypeUi(place.type).lowerCaseName,
        style: textStyle,
        onPressed: () {
          filter = filter.copyWith(placeTypes: {place.type});
          Loader.of<List<Place>>(context).reload();
        },
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

  Widget _buildCardBottom(MyThemeData theme) => Expanded(
        child: Container(
            padding: commonPadding,
            child: RichText(
              overflow: TextOverflow.fade,
              maxLines: null,
              text: TextSpan(
                text: '${place.name}\n',
                style: theme.textMiddle16Main,
                children: [
                  TextSpan(
                    text: '${place.distance}\n${place.description}',
                    style: theme.textRegular14Light,
                  ),
                ],
              ),
            )),
      );

  Widget _buildBackground(
    MyThemeData theme, {
    required Color color,
    required String svg,
    required String label,
    required Alignment alignment,
  }) {
    final textStyle = theme.textMiddle12White;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: commonSpacing),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(commonSpacing),
          ),
        ),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: commonPadding,
            child: SizedBox(
              width: commonSpacing3_2 * 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    svg,
                    color: textStyle.color,
                  ),
                  const SizedBox(height: commonSpacing1_2),
                  Text(
                    label,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
