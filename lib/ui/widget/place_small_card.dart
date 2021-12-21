import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_details.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/widget/photo_card.dart';

/// Карточка места для экрана поиска.
class PlaceSmallCard extends StatefulWidget {
  const PlaceSmallCard({
    Key? key,
    required this.place,
  }) : super(key: key);

  final Place place;

  @override
  _PlaceSmallCardState createState() => _PlaceSmallCardState();
}

class _PlaceSmallCardState extends State<PlaceSmallCard> {
  late MyThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: commonSpacing,
            vertical: commonSpacing1_2,
          ),
          child: Row(
            children: [
              _buildPhoto(),
              const SizedBox(width: commonSpacing),
              _buildTile(),
            ],
          ),
        ),
        Positioned.fill(
          child: MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              standartNavigatorPush<Place>(
                context,
                () => PlaceDetails(widget.place),
              );
            },
          ),
        ),
      ],
    );
  }

  Expanded _buildTile() => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.place.name,
              maxLines: 1,
              style: _theme.textRegular14Main,
            ),
            const SizedBox(height: commonSpacing1_2),
            Text(
              '${PlaceTypeUi(widget.place.type).name}, '
              '${widget.place.distance}',
              maxLines: 1,
              style: _theme.textRegular14Light,
            ),
          ],
        ),
      );

  Widget _buildPhoto() => SizedBox(
        width: photoCardSize,
        height: photoCardSize,
        child: widget.place.photos.isEmpty
            ? null
            : Hero(
                tag: widget.place.photos[0],
                child: PhotoCard(url: widget.place.photos[0]),
              ),
      );
}
