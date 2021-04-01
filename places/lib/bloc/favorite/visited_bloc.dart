part of 'favorite_bloc.dart';

class VisitedBloc extends _FavoriteBloc {
  VisitedBloc(PlaceInteractor placeInteractor) : super._(placeInteractor);

  @override
  bool _onEvent(Place place) {
    if (super._onEvent(place)) return true;

    if (place.userInfo.favorite == Favorite.visited) {
      emit(const FavoriteUnstable());
      return true;
    }

    return false;
  }

  @override
  Future<List<Place>> _getList() => _placeInteractor.getVisited();

  @override
  Future<Place> _removeFromList(Place place) =>
      _placeInteractor.removeFromVisited(place);

  @override
  Future<Place> _addToAdjacentList(Place place) =>
      _placeInteractor.addToWishlist(place);
}
