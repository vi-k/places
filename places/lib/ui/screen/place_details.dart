import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/loadable_image.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';

import 'place_edit_screen.dart';

/// Экран детализации места.
class PlaceDetails extends StatefulWidget {
  const PlaceDetails({
    Key? key,
    required this.place,
  }) : super(key: key);

  /// Идентификатор места.
  final Place place;

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  // Отслеживаем изменения, чтобы уведомить вызывающую сторону о необходимости
  // обновиться.
  late Place place;
  var _modified = false;

  @override
  void initState() {
    super.initState();
    place = widget.place;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    // Перехватываем `pop`, чтобы передать значение.
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _modified ? place : null);
        return false;
      },
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: const SizedBox(), // Убираем кнопку back
                backgroundColor: theme.backgroundFirst,
                expandedHeight: detailsImageSize,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _Gallery(place),
                ),
              ),
              SliverPadding(
                padding: commonPaddingLR,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ..._buildText(theme),
                    ..._buildButtons(),
                    ..._buildEditButton(context),
                  ]),
                ),
              ),
            ],
          ),
          Container(
            height:
                commonSpacing3_4 + bottomSheetThumbHeight + commonSpacing3_4,
            color: bottomSheetThumbBackground,
            child: Center(
              child: Container(
                width: bottomSheetThumbWidth,
                height: bottomSheetThumbHeight,
                decoration: BoxDecoration(
                  color: mainColor100,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(commonSpacing1_2),
                ),
              ),
            ),
          ),
          Positioned(
            top: commonSpacing,
            right: commonSpacing,
            child: _buildClose(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(MyThemeData theme) => Center(
        child: SizedBox(
          width: verySmallButtonHeight,
          height: verySmallButtonHeight,
          child: MaterialButton(
            padding: EdgeInsets.zero,
            color: theme.backgroundFirst,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(textFieldRadius),
            ),
            onPressed: () => Navigator.pop(context, _modified),
            child: SvgPicture.asset(
              Svg24.back,
              color: theme.mainTextColor2,
            ),
          ),
        ),
      );

  Widget _buildClose(MyThemeData theme) => Center(
        child: SizedBox(
          width: smallButtonHeight,
          height: smallButtonHeight,
          child: MaterialButton(
            elevation: 0,
            padding: EdgeInsets.zero,
            color: theme.backgroundFirst,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(smallButtonHeight),
            ),
            onPressed: () => Navigator.pop(context, _modified ? place : null),
            child: SvgPicture.asset(
              Svg24.close,
              color: theme.mainTextColor2,
            ),
          ),
        ),
      );

  List<Widget> _buildText(MyThemeData theme) => [
        const SizedBox(height: commonSpacing3_2),
        Text(
          place.name,
          style: theme.textBold24Main,
        ),
        const SizedBox(height: dividerHeight),
        Row(
          children: [
            Text(
              PlaceTypeUi(place.type).lowerCaseName,
              style: theme.textBold14Light,
            ),
            const SizedBox(width: commonSpacing),
            Text(
              'закрыто до 09:00', // Временно
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

  List<Widget> _buildButtons() => [
        StandartButton(
          svg: Svg24.go,
          label: stringBuildRoute,
          onPressed: () {
            print('Строим маршрут');
          },
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
              onPressed: () => print('В Избранное'),
              svg: Svg24.heart,
              label: stringToFavorite,
            ),
          ],
        ),
      ];

  List<Widget> _buildEditButton(BuildContext context) => [
        const SizedBox(height: commonSpacing1_2),
        const Divider(height: dividerHeight),
        const SizedBox(height: commonSpacing3_2),
        StandartButton(
          label: stringEdit,
          onPressed: () async {
            final newPlace = await Navigator.push<Place>(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceEditScreen(place: place),
              ),
            );

            if (newPlace != null) {
              setState(() {
                _modified = true;
                place = newPlace;
              });
            }
          },
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
  final _controller = PageController();
  var _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
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
                        child: LoadableImage(
                          url: url,
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
