import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/bloc/place/place_bloc.dart';
import 'package:places/bloc/favorite/favorite_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_details.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/utils/map.dart';
import 'package:places/utils/date.dart';

import 'cupertino_date_select.dart';
import 'loadable_image.dart';
import 'svg_button.dart';

/// Карточка места.
class PlaceCard extends StatefulWidget {
  const PlaceCard({
    Key? key,
    required this.place,
    required this.cardType,
    this.onLongPress,
    this.onClose,
    this.go,
  }) : super(key: key);

  /// Информация о месте.
  final Place place;

  /// Тип карточки.
  final Favorite cardType;

  /// Обратный вызов для реализации перемещения карточек.
  final void Function()? onLongPress;

  /// Обрытный выхов для закрытия карточки.
  final void Function()? onClose;

  /// Дополнительная кнопка для навигации.
  final void Function()? go;

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return BlocProvider<PlaceBloc>(
      create: (_) => PlaceBloc(context.read<PlaceInteractor>(), widget.place),
      child: BlocBuilder<PlaceBloc, PlaceState>(
          builder: (context, state) => widget.cardType == Favorite.no
              ? _buildCard(context, theme, state.place)
              : Stack(
                  children: [
                    Container(),
                    Center(
                      child: Dismissible(
                        key: ValueKey(state.place.id),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          if (widget.cardType == Favorite.wishlist) {
                            context.read<WishlistBloc>().add(
                                direction == DismissDirection.startToEnd
                                    ? FavoriteMoveToAdjacentList(state.place)
                                    : FavoriteRemove(state.place));
                          } else {
                            context.read<VisitedBloc>().add(
                                direction == DismissDirection.startToEnd
                                    ? FavoriteRemove(state.place)
                                    : FavoriteMoveToAdjacentList(state.place));
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
                        secondaryBackground:
                            widget.cardType == Favorite.wishlist
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
                        child: _buildCard(context, theme, state.place),
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget _buildCard(BuildContext context, MyThemeData theme, Place place) =>
      Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCardTop(place),
                _buildCardBottom(theme, place),
              ],
            ),
            // Поверх карточки невидимая кнопка
            MaterialButton(
              padding: EdgeInsets.zero,
              highlightColor: theme.app.highlightColor,
              splashColor: theme.app.splashColor,
              onLongPress: widget.onLongPress,
              onPressed: () => _gotoPlaceDetails(context, place),
              child: _buildSignatures(context, theme, place),
            ),
            if (widget.go != null) _buildGo(theme),
          ],
        ),
      );

  Positioned _buildGo(MyThemeData theme) => Positioned(
        right: commonSpacing1_2,
        bottom: commonSpacing1_2,
        child: MaterialButton(
          elevation: 0,
          minWidth: standartButtonHeight,
          height: standartButtonHeight,
          padding: EdgeInsets.zero,
          color: theme.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(standartButtonRadius),
          ),
          onPressed: widget.go,
          child: SvgPicture.asset(
            Svg24.go,
            color: theme.textBold14White.color,
          ),
        ),
      );

  Widget _buildCardTop(Place place) {
    final url = place.photos.isEmpty ? null : place.photos[0];

    return Expanded(
      flex: 3,
      child: Hero(
        tag: url ?? '',
        child: Stack(
          children: [
            Positioned.fill(
              child: url == null ? const SizedBox() : LoadableImage(url: url),
            ),
            Positioned.fill(
              child: Container(
                color: highlightColorDark2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatures(
      BuildContext context, MyThemeData theme, Place place) {
    final textStyle = theme.textBold14White;
    final color = textStyle.color!;

    final signatures = <Widget>[];
    if (widget.cardType == Favorite.no) {
      signatures.add(
        _buildSignatureButton(
          place.userInfo.favorite == Favorite.wishlist ||
                  place.userInfo.favorite == Favorite.visited
              ? Svg24.heartFull
              : Svg24.heart,
          color,
          () => context.read<PlaceBloc>().add(const PlaceToggleWishlist()),
        ),
      );
    } else if (widget.cardType == Favorite.wishlist) {
      signatures.add(
        _buildSignatureButton(
          Svg24.calendar,
          place.userInfo.planToVisit == null ? color : theme.accentColor,
          () => _setDate(context, place),
        ),
      );
    } else if (widget.cardType == Favorite.visited) {
      signatures.add(
        _buildSignatureButton(
          Svg24.share,
          color,
          () => print('Share'),
        ),
      );
    }

    if (widget.onClose != null) {
      signatures
          .add(_buildSignatureButton(Svg24.close, color, widget.onClose!));
    }

    return Container(
      alignment: Alignment.topLeft,
      padding: cardSignaturesPadding,
      child: Row(
        children: [
          _buildSignaturePlaceType(context, textStyle, place),
          const Spacer(),
          ...signatures,
        ],
      ),
    );
  }

  Widget _buildSignaturePlaceType(
          BuildContext context, TextStyle textStyle, Place place) =>
      Padding(
        padding: commonPaddingLR,
        child: Text(
          PlaceTypeUi(place.type).lowerCaseName,
          style: textStyle,
        ),
      );

  Widget _buildSignatureButton(
          String svg, Color color, void Function() onPressed) =>
      AnimatedSwitcher(
        duration: standartAnimationDuration,
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        child: SvgButton(
          svg,
          key: ValueKey(svg.hashCode ^ color.hashCode),
          highlightColor: highlightColorDark2,
          splashColor: splashColorDark2,
          color: color,
          onPressed: onPressed,
        ),
      );

  Widget _buildCardBottom(MyThemeData theme, Place place) => Expanded(
        flex: 2,
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.white, Color(0xFF808080), Colors.black],
            stops: [0.0, 0.6, 1.0],
          ).createShader(Rect.fromLTRB(
            bounds.left,
            bounds.bottom - commonSpacing * 3,
            bounds.right,
            bounds.bottom,
          )),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              commonSpacing,
              commonSpacing1_2,
              commonSpacing + (widget.go == null ? 0 : standartButtonHeight),
              commonSpacing1_2,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: theme.textMiddle16Main,
                      ),
                    ),
                    const SizedBox(width: commonSpacing1_2),
                    Text(
                      '${place.distance ?? '-'}',
                      style: theme.textRegular14Light,
                    ),
                  ],
                ),
                const SizedBox(height: commonSpacing1_2),
                Text(
                  place.description,
                  style: theme.textRegular14Light,
                ),
              ],
            ),
          ),
        ),
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

  void _gotoPlaceDetails(BuildContext context, Place place) {
    standartNavigatorPush<Place>(context, () => PlaceDetails(place));
  }

  Future<void> _setDate(BuildContext context, Place place) async {
    final today = Date.today();
    final yesterday = Date.yesterday();
    var date = place.userInfo.planToVisit;

    date = Platform.isIOS
        ? await showCupertinoDatePicker(
            context: context,
            initialDate: date ?? today,
            firstDate: date != null && date.isBefore(today) ? date : yesterday,
          )
        : await showDatePicker(
            context: context,
            initialDate: date ?? today,
            firstDate: date != null && date.isBefore(today) ? date : yesterday,
            lastDate: DateTime(today.year + 10, 12, 31),
          );

    // Не знаю, как удалить дату. Как временное решение - удаляю, если дата
    // посещения установлена в прошлом.
    if (date != null) {
      print('date: $date');
      final userInfo = date.isBefore(today)
          ? place.userInfo.copyWith(planToVisitReset: true)
          : place.userInfo.copyWith(planToVisit: date);

      context.read<PlaceBloc>().add(PlaceUpdateUserInfo(userInfo));
    }
  }
}
