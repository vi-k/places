part of 'favorite_bloc.dart';

class VisitedBloc extends _FavoriteBloc {
  VisitedBloc(PlaceInteractor placeInteractor) : super._(placeInteractor);

  @override
  Future<List<Place>> _getList() => _placeInteractor.getVisited();

  @override
  Future<Place> _removeFromList(Place place) =>
      _placeInteractor.removeFromVisited(place);

  @override
  Future<Place> _addToAdjacentList(Place place) =>
      _placeInteractor.addToWishlist(place);

  @override
  bool _isOwn(Place place) => place.userInfo.favorite == Favorite.visited;
}
