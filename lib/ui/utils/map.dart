import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:url_launcher/url_launcher.dart';

/// Запускает внешнее приложение (выбирается из списка) для построения маршрута
/// к месту.
Future<void> gotoPlace(BuildContext context, Place place) async {
  final availableMaps = await MapLauncher.installedMaps;
  final index =
      availableMaps.indexWhere((e) => e.mapType == MapType.yandexMaps);
  if (index == -1) {
    // Яндекс.Карты есть всегда (через браузер).
    availableMaps.add(
      AvailableMap(
        mapName: 'Yandex Maps',
        mapType: MapType.yandexMaps,
        icon: 'packages/map_launcher/assets/icons/yandexMaps.svg',
      ),
    );
  }

  await showModalBottomSheet<void>(
    context: context,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(commonSpacing3_4),
      ),
    ),
    builder: (context) => _Maps(availableMaps: availableMaps, place: place),
  );
}

class _Maps extends StatelessWidget {
  const _Maps({
    Key? key,
    required this.availableMaps,
    required this.place,
  }) : super(key: key);

  final List<AvailableMap> availableMaps;

  final Place place;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: commonSpacing1_2,
          ),
          shrinkWrap: true,
          children: [
            for (final map in availableMaps)
              ListTile(
                title: Text(map.mapName),
                leading: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(commonSpacing1_2),
                  ),
                  child: SvgPicture.asset(
                    map.icon,
                    height: mapIconSize,
                    width: mapIconSize,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  // Яндекс.Карты запускаем по возможности через браузер.
                  // Если есть приложение, то запустится через него, но
                  // только 5 раз в день, т.к. нужен API KEY, который они
                  // просто так не дают.
                  if (map.mapType == MapType.yandexMaps) {
                    final url = 'https://yandex.ru/maps/'
                        '?rtext=~${place.coord.lat},${place.coord.lon}';
                    if (await canLaunch(url)) await launch(url);
                  } else {
                    await map.showDirections(
                      destination: Coords(place.coord.lat, place.coord.lon),
                      destinationTitle: place.name,
                      directionsMode: DirectionsMode.walking,
                    );
                  }
                },
              ),
          ],
        ),
      );
}
