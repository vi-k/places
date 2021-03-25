import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/bloc/place_bloc.dart';
import 'package:places/bloc/places_bloc.dart';
import 'package:places/bloc/wishlist_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_details.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/utils/hero_tags.dart';
import 'package:places/ui/widget/small_button.dart';

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
                                    ? WishlistMoveToAdjacentList(state.place)
                                    : WishlistRemove(state.place));
                          } else {
                            context.read<WishlistBloc>().add(
                                direction == DismissDirection.startToEnd
                                    ? WishlistRemove(state.place)
                                    : WishlistMoveToAdjacentList(state.place));
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
          ],
        ),
      );

  Widget _buildCardTop(Place place) => Expanded(
        child: Hero(
          tag: heroPlaceTag(place),
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
        ),
      );

  Widget _buildSignatures(
      BuildContext context, MyThemeData theme, Place place) {
    final textStyle = theme.textBold14White;
    final color = textStyle.color!;

    final signatures = <Widget>[];
    if (widget.cardType == Favorite.no) {
      signatures
        ..add(
          _buildSignatureButton(
            place.userInfo.favorite == Favorite.wishlist ||
                    place.userInfo.favorite == Favorite.visited
                ? Svg24.heartFull
                : Svg24.heart,
            color,
            () => context.read<PlaceBloc>().add(const PlaceToggleWishlist()),
          ),
        )
        ..add(
          _buildSignatureButton(Svg24.close, color, () async {
            final doDelete = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(stringDoDelete),
                    actions: [
                      SmallButton(
                        label: stringCancel,
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      SmallButton(
                        label: stringYes,
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (doDelete) {
              context.read<PlacesBloc>().add(PlacesRemove(place));
            }
          }),
          // () {}),
        );
    } else if (widget.cardType == Favorite.wishlist) {
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
                context.read<PlaceBloc>().add(PlaceUpdateUserInfo(userInfo));
              }
            },
          ),
        )
        ..add(
          _buildSignatureButton(
            Svg24.close,
            color,
            () => context.read<WishlistBloc>().add(WishlistRemove(place)),
          ),
        );
    } else if (widget.cardType == Favorite.visited) {
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
            () => context
                .read<WishlistBloc>()
                .add(WishlistMoveToAdjacentList(place)),
          ),
        );
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

  Future<void> _gotoPlaceDetails(BuildContext context, Place place) async {
    final newPlace = await standartNavigatorPush<Place>(
        context, () => PlaceDetails(place: place));

    if (newPlace != null && newPlace != place) {
      context.read<PlaceBloc>().add(PlaceChanged(newPlace));
    }
  }
}
