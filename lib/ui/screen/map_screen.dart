import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/bloc/places/places_bloc.dart';
import 'package:places/data/model/map_settings.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repositories/location/location_repository.dart';
import 'package:places/logger.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/utils/map.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/place_card.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';

import 'place_edit_screen.dart';
import 'search_screen.dart';

/// Карта мест.
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _googleMapController = Completer();
  late final AnimationController _placeAnimationController =
      AnimationController(
    vsync: this,
    duration: standartAnimationDuration,
    reverseDuration: standartAnimationDuration * 0.5,
  );
  late final Animation<double> _placeAnimation =
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    curve: Curves.fastOutSlowIn,
    parent: _placeAnimationController,
  ));

  Place? _lastPlace;
  CameraPosition? _lastPosition;
  BitmapDescriptor? _marker;

  PlacesBloc get bloc => context.read<PlacesBloc>();

  @override
  void initState() {
    super.initState();

    // Берём данные из MediaQuery (в initState мы не можем использовать
    // MediaQuery.of, но он нам и не нужен).
    final devicePixelRatio = context
        .findAncestorWidgetOfExactType<MediaQuery>()!
        .data
        .devicePixelRatio;

    getBytesFromAsset(
      'res/location.png',
      (markerSize * devicePixelRatio).round(),
    ).then((bytes) {
      _marker = BitmapDescriptor.fromBytes(bytes);
    });
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final initialLocation =
        context.read<LocationRepository>().lastLocation ?? initialPlace;
    final lastPlace = _lastPlace;

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (_, state) => Scaffold(
        appBar: _buildAppBar(state),
        body: Builder(
          builder: (context) => Stack(
            children: [
              GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    initialLocation.lat,
                    initialLocation.lon,
                  ),
                  zoom: 12,
                ),
                onMapCreated: (controller) {
                  _googleMapController.complete(controller);
                  _initMap();
                  // Обновляем, чтобы показать наши маркеры вместо
                  // дефолтных. Если наши вдруг загрузились позже.
                  // ignore: no-empty-block
                  setState(() {});
                },
                onCameraMove: (position) {
                  _lastPosition = position;
                },
                onCameraIdle: () {
                  if (_lastPosition != null) {
                    bloc.add(PlacesMapChanged(
                      MapSettings(
                        location: Coord(
                          _lastPosition!.target.latitude,
                          _lastPosition!.target.longitude,
                        ),
                        zoom: _lastPosition!.zoom,
                        bearing: _lastPosition!.bearing,
                        tilt: _lastPosition!.tilt,
                      ),
                    ));
                  }
                },
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                onTap: (_) => _hidePlaceCard(),
                markers: {
                  if (state.places.isReady)
                    for (final place in state.places.value)
                      Marker(
                        markerId: MarkerId('${place.id}'),
                        icon: _marker ?? BitmapDescriptor.defaultMarker,
                        position: LatLng(place.coord.lat, place.coord.lon),
                        onTap: () => _showPlaceCard(place),
                      ),
                },
                circles: {
                  if (state.filter.isReady &&
                      state.filter.value.radius.isFinite)
                    Circle(
                      circleId: const CircleId('main'),
                      radius: state.filter.value.radius.value,
                      center: LatLng(initialLocation.lat, initialLocation.lon),
                      strokeWidth: 2,
                      strokeColor: Colors.blue.withOpacity(0.5),
                      fillColor: Colors.blue.withOpacity(0.1),
                    ),
                },
              ),
              if (state is PlacesLoadInProgress)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              Positioned(
                bottom: commonSpacing,
                left: 12,
                right: 62,
                child: AnimatedBuilder(
                  animation: _placeAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _placeAnimation.value,
                    child: child,
                  ),
                  child: AspectRatio(
                    aspectRatio: cardAspectRatio,
                    child: lastPlace == null
                        ? const SizedBox()
                        : PlaceCard(
                            key: ValueKey(lastPlace.id),
                            place: lastPlace,
                            cardType: Favorite.no,
                            onClose: _hidePlaceCard,
                            go: () => gotoPlace(context, lastPlace),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _placeAnimationController.isDismissed &&
                _placeAnimationController.value == 0.0
            ? FloatingActionButton.extended(
                isExtended: true,
                onPressed: () {
                  PlaceEditScreen.start(context);
                },
                icon: const Icon(Icons.add),
                label: Text(stringNewPlace.toUpperCase()),
              )
            : null,
        bottomNavigationBar: const AppNavigationBar(index: 1),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(PlacesState state) => SmallAppBar(
        title: stringMap,
        button: stringRefresh,
        onPressed: () => bloc.add(const PlacesRerfreshed()),
        bottom: Padding(
          padding: commonPaddingLBR,
          child: state.filter.isNotReady
              ? const SizedBox()
              : SearchBar(
                  onTap: () => SearchScreen.start(context),
                  filter: state.filter.value,
                  onFilterChanged: (filter) =>
                      bloc.add(PlacesFilterChanged(filter)),
                ),
        ),
      );

  Future<void> _initMap() async {
    final state = bloc.state;
    final mapSettings = state.mapSettings.value;
    if (mapSettings != null) {
      await _goto(mapSettings);
    } else if (state.filter.isReady) {
      final radius = state.filter.value.radius;
      await _gotoCurrentLocation(radius);
    }
  }

  // Перемещает карту в заданную позицию.
  Future<void> _goto(MapSettings mapSettings) async {
    try {
      final controller = await _googleMapController.future;

      logger.d('goto $mapSettings');

      return controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              mapSettings.location.lat,
              mapSettings.location.lon,
            ),
            zoom: mapSettings.zoom,
            bearing: mapSettings.bearing,
            tilt: mapSettings.tilt,
          ),
        ),
      );
    } on MissingPluginException catch (_) {
      // Если переключить на другой экран, не дождавшись завершения, то получаем
      // исключение 'No implementation found for method ...'.
    }
  }

  // Перемещает карту в текущую позицию.
  //
  // Т.к. процесс получения текущих координат затяжной, пытаемся сначала
  // переместится в последнюю известную позицию. А за время анимации, может
  // уже и получим координаты.
  Future<void> _gotoCurrentLocation(Distance radius) async {
    final currentLocationFuture =
        context.read<LocationRepository>().getLocation();

    final lastLocation = context.read<LocationRepository>().lastLocation;
    if (lastLocation != null) await _gotoAutoZoom(lastLocation, radius);

    final currentLocation = await currentLocationFuture;
    if (currentLocation != null) await _gotoAutoZoom(currentLocation, radius);
  }

  // Перемещает карту в заданную позицию с автоматическим рассчётом масштаба,
  // чтобы поместился весь радиус.
  Future<void> _gotoAutoZoom(Coord location, Distance radius) async {
    try {
      final controller = await _googleMapController.future;
      var zoom = await controller.getZoomLevel();

      // Рассчитываем zoom, чтобы круг полностью вместился в экран.
      if (radius.isFinite) {
        final screen = await controller.getVisibleRegion();
        final middleLat =
            (screen.southwest.latitude + screen.northeast.latitude) / 2;
        final middleLon =
            (screen.southwest.longitude + screen.northeast.longitude) / 2;
        final size = min(
          calcDistance(
            middleLat,
            screen.southwest.longitude,
            middleLat,
            screen.northeast.longitude,
          ),
          calcDistance(
            screen.southwest.latitude,
            middleLon,
            screen.northeast.latitude,
            middleLon,
          ),
        );

        var k = 2 * radius.value / size;
        while (k > 1) {
          zoom--;
          k /= 2;
        }
        while (k < 0.5) {
          zoom++;
          k *= 2;
        }
      }

      logger.d('goto $location');

      return controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.lat, location.lon),
            zoom: zoom,
          ),
        ),
      );
    } on MissingPluginException catch (_) {
      // Если переключить на другой экран, не дождавшись завершения, то получаем
      // исключение 'No implementation found for method ...'.
    }
  }

  void _hidePlaceCard() {
    // ignore: no-empty-block
    _placeAnimationController.reverse().then((value) => setState(() {}));
  }

  void _showPlaceCard(Place place) {
    final lastPlace = _lastPlace;
    final onlyHide = lastPlace != null &&
        lastPlace.id == place.id &&
        !_placeAnimationController.isDismissed;

    _placeAnimationController.reverse().then((value) {
      setState(() {
        if (!onlyHide) {
          _lastPlace = place;
          _placeAnimationController.forward();
        }
      });
    });
  }
}
