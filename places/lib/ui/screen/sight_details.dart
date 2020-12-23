/// Экран детализации места.

import 'package:flutter/material.dart';

import '../../domain/sight.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/loadable_image.dart';
import '../widget/my_theme.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';

class SightDetails extends StatefulWidget {
  final Sight sight;

  const SightDetails({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  _SightDetailsState createState() => _SightDetailsState();
}

class _SightDetailsState extends State<SightDetails> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MyThemeData.detailsImageSize,
              child: LoadableImage(url: widget.sight.url),
            ),
            Padding(
              padding: MyThemeData.detailsPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.sight.name,
                    style: theme.textBold24Main,
                  ),
                  const SizedBox(
                    height: MyThemeData.detailsTitleSpacing,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.sight.type.text,
                        style: theme.textBold14Light,
                      ),
                      const SizedBox(
                        width: MyThemeData.detailsHoursSpacing,
                      ),
                      Text(
                        'закрыто до 09:00', // Временно
                        style: theme.textRegular14Light,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: MyThemeData.detailsCommonSpacing,
                  ),
                  Text(
                    widget.sight.details,
                    style: theme.textRegular14Light,
                  ),
                  const SizedBox(
                    height: MyThemeData.detailsCommonSpacing,
                  ),
                  StandartButton(
                    svg: assetRoute,
                    label: stringBuildRoute,
                    onPressed: () {
                      print('Строим маршрут');
                    },
                  ),
                  const SizedBox(
                    height: MyThemeData.detailsCommonSpacing,
                  ),
                  const Divider(
                    height: 0,
                  ),
                  const SizedBox(
                    height: MyThemeData.detailsFooterSpacing,
                  ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
