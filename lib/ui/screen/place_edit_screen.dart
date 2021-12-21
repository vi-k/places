import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/bloc/edit_place/edit_place_bloc.dart';
import 'package:places/data/model/photo.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/repositories/location/location_repository.dart';
import 'package:places/data/repositories/upload/upload_repository.dart';
import 'package:places/logger.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/widget/add_photo_card.dart';
import 'package:places/ui/widget/get_image.dart';
import 'package:places/ui/widget/photo_card.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/focus.dart';
import 'package:provider/provider.dart';

import 'place_type_select_screen.dart';

/// Экран добавления места.
///
/// Запуск:
/// ```
/// PlaceEditScreen.start(context, placeId);
/// ```
class PlaceEditScreen extends StatefulWidget {
  const PlaceEditScreen._({
    Key? key,
  }) : super(key: key);

  @override
  _PlaceEditScreenState createState() => _PlaceEditScreenState();

  /// Помещаем блок выше экрана, чтобы из контекста стейта сразу можно было
  /// обращаться к блоку.
  static void start(BuildContext context, [int placeId = 0]) {
    standartNavigatorPush<void>(
      context,
      () => BlocProvider<EditPlaceBloc>(
        create: (_) => EditPlaceBloc(
          context.read<PlaceInteractor>(),
          context.read<UploadRepository>(),
          context.read<LocationRepository>(),
          placeId,
        )..add(const EditPlaceStarted()),
        child: const PlaceEditScreen._(),
      ),
    );
  }
}

class _PlaceEditScreenState extends State<PlaceEditScreen> {
  // Контроллер GoogleMap через Future.
  final Completer<GoogleMapController> _googleMapController = Completer();

  // Обновляем поля с координатами в соответствии с имзенениями на карте.
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

  // При перемещении карты пользователем, сохраняем координаты в onCameraMove.
  // Устанавливать их будет только в конце перемещения в onCameraIdle.
  Coord? _moveCoord;

  // Надо отличать установку координат через контроллер, и перемещения карты
  // пользователем.
  bool _updateMapController = false;

  // Чтобы не передавать каждый раз тему в функции, выношу в отдельную
  // переменную, которая будет обновляться при каждом билде.
  late MyThemeData _theme;

  // Благодаря выносу блока наверх, всегда имеем доступ к нему.
  EditPlaceBloc get bloc => context.read<EditPlaceBloc>();

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;

