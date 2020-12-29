import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/sight.dart';
import '../../mocks.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/loadable_image.dart';
import '../widget/my_theme.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';
import 'sight_screen.dart';

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
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final sight = context.read<Mocks>()[widget.sightId];

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

    final sight = context.watch<Mocks>()[widget.sightId];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGallery(theme, sight),
            Padding(
              padding: detailsPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ..._buildText(theme, sight),
                  ..._buildButtons(),
                  ..._buildEditButton(sight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(MyThemeData theme, Sight sight) => SizedBox(
        height: detailsImageSize,
        child: sight.photos.isEmpty
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

  List<Widget> _buildText(MyThemeData theme, Sight sight) => [
        Text(
          sight.name,
          style: theme.textBold24Main,
        ),
        Row(
          children: [
            Text(
              sight.category.text,
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
          sight.details,
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

  List<Widget> _buildEditButton(Sight sight) => [
        const SizedBox(height: commonSpacing1_2),
        const Divider(height: 2),
        const SizedBox(height: commonSpacing3_2),
        StandartButton(
          label: stringEdit,
          onPressed: () {
            Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => SightScreen(sight: sight),
                ));
            // if (newSight != null) {
            //   setState(() {
            //     _sight = newSight;
            //     _changed = true;
            //     // Обновляем tabController. Для этого нужно, чтобы
            //     // виджет был наследником TickerProviderStateMixin,
            //     // а не SingleTickerProviderStateMixin.
            //     _tabController.dispose();
            //     _tabController = TabController(
            //       length: _sight.photos.length,
            //       vsync: this,
            //     );
            //   });
            // }
          },
        )
      ];
}
