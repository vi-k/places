import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/themes.dart';

import 'place_card.dart';

/// Список карточек.
class PlaceCardGrid extends StatefulWidget {
  const PlaceCardGrid({
    Key? key,
    required this.places,
    required this.cardType,
    this.asSliver = false,
  }) : super(key: key);

  /// Список мест.
  final List<Place>? places;

  /// Тип карточки.
  final Favorite cardType;

  /// Встроить в CustomView как sliver.
  final bool asSliver;

  @override
  _PlaceCardGridState createState() => _PlaceCardGridState();
}

class _PlaceCardGridState extends State<PlaceCardGrid> {
  // bool _draggableMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;
    final places = widget.places;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final columnsCount = aspectRatio <= 4 / 5
        ? 1
        : aspectRatio <= 5 / 4
            ? 2
            : 3;

    return widget.asSliver
        ? _buildSliverGrid(theme, columnsCount, places)
        : CustomScrollView(
            slivers: [
              _buildSliverGrid(theme, columnsCount, places),
            ],
          );
  }

  SliverGrid _buildSliverGrid(
          MyThemeData theme, int columnsCount, List<Place>? places) =>
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 2,
          crossAxisCount: columnsCount,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final place = places![index];
            return Padding(
                padding: commonPaddingLBR,
                child: PlaceCard(
                    key: ValueKey(place.id),
                    place: place,
                    cardType: widget.cardType));
          },
          childCount: places?.length ?? 0,
        ),
      );
}