    return BlocConsumer<EditPlaceBloc, EditPlaceState>(
      listener: (context, state) {
        logger.d('$state');
        // Выходим после сохранения.
        if (state is EditPlaceSaveSuccess) {
          Navigator.pop(context);
        }
      },
      // Обновляем, когда начинается или заканчивается загрузка или сохранение.
      buildWhen: (previous, current) =>
          previous is EditPlaceLoadInProgress &&
          current is! EditPlaceLoadInProgress,
      builder: (context, state) => Scaffold(
        appBar: SmallAppBar(
          title: bloc.isNew ? stringNewPlace : stringEdit,
          back: stringCancel,
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: AbsorbPointer(
            absorbing: state is EditPlaceLoadInProgress,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          _buildPhotoGallery(),
                          _buildPlaceType(),
                          _buildName(),
                          _buildCoord(),
                          _buildDescription(),
                        ],
                      ),
                      if (state is EditPlaceLoadInProgress)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
                _buildDone(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Фотографии мест.
  Widget _buildPhotoGallery() => BlocBuilder<EditPlaceBloc, EditPlaceState>(
        buildWhen: (previous, current) => previous.photos != current.photos,
        builder: (context, state) {
          logger.d('builder photos');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: commonSpacing + photoCardSize - photoCardRadius,
                        height: photoCardSize,
                      ),
                      Expanded(
                        child: ShaderMask(
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
                            stops: [0.0, 1.0],
                          ).createShader(Rect.fromLTRB(
                            bounds.left,
                            bounds.top,
                            bounds.left + commonSpacing + photoCardRadius,
                            bounds.bottom,
                          )),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: BlocBuilder<EditPlaceBloc, EditPlaceState>(
                              builder: (context, state) => Row(
                                children: [
                                  const SizedBox(
                                    width: commonSpacing - photoCardRadius,
                                  ),
                                  for (final photo in state.photos.value
                                      .asMap()
                                      .entries) ...[
                                    const SizedBox(width: commonSpacing),
                                    SizedBox(
                                      width: photoCardSize,
                                      height: photoCardSize,
                                      child: photo.value.isLoaded
                                          ? Hero(
                                              tag: photo.value.url!,
                                              flightShuttleBuilder:
                                                  standartFlightShuttleBuilder,
                                              child: _buildPhoto(photo.value),
                                            )
                                          : _buildPhoto(photo.value),
                                    ),
                                  ],
                                  const SizedBox(width: commonSpacing),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: commonSpacing,
                    child: AddPhotoCard(onPressed: _addPhoto),
                  ),
                ],
              ),
              if (state.photos.isInvalid)
                Padding(
                  padding: commonPadding,
                  child: Text(
                    state.photos.error!,
                    style: _theme.textRegular12Attention,
                  ),
                ),
            ],
          );
        },
      );

  Widget _buildPhoto(Photo photo) => Dismissible(
        key: ValueKey(photo.hashCode),
        direction: DismissDirection.up,
        onDismissed: (_) => bloc.add(EditPlacePhotoRemoved(photo)),
        child: PhotoCard(
          url: photo.url,
          path: photo.path,
          onClose: () => bloc.add(EditPlacePhotoRemoved(photo)),
        ),
      );

  // Тип места.
  Widget _buildPlaceType() => Section(
        stringPlaceType,
        spacing: 0,
        applyPaddingToChild: false,
        child: BlocBuilder<EditPlaceBloc, EditPlaceState>(
          buildWhen: (previous, current) => previous.type != current.type,
          builder: (context, state) {
            logger.d('builder type');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    state.type.value == null
                        ? stringUnselected
                        : PlaceTypeUi(state.type.value!).name,
                    style: _theme.textRegular16Light,
                  ),
                  trailing: SvgPicture.asset(
                    Svg24.view,
                    color: _theme.mainTextColor2,
                  ),
                  onTap: () => _getPlaceType(state.type.value),
                ),
                if (state.type.error != null)
                  Padding(
                    padding: commonPaddingLBR,
                    child: Text(
                      state.type.error!,
                      style: _theme.textRegular12Attention,
                    ),
                  ),
              ],
            );
          },
        ),
      );

  // Название.
  Widget _buildName() => Section(
        stringName,
        child: BlocBuilder<EditPlaceBloc, EditPlaceState>(
          buildWhen: (previous, current) => previous.name != current.name,
          builder: (context, state) {
            logger.d('builder name');

            return TextFormField(
              key: ValueKey(state.name.isUndefined),
              initialValue: state.name.value,
              decoration: InputDecoration(
                hintText: bloc.isNew ? stringNewPlaceFakeName : '',
                errorText: state.name.error,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (value) => bloc.add(EditPlaceChanged(name: value)),
              onEditingComplete: () =>
                  FocusScope.of(context).nextEditableTextFocus(),
            );
          },
        ),
      );

  // Координаты.
  Widget _buildCoord() => BlocConsumer<EditPlaceBloc, EditPlaceState>(
        listenWhen: (previous, current) =>
            previous.lat != current.lat || previous.lon != current.lon,
        listener: (context, state) {
          // Если координаты изменились, меняем значения в полях.
          _textControllerSetValue(_latController, state.lat.value);
          _textControllerSetValue(_lonController, state.lon.value);
          // И перемещаем карту.
          if (state.lat.isValid && state.lon.isValid) {
            _goto(Coord(
              double.parse(state.lat.value),
              double.parse(state.lon.value),
            ));
          }
        },
        buildWhen: (previous, current) =>
            previous is EditPlaceLoadInProgress &&
                current is! EditPlaceLoadInProgress ||
            previous is! EditPlaceLoadInProgress &&
                current is EditPlaceLoadInProgress ||
            previous.lat != current.lat ||
            previous.lon != current.lon,
        builder: (context, state) {
          logger.d('builder coord');

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Section(
                      stringLatitude,
                      right: 0,
                      child: TextFormField(
                        controller: _latController,
                        decoration: InputDecoration(
                          hintText:
                              bloc.isNew ? stringNewPlaceFakeLatitude : '',
                          errorText: state.lat.error,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) =>
                            bloc.add(EditPlaceChanged(lat: value)),
                        onEditingComplete: () {
                          FocusScope.of(context).nextEditableTextFocus();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: commonSpacing),
                  Expanded(
                    child: Section(
                      stringLongitude,
                      left: 0,
                      child: TextFormField(
                        controller: _lonController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText:
                              bloc.isNew ? stringNewPlaceFakeLongitude : '',
                          errorText: state.lon.error,
                        ),
                        onChanged: (value) =>
                            bloc.add(EditPlaceChanged(lon: value)),
                        onEditingComplete: () {
                          FocusScope.of(context).nextEditableTextFocus();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: commonPaddingLTR,
                child: SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(textFieldRadius),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      color: _theme.backgroundSecond,
                      child: Stack(
                        children: [
                          // Прячем карту, если координаты не валидны.
                          AnimatedOpacity(
                            duration: standartAnimationDuration,
                            opacity:
                                state.lat.isValid && state.lon.isValid ? 1 : 0,
                            child: GoogleMap(
                              mapType: MapType.hybrid,
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                                // Factory<PanGestureRecognizer>(
                                //   () => PanGestureRecognizer(),
                                // ),
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  initialPlace.lat,
                                  initialPlace.lon,
                                ),
                                zoom: 18,
                              ),
                              onMapCreated: _googleMapController.complete,
                              onCameraMoveStarted: () {
                                _moveCoord = null;
                              },
                              onCameraMove: (position) {
                                if (!_updateMapController) {
                                  _moveCoord = Coord(
                                    position.target.latitude,
                                    position.target.longitude,
                                  );
                                }
                              },
                              onCameraIdle: () {
                                if (_moveCoord != null) {
                                  bloc.add(EditPlaceChanged(coord: _moveCoord));
                                  _moveCoord = null;
                                }
                              },
                              mapToolbarEnabled: false,
                              myLocationEnabled: true,
                            ),
                          ),
                          // Прогресс-индикатор, когда устанавливается текущая
                          // позиция.
                          if (state is! EditPlaceLoadInProgress &&
                              state.lat.isUndefined &&
                              state.lon.isUndefined)
                            const Positioned.fill(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          // Маркер места - всегда по центру экрана.
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgAny.location,
                                  width: markerSize,
                                  height: markerSize,
                                ),
                                const SizedBox(height: markerSize),
                              ],
                            ),
                          ),
                          // Кнопка сверху, чтобы нельзя была двигать карту,
                          // когда она "спрятана", но можно было запустить
                          // установку карты в текущую позицию.
                          if (!(state.lat.isValid && state.lon.isValid))
                            Positioned.fill(
                              child: MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: state.lat.isUndefined &&
                                        state.lon.isUndefined
                                    ? null
                                    : () =>
                                        bloc.add(const EditPlaceSetLocation()),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

  // Описание.
  Widget _buildDescription() => Section(
        stringDescription,
        child: BlocBuilder<EditPlaceBloc, EditPlaceState>(
          buildWhen: (previous, current) =>
              previous.description != current.description,
          builder: (context, state) {
            logger.d('builder description');

            return TextFormField(
              key: ValueKey(state.description.isUndefined),
              initialValue: state.description.value,
              minLines: 3,
              maxLines: 10,
              textInputAction: TextInputAction.done,
              onChanged: (value) =>
                  bloc.add(EditPlaceChanged(description: value)),
            );
          },
        ),
      );

  // Кнопка создания/сохранения
  Widget _buildDone() => Container(
        width: double.infinity,
        padding: commonPadding,
        child: BlocBuilder<EditPlaceBloc, EditPlaceState>(
          buildWhen: (previous, current) =>
              previous.isModified != current.isModified,
          builder: (context, state) {
            logger.d('build done');

            return StandartButton(
              label: bloc.isNew ? stringCreate : stringSave,
              onPressed: state.isModified
                  ? () => bloc.add(const EditPlaceFinished())
                  : null,
            );
          },
        ),
      );

  // Калбэк для WillPopScope.
  //
  // Проверяем, сохранены ли данные.
  Future<bool> _onWillPop() async {
    if (!bloc.state.isModified) return true;

    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(stringDoCancel),
            actions: [
              SmallButton(
                label: stringCancel,
                onPressed: () => Navigator.pop(context, false),
              ),
              SmallButton(
                label: stringYes,
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Добавляет фотографию.
  Future<void> _addPhoto() async {
    final photo = await showModalBottomSheet<Photo>(
      context: context,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      builder: (context) => GetImage(),
    );

    if (photo != null) {
      bloc.add(EditPlacePhotoAdded(photo));
    }
  }

  // Получает типа места.
  Future<void> _getPlaceType(PlaceType? type) async {
    final newType = await standartNavigatorPush<PlaceType>(
      context,
      () => PlaceTypeSelectScreen(placeType: type),
    );

    if (newType != null) {
      bloc.add(EditPlaceChanged(type: newType));
    }
  }

  // Устанавливает карту в заданную позицию.
  Future<void> _goto(Coord pos) async {
    try {
      final controller = await _googleMapController.future;
      if (!mounted) return;

      logger.d('goto: $pos');

      _updateMapController = true;
      await controller.moveCamera(
        CameraUpdate.newLatLng(LatLng(pos.lat, pos.lon)),
      );
      // Камера не сразу устанавливается, из-за этого возникают ошибки
      // с определением - пользователь двигает карту или контроллер. Делаем
      // задержку, чтобы камера успела установиться.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _updateMapController = false;
    } on MissingPluginException catch (_) {
      // Если переключить на другой экран, не дождавшись завершения, то получаем
      // исключение 'No implementation found for method ...'.
    }
  }

  // Устанавливает значение контроллера, перемещает курсор в конец поля.
  void _textControllerSetValue(TextEditingController controller, String value) {
    if (controller.text != value) {
      controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }
}
