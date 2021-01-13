import 'package:flutter/material.dart';

import '../../domain/category.dart';
import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/failed.dart';
import '../widget/loadable_image.dart';
import '../widget/loader.dart';
import '../widget/mocks.dart';
import '../widget/small_button.dart';
import '../widget/small_loader.dart';
import '../widget/standart_button.dart';
import '../widget/svg_button.dart';
import 'sight_edit_screen.dart';

/// Экран детализации места.
class SightDetails extends StatefulWidget {
  const SightDetails({
    Key? key,
    required this.sightId,
  }) : super(key: key);

  final int sightId;

  @override
  _SightDetailsState createState() => _SightDetailsState();
}

class _SightDetailsState extends State<SightDetails> {
  var _modified = false;
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

    return Scaffold(
      body: WillPopScope(
        // Перехватываем `pop`, чтобы передать значение.
        onWillPop: () async {
          Navigator.pop(context, _modified);
          return false;
        },
        child: Loader<Sight>(
            load: () => Mocks.of(context).sightById(widget.sightId),
            error: (context, error) => Failed(
                  error.toString(),
                  onRepeat: () => Loader.of<Sight>(context).reload(),
                ),
            builder: (context, state, sight) => ListView(
                  children: [
                    _buildGallery(theme, sight),
                    Padding(
                      padding: detailsPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ..._buildText(theme, sight),
                          ..._buildButtons(),
                          ..._buildEditButton(context),
                        ],
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  Widget _buildGallery(MyThemeData theme, Sight? sight) => SizedBox(
        height: detailsImageSize,
        child: sight == null
            ? null
            : sight.photos.isEmpty
                ? Center(
                    child: Text(
                      'Нет фотографий',
                      style: theme.textRegular16Light56,
                    ),
                  )
                : Stack(
                    children: [
                      PageView(
                        controller: _controller,
                        //physics: const BouncingScrollPhysics(),
                        children: [
                          for (final url in sight.photos)
                            Tab(
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: LoadableImage(
                                  url: url,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (sight.photos.length > 1)
                        Positioned(
                          bottom: 0,
                          left: _currentPage *
                                  MediaQuery.of(context).size.width /
                                  sight.photos.length -
                              commonSpacing1_2,
                          child: Container(
                            height: commonSpacing1_2,
                            width: MediaQuery.of(context).size.width /
                                    sight.photos.length +
                                commonSpacing,
                            decoration: BoxDecoration(
                              color: theme.mainTextColor2,
                              borderRadius:
                                  BorderRadius.circular(commonSpacing1_2),
                            ),
                          ),
                        ),
                    ],
                  ),
      );

  List<Widget> _buildText(MyThemeData theme, Sight? sight) => [
        Text(
          sight?.name ?? '',
          style: theme.textBold24Main,
        ),
        Row(
          children: [
            Loader<Category>(
              tag: sight?.categoryId,
              load: sight == null
                  ? null
                  : () => Mocks.of(context).categoryById(sight.categoryId),
              loader: (_) => Center(
                child: SmallLoader(color: theme.lightTextColor),
              ),
              error: (context, error) => SvgButton(
                Svg24.refresh,
                color: theme.lightTextColor,
                onPressed: () => Loader.of<Category>(context).reload(),
              ),
              builder: (context, done, category) => category == null
                  ? const SizedBox(
                      height: smallButtonHeight,
                      width: smallButtonHeight,
                    )
                  : Text(
                      category.name,
                      style: theme.textBold14Light,
                    ),
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
          sight?.details ?? '',
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
        const Divider(height: 2),
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
        const Divider(height: 2),
        const SizedBox(height: commonSpacing3_2),
        StandartButton(
          label: stringEdit,
          onPressed: () {
            Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SightEditScreen(sightId: widget.sightId),
                )).then((value) {
              if (value != null) {
                _modified = true;
                Loader.of<Sight>(context).reload();
              }
            });
          },
        )
      ];
}
