part of 'place_bloc.dart';

@immutable
abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

/// Событие: переключить в избранное и обратно.
class PlaceUpdate extends PlaceEvent {
  const PlaceUpdate(this.place);

  final Place place;
}

/// Событие: переключить в избранное и обратно.
class PlaceToggleWishlist extends PlaceEvent {}

/// Событие: обновить пользовательскую информацию.
class PlaceUpdateUserInfo extends PlaceEvent {
  const PlaceUpdateUserInfo(this.userInfo);

  final PlaceUserInfo userInfo;

  @override
  List<Object> get props => [userInfo];
}
