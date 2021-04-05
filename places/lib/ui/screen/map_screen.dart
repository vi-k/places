import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/bloc/places/places_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repositories/location/location_repository.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/utils/map.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/place_card.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';

import 'place_edit_screen.dart';
import 'search_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _googleMapController = Completer();
  Place? _lastPlace;
  late final AnimationController _placeAnimationController =
      AnimationController(
    vsync: this,
    duration: standartAnimationDuration,
    reverseDuration: standartAnimationDuration * 0.5,
  );
  late final Animation<double> _placeAnimation =
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
    curve: Curves.fastOutSlowIn,
    // reverseCurve: Curves.linear,
    parent: _placeAnimationController,
  ));

  @override
  Widget build(BuildContext context) {
    final initialLocation = context.read<LocationRepository>().lastLocation ??
        initialPlace; // Новое место
    final lastPlace = _lastPlace;

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) => Scaffold(
        appBar: _buildAppBar(context, state),
        body: Builder(
            builder: (context) => Stack(
                  children: [
                    Positioned.fill(
                      child: GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: CameraPosition(
                          target:
                              LatLng(initialLocation.lat, initialLocation.lon),
                          zoom: 12,
                        ),
                        onMapCreated: (controller) {
                          _googleMapController.complete(controller);
                          _gotoCurrentLocation(context, state.filter.radius);
                        },
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        onTap: (_) => _hidePlaceCard(),
                        markers: {
                          if (state is PlacesReady)
                            for (final place in state.places)
                              Marker(
                                markerId: MarkerId('${place.id}'),
                                position:
                                    LatLng(place.coord.lat, place.coord.lon),
                                onDragEnd: (value) {},
                                onTap: () => _showPlaceCard(place),
                              ),
                        },
                        circles: {
                          if (state is PlacesReady &&
                              state.filter.radius.isFinite)
                            Circle(
                              circleId: const CircleId('main'),
                              radius: state.filter.radius.value,
                              center: LatLng(
                                  initialLocation.lat, initialLocation.lon),
                              strokeWidth: 2,
                              strokeColor: Colors.blue.withOpacity(0.5),
                              fillColor: Colors.blue.withOpacity(0.1),
                            ),
                        },
                      ),
                    ),
                    if (state is PlacesLoading)
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
                            scale: _placeAnimation.value, child: child),
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
                )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _placeAnimationController.isDismissed &&
                _placeAnimationController.value == 0.0
            ? FloatingActionButton.extended(
                isExtended: true,
                onPressed: () => PlaceEditScreen.start(context),
                icon: const Icon(Icons.add),
                label: Text(stringNewPlace.toUpperCase()),
              )
            : null,
        bottomNavigationBar: const AppNavigationBar(index: 1),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, PlacesState state) =>
      SmallAppBar(
        title: stringMap,
        button: stringRefresh,
        onPressed: () {
          context.read<PlacesBloc>().add(const PlacesReload());
          _gotoCurrentLocation(context, state.filter.radius);
        },
        bottom: Padding(
          padding: commonPaddingLBR,
          child: SearchBar(
            onTap: () => standartNavigatorPush<String>(
                context, () => const SearchScreen()),
            filter: state.filter,
            onFilterChanged: (filter) {
              context.read<PlacesBloc>().add(PlacesLoad(filter));
              context.read<AppBloc>().add(AppChangeSettings(filter: filter));
              _gotoCurrentLocation(context, filter.radius);
            },
          ),
        ),
      );

  Future<void> _gotoCurrentLocation(
      BuildContext context, Distance radius) async {
    try {
      final location = await context.read<LocationRepository>().getLocation();
      if (location == null) return;

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
            calcDistance(middleLat, screen.southwest.longitude, middleLat,
                screen.northeast.longitude),
            calcDistance(screen.southwest.latitude, middleLon,
                screen.northeast.latitude, middleLon));

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
