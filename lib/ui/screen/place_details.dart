import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/bloc/place/place_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/utils/map.dart';
import 'package:places/ui/widget/loadable_image.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';

import 'place_edit_screen.dart';

/// Экран детализации места.
class PlaceDetails extends StatefulWidget {
  const PlaceDetails(
    this.place, {
    Key? key,
  }) : super(key: key);

  /// Идентификатор места.
  final Place place;

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return BlocProvider<PlaceBloc>(
      create: (_) => PlaceBloc(context.read<PlaceInteractor>(), widget.place),
      child: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) => Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, state.place);

              return false;
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: _buildBack(theme, state.place),
                  backgroundColor: theme.backgroundFirst,
                  expandedHeight:
                      detailsImageSize - MediaQuery.of(context).padding.top,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _Gallery(state.place),
                  ),
                ),
                SliverPadding(
                  padding: commonPaddingLR,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ..._buildText(theme, state.place),
                      ..._buildButtons(context, state.place),
                      ..._buildEditButton(context, state.place),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBack(MyThemeData theme, Place place) => Center(
        child: SizedBox(
          width: verySmallButtonHeight,
          height: verySmallButtonHeight,
          child: MaterialButton(
            padding: EdgeInsets.zero,
            color: theme.backgroundFirst,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(textFieldRadius),
            ),
            onPressed: () => Navigator.pop(context, place),
            child: SvgPicture.asset(
              Svg24.back,
              color: theme.mainTextColor2,
            ),
          ),
        ),
      );

  List<Widget> _buildText(MyThemeData theme, Place place) => [
        const SizedBox(height: commonSpacing3_2),
        Text(
          place.name,
          style: theme.textBold24Main,
        ),
        const SizedBox(height: dividerHeight),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              PlaceTypeUi(place.type).lowerCaseName,
              style: theme.textBold14Light,
            ),
            const SizedBox(width: commonSpacing),
            Text(
              '${place.distance}',
              style: theme.textRegular14Light,
            ),
          ],
        ),
        const SizedBox(height: commonSpacing3_2),
        Text(
          place.description,
          style: theme.textRegular14Light,
        ),
        const SizedBox(height: commonSpacing3_2),
      ];

  List<Widget> _buildButtons(BuildContext context, Place place) => [
        StandartButton(
          svg: Svg24.go,
          label: stringBuildRoute,
          onPressed: () => gotoPlace(context, place),
        ),
        const SizedBox(height: commonSpacing3_2),
        const Divider(height: dividerHeight),
        const SizedBox(height: commonSpacing1_2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SmallButton(
              svg: Svg24.calendar,
              label: stringToSchedule,
            ),
            SmallButton(
              onPressed: () =>
                  context.read<PlaceBloc>().add(const PlaceWishlistToggled()),
              svg: place.userInfo.favorite == Favorite.wishlist ||
                      place.userInfo.favorite == Favorite.visited
                  ? Svg24.heartFull
                  : Svg24.heart,
              label: stringToFavorite,
            ),
          ],
        ),
      ];

  List<Widget> _buildEditButton(BuildContext context, Place place) => [
        const SizedBox(height: commonSpacing1_2),
        const Divider(height: dividerHeight),
        const SizedBox(height: commonSpacing3_2),
        StandartButton(
          label: stringEdit,
          onPressed: () => PlaceEditScreen.start(context, place.id),
        ),
        const SizedBox(height: commonSpacing3_2),
      ];
}

class _Gallery extends StatefulWidget {
  const _Gallery(
    this.place, {
    Key? key,
  }) : super(key: key);

  final Place place;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  late final PageController _controller = PageController()
    ..addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0;
      });
    });

  var _currentPage = 0.0;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;
    final place = widget.place;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: detailsImageSize,
      child: place.photos.isEmpty
          ? Center(
              child: Text(
                stringNoPhotos,
                style: theme.textRegular16Light56,
              ),
            )
          : Stack(
              children: [
                PageView(
                  controller: _controller,
                  children: [
                    for (final url in place.photos)
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Hero(
                          tag: url,
                          flightShuttleBuilder: standartFlightShuttleBuilder,
                          child: LoadableImage(
                            url: url,
                          ),
                        ),
                      ),
                  ],
                ),
                if (place.photos.length > 1)
                  Positioned(
                    bottom: 0,
                    left: _currentPage * screenWidth / place.photos.length -
                        commonSpacing1_2,
                    child: Container(
                      height: commonSpacing1_2,
                      width: screenWidth / place.photos.length + commonSpacing,
                      decoration: BoxDecoration(
                        color: theme.mainTextColor2,
                        borderRadius: BorderRadius.circular(commonSpacing1_2),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
