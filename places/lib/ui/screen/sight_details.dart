import 'package:flutter/material.dart';

import '../../domain/category.dart';
import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/failed.dart';
import '../widget/loadable_data.dart';
import '../widget/loadable_image.dart';
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

class _SightDetailsState extends State<SightDetails>
    with TickerProviderStateMixin {
  late Future<Sight> _sight;
  var _category = Future<Category>.value(null);
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _loadSight();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Загружает информацию о месте.
  void _loadSight() {
    _sight = Mocks.of(context).sightById(widget.sightId).then((sight) {
      _updateTabController(sight);

      _category = Mocks.of(context).categoryById(sight.categoryId);

      return sight;
    });

    _category = Future.value(null);
  }

  // Загружает информацию о категории.
  void _loadCategory(int categoryId) {
    _category = Mocks.of(context).categoryById(categoryId);
  }

  void _updateTabController(Sight sight) {
    _tabController?.dispose();
    _tabController = TabController(
      length: sight.photos.length,
      vsync: this,
    );
    _tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      body: LoadableData<Sight>(
          future: _sight,
          error: (context, error) => Failed(
                error.toString(),
                onRepeat: () => setState(_loadSight),
              ),
          builder: (context, done, sight) => ListView(
                children: [
                  _buildGallery(theme, sight),
                  Padding(
                    padding: detailsPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ..._buildText(theme, sight),
                        ..._buildButtons(),
                        ..._buildEditButton(),
                      ],
                    ),
                  ),
                ],
              )),
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
                : TabBarView(
                    controller: _tabController,
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
      );

  List<Widget> _buildText(MyThemeData theme, Sight? sight) => [
        Text(
          sight?.name ?? '',
          style: theme.textBold24Main,
        ),
        Row(
          children: [
            LoadableData<Category>(
              future: _category,
              error: (context, error) => SvgButton(
                Svg24.refresh,
                color: theme.lightTextColor,
                onPressed: () => setState(() {
                  _loadCategory(sight!.categoryId);
                }),
              ),
              loader: (_) => Center(
                child: SmallLoader(color: theme.lightTextColor),
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

  List<Widget> _buildEditButton() => [
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
                ));
          },
        )
      ];
}
