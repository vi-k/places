import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/loadable_image.dart';
import '../widget/my_theme.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';
import 'sight_screen.dart';

/// Экран детализации места.
class SightDetails extends StatefulWidget {
  final Sight sight;

  const SightDetails({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  _SightDetailsState createState() => _SightDetailsState();
}

class _SightDetailsState extends State<SightDetails>
    with TickerProviderStateMixin {
  late Sight _sight;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _sight = widget.sight;

    _tabController = TabController(
      length: _sight.photos.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Перехватываем возврат, чтобы передать sight, т.к. он мог
          // измениться.
          Navigator.pop(context, _sight);
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGallery(theme),
              Padding(
                padding: detailsPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ..._buildText(theme),
                    ..._buildButtons(),
                    ..._buildEditButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(MyThemeData theme) => SizedBox(
        height: detailsImageSize,
        child: _sight.photos.isEmpty
            ? Center(
                child: Text(
                  'Нет фотографий',
                  style: theme.textRegular16Light56,
                ),
              )
            : TabBarView(
                controller: _tabController,
                children: [
                  for (final url in _sight.photos)
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
  List<Widget> _buildText(MyThemeData theme) => [
        Text(
          _sight.name,
          style: theme.textBold24Main,
        ),
        Row(
          children: [
            Text(
              _sight.category.text,
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
          _sight.details,
          style: theme.textRegular14Light,
        ),
        const SizedBox(height: commonSpacing3_2),
      ];

  List<Widget> _buildButtons() => [
        StandartButton(
          svg: assetRoute,
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
              svg: assetCalendar,
              label: stringToSchedule,
            ),
            SmallButton(
              onPressed: () => print('В Избранное'),
              svg: assetFavorite,
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
            Navigator.push<Sight>(
                context,
                MaterialPageRoute(
                  builder: (context) => SightScreen(sight: widget.sight),
                )).then((value) => setState(() {
                  if (value != null) {
                    _sight = value;
                    // Обновляем tabController. Для этого нужно, чтобы
                    // виджет был наследником TickerProviderStateMixin,
                    // а не SingleTickerProviderStateMixin.
                    _tabController.dispose();
                    _tabController = TabController(
                      length: _sight.photos.length,
                      vsync: this,
                    );
                  }
                }));
          },
        )
      ];
}
