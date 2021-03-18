import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/screen/place_details.dart';
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
  late Place place;

  @override
  void initState() {
    super.initState();

    place = widget.place;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: commonSpacing,
            vertical: commonSpacing1_2,
          ),
          child: Row(
            children: [
              if (place.photos.isEmpty)
                const SizedBox(width: photoCardSize, height: photoCardSize)
              else
                PhotoCard(url: place.photos[0]),
              const SizedBox(width: commonSpacing),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      style: theme.textRegular14Main,
                    ),
                    const SizedBox(height: commonSpacing1_2),
                    Text(
                      '${PlaceTypeUi(place.type).name}, ${place.distance}',
                      maxLines: 1,
                      style: theme.textRegular14Light,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: MaterialButton(
            padding: EdgeInsets.zero,
            highlightColor: theme.app.highlightColor,
            splashColor: theme.app.splashColor,
            onPressed: () async {
              final newPlace =
                  await PlaceDetails.showAsModalBottomSheet(context, place);
              if (newPlace != null) {
                place = newPlace;
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }
}
