part of 'favorite_bloc.dart';

class WishlistBloc extends _FavoriteBloc {
  WishlistBloc(PlaceInteractor placeInteractor) : super._(placeInteractor);

  @override
  bool _onEvent(Place place) {
    if (super._onEvent(place)) return true;

    if (place.userInfo.favorite == Favorite.wishlist) {
      emit(const FavoriteUnstable());
      return true;
    }

    return false;
  }

  @override
  Future<List<Place>> _getList() => _placeInteractor.getWishlist();

  @override
  Future<Place> _removeFromList(Place place) =>
      _placeInteractor.removeFromWishlist(place);

  @override
  Future<Place> _addToAdjacentList(Place place) =>
      _placeInteractor.addToVisited(place);
}
